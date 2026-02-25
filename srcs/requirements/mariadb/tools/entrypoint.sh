#!/bin/bash

# -e exit on error; -u error on undefined vars; -o pipefail catch errors in pipelines
set -euo pipefail

DATADIR="/var/lib/mysql"
SOCKET="/run/mysqld/mysqld.sock"

# Read required env vars
: "${MYSQL_DATABASE:?MYSQL_DATABASE is required}"
: "${MYSQL_USER:?MYSQL_USER is required}"

# Read secrets (passwords) from Docker secrets files
DB_ROOT_PASSWORD="$(cat /run/secrets/db_root_password)"
DB_PASSWORD="$(cat /run/secrets/db_password)"

# 1 If datadir is empty, initialize system tables
if [ ! -d "$DATADIR/mysql" ]; then
	echo "[mariadb] Initializing data directory..."
	mariadb-install-db --user=mysql --datadir="$DATADIR" >/dev/null
fi

# 2 First-time setup (create db/user, set root password)
# Marker file stored in the volume so it wont be initialised again after it been once
if [ ! -f "$DATADIR/.inception_initialized" ]; then
	echo "[mariadb] First-time setup..."

	# Start MariaDB temporarily without network access (local (unix) socket only)
	mysqld --user=mysql --datadir="$DATADIR" --skip-networking --socket="$SOCKET" &
	pid="$!"

	# Wait until mariaDB is ready to prevent race conditions
	for i in {1..50}; do
		if mariadb --protocol=SOCKET --socket="$SOCKET" -e "SELECT 1;" >/dev/null 2>&1; then
			break
		fi
		sleep 0.1
	done

	# Run SQL setup
	mariadb --protocol=SOCKET --socket="$SOCKET" <<-SQL
		ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
		DELETE FROM mysql.user WHERE User='';
		DROP DATABASE IF EXISTS test;
		DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';

		CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`
			CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

		CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
		GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
		FLUSH PRIVILEGES;
SQL

	# Shutdown the temporary server
	mariadb-admin --protocol=SOCKET --socket="$SOCKET" -u root -p"${DB_ROOT_PASSWORD}" shutdown >/dev/null 2>&1 || true
	wait "$pid" || true

	touch "$DATADIR/.inception_initialized"
	echo "[mariadb] Setup complete."
fi

# 3Start MariaDB normally as the container's main process (PID 1)
exec "$@" --user=mysql --datadir="$DATADIR"
