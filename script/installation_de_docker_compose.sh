#!/bin/sh

# Définir les variables de couleur
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m' # Réinitialisation des couleurs

# Afficher un message en couleur
echo_message() {
    local color=$1
    shift
    echo -e "${color}$@${RESET}"
}

# Mise à jour de la liste des paquets
echo_message $BLUE "Mise à jour de la liste des paquets..."
apk update

# Installation des dépendances nécessaires pour télécharger le binaire Docker Compose
echo_message $YELLOW "Installation des dépendances nécessaires..."
apk add --no-cache curl py3-pip

# Téléchargement de la dernière version stable de Docker Compose
echo_message $BLUE "Téléchargement de Docker Compose..."
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Attribution des permissions d'exécution au binaire Docker Compose
echo_message $GREEN "Attribution des permissions d'exécution au binaire..."
chmod +x /usr/local/bin/docker-compose

# Vérification de l'installation
echo_message $BLUE "Vérification de l'installation de Docker Compose..."
docker-compose --version

# Confirmation de l'installation
echo_message $GREEN "Docker Compose a été installé avec succès !"
