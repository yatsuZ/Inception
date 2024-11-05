#!/usr/bin/env sh

sleep 5

#WP_PATH="/var/www/wordpress"

# A supprimer
MYSQL_DATABASE="data_name"
MYSQL_USER="user_data"
MYSQL_PASSWORD="mdp"

echo "Installation de WordPress..."

mkdir -p "$WP_PATH"
    
chown -R root:root "$WP_PATH"
wget https://wordpress.org/latest.tar.gz -P /tmp
tar -xzf /tmp/latest.tar.gz -C /tmp
mv /tmp/wordpress/* "$WP_PATH"
rm -rf /tmp/latest.tar.gz /tmp/wordpress



# # Vérifier si le fichier wp-config.php existe
# if [ ! -f "$WP_PATH/wp-config.php" ]; then
#     # Créer le fichier wp-config.php avec WP-CLI
#     wp config create --dbname="$MYSQL_DATABASE" --dbuser="$MYSQL_USER" --dbpass="$MYSQL_PASSWORD" --dbhost="localhost" --path="$WP_PATH"
    
#     # Installer WordPress avec WP-CLI
#     wp core install --url="http://example.com" --title="Mon Site WordPress" --admin_user="admin" --admin_password="admin_password" --admin_email="email@example.com" --path="$WP_PATH"

#     echo "Fichier wp-config.php créé et WordPress installé avec succès."
# else
#     echo "Le fichier wp-config.php existe déjà."
# fi

# Installation et activation des plugins, si nécessaire
# wp plugin install wp-redis --activate --path="$WP_PATH"
# wp redis enable --path="$WP_PATH"

# Démarrer PHP-FPM
exec php-fpm82 -F

