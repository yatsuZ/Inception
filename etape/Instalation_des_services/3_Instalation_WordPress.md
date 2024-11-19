## 3. Installation de WordPress

**Objectif :** Créer un conteneur WordPress.  
Voir [les règles](./../../concepts/regle_du_projet.md).

## Leçon

1. Écrire un Dockerfile pour installer WordPress.
2. Démarrer WordPress et configurer PHP.
3. Utiliser les variables d'environnement.

## WordPress

Pour une définition, consulte le [site officiel de WordPress](https://fr.wordpress.org/) ou la [documentation officielle](https://developer.wordpress.org/).

## Comment faire ?

1. Écrire le Dockerfile.
2. Créer un fichier de configuration pour PHP.
3. Copier les fichiers de configuration.
4. Créer un script pour démarrer WordPress.

### Arborescence

```zsh
➜  wordpress git:(main) ✗ tree
.
├── conf
│   ├── config_vim
│   └── php82_php-fpm_d_www.conf
├── Dockerfile
└── tools
    └── start_wp.sh
```

## Le Dockerfile

```Dockerfile
FROM alpine:3.19

COPY ./conf/config_vim /root/.vimrc

RUN apk update && \
    apk add --no-cache \
    bash \
    vim \
    curl \
    tree \
    wget \
    mariadb-client \
    php \
    php-fpm \
    php-pdo \
    php-mysqli \
    php-phar \
    php-mbstring \
    php-iconv \
    php-tokenizer \
    php-redis \
    php-curl \
    php-json \
    php-xml

COPY ./conf/php82_php-fpm_d_www.conf /etc/php82/php-fpm.d/www.conf

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY ./tools/start_wp.sh /usr/local/bin/start_wp.sh
RUN chmod +x /usr/local/bin/start_wp.sh

ENTRYPOINT ["/usr/local/bin/start_wp.sh"]
```

### Explication détaillée du Dockerfile

1. **Base de l'image**  
   Utilise Alpine Linux version 3.19 comme image de base, ce qui rend l'image légère et rapide.

2. **Copie de la configuration de Vim**  
   Copie un fichier de configuration Vim depuis ton répertoire local vers le répertoire personnel de l'utilisateur root dans le conteneur.

3. **Mise à jour des paquets et installation des dépendances**  
   Met à jour la liste des paquets disponibles et installe plusieurs dépendances nécessaires au fonctionnement de WordPress, notamment :
   - **bash** : Un interpréteur de commandes.
   - **vim** : Un éditeur de texte.
   - **curl** : Pour transférer des données avec des URL.
   - **tree** : Pour afficher la structure des répertoires.
   - **wget** : Pour télécharger des fichiers depuis le web.
   - **mariadb-client** : Pour interagir avec des bases de données MariaDB.
   - **php et ses extensions** : Nécessaires pour exécuter WordPress, ces extensions ajoutent des fonctionnalités essentielles. Pour plus de détails sur les spécificités de chaque extension, voir [les extensions de PHP](./../../concepts/Les_extension_de_php.md) ou concernant [FastCGI](./../../concepts/Les_extension_de_php.md#fastcgi).

4. **Configuration de PHP-FPM**  
   Copie la configuration spécifique de PHP-FPM depuis ton répertoire local vers le répertoire de configuration de PHP-FPM dans le conteneur.

5. **Installation de WP-CLI**  
   Télécharge le fichier WP-CLI, le rend exécutable, puis le déplace dans un répertoire du PATH pour qu'il soit accessible en tant que commande `wp`. WP-CLI est un outil en ligne de commande pour gérer WordPress.

6. **Copie et configuration du script de démarrage**  
   Copie le script de démarrage (`start_wp.sh`) dans le conteneur et le rend exécutable. Ce script contiendra la logique pour démarrer PHP-FPM et initialiser WordPress.

7. **Commande de démarrage**  
   Définit le script `start_wp.sh` comme point d'entrée du conteneur, ce qui signifie qu'il sera exécuté lorsque le conteneur démarrera. Le CMD vide indique qu'aucune commande supplémentaire ne sera ajoutée.

### En résumé

Ce Dockerfile construit un conteneur pour exécuter WordPress sur Alpine Linux, en installant toutes les dépendances nécessaires, y compris PHP et ses extensions, ainsi que WP-CLI. Il configure PHP-FPM pour traiter les requêtes PHP et utilise un script de démarrage pour initialiser et démarrer l'environnement WordPress.


## Explication des fichiers de configuration

### `config_vim`

Ce fichier est optionnel. Il permet de configurer directement l'éditeur Vim à l'intérieur du conteneur. Si vous avez des préférences spécifiques pour l'édition de texte, ce fichier les appliquera automatiquement lors de l'utilisation de Vim.

### `php82_php-fpm_d_www.conf`

Ce fichier permet de configurer PHP-FPM et remplace le fichier par défaut dans votre conteneur Alpine à l'emplacement `/etc/php82/php-fpm.d/www.conf`. Il est essentiel pour définir le comportement de PHP-FPM, notamment en ce qui concerne la gestion des requêtes PHP.

Voici quelques modifications que j'ai apportées par rapport au fichier par défaut :

```conf
[...]
;listen = 127.0.0.1:9000  ; <default à changer> ligne 41
listen = wordpress:9000
[...]
```

- **Modification de l'adresse d'écoute** :  
  La ligne `listen = wordpress:9000` indique à PHP-FPM d'écouter les requêtes sur le réseau Docker à l'adresse `wordpress` (nom du service dans le fichier Docker Compose) sur le port 9000. Cela permet aux requêtes envoyées par le serveur web (NGINX, par exemple) d'être correctement redirigées vers PHP-FPM.

```conf
; ligne 453
clear_env = no
```

- **Paramètre `clear_env`** :  
  Ce paramètre contrôle si l'environnement des variables d'environnement doit être nettoyé avant que PHP ne soit exécuté. En le réglant sur `no`, vous permettez à PHP d'accéder à toutes les variables d'environnement définies dans le conteneur, ce qui peut être crucial pour certaines applications qui s'appuient sur des configurations basées sur ces variables (comme des clés API, des chemins de fichiers, etc.).

Ces changements sont importants pour assurer que PHP-FPM fonctionne correctement dans l'architecture de conteneurs, facilitant ainsi la communication entre les différents services de l'application WordPress.

Voici une explication détaillée du script `start_wp.sh` que tu as fourni pour installer et configurer WordPress :

### `start_wp.sh`

```sh
#!/usr/bin/env sh

# Définition des couleurs
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
RESET='\033[0m'

echo -e "${BLUE}Vérification de l'installation de WordPress...${RESET}"

# Vérifier si le répertoire de WordPress existe
if [ ! -d "$WP_PATH" ] || [ ! -f "$WP_PATH/wp-config.php" ]; then
    echo -e "${YELLOW}Installation de WordPress...${RESET}"

    mkdir -p "$WP_PATH"
    chown -R root:root "$WP_PATH"

    # Télécharger et extraire WordPress
    wget -q https://wordpress.org/latest.tar.gz -P /tmp
    tar -xzf /tmp/latest.tar.gz -C /tmp 
    mv /tmp/wordpress/* "$WP_PATH"
    rm -rf /tmp/latest.tar.gz /tmp/wordpress

    # Créer le fichier wp-config.php si nécessaire
    if [ ! -f "$WP_PATH/wp-config.php" ]; then


        # Attendre que la base de données soit prête
        until mysql -h "$SQL_HOST" -u "$SQL_NAME_USER" -p"$SQL_PASSWORD_USER" -e "SHOW DATABASES;" > /dev/null 2>&1; do
            echo -e "${YELLOW}En attente de la base de données...${RESET}"
            echo -e "${YELLOW}Essai de connexion à : $SQL_HOST avec l'utilisateur : $SQL_NAME_USER${RESET}"
            sleep 2
        done

        echo -e "${GREEN}Connexion à la base de données réussie${RESET}"


        echo -e "${YELLOW}Configuration du \"wp-config.php\" ${RESET}"
        # Utilisation de wp-cli pour créer le fichier wp-config.php
        sed "s/database_name_here/$SQL_NAME_DATABASE/;s/username_here/$SQL_NAME_USER/;s/password_here/$SQL_PASSWORD_USER/;s/localhost/$SQL_HOST/;" /var/www/wordpress/wp-config-sample.php > /var/www/wordpress/wp-config.php
        echo "define( 'WPLANG', 'fr_FR' );" >> /var/www/wordpress/wp-config.php

        # Installation de WordPress avec WP-CLI
        wp core install --url="$URL__OF_SITE"  --title="$TITLE_OF_SITE" --admin_user="$SQL_NAME_USER" --admin_password="$SQL_PASSWORD_USER" --admin_email="email@example.com" --path="$WP_PATH"

        # Installation et activation des plugins, si nécessaire
        wp plugin install wp-redis --activate --path="$WP_PATH"
        wp redis enable --path="$WP_PATH"

        echo -e "${GREEN}Fichier wp-config.php créé et WordPress installé avec succès.${RESET}"
    else
        echo -e "${GREEN}WordPress est déjà installé, fichier wp-config.php trouvé.${RESET}"
    fi
else
    echo -e "${GREEN}WordPress est déjà installé, répertoire et wp-config.php trouvés.${RESET}"
fi

# Démarrer PHP-FPM
echo -e "${BLUE}Démarrage de PHP-FPM...${RESET}"
exec php-fpm82 -F
```

### Explication du script

1. **En-tête du script**
   - `#!/usr/bin/env sh` : Spécifie que le script doit être exécuté avec l'interpréteur shell `sh`.

2. **Vérification de l'installation de WordPress**
   - `if [ ! -d "$WP_PATH" ] || [ ! -f "$WP_PATH/wp-config.php" ]; then` : Vérifie si le répertoire de WordPress et le fichier `wp-config.php` existent. Si l'un de ces éléments est manquant, cela signifie que l'installation de WordPress doit être effectuée.

3. **Installation de WordPress**
   - Si l'installation est nécessaire, le script crée un répertoire pour WordPress, télécharge et décompresse l'archive de WordPress, puis déplace les fichiers dans le répertoire prévu.
   - Les fichiers temporaires sont supprimés après l'installation.

4. **Configuration de WordPress (si nécessaire)**
   - Si le fichier `wp-config.php` n'existe pas, le script attend que la base de données soit prête avant de configurer ce fichier avec les informations de connexion appropriées. Il utilise `wp-cli` pour installer WordPress et configure le fichier `wp-config.php` avec les paramètres de la base de données.

5. **Installation des plugins**
   - Le script installe et active le plugin `wp-redis` pour activer la gestion du cache Redis dans WordPress.

6. **Démarrage de PHP-FPM**
   - Une fois WordPress installé, le script démarre PHP-FPM pour exécuter WordPress.

### Conclusion

Le script `start_wp.sh` automatise l'installation de WordPress dans le conteneur Docker, y compris la configuration du fichier `wp-config.php` et l'installation de plugins comme `wp-redis`. Il permet de vérifier l'état de l'installation avant de procéder et garantit que tous les composants nécessaires sont en place avant de démarrer PHP-FPM. Les sections qui ne sont pas nécessaires peuvent être commentées ou ajustées selon les besoins spécifiques du projet.

## Test

Pas de teste il faut manipuler avec les docker compose et les 2 autres services

## Fin 

Voici la mise à jour de ton fichier `.md` avec les explications ajoutées à la section `start_wp.sh` :