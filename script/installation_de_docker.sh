#!/bin/sh

# Définition des couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Installation de Docker sur Alpine

# Mise à jour des paquets
echo -e "${BLUE}Mise à jour des paquets...${NC}"
apk update

# Installation du paquet Docker
echo -e "${YELLOW}Installation de Docker...${NC}"
apk add docker

# Démarrage du service Docker et activation au démarrage
echo -e "${GREEN}Démarrage de Docker et activation au démarrage...${NC}"
service docker start
rc-update add docker

# Vérification de la version de Docker installée
echo -e "${GREEN}Vérification de la version de Docker...${NC}"
docker --version

# Vérification de l'état du service Docker
echo -e "${YELLOW}Vérification du statut du service Docker...${NC}"
service docker status