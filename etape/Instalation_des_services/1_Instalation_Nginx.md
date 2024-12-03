# 1. Installation de Nginx

- [1. Installation de Nginx](#1-installation-de-nginx)
  - [Leçon](#leçon)
  - [C'est quoi](#cest-quoi)
  - [L'arborescence du projet](#larborescence-du-projet)
  - [Le contenu du Dockerfile](#le-contenu-du-dockerfile)
    - [Explication](#explication)
  - [Explication des fichiers de configuration](#explication-des-fichiers-de-configuration)
    - [`config_vim`](#config_vim)
    - [`fastcgi-php.conf`](#fastcgi-phpconf)
    - [`nginx.conf`](#nginxconf)
      - [Explications](#explications)
    - [1. Script pour générer les certificats](#1-script-pour-générer-les-certificats)
      - [Explication](#explication-1)
    - [2. Script pour démarrer le serveur](#2-script-pour-démarrer-le-serveur)
      - [Explication](#explication-2)
  - [Tester le Docker individuellement](#tester-le-docker-individuellement)
    - [1. Construction de l'image](#1-construction-de-limage)
    - [2. Lancement du conteneur](#2-lancement-du-conteneur)
    - [3. Vérification de l'installation](#3-vérification-de-linstallation)

## Leçon

- **Objectif** : Mettre en place un conteneur contenant NGINX avec TLSv1.2.
- **Tâches à réaliser** :
  1. Rédiger un Dockerfile pour installer Nginx.
  2. Générer un certificat SSL pour la connexion sécurisée.
  3. Comprendre la configuration de Nginx.
  4. Apprendre à utiliser les commandes de Docker.

---

## C'est quoi

Qu'est-ce que [NGINX](./../../concepts/documentation.md#nginx-et-tls) et [TLSv](./../../concepts/documentation.md#nginx-et-tls) ?

## L'arborescence du projet

Voici l'arborescence du projet que nous avons utilisée pour ce tutoriel :

```bash
➜  nginx git:(main) ✗ tree
.
├── Dockerfile
├── conf
│   ├── config_vim
│   ├── fastcgi-php.conf
│   └── nginx.conf
└── tools
    ├── generateur_certificat.sh
    └── start_server.sh

2 directories, 6 files
```

**Explications des éléments** :

- **Dockerfile** : Ce fichier définit la manière dont l'image Docker doit être construite, en incluant l'installation de Nginx et d'autres dépendances nécessaires.
- **conf** : Ce répertoire contient les fichiers de configuration que nous allons utiliser dans Nginx pour personnaliser son fonctionnement.
    - `config_vim` : Un fichier de configuration pour Vim, si tu en as besoin pour ton environnement.
    - `fastcgi-php.conf` : La configuration nécessaire pour l'intégration avec PHP-FPM (si tu utilises PHP dans ton projet).
    - `nginx.conf` : Le fichier principal de configuration de Nginx.
- **tools** : Ce répertoire contient des scripts utiles pour la gestion du serveur et la création des certificats SSL.
    - `generateur_certificat.sh` : Un script pour générer des certificats SSL.
    - `start_server.sh` : Un script pour démarrer le serveur Nginx à l'intérieur du conteneur Docker.

---

Est-ce que cette version te convient pour cette partie ? Si tu es satisfait, nous pourrons avancer progressivement dans les sections suivantes.

## Le contenu du Dockerfile

Voir [Docker info si vous ne comprenez pas certains mots-clés](./../../concepts/Dockerfile_info.md).

```Dockerfile
FROM alpine:3.19

ARG SERVER_NAME

RUN apk update; apk upgrade
RUN apk add nginx
RUN apk add vim
RUN apk add curl
RUN apk add bash
RUN apk add openssl
RUN apk add envsubst

RUN mkdir -p /etc/nginx/ssl
RUN mkdir -p /var/run/nginx
RUN mkdir -p /var/www/html
RUN adduser -S -G www-data www-data
RUN mkdir -p /etc/nginx/snippets

RUN chmod 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html

COPY ./tools/generateur_certifica.sh /root/generateur_certifica_dans_image.sh
COPY ./conf/config_vim /root/.vimrc 
COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./conf/fastcgi-php.conf /etc/nginx/snippets/fastcgi-php.conf
COPY ./tools/start_server.sh /root/start_server.sh

RUN /root/generateur_certifica_dans_image.sh

#RUN echo "Bienvenue sur mon serveur NGINX !" > /var/www/html/index.html

EXPOSE 443

ENTRYPOINT [ "/root/start_server.sh" ]
```

---

### Explication

1. **RUN mkdir -p ... et RUN adduser ...**
   - Crée les répertoires nécessaires pour Nginx et ajoute l'utilisateur `www-data` (utilisé pour les services web).
   - `chmod 755 /var/www/html` : Attribue les bonnes permissions.
   - `chown -R www-data:www-data /var/www/html` : Change le propriétaire du répertoire pour l'utilisateur `www-data`.

2. **RUN apk add ...**
   - Installe les paquets nécessaires pour Nginx et les outils comme `vim`, `curl`, `openssl`, etc.

3. **COPY ...**
   - Copie les fichiers de configuration et le script de génération de certificats dans le conteneur.

4. **RUN /root/generateur_certifica_dans_image.sh**
   - Exécute le script pour générer un certificat SSL durant la construction de l'image.

5. **EXPOSE 443**
   - Expose le port 443 pour les connexions HTTPS.

6. **ENTRYPOINT [ "/root/start_server.sh" ]**
   - Définit le script `start_server.sh` comme programme principal à exécuter lors du démarrage du conteneur.

## Explication des fichiers de configuration

### `config_vim`

Ce fichier est optionnel. Il permet de configurer directement l'éditeur Vim à l'intérieur du conteneur. Si vous avez des préférences spécifiques pour l'édition de texte, ce fichier les appliquera automatiquement lors de l'utilisation de Vim.

### `fastcgi-php.conf`

> À supprimer car ce sera le conteneur WordPress qui s'en occupera.

Le fichier `fastcgi-php.conf` configure Nginx pour le traitement des requêtes PHP via FastCGI. Voici son contenu :

```conf
# fastcgi-php.conf
fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
fastcgi_param DOCUMENT_ROOT $document_root;
include fastcgi_params;
```

- **`SCRIPT_FILENAME`** : Définit le chemin absolu du fichier PHP à exécuter.
- **`DOCUMENT_ROOT`** : Définit le répertoire racine de votre serveur web.
- **`include fastcgi_params`** : Inclut les paramètres de configuration nécessaires pour le bon fonctionnement de FastCGI.

Ce fichier est utilisé dans la configuration de Nginx pour les requêtes PHP.

### `nginx.conf`

Le fichier `nginx.conf` configure Nginx pour un serveur sécurisé avec TLS. Voici un aperçu de la configuration :

```conf
# Yaya version (ง ͠ಥ_ಥ)ง
user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
    worker_connections 768;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    server {
        listen 443 ssl;
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_certificate /etc/nginx/ssl/nginx_tls_inception.crt;
        ssl_certificate_key /etc/nginx/ssl/nginx_tls_inception.key;

        root /var/www/wordpress; #/var/www/html;
        server_name ${SERVER_NAME};
        index index.php index.html index.htm;

        location / {
            try_files $uri $uri/ /index.php$is_args$args;
        }

        location ~ \.php$ {
            include snippets/fastcgi-php.conf;
            fastcgi_pass wordpress:9000;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            include fastcgi_params;
        }
    }
}
```

#### Explications

1. **Configuration globale :**
   - **`user www-data`** : Nginx s'exécute sous l'utilisateur `www-data` pour des raisons de sécurité.
   - **`worker_processes auto`** : Le nombre de processus est ajusté automatiquement en fonction des cœurs CPU disponibles.
   - **`include /etc/nginx/modules-enabled/*.conf`** : Inclut les modules Nginx activés pour ajouter des fonctionnalités supplémentaires.

2. **Bloc `http` :**
   - **`ssl_protocols TLSv1.2 TLSv1.3`** : Active TLS 1.2 et 1.3 pour une connexion sécurisée.
   - **`ssl_certificate` et `ssl_certificate_key`** : Définit le certificat SSL et sa clé pour HTTPS.
   - **`root /var/www/wordpress`** : Définit le répertoire racine de votre site WordPress.
   - **`server_name ${SERVER_NAME}`** : Le nom du serveur est défini dynamiquement via une variable d'environnement.
   - **`index`** : Définit les fichiers à utiliser comme index.

3. **Bloc `location / { ... }` :**
   - **`try_files`** : Cherche les fichiers ou redirige vers `index.php` si le fichier n'existe pas.

4. **Bloc `location ~ \.php$ { ... }` :**
   - **`fastcgi_pass wordpress:9000`** : Envoie les requêtes PHP à PHP-FPM sur le conteneur `wordpress:9000`.
   - **`include snippets/fastcgi-php.conf`** : Inclut la configuration FastCGI pour PHP.
   - **`fastcgi_param SCRIPT_FILENAME`** : Définit le chemin du fichier PHP à exécuter.

Ce fichier configure Nginx pour servir un site WordPress en HTTPS et gérer les requêtes PHP via PHP-FPM, tout en permettant une gestion flexible du nom de serveur et de la sécurité.

Voici une explication et une version simplifiée du script `generateur_certifica.sh` :

### 1. Script pour générer les certificats

Le script `generateur_certifica.sh` crée un certificat SSL auto-signé ainsi qu'une clé privée. Voici le contenu du script :

```bash
#!/bin/bash

ROUGE="\e[31m"
NOCOLOR="\e[0m"

# Vérifie si OpenSSL est installé
if ! command -v openssl &> /dev/null
then
    echo -e $ROUGE "Erreur : 'openssl' n'est pas installé. Veuillez l'installer pour continuer." $NOCOLOR
    exit 1
fi

# Définit les chemins des certificats et de la clé
CERT_PATH="/etc/nginx/ssl/nginx_tls_inception.crt"
KEY_PATH="/etc/nginx/ssl/nginx_tls_inception.key"

# Définition du sujet du certificat
SUBJECT="/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=yzaoui.42.fr/UID=yzaoui"

# Génère le certificat SSL auto-signé
openssl req -x509 -nodes -out $CERT_PATH -keyout $KEY_PATH -subj "$SUBJECT"
```

#### Explication

1. **Vérification de `openssl`** : Le script vérifie si `openssl` est installé sur la machine. Si ce n'est pas le cas, il affiche un message d'erreur et arrête le script.
2. **Définition des chemins** : Le certificat et la clé sont enregistrés dans `/etc/nginx/ssl/` sous les noms `nginx_tls_inception.crt` et `nginx_tls_inception.key`.
3. **Sujet du certificat** : Le sujet du certificat définit des informations comme le pays, l'État, la localité, l'organisation, etc.
4. **Génération du certificat** : Utilise `openssl` pour générer un certificat auto-signé à partir des informations définies.

### 2. Script pour démarrer le serveur

Le script `start_server.sh` remplace la variable d'environnement dans `nginx.conf`, affiche une valeur pour le débogage et démarre Nginx en arrière-plan. Voici le contenu du script :

```bash
#!/bin/sh

# Remplace la variable $SERVER_NAME dans nginx.conf par sa valeur dans l'environnement
envsubst '${SERVER_NAME}' < /etc/nginx/nginx.conf > /etc/nginx/nginx_TMP.conf
mv /etc/nginx/nginx_TMP.conf /etc/nginx/nginx.conf
echo $SERVER_NAME > /res.txt

# Lance Nginx avec la commande "daemon off" pour qu'il fonctionne en premier plan
exec nginx -g "daemon off;"
```

#### Explication

1. **Remplacement de la variable d'environnement** : 
   - `envsubst '${SERVER_NAME}'` remplace la variable `${SERVER_NAME}` dans le fichier `nginx.conf` par sa valeur actuelle dans l'environnement.
   - Le fichier temporaire `nginx_TMP.conf` est ensuite écrit, puis renommé pour remplacer l'original `nginx.conf`.

2. **Affichage de la variable d'environnement** : 
   - `echo $SERVER_NAME > /res.txt` écrit la valeur de la variable `SERVER_NAME` dans le fichier `/res.txt` pour déboguer et vérifier sa valeur.

3. **Démarrage de Nginx** : 
   - La commande `exec nginx -g "daemon off;"` démarre Nginx en mode premier plan, ce qui est nécessaire pour le bon fonctionnement dans un conteneur Docker ou un environnement où les processus doivent être gérés directement par le système.

## Tester le Docker individuellement

### 1. Construction de l'image

Pour construire l'image Docker à partir du `Dockerfile`, utilisez la commande suivante :

```bash
docker build -t nginx-ssl-img .
```

### 2. Lancement du conteneur

Pour lancer le conteneur à partir de l'image nouvellement construite, vous pouvez définir la variable d'environnement `SERVER_NAME` avec la commande suivante :

```bash
docker run -d -p 443:443 -e SERVER_NAME=localhost --name nginx-ssl-cont nginx-ssl-img
```

- **`-e SERVER_NAME=localhost`** : Déclare la variable d'environnement `SERVER_NAME` avec la valeur `localhost`, qui sera utilisée dans le fichier `nginx.conf` pour remplacer la variable dynamique.
  
### 3. Vérification de l'installation

Pour vérifier que Nginx fonctionne correctement avec HTTPS, ouvrez votre navigateur et accédez à `https://localhost`. Vous verrez la page par défaut de Nginx, mais étant donné que le certificat est auto-signé, votre navigateur vous avertira que la connexion n'est pas sécurisée.

Ou, vous pouvez utiliser `curl` pour tester directement :

```bash
curl -k https://localhost
```

L'option `-k` permet d'ignorer les avertissements de certificat auto-signé et d'effectuer la requête HTTPS.