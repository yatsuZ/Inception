## 3. Installation de WordPress

- [3. Installation de WordPress](#3-installation-de-wordpress)
- [Objectif](#objectif)
- [Leçon](#leçon)
- [WordPress](#wordpress)
- [Comment faire](#comment-faire)
  - [Arborescence](#arborescence)
- [Le Dockerfile](#le-dockerfile)
  - [Explication détaillée du Dockerfile](#explication-détaillée-du-dockerfile)
  - [En résumé](#en-résumé)
- [Explication des fichiers de configuration](#explication-des-fichiers-de-configuration)
  - [`config_vim`](#config_vim)
  - [`php82_php-fpm_d_www.conf`](#php82_php-fpm_d_wwwconf)
  - [`start_wp.sh`](#start_wpsh)
  - [Explication du script](#explication-du-script)
  - [Conclusion](#conclusion)
- [Test](#test)
- [Fin](#fin)


## Objectif
L'objectif de cette leçon est de créer un conteneur Docker configuré pour héberger un site WordPress.  
Pour plus de détails, consultez [les règles du projet](./../../concepts/regle_du_projet.md).

## Leçon

1. **Écrire un Dockerfile** pour installer WordPress dans un conteneur Docker.
2. **Démarrer WordPress** et configurer PHP pour le bon fonctionnement du site.
3. **Utiliser les variables d'environnement** pour personnaliser l'installation de WordPress.

## WordPress

WordPress est un système de gestion de contenu (CMS) open source, utilisé pour créer et gérer des sites web. Il est particulièrement apprécié pour sa flexibilité et sa grande communauté. Pour plus d'informations, consultez le [site officiel de WordPress](https://fr.wordpress.org/) ou la [documentation officielle](https://developer.wordpress.org/).

## Comment faire

1. **Écrire le Dockerfile** : Ce fichier est essentiel pour installer WordPress et PHP dans un conteneur Docker. Il configure l'environnement d'exécution du site.
2. **Créer un fichier de configuration pour PHP** : Ce fichier définit les paramètres nécessaires pour faire fonctionner WordPress avec PHP-FPM.
3. **Copier les fichiers de configuration** dans le conteneur pour que PHP et WordPress puissent interagir correctement.
4. **Créer un script pour démarrer WordPress** : Ce script initie le démarrage de WordPress et de PHP-FPM dans le conteneur, facilitant ainsi le lancement du service.

### Arborescence

Voici l'arborescence des fichiers du projet WordPress dans Docker :

```bash
➜  wordpress git:(main) ✗ tree
.
├── Dockerfile                    # Le fichier Dockerfile pour construire l'image WordPress
├── conf
│   ├── config_vim                # Configuration personnalisée pour l'éditeur Vim
│   └── php82_php-fpm_d_www.conf  # Fichier de configuration PHP-FPM pour WordPress
└── tools
    └── start_wp.sh               # Script pour démarrer WordPress et PHP-FPM
2 directories, 4 files
```

Voici la section que tu peux intégrer dans ton fichier `.md` avec le Dockerfile et les explications détaillées :

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

### `start_wp.sh`

```sh
#!/usr/bin/env sh

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
RESET='\033[0m'

export SQL_PASSWORD_ADMIN=$(cat /run/secrets/sql_password_admin)
export SQL_PASSWORD_USER=$(cat /run/secrets/sql_password_user)

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
            sleep 2
        done

        echo -e "${GREEN}Connexion à la base de données réussie${RESET}"

        echo -e "${YELLOW}Configuration du \"wp-config.php\" ${RESET}"
        sed "s/database_name_here/$SQL_NAME_DATABASE/;s/username_here/$SQL_NAME_USER/;s/password_here/$SQL_PASSWORD_USER/;s/localhost/$SQL_HOST/;" /var/www/wordpress/wp-config-sample.php > /var/www/wordpress/wp-config.php
        echo "define( 'WPLANG', 'fr_FR' );" >> /var/www/wordpress/wp-config.php

        wp core install --url="https://$SERVER_NAME"  --title="$TITLE_OF_SITE" --admin_user="$SQL_NAME_ADMIN" --admin_password="$SQL_PASSWORD_ADMIN" --admin_email="email@example.com" --path="$WP_PATH"

        wp plugin install wp-redis --activate --path="$WP_PATH"
        wp redis enable --path="$WP_PATH"

        echo -e "${YELLOW}Ajout de l'utilisateur WordPress $SQL_NAME_USER...${RESET}"
        wp user create "$SQL_NAME_USER" "user@example.com" --role="subscriber" --user_pass="$SQL_PASSWORD_USER" --path="$WP_PATH"
        echo -e "${GREEN}Utilisateur $SQL_NAME_USER ajouté avec succès.${RESET}"

        echo -e "${GREEN}Fichier wp-config.php créé et WordPress installé avec succès.${RESET}"
    else
        echo -e "${GREEN}WordPress est déjà installé, fichier wp-config.php trouvé.${RESET}"
    fi
else
    echo -e "${GREEN}WordPress est déjà installé, répertoire et wp-config.php trouvés.${RESET}"
fi

echo -e "${BLUE}Démarrage de PHP-FPM...${RESET}"
exec php-fpm82 -F
```

### Explication du script

1. **Vérification de l'installation de WordPress** : Si le répertoire `WP_PATH` ou le fichier `wp-config.php` n'existent pas, le script procède à l'installation de WordPress.
   
2. **Installation de WordPress** : Le script télécharge l'archive de WordPress, l'extrait et déplace les fichiers dans le répertoire souhaité, tout en supprimant les fichiers temporaires.

3. **Configuration de WordPress** : Le script attend que la base de données MySQL soit disponible, puis configure `wp-config.php` avec les informations de connexion.

4. **Installation des plugins** : Le plugin `wp-redis` est installé et activé pour améliorer les performances de WordPress avec Redis.

5. **Création d'un utilisateur WordPress** : Un utilisateur avec le rôle `subscriber` est ajouté à WordPress.

6. **Démarrage de PHP-FPM** : PHP-FPM est lancé pour exécuter WordPress.

### Conclusion

Le script permet d'automatiser l'installation de WordPress dans un environnement Docker. Il configure la base de données, installe les plugins nécessaires et s'assure que PHP-FPM est prêt à gérer les requêtes WordPress.

## Test

Pas de teste individuelle.

## Fin