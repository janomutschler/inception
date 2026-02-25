FROM debian:bookworm-slim

# Install MariaDB (and certificates so TLS downloads work reliably during build)
RUN apt-get update && apt-get install -y --no-install-recommends \
    mariadb-server \
    ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# MariaDB expects these directories to exist and be owned by mysql
RUN mkdir -p /run/mysqld /var/lib/mysql \
 && chown -R mysql:mysql /run/mysqld /var/lib/mysql

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 3306

# When the container starts: run entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Default command passed to entrypoint: start the DB server
CMD ["mysqld"]