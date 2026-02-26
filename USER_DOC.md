# Inception  - USER_DOC

## 1. What this stack provides

This project deploys a small web stack using Docker:

- **NGINX**: HTTPS web server (only port **443** exposed to the host)
- **WordPress (PHP-FPM)**: the website + admin panel
- **MariaDB**: database used by WordPress

All services run as separate containers using Docker Compose.

---

## 2. Start / Stop the project

### Start (build + run)
From the project root:

	make

Stop (keep data)

	make down

Stop + remove everything (including volumes/data)

This deletes WordPress + DB stored data.

	make fclean
## 3. Access the website and admin panel

### 3.1 Domain mapping (required)

Your domain resolve locally to your VM/host IP.

Add to /etc/hosts (replace <login>):

	127.0.0.1 <login>.42.fr

### 3.2 Open the site

Website:

	https://<login>.42.fr

### 3.3 Open the admin panel

Admin panel:

	https://<login>.42.fr/wp-admin

Log in with the WordPress admin credentials (see section 4).

## 4. Locate and manage credentials

Credentials are not hardcoded in images. They are provided via Docker secrets.

### 4.1 Where credentials live

In srcs/secrets/:

	db_root_password.txt — MariaDB root password

	db_password.txt — MariaDB password for the WordPress DB user

	wp_admin_password.txt — WordPress admin password

	wp_user_password.txt — WordPress normal user password

Each secret file should contain only the password (no extra text).

### 4.2 Configuration values

Non-secret configuration (like DB name/user, domain) is usually stored in:

	srcs/.env

## 5. Check services are running correctly

### 5.1 Container status

	make status

You should see nginx, wordpress, mariadb as Up.

### 5.2 Logs

	make logs

### 5.3 HTTPS / TLS check

Confirm only HTTPS is served:

	curl -vk https://<login>.42.fr

Expected: TLS handshake succeeds and you receive HTML content (self-signed cert warnings are normal).

### 5.4 Port exposure check (host side)

Only port 443 should be published:

	docker ps --format "table {{.Names}}\t{{.Ports}}"

Expected:

	nginx shows 0.0.0.0:443->443/tcp (or similar)

wordpress and mariadb should not publish ports to host (they may show internal ports only)