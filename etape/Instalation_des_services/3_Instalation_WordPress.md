Voici la version révisée de ta section sur le Dockerfile, intégrant toutes les explications demandées :

---

## 3. Installation de WordPress

> Cette section est en cours de révision pour l'intégration finale.

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
CMD [] 
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

sleep 5

WP_PATH="/var/www/wordpress"

# A supprimer
MYSQL_DATABASE="data_name"
MYSQL_USER="user_data"
MYSQL_PASSWORD="mdp"

if [ ! -f "$WP_PATH/wp-load.php" ]; then
    echo "Installation de WordPress..."

    mkdir -p "$WP_PATH"
    
    chown -R root:root "$WP_PATH"
    wget https://wordpress.org/latest.tar.gz -P /tmp
    tar -xzf /tmp/latest.tar.gz -C /tmp
    mv /tmp/wordpress/* "$WP_PATH"
    rm -rf /tmp/latest.tar.gz /tmp/wordpress
else
    echo "WordPress est déjà installé."
fi

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
```

### Explication du script

1. **En-tête du script**
   - `#!/usr/bin/env sh` : Indique que le script doit être exécuté avec l'interpréteur shell `sh`.

2. **Pause au démarrage**
   - `sleep 5` : Attendre 5 secondes avant d'exécuter le reste du script. Cela peut permettre à d'autres services, comme MariaDB, de se stabiliser avant d'initier l'installation de WordPress.

3. **Définition des variables**
   - `WP_PATH="/var/www/wordpress"` : Définit le chemin où WordPress sera installé.
   - Les variables pour la base de données sont définies mais commentées (à supprimer plus tard).

4. **Vérification de l'installation de WordPress**
   - `if [ ! -f "$WP_PATH/wp-load.php" ]; then` : Vérifie si WordPress n'est pas déjà installé en cherchant le fichier `wp-load.php`. S'il n'existe pas, cela signifie que l'installation n'a pas été effectuée.

5. **Installation de WordPress**
   - `mkdir -p "$WP_PATH"` : Crée le répertoire de destination pour WordPress, s'il n'existe pas déjà.
   - `chown -R root:root "$WP_PATH"` : Change le propriétaire du répertoire pour qu'il soit le même que celui du processus (root).
   - `wget https://wordpress.org/latest.tar.gz -P /tmp` : Télécharge la dernière version de WordPress dans le répertoire temporaire `/tmp`.
   - `tar -xzf /tmp/latest.tar.gz -C /tmp` : Décompresse l'archive téléchargée.
   - `mv /tmp/wordpress/* "$WP_PATH"` : Déplace tous les fichiers décompressés vers le répertoire cible.
   - `rm -rf /tmp/latest.tar.gz /tmp/wordpress` : Supprime les fichiers temporaires après l'installation.

6. **Message d'état**
   - `else echo "WordPress est déjà installé."` : Si WordPress est déjà installé, un message est affiché.

7. **Configuration de WordPress (commentée)**
   - La section commentée vérifie si le fichier `wp-config.php` existe. Si ce n'est pas le cas, elle crée ce fichier et installe WordPress via WP-CLI. Ces commandes sont mises en commentaire pour être activées plus tard, une fois que tu auras connecté tes conteneurs et configuré manuellement WordPress.

8. **Installation des plugins (commentée)**
   - Une autre section commentée pour installer et activer le plugin `wp-redis`, si nécessaire.

9. **Démarrage de PHP-FPM**
   - `exec php-fpm82 -F` : Démarre PHP-FPM en mode premier plan (`-F`), ce qui signifie que le processus sera exécuté en tant que processus principal du conteneur.

### Conclusion

Le script `start_wp.sh` est conçu pour automatiser l'installation de WordPress dans le conteneur Docker, mais avec des parties commentées pour permettre une configuration manuelle initiale. Une fois que tu seras plus à l'aise avec la configuration des conteneurs, tu pourras réactiver les sections commentées pour automatiser complètement le processus. Cela favorise une approche pédagogique en te permettant de comprendre chaque étape avant d'automatiser.

## Test

Pas encore possible il faus connecter les 3 docker

## Fin 

Temporaire :D