# Les derniere tache a effectuer

- [Les derniere tache a effectuer](#les-derniere-tache-a-effectuer)
	- [Objectif](#objectif)
	- [Arborescence](#arborescence)
		- [Explications de l'arborescence :](#explications-de-larborescence-)
		- [Partie : Contenu de `.env`](#partie--contenu-de-env)
			- [Explications des variables :](#explications-des-variables-)
			- [Informations complémentaires sur `SERVER_NAME` :](#informations-complémentaires-sur-server_name-)
	- [Contenu des secrets](#contenu-des-secrets)
	- [Contenue du makefile](#contenue-du-makefile)
		- [Explication](#explication)
		- [Commandes principales](#commandes-principales)
		- [Explication générale](#explication-générale)
	- [Contenue du petit script verif secrets](#contenue-du-petit-script-verif-secrets)
		- [Explication](#explication-1)
		- [Tester](#tester)

## Objectif

Dans cette section, l'objectif principal est de finaliser les tâches restantes pour assurer que le projet est complet et fonctionnel. Nous devons créer le `Makefile`, les fichiers de secrets et tester l'intégralité de la configuration. L'achèvement de ces étapes garantira que l'application est prête à être déployée avec les secrets nécessaires pour une sécurité optimale et que tout fonctionne comme prévu.

## Arborescence

Voici l'arborescence du projet qui détaille la structure des fichiers et répertoires à prendre en compte :

```bash
➜  rendu git:(main) ✗ tree -a
.
├── Makefile
├── file_secrets_exist.sh
├── secrets
│   ├── sql_password_admin.txt
│   └── sql_password_user.txt
└── srcs
    ├── .env
    ├── data_docker_compose
    │   ├── mariadb
    │   │   └── .gitkeep
    │   └── wordpress
    │       └── .gitkeep
    ├── docker-compose.yml
    └── requirements
        ├── bonus
        │   └── info.txt
        ├── mariadb
        │   ├── .dockerignore
        │   ├── Dockerfile
        │   ├── config
        │   │   ├── config_vim
        │   │   └── mariadb-server.cnf
        │   └── tool
        │       ├── init_db.sql
        │       └── init_maria_mysql.sh
        ├── nginx
        │   ├── .dockerignore
        │   ├── Dockerfile
        │   ├── conf
        │   │   ├── config_vim
        │   │   ├── fastcgi-php.conf
        │   │   └── nginx.conf
        │   └── tools
        │       ├── generateur_certifica.sh
        │       └── start_server.sh
        └── wordpress
            ├── .dockerignore
            ├── Dockerfile
            ├── conf
            │   ├── config_vim
            │   └── php82_php-fpm_d_www.conf
            └── tools
                └── start_wp.sh
```

### Explications de l'arborescence :
- **Makefile** : Ce fichier est essentiel car il automatisera la construction du projet. Il permettra de compiler les services et de simplifier les étapes nécessaires pour démarrer et tester le projet.
  
- **file_secrets_exist.sh** : Ce script shell permet de vérifier si le répertoire `secrets` existe, s'assurant ainsi que les fichiers contenant des informations sensibles sont présents et sécurisés.

- **secrets** : Il contient les fichiers `sql_password_admin.txt` et `sql_password_user.txt` qui stockent les mots de passe de l'utilisateur administrateur et de l'utilisateur standard pour la base de données. Ce répertoire doit être protégé pour éviter toute fuite d'information sensible.

- **./srcs/data_docker_compose** : Ce répertoire contient des fichiers de données Docker persistants (volumes), où les données de MariaDB et WordPress seront stockées entre les redémarrages des conteneurs.

- **./srcs/.env** : Ce fichier contient les variables d'environnement nécessaires pour configurer les services, comme les informations de connexion à la base de données ou d'autres paramètres spécifiques au projet.

Cette structure de répertoire assure que tous les composants nécessaires sont bien organisés et prêts à être utilisés pour déployer et gérer l'application. Le fichier `docker-compose.yml` et les répertoires `requirements` pour chaque service (mariadb, nginx, wordpress) sont également intégrés, comme décrit dans le document précédent [4_redaction_du_docker_compose.md](./4_redaction_du_docker_compose.md#arborescence). 

### Partie : Contenu de `.env`

Le fichier `.env` contient les variables d'environnement nécessaires pour la configuration de WordPress et MariaDB dans votre projet Docker. Il permet de définir des chemins, des paramètres de base de données et des informations spécifiques au site WordPress, afin de faciliter la gestion et l'accès à ces données sans les coder en dur dans le projet.

Voici le contenu du fichier `.env` :

```env
WP_PATH=/var/www/wordpress
MARIA_PATH=/var/www/wordpress

SQL_NAME_DATABASE=nom_de_database_test
SQL_NAME_ADMIN=chef
SQL_NAME_USER=user
SQL_HOST=mariadb

TITLE_OF_SITE="Mon Site WordPress"
# SERVER_NAME="yzaoui.42.fr"
SERVER_NAME="localhost"
```

#### Explications des variables :
- **WP_PATH** et **MARIA_PATH** : Ces variables définissent les chemins de base pour WordPress et MariaDB dans le conteneur. Elles sont utilisées dans le fichier `docker-compose.yml` pour configurer les volumes et les données persistantes.
  
- **SQL_NAME_DATABASE** : Le nom de la base de données que MariaDB créera et utilisera pour WordPress.
  
- **SQL_NAME_ADMIN** et **SQL_NAME_USER** : Les noms d'utilisateur pour l'administrateur et l'utilisateur de la base de données.
  
- **SQL_HOST** : Définit l'hôte de la base de données, ici `mariadb`, qui est le nom du service de base de données défini dans le fichier `docker-compose.yml`.

- **TITLE_OF_SITE** : Le titre du site WordPress, qui peut être modifié selon vos préférences.

- **SERVER_NAME** : Ce paramètre détermine le nom du serveur WordPress. Si vous souhaitez utiliser un nom de domaine autre que `localhost`, vous devrez mettre à jour le fichier `/etc/hosts` sur votre machine pour associer le nom de domaine au bon serveur.

#### Informations complémentaires sur `SERVER_NAME` :

> Sur Windows, la modification du fichier `hosts` est différente.

Si vous voulez utiliser un nom de domaine personnalisé autre que `localhost`, vous devez modifier le fichier `/etc/hosts` pour associer l'adresse IP de votre machine au `SERVER_NAME` choisi. Voici un exemple de modification :

```bash
➜  rendu git:(main) ✗ cat /etc/hosts
# [network]
# generateHosts = false
127.0.0.1   localhost
127.0.1.1   [nom de ma machine]  [nom de ma machine]
127.0.0.1   [nom de votre server_name]
```

Cela permet à votre machine locale de reconnaître et de résoudre le nom de domaine personnalisé que vous avez spécifié dans le fichier `.env`. 

En résumé, ce fichier `.env` est essentiel pour garantir que vos services WordPress et MariaDB peuvent communiquer efficacement et de manière sécurisée tout en vous offrant la possibilité de personnaliser certains paramètres.


## Contenu des secrets

Le répertoire `./secrets` contient les mots de passe de l'admin et de l'utilisateur.

- Contenu de `./secrets/sql_password_admin.txt` :
```txt
patate
```

- Contenu de `./secrets/sql_password_user.txt` :
```txt
fruit
```

Tant que vous n'avez pas encore construit le projet, vous pouvez modifier les informations dans le fichier `.env` et dans les fichiers secrets, comme les mots de passe, le `SERVER_NAME`, le nom du site, etc. Ces valeurs ne sont pas encore définies avant la construction du projet.

## Contenue du makefile

Le Makefile que nous avons ici est utilisé pour automatiser diverses tâches liées à la gestion de notre environnement Docker, comme la construction des images, le démarrage des conteneurs, et le nettoyage des ressources.

Voici un aperçu détaillé du fichier :

```Makefile
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
```

### Explication

- **Couleurs :**
  - Les couleurs sont définies au début du fichier à l'aide des séquences d'échappement ANSI, pour rendre la sortie du terminal plus lisible.
  - `GREEN`, `BLUE`, `YELLOW`, `RED`, et `NC` sont utilisés pour colorier les messages qui apparaissent lors de l'exécution des commandes `make`.

- **Variables :**
  - `DOCKER_COMPOSE` : Définit la commande `docker-compose` utilisée pour gérer les conteneurs.
  - `COMPOSE_FILE` : Chemin du fichier `docker-compose.yml` qui définit la configuration de l'application.
  - `DATA_DIR`, `MARIADB_DIR`, et `WORDPRESS_DIR` : Chemins des répertoires où les données de MariaDB et WordPress seront stockées sur l'hôte.

### Commandes principales

1. **`all` :**
   - Cette cible est l'objectif principal. Elle appelle successivement les cibles `build` et `up` pour construire et démarrer les conteneurs.
   - Après la construction et le démarrage des conteneurs, un message de succès est affiché.

2. **`check` :**
   - Exécute le script `file_secrets_exist.sh` pour vérifier la présence des fichiers secrets nécessaires (mots de passe).

3. **`build` :**
   - Cette commande vérifie d'abord la présence des répertoires nécessaires (via la commande `check`).
   - Si les répertoires ne sont pas présents, elle les crée avec `mkdir -p`.
   - Elle construit ensuite les images Docker avec `docker-compose build`.

4. **`up` :**
   - Démarre les conteneurs en arrière-plan (`-d`) avec la commande `docker-compose up -d`.
   - Un message de succès est affiché si les conteneurs démarrent correctement.

5. **`stop` :**
   - Arrête les conteneurs en cours d'exécution avec `docker-compose down`, sans supprimer les volumes.

6. **`clean` :**
   - Cette commande arrête les conteneurs, supprime les volumes et les réseaux avec `docker-compose down -v --remove-orphans --rmi all`.
   - Elle supprime également les répertoires de données MariaDB et WordPress sur l'hôte.
   - Un message de nettoyage réussi est affiché à la fin.

7. **`re` :**
   - Effectue un nettoyage complet avec `clean`, puis reconstruit les images Docker avec `build` et redémarre les conteneurs avec `up`.

8. **`help` :**
   - Affiche un message d'aide détaillant les différentes cibles du Makefile et leur fonctionnement.

### Explication générale

Ce Makefile est conçu pour faciliter la gestion du projet Docker. Il permet aux utilisateurs de facilement construire, démarrer, nettoyer et redémarrer l'application en exécutant des commandes simples comme `make`, `make build`, `make up`, etc. 

Il est particulièrement utile pour automatiser les tâches répétitives et s'assurer que l'environnement Docker est configuré correctement avant chaque déploiement.

## Contenue du petit script verif secrets

```bash
#!/bin/bash

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
RESET='\033[0m'

# Répertoire à vérifier
REQUIRED_DIRECTORY="./secrets"

echo -e "${CYAN}🔧 Vérification de l'existence du répertoire : ${YELLOW}$REQUIRED_DIRECTORY${RESET}"
if [ ! -d "$REQUIRED_DIRECTORY" ]; then
  echo -e "${RED}❌ Répertoire manquant :${YELLOW} $REQUIRED_DIRECTORY${RESET}"
  echo -e "${RED}🚨 Assurez-vous que le répertoire existe avant de continuer.${RESET}"
  exit 1
fi

echo -e "${GREEN}✔ Le répertoire ${YELLOW}$REQUIRED_DIRECTORY ${GREEN}est présent !${RESET}"

Décommenter cette section si tu veux vérifier des fichiers spécifiques
# Fichiers nécessaires
REQUIRED_FILES=(
  "./secrets/sql_password_admin.txt"
  "./secrets/sql_password_user.txt"
)

# Vérifier chaque fichier
echo -e "${CYAN}🔧 Vérification des fichiers secrets${RESET}"
for FILE in "${REQUIRED_FILES[@]}"; do
  if [ ! -f "$FILE" ]; then
    echo -e "${RED}❌ Fichier manquant :${YELLOW} $FILE${RESET}"
    echo -e "${RED}🚨 Assurez-vous que tous les fichiers secrets sont présents avant de continuer.${RESET}"
    exit 1
  fi
done

echo -e "${GREEN}✔ Tous les fichiers secrets sont présents !${RESET}"
```

### Explication

Ce script vérifie la présence du répertoire `./secrets` et de certains fichiers nécessaires.

1. **Couleurs** : Définition des couleurs pour les messages (rouge, vert, jaune, cyan).
2. **Vérification du répertoire** : Si le répertoire `./secrets` n'existe pas, un message d'erreur s'affiche et le script s'arrête.
3. **Fichiers secrets** : Si activée (en décommentant), la section vérifie la présence des fichiers `sql_password_admin.txt` et `sql_password_user.txt`. Si l'un est manquant, un message d'erreur est affiché et le script s'arrête.
4. **Confirmation** : Si tout est présent, un message de succès est affiché.

Ce script permet de s'assurer que l'environnement est prêt avant de continuer.

### Tester

Pour vous connecter à votre site WordPress :

1. Ouvrez votre navigateur web.
2. Allez à [https://localhost](https://localhost) ou utilisez votre `SERVER_NAME` si vous l'avez modifié dans le fichier `.env`.
3. Vous devriez être redirigé vers la page d'accueil de WordPress.

Si tout est configuré correctement, la page de configuration de WordPress s'affichera, vous permettant de compléter l'installation.