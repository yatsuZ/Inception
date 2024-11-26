r les couleurs
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
CYAN="\033[0;36m"
RESET="\033[0m"

# Fonction pour afficher un message avec une couleur
print_msg() {
	    echo -e "${1}${2}${RESET}"
    }

    print_msg $CYAN "-------------------------"
    print_msg $CYAN "| Installation Docker   |"
    print_msg $CYAN "-------------------------"

    # Mise à jour des paquets
    print_msg $YELLOW "Mise à jour des paquets..."
    sudo apt update && sudo apt upgrade -y

    # Installation des dépendances requises
    print_msg $YELLOW "Installation des dépendances requises..."
    sudo apt install -y \
	        ca-certificates \
		    curl \
		        gnupg \
			    lsb-release

    # Ajout de la clé GPG officielle de Docker
    print_msg $YELLOW "Ajout de la clé GPG officielle de Docker..."
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    # Ajout du dépôt Docker
    print_msg $YELLOW "Ajout du dépôt Docker..."
    echo \
	      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
	        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Mise à jour des paquets pour inclure Docker
    print_msg $YELLOW "Mise à jour des paquets pour inclure Docker..."
    sudo apt update

    # Installation de Docker Engine, Docker CLI, et Containerd
    print_msg $YELLOW "Installation de Docker Engine, Docker CLI, et Containerd..."
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Ajout de l'utilisateur courant au groupe Docker
    print_msg $YELLOW "Ajout de l'utilisateur courant au groupe Docker..."
    sudo usermod -aG docker $USER

    # Installation de Docker Compose (version standalone si nécessaire)
    print_msg $YELLOW "Installation de Docker Compose (standalone)..."
    DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep "tag_name" | cut -d '"' -f 4)
    sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

    # Vérification des installations
    print_msg $CYAN "-------------------------"
    print_msg $CYAN "| Vérification des versions |"
    print_msg $CYAN "-------------------------"
docker --version && print_msg $GREEN "Docker installé avec succès."
docker-compose --version && print_msg $GREEN "Docker Compose installé avec succès."

print_msg $CYAN "--------------------------------------"
print_msg $GREEN "Installation terminée."
print_msg $YELLOW "Veuillez redémarrer votre terminal pour appliquer les modifications au groupe Docker."
print_msg $CYAN "--------------------------------------"

