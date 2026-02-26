# Inception – DEV_DOC

## Overview

This project sets up a small Docker-based infrastructure composed of:

- NGINX (TLS 1.2/1.3 only)
- WordPress (PHP-FPM)
- MariaDB

All services run in separate containers using Docker Compose.

Only HTTPS (port 443) is exposed to the host.

---

## Requirements

- Linux system (Debian recommended)
- Docker
- Docker Compose plugin
- Make

---

## Setup

### 1️⃣ Clone the repository

	git clone <repository-url>
	cd inception

### 2️⃣ Create required folders to store data

	mkdir -p /home/<your_login>/data/mariadb
	mkdir -p /home/<your_login>/data/wordpress

### 3️⃣ Add secrets

Create the following files inside srcs/secrets/:

	db_root_password.txt

	db_password.txt

	wp_admin_password.txt

	wp_user_password.txt

Each file must contain only the password (no spaces, no newline if possible).

### Start the infrastructure

	make

### Access WordPress

Open your browser:

	https://<your_login>.42.fr

Make sure /etc/hosts contains:

	127.0.0.1 <your_login>.42.fr

### Stop services

	make down

### Clean everything (including volumes)

	make fclean

⚠ This removes all project data.