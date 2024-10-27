#!/usr/bin/env sh

# Attendre 10 secondes pour s'assurer que MariaDB est démarré
sleep 10

# Vérifier si le fichier wp-config.php existe déjà
if [ ! -f /var/www/html/wp-config.php ]; then
    # Créer le fichier wp-config.php avec les informations de connexion à la base de données
    wp config create --dbname=nom_de_la_base_de_donnees --dbuser=nom_utilisateur --dbpass=mot_de_passe --dbhost=localhost --path=/var/www/html
fi

# Lancer l'installation de WordPress (si nécessaire)
wp core install --url="http://example.com" --title="Mon Site WordPress" --admin_user="admin" --admin_password="admin_password" --admin_email="email@example.com" --path=/var/www/html

# Lancer le serveur PHP
exec php-fpm82 -F
