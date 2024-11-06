#!/usr/bin/env sh

sleep 15

# WP_PATH="/var/www/wordpress"

echo "Vérification de l'installation de WordPress..."

# Vérifier si le répertoire de WordPress existe
if [ ! -d "$WP_PATH" ] || [ ! -f "$WP_PATH/wp-config.php" ]; then
    echo "Installation de WordPress..."

    mkdir -p "$WP_PATH"
    chown -R root:root "$WP_PATH"

    # Télécharger et extraire WordPress
    wget https://wordpress.org/latest.tar.gz -P /tmp
    tar -xzf /tmp/latest.tar.gz -C /tmp
    mv /tmp/wordpress/* "$WP_PATH"
    rm -rf /tmp/latest.tar.gz /tmp/wordpress

    # Créer le fichier wp-config.php si nécessaire
    if [ ! -f "$WP_PATH/wp-config.php" ]; then
        wp config create --dbname="$MYSQL_DATABASE" --dbuser="$MYSQL_USER" --dbpass="$MYSQL_PASSWORD" --dbhost="mariadb" --path="$WP_PATH"

        # Installer WordPress avec WP-CLI
        # wp core install --url="http://example.com" --title="Mon Site WordPress" --admin_user="admin" --admin_password="admin_password" --admin_email="email@example.com" --path="$WP_PATH"

        echo "Fichier wp-config.php créé et WordPress installé avec succès."
#        echo "Fichier wp-config.php doit etre créé."
    else
        echo "WordPress est déjà installé, fichier wp-config.php trouvé."
    fi
else
    echo "WordPress est déjà installé, répertoire et wp-config.php trouvés."
fi

# Installation et activation des plugins, si nécessaire
# wp plugin install wp-redis --activate --path="$WP_PATH"
# wp redis enable --path="$WP_PATH"

# Démarrer PHP-FPM
exec php-fpm82 -F

