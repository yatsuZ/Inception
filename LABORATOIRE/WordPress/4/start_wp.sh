#!/usr/bin/env sh

# Attendre 10 secondes pour s'assurer que MariaDB est démarré
sleep 10

# Chemin vers le répertoire WordPress
WP_PATH="/var/www/html"

MYSQL_DATABASE="data_name"
MYSQL_USER="user_data"
MYSQL_PASSWORD="mdp"

# Vérifier si le fichier wp-config.php existe déjà pour déterminer si WordPress est installé
if [ ! -f "$WP_PATH/wp-config.php" ]; then
    echo "Installation de WordPress..."

    # Créer le répertoire de destination s'il n'existe pas
    mkdir -p "$WP_PATH"
    
    # Télécharger et extraire WordPress
    wget https://wordpress.org/latest.tar.gz -P /tmp
    tar -xzf /tmp/latest.tar.gz -C /tmp
    mv /tmp/wordpress/* "$WP_PATH"
    rm -rf /tmp/latest.tar.gz /tmp/wordpress

    # Créer le fichier wp-config.php avec WP-CLI
    wp config create --dbname="$MYSQL_DATABASE" --dbuser="$MYSQL_USER" --dbpass="$MYSQL_PASSWORD" --dbhost="localhost" --path="$WP_PATH"
    
    # Installer WordPress avec WP-CLI
    wp core install --url="http://example.com" --title="Mon Site WordPress" --admin_user="admin" --admin_password="admin_password" --admin_email="email@example.com" --path="$WP_PATH"

    echo "WordPress installé avec succès."
else
    echo "WordPress est déjà installé."
fi

# Installation et activation des plugins, si nécessaire
wp plugin install wp-redis --activate --path="$WP_PATH"
wp redis enable --path="$WP_PATH"

# Démarrer PHP-FPM
exec php-fpm82 -F
