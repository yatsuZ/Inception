#!/usr/bin/env sh

# Définition des couleurs
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
RESET='\033[0m'

echo "${BLUE}Vérification de l'installation de WordPress...${RESET}"

# Vérifier si le répertoire de WordPress existe
if [ ! -d "$WP_PATH" ] || [ ! -f "$WP_PATH/wp-config.php" ]; then
    echo "${YELLOW}Installation de WordPress...${RESET}"

    mkdir -p "$WP_PATH"
    chown -R root:root "$WP_PATH"

    # Télécharger et extraire WordPress
    wget https://wordpress.org/latest.tar.gz -P /tmp
    tar -xzf /tmp/latest.tar.gz -C /tmp
    mv /tmp/wordpress/* "$WP_PATH"
    rm -rf /tmp/latest.tar.gz /tmp/wordpress

    # Créer le fichier wp-config.php si nécessaire
    if [ ! -f "$WP_PATH/wp-config.php" ]; then

        sleep 5

        # Attendre que la base de données soit prête
        until mysql -h "$SQL_HOST" -u "$SQL_NAME_USER" -p"$SQL_PASSWORD_USER" -e "SHOW DATABASES;" > /dev/null 2>&1; do
            echo "${YELLOW}En attente de la base de données...${RESET}"
            echo "${YELLOW}Essai de connexion à : $SQL_HOST avec l'utilisateur : $SQL_NAME_USER${RESET}"
            sleep 2
        done

        echo "${GREEN}Connexion à la base de données réussie${RESET}"
        
        # Utilisation de wp-cli pour créer le fichier wp-config.php
        wp config create --dbname="$SQL_NAME_DATABASE" --dbuser="$SQL_NAME_USER" --dbpass="$SQL_PASSWORD_USER" --dbhost="$SQL_HOST" --path="$WP_PATH"

        # Installation de WordPress avec WP-CLI
        # wp core install --url="http://example.com" --title="Mon Site WordPress" --admin_user="admin" --admin_password="admin_password" --admin_email="email@example.com" --path="$WP_PATH"

        # Installation et activation des plugins, si nécessaire
        # wp plugin install wp-redis --activate --path="$WP_PATH"
        # wp redis enable --path="$WP_PATH"

        echo "${GREEN}Fichier wp-config.php créé et WordPress installé avec succès.${RESET}"
    else
        echo "${GREEN}WordPress est déjà installé, fichier wp-config.php trouvé.${RESET}"
    fi
else
    echo "${GREEN}WordPress est déjà installé, répertoire et wp-config.php trouvés.${RESET}"
fi

# Démarrer PHP-FPM
echo "${BLUE}Démarrage de PHP-FPM...${RESET}"
exec php-fpm82 -F

