#!/usr/bin/env sh

sleep 5


if [ ! -f "$WP_PATH/wp-load.php" ]; then
    echo "Installation de WordPress..."

    mkdir -p "$WP_PATH"
    
    chown -R root:root "$WP_PATH"
    wget https://wordpress.org/latest.tar.gz -P /tmp
    tar -xzf /tmp/latest.tar.gz -C /tmp
    mv /tmp/wordpress/* "$WP_PATH"
    rm -rf /tmp/latest.tar.gz /tmp/wordpress

    # Donner les droits nécessaires au serveur web
    chown -R www-data:www-data "$WP_PATH"        # Remplace 'www-data' par l'utilisateur de ton serveur web si nécessaire
    find "$WP_PATH" -type d -exec chmod 755 {} \;
    find "$WP_PATH" -type f -exec chmod 644 {} \;

else
    echo "WordPress est déjà installé."
fi

# # Vérifier si le fichier wp-config.php existe
 if [ ! -f "$WP_PATH/wp-config.php" ]; then
     # Créer le fichier wp-config.php avec WP-CLI
     wp config create --dbname="$SQL_NAME_DATABASE" --dbuser="$SQL_NAME_USER" --dbpass="$SQL_PASSWORD_USER" --dbhost="mariadb" --path="$WP_PATH"
    
#     # Installer WordPress avec WP-CLI
    #  wp core install --url="http://example.com" --title="Mon Site WordPress" --admin_user="admin" --admin_password="admin_password" --admin_email="email@example.com" --path="$WP_PATH"

     echo "Fichier wp-config.php créé et WordPress installé avec succès."
 else
     echo "Le fichier wp-config.php existe déjà."
 fi

# Installation et activation des plugins, si nécessaire
wp plugin install wp-redis --activate --path="$WP_PATH"
wp redis enable --path="$WP_PATH"

# Démarrer PHP-FPM
exec php-fpm82 -F

