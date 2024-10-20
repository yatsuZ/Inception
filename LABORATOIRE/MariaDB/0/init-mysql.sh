#!/bin/sh

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # Pas de couleur

# Fonction pour afficher les étapes
log_step() {
    echo -e "${CYAN}=== $1 ===${NC}"
}

# Vérifier si le répertoire de données existe
log_step "Vérification du répertoire de données..."
if [ ! -d "/var/lib/mysql" ]; then
    echo -e "${YELLOW}Le répertoire /var/lib/mysql n'existe pas. Création en cours...${NC}"
    mkdir -p /var/lib/mysql
    chown -R mysql:mysql /var/lib/mysql
else
    echo -e "${GREEN}Le répertoire de données existe déjà.${NC}"
fi

# Vérifier si la base de données est initialisée
log_step "Vérification de l'initialisation de la base de données..."
if [ ! -f "/var/lib/mysql/mysql.sock" ]; then
    echo -e "${YELLOW}Base de données non initialisée. Initialisation en cours...${NC}"
    mysqld --initialize-insecure --user=mysql
else
    echo -e "${GREEN}Base de données déjà initialisée.${NC}"
fi

# Lancer le service MySQL
log_step "Lancement de MySQL..."
mysqld &

# Vérification de l'état de MySQL
log_step "Vérification de l'état de MySQL..."
if ps aux | grep -v grep | grep mysqld > /dev/null; then
    echo -e "${GREEN}MySQL est démarré avec succès.${NC}"
else
    echo -e "${RED}Échec du démarrage de MySQL. Vérifiez les logs pour plus d'informations.${NC}"
    exit 1
fi

# Configuration des utilisateurs
log_step "Création de l'utilisateur root..."
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"

log_step "Création de la base de données et de l'utilisateur..."
mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';"

# Rafraîchir les privilèges
log_step "Rafraîchissement des privilèges MySQL..."
mysql -e "FLUSH PRIVILEGES;"

# Arrêter MySQL avant de redémarrer
log_step "Arrêt de MySQL..."
mysqladmin -u root -p${SQL_ROOT_PASSWORD} shutdown

# Redémarrer MySQL
log_step "Redémarrage de MySQL..."
exec mysqld_safe

