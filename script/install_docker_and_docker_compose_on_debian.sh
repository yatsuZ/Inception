#!/bin/bash

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m' # Pas de couleur

# Vérification des droits root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Ce script doit être exécuté en tant que root.${NC}"
    exit 1
fi

echo -e "${BLUE}Mise à jour des paquets...${NC}"
apt update && apt upgrade -y
if [ $? -ne 0 ]; then
    echo -e "${RED}Erreur lors de la mise à jour des paquets.${NC}"
    exit 1
fi

echo -e "${BLUE}Installation des prérequis pour Docker...${NC}"
apt install -y apt-transport-https ca-certificates curl gnupg lsb-release
if [ $? -ne 0 ]; then
    echo -e "${RED}Erreur lors de l'installation des prérequis.${NC}"
    exit 1
fi

echo -e "${BLUE}Ajout de la clé GPG officielle de Docker...${NC}"
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
if [ $? -ne 0 ]; then
    echo -e "${RED}Erreur lors de l'ajout de la clé GPG.${NC}"
    exit 1
fi

echo -e "${BLUE}Ajout du dépôt Docker...${NC}"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
if [ $? -ne 0 ]; then
    echo -e "${RED}Erreur lors de l'ajout du dépôt Docker.${NC}"
    exit 1
fi

echo -e "${BLUE}Mise à jour des paquets après ajout du dépôt Docker...${NC}"
apt update
if [ $? -ne 0 ]; then
    echo -e "${RED}Erreur lors de la mise à jour des paquets.${NC}"
    exit 1
fi

echo -e "${BLUE}Installation de Docker...${NC}"
apt install -y docker-ce docker-ce-cli containerd.io
if [ $? -ne 0 ]; then
    echo -e "${RED}Erreur lors de l'installation de Docker.${NC}"
    exit 1
fi

echo -e "${GREEN}Docker installé avec succès !${NC}"

echo -e "${BLUE}Téléchargement de Docker Compose...${NC}"
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')
curl -L "https://github.com/docker/compose/releases/download/v$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
if [ $? -ne 0 ]; then
    echo -e "${RED}Erreur lors du téléchargement de Docker Compose.${NC}"
    exit 1
fi

echo -e "${BLUE}Rendre Docker Compose exécutable...${NC}"
chmod +x /usr/local/bin/docker-compose
if [ $? -ne 0 ]; then
    echo -e "${RED}Erreur lors de la modification des permissions de Docker Compose.${NC}"
    exit 1
fi

echo -e "${GREEN}Docker Compose installé avec succès !${NC}"

echo -e "${YELLOW}Vérification des versions installées...${NC}"
docker --version
docker-compose --version

echo -e "${GREEN}Installation terminée ! Docker et Docker Compose sont prêts à l'emploi.${NC}"

