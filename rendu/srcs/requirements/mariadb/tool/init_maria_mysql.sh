#!/usr/bin/env sh

# Définition des couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

export SQL_PASSWORD_ADMIN=$(cat /run/secrets/sql_password_admin)
export SQL_PASSWORD_USER=$(cat /run/secrets/sql_password_user)

# Afficher les valeurs des variables d'environnement
echo -e "${BLUE}MARIA_PATH:${NC} ${MARIA_PATH}"
echo -e "${BLUE}SQL_NAME_DATABASE:${NC} ${SQL_NAME_DATABASE}"
echo -e "${BLUE}SQL_NAME_USER:${NC} ${SQL_NAME_USER}"
echo -e "${BLUE}SQL_PASSWORD_USER:${NC} ${SQL_PASSWORD_USER}"
echo -e "${BLUE}SQL_NAME_ADMIN:${NC} ${SQL_NAME_ADMIN}"
echo -e "${BLUE}SQL_PASSWORD_ADMIN:${NC} ${SQL_PASSWORD_ADMIN}"

# Vérifier si la base de données existe déjà
if find ${MARIA_PATH} -mindepth 1 -maxdepth 1 | read; then
    echo -e "${GREEN}La base de données existe déjà.${NC}"
else
    echo -e "${YELLOW}La base de données doit être créée.${NC}"
    mysql_install_db -umysql --ldata=/var/lib/mysql
    mariadbd -umysql &
    sleep 1

    echo -e "${YELLOW}Création de la base de données et de l'utilisateur via un script SQL.${NC}"
    # Exécuter le script SQL avec des variables d'environnement
    envsubst < /bin/init_db.sql | mysql -u ${SQL_NAME_ADMIN}
    if [ $? -ne 0 ]; then
        echo -e "${RED}Erreur lors de la création de la base de données.${NC}"
        exit 1
    fi

    echo -e "${GREEN}Base de données et utilisateur créés avec succès.${NC}"

    mysqladmin shutdown -p"${SQL_PASSWORD_ADMIN}"
fi

echo -e "${GREEN}Démarrage du serveur MariaDB...${NC}"
exec mariadbd -umysql
