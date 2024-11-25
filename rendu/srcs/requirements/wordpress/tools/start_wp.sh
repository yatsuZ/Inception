#!/usr/bin/env sh

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
RESET='\033[0m'

echo -e "${BLUE}Vérification de l'installation de WordPress...${RESET}"

if [ ! -d "$WP_PATH" ] || [ ! -f "$WP_PATH/wp-config.php" ]; then
    echo -e "${YELLOW}Installation de WordPress...${RESET}"

    mkdir -p "$WP_PATH"
    chown -R root:root "$WP_PATH"

    wget -q https://wordpress.org/latest.tar.gz -P /tmp
    tar -xzf /tmp/latest.tar.gz -C /tmp 
    mv /tmp/wordpress/* "$WP_PATH"
    rm -rf /tmp/latest.tar.gz /tmp/wordpress

    if [ ! -f "$WP_PATH/wp-config.php" ]; then


        until mysql -h "$SQL_HOST" -u "$SQL_NAME_USER" -p"$SQL_PASSWORD_USER" -e "SHOW DATABASES;" > /dev/null 2>&1; do
            echo -e "${YELLOW}En attente de la base de données...${RESET}"
            echo -e "${YELLOW}Essai de connexion à : ${BLUE}$SQL_HOST${YELLOW} avec l'utilisateur : ${BLUE}$SQL_NAME_USER${YELLOW} avec le mot de passe : ${BLUE} $SQL_PASSWORD_USER${RESET} "
            sleep 2
        done

        echo -e "${GREEN}Connexion à la base de données réussie${RESET}"


        echo -e "${YELLOW}Configuration du \"wp-config.php\" ${RESET}"
        sed "s/database_name_here/$SQL_NAME_DATABASE/;s/username_here/$SQL_NAME_USER/;s/password_here/$SQL_PASSWORD_USER/;s/localhost/$SQL_HOST/;" /var/www/wordpress/wp-config-sample.php > /var/www/wordpress/wp-config.php
        echo "define( 'WPLANG', 'fr_FR' );" >> /var/www/wordpress/wp-config.php

        wp core install --url="https://$SERVER_NAME"  --title="$TITLE_OF_SITE" --admin_user="$SQL_NAME_USER" --admin_password="$SQL_PASSWORD_USER" --admin_email="email@example.com" --path="$WP_PATH"

        wp plugin install wp-redis --activate --path="$WP_PATH"
        wp redis enable --path="$WP_PATH"

        echo -e "${GREEN}Fichier wp-config.php créé et WordPress installé avec succès.${RESET}"
    else
        echo -e "${GREEN}WordPress est déjà installé, fichier wp-config.php trouvé.${RESET}"
    fi
else
    echo -e "${GREEN}WordPress est déjà installé, répertoire et wp-config.php trouvés.${RESET}"
fi

echo -e "${BLUE}Démarrage de PHP-FPM...${RESET}"
exec php-fpm82 -F

