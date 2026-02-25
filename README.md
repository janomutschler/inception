*This project has been created as part of the 42 curriculum by jmutschl.*

# Inception

## Description

Inception is a System Administration project focused on building a secure multi-service infrastructure using Docker and Docker Compose inside a Virtual Machine.

The stack includes:

- NGINX (TLSv1.2 / TLSv1.3 only, port 443)
- WordPress + php-fpm
- MariaDB
- Docker named volumes (database + website files)
- Custom Docker network

Each service runs in its own container and is built from a custom Dockerfile (no pre-built service images allowed).

The website is accessible via:


https://jmutschl.42.fr

### Design Choices

#### Virtual Machines vs Docker

	VM virtualizes OS

	Docker virtualizes applications

	Docker is lightweight and faster

#### Secrets vs Environment Variables

	.env → configuration

	Docker secrets → passwords

	No credentials stored in Dockerfiles or Git

#### Docker Network vs Host Network

	Custom bridge network used

	No network: host

	Secure internal container communication

#### Docker Volumes vs Bind Mounts

	Named volumes required

	Managed by Docker

	Ensure persistence after container restart

### Security

	TLSv1.2 / TLSv1.3 only

	Only port 443 exposed

	No latest tags

	No infinite loops (tail -f, sleep infinity, etc.)

	Proper PID 1 handling
---

## Instructions

### Requirements
- Linux VM
- Docker
- Docker Compose
- Make

### Setup

Add to `/etc/hosts`:


	127.0.0.1 jmutschl.42.fr



### Build & Start

start

	make

Stop

	make down

Rebuild

	make re


### Architecture

	NGINX (entrypoint, 443 TLS)

	→ WordPress (php-fpm)

	→ MariaDB

Persistent storage:

	Named volume for database

	Named volume for WordPress files

Stored in /home/jmutschl/data

---
## Resources

	Docker documentation

	Docker Compose documentation

	NGINX documentation

	MariaDB documentation

	WordPress documentation

### AI Usage

AI was used to:

	Clarify Docker concepts

	Structure documentation

	Review configuration logic

All content was manually reviewed and tested, respecting subject AI rules

---