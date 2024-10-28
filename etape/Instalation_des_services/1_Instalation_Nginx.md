# 1. Installation de Nginx

> ! Encore à modifier pour la version définitive

**Objectif** : Mettre en place un conteneur contenant NGINX avec TLSv1.2.

Voir [les règles](./../../concepts/regle_du_projet.md).

## Leçon

1. Rédiger un Dockerfile pour installer Nginx.
2. Générer un certificat SSL.
3. Comprendre la configuration de Nginx.
4. Connaître les différentes commandes de Docker.

## C'est quoi ?

Qu'est-ce que [NGINX](./../../concepts/documentation.md#nginx-et-tls) et [TLSv](./../../concepts/documentation.md#nginx-et-tls) ?

### L'arborescence

Dans un premier temps, j'ai testé dans un laboratoire les bases du Dockerfile et j'ai développé au fur et à mesure. Je vais donc expliquer les résultats et avancer progressivement.

Voici l'arborescence obtenue de Nginx :

```zsh
➜  nginx git:(main) ✗ tree
.
├── conf
│   ├── config_vim
│   ├── fastcgi-php.conf
│   └── nginx.conf
├── Dockerfile
└── tools
    └── generateur_certifica.sh

2 directories, 5 files
```

- Le fichier `Dockerfile` permet de spécifier comment construire une image puis exécuter le conteneur.
- Le dossier `conf` contient tous les fichiers de configuration que je vais copier ensuite dans mon conteneur.
- Le dossier `tools` contient tous les outils utiles, en l'occurrence, ici il s'agit d'un script.

### Le contenu du Dockerfile

Voir [Docker info si vous ne comprenez pas certains mots-clés](./../../concepts/Dockerfile_info.md).

```Dockerfile
# Spécifie l'image
FROM alpine:3.19

# Installation de services, mais avant mise à jour des paquets
RUN apk update; apk upgrade

# Installation du serveur web
RUN apk add nginx
# Installation d'un éditeur de texte
RUN apk add vim
# Installation d'un outil pour transférer des données
RUN apk add curl
# Installation d'un interpréteur de commandes
RUN apk add bash
# Installation pour gérer les certificats SSL
RUN apk add openssl

# Création de dossiers et droits de groupe
RUN mkdir -p /etc/nginx/ssl
RUN mkdir -p /var/run/nginx
RUN mkdir -p /var/www/html
RUN adduser -S -G www-data www-data
RUN mkdir -p /etc/nginx/snippets

RUN chmod 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html

# Copie de fichiers de configuration et du script
COPY ./tools/generateur_certifica.sh /root/generateur_certifica_dans_image.sh
COPY ./conf/config_vim /root/.vimrc 
COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./conf/fastcgi-php.conf /etc/nginx/snippets/fastcgi-php.conf

# Génération d'une clé et d'un certificat TLS
RUN /root/generateur_certifica_dans_image.sh

EXPOSE 443

CMD [ "nginx", "-g", "daemon off;" ]
```

### Explication :

1. **RUN mkdir -p ... et RUN adduser ...**
   - Ces commandes créent les répertoires nécessaires à Nginx et ajoutent un utilisateur `www-data` (utilisé généralement par les services web).
   - `chmod 755 /var/www/html` : donne les permissions appropriées au répertoire `/var/www/html`.
   - `chown -R www-data:www-data /var/www/html` : attribue la propriété du répertoire à l'utilisateur `www-data`.

2. **EXPOSE 443**
   - Cette instruction expose le port 443, utilisé pour les connexions HTTPS, afin que l'image Docker sache qu'elle écoute ce port.

3. **CMD ["nginx", "-g", "daemon off;"]**
   - La commande CMD définit l'action par défaut à exécuter lorsque le conteneur démarre. Ici, il s'agit de démarrer Nginx en mode "non-daemon", c'est-à-dire sans passer en arrière-plan, ce qui est nécessaire dans un conteneur Docker.

---

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

Le fichier `nginx.conf` est utilisé pour configurer le serveur web Nginx. Voici un exemple de configuration avec des explications :

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
    server {
        listen 443 ssl;
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_certificate /etc/nginx/ssl/nginx_tls_inception.crt;
        ssl_certificate_key /etc/nginx/ssl/nginx_tls_inception.key;

        root /var/www/html;
        server_name localhost;
        index index.php index.html index.htm;

        location / {
            try_files $uri $uri/ =404;
        }

        location ~ \.php$ {    
            include snippets/fastcgi-php.conf;
            # fastcgi_pass wordpress:9000;
        }
    }
}
```

#### Explications :

1. **`user www-data;`**
   - Définit l'utilisateur sous lequel Nginx s'exécute. Par défaut, Nginx utilise l'utilisateur `www-data` pour des raisons de sécurité.

2. **`worker_processes auto;`**
   - Configure le nombre de processus de travail (workers) que Nginx doit utiliser. L'option `auto` permet à Nginx de déterminer automatiquement le nombre de processus en fonction des ressources disponibles.

3. **`pid /run/nginx.pid;`**
   - Définit l'emplacement du fichier PID de Nginx. Ce fichier contient l'ID du processus principal de Nginx.

4. **`include /etc/nginx/modules-enabled/*.conf;`**
   - Inclut tous les fichiers de configuration des modules activés, ce qui permet de charger des fonctionnalités supplémentaires dans Nginx.

5. **`events { ... }`**
   - La section `events` configure les paramètres de gestion des connexions, comme le nombre maximal de connexions simultanées par worker.

6. **`http { ... }`**
   - La section `http` contient les paramètres de configuration pour le traitement des requêtes HTTP.

   - **`listen 443 ssl;`**
     - Configure Nginx pour écouter sur le port 443 (HTTPS) avec SSL activé.

   - **`ssl_protocols TLSv1.2 TLSv1.3;`**
     - Définit les versions de SSL/TLS autorisées. Ici, les versions 1.2 et 1.3 sont activées pour assurer une connexion sécurisée.

   - **`ssl_certificate` et `ssl_certificate_key`**
     - Définissent les chemins vers le certificat SSL et la clé privée nécessaires pour établir une connexion HTTPS.

   - **`root /var/www/html;`**
     - Spécifie le répertoire racine des fichiers de votre site web.

   - **`server_name localhost;`**
     - Définit le nom du serveur. Ici, il est défini sur `localhost`, mais il peut être remplacé par un nom de domaine réel.

   - **`index index.php index.html index.htm;`**
     - Spécifie les fichiers à utiliser comme index (page d'accueil) dans l'ordre de priorité.

   - **`location / { ... }`**
     - Définit le comportement pour la racine du site. La directive `try_files` tente de servir un fichier ou un répertoire correspondant à la requête. Si rien n'est trouvé, elle renvoie une erreur 404.

   - **`location ~ \.php$ { ... }`**
     - Cette section gère les fichiers PHP. Elle inclut le fichier de configuration `fastcgi-php.conf` pour traiter les requêtes PHP via FastCGI.
     - La ligne **`# fastcgi_pass wordpress

:9000;`** est commentée pour l'instant, car elle sera configurée ultérieurement lors de la mise en place de WordPress.

### 2. Script pour générer les certificats

Le script `generateur_certifica.sh` permet de générer un certificat SSL auto-signé et une clé associée. Voici le contenu du script :

```bash
#!/bin/sh

# Génération d'une clé privée
openssl genrsa -out /etc/nginx/ssl/nginx_tls_inception.key 2048

# Génération d'un certificat auto-signé
openssl req -new -x509 -key /etc/nginx/ssl/nginx_tls_inception.key -out /etc/nginx/ssl/nginx_tls_inception.crt -days 365 -subj "/C=FR/ST=France/L=Paris/O=Inception/OU=IT Department/CN=localhost"
```

- **`openssl genrsa ...`** : génère une clé RSA de 2048 bits.
- **`openssl req -new -x509 ...`** : génère un certificat SSL auto-signé valable 365 jours, avec des informations spécifiées dans le champ `-subj`.

### 3. Construction de l'image Docker

Pour construire l'image Docker à partir du `Dockerfile`, utilisez la commande suivante :

```bash
docker build -t nginx-ssl .
```

### 4. Lancement du conteneur

Pour lancer le conteneur à partir de l'image nouvellement construite, utilisez la commande suivante :

```bash
docker run -d -p 443:443 --name nginx-ssl nginx-ssl
```

### 5. Vérification de l'installation

Pour vérifier que Nginx fonctionne correctement avec HTTPS, ouvrez votre navigateur et accédez à `https://localhost`. Vous devriez voir la page par défaut de Nginx, mais comme c'est un certificat auto-signé, votre navigateur vous avertira que la connexion n'est pas sécurisée.