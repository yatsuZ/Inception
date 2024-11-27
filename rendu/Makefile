# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: yzaoui <yzaoui@student.42.fr>              +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/09/11 18:44:28 by yzaoui            #+#    #+#              #
#    Updated: 2024/11/27 03:28:03 by yzaoui           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Couleurs
GREEN := \033[1;32m
BLUE := \033[1;34m
YELLOW := \033[1;33m
RED := \033[1;31m
NC := \033[0m  # Sans couleur

# Variables
DOCKER_COMPOSE := docker-compose
COMPOSE_FILE := srcs/docker-compose.yml
DC := $(DOCKER_COMPOSE) -f $(COMPOSE_FILE)

DATA_DIR := /home/yzaoui/data/
MARIADB_DIR := $(DATA_DIR)/mariadb
WORDPRESS_DIR := $(DATA_DIR)/wordpress

# Commandes par défaut
.PHONY: all build up clean help check re

# Commande principale : construire et démarrer
all: build up
	@echo "$(GREEN)✔ Application construite et démarrée avec succès !$(NC)"

# Verifie la presence des fichiers secrets
check:
	@bash file_secrets_exist.sh

# Construire les images Docker
build: check
	@echo "$(BLUE)🔧 Vérification des dossiers nécessaires...$(NC)"
	@sudo mkdir -p $(MARIADB_DIR) $(WORDPRESS_DIR)
	@echo "$(GREEN)✔ Dossiers $(MARIADB_DIR) et $(WORDPRESS_DIR) prêts !$(NC)"
	@echo "$(BLUE)🔧 Construction des images Docker...$(NC)"
	@$(DC) build
	@echo "$(GREEN)✔ Images Docker construites avec succès !$(NC)"

# Démarrer les conteneurs
up:
	@echo "$(BLUE)🚀 Démarrage des conteneurs Docker...$(NC)"
	@$(DC) up -d
	@echo "$(GREEN)✔ Conteneurs Docker démarrés avec succès !$(NC)"

# Nettoyer les conteneurs, volumes et réseaux
stop:
	@echo "$(RED)🛑 Stop les conteneurs ...$(NC)"
	@$(DC) down
	@echo "$(GREEN)✔ Arret terminé !$(NC)"


# Nettoyer les conteneurs, volumes et réseaux
clean:
	@echo "$(RED)🧹 Nettoyage des conteneurs et volumes Docker...$(NC)"
	@$(DC) down -v --remove-orphans --rmi all
	@sudo rm -rf $(MARIADB_DIR) $(WORDPRESS_DIR)
	@echo "$(GREEN)✔ Nettoyage terminé !$(NC)"

re: clean build up

# Aide
help:
	@echo "$(YELLOW)📝 Utilisation :$(NC)"
	@echo "  $(GREEN)make$(NC)              : Construire et démarrer l'application"
	@echo "  $(GREEN)make check$(NC)        : Vertifie la presence de fichier secrets"
	@echo "  $(GREEN)make build$(NC)        : Construire uniquement les images Docker"
	@echo "  $(GREEN)make up$(NC)           : Démarrer uniquement les conteneurs Docker"
	@echo "  $(GREEN)make stop$(NC)         : Arret uniquement les conteneurs Docker"
	@echo "  $(GREEN)make clean$(NC)        : Nettoyer les conteneurs et volumes Docker"
	@echo "  $(GREEN)make re$(NC)           : Nettoyer et reconstruire les images Docker et les redémarre"
	@echo "  $(GREEN)make help$(NC)         : Afficher cette aide"
