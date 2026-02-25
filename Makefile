NAME        := inception
COMPOSE_DIR := srcs
COMPOSE     := docker compose

all: up

up:
	cd $(COMPOSE_DIR) && $(COMPOSE) up -d --build

down:
	cd $(COMPOSE_DIR) && $(COMPOSE) down

build:
	cd $(COMPOSE_DIR) && $(COMPOSE) build

start:
	cd $(COMPOSE_DIR) && $(COMPOSE) start

stop:
	cd $(COMPOSE_DIR) && $(COMPOSE) stop

restart:
	cd $(COMPOSE_DIR) && $(COMPOSE) restart

status:
	cd $(COMPOSE_DIR) && $(COMPOSE) ps

logs:
	cd $(COMPOSE_DIR) && $(COMPOSE) logs -f --tail=100

clean:
	cd $(COMPOSE_DIR) && $(COMPOSE) down -v
	sudo rm -rf /home/$(USER)/data/mariadb
	sudo rm -rf /home/$(USER)/data/wordpress

fclean: clean
	cd $(COMPOSE_DIR) && $(COMPOSE) down --rmi all
	docker system prune -af

re: fclean up

.PHONY: all up down build start stop restart status logs clean fclean re