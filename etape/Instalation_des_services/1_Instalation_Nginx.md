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
FROM alpine:3.19

RUN apk update; apk upgrade
RUN apk add nginx
RUN apk add vim
RUN apk add curl
RUN apk add bash
RUN apk add openssl

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


RUN /root/generateur_certifica_dans_image.sh


#RUN echo "Bienvenue sur mon serveur NGINX !" > /var/www/html/index.html

EXPOSE 443

ENTRYPOINT [ "nginx" ]

CMD ["-g", "daemon off;" ]
```

### Explication :

1. **RUN mkdir -p ... et RUN adduser ...**
   - Ces commandes créent les répertoires nécessaires à Nginx et ajoutent un utilisateur `www-data` (utilisé généralement par les services web).
   - `chmod 755 /var/www/html` : donne les permissions appropriées au répertoire `/var/www/html`.
   - `chown -R www-data:www-data /var/www/html` : attribue la propriété du répertoire à l'utilisateur `www-data`.

2. **EXPOSE 443**
   - Cette instruction expose le port 443, utilisé pour les connexions HTTPS, afin que l'image Docker sache qu'elle écoute ce port.

3. **ENTRYPOINT ["nginx"]**
   - L'instruction **ENTRYPOINT** définit le programme à exécuter lorsqu'un conteneur basé sur cette image est lancé. Ici, le programme spécifié est `nginx`. 
   - Cela permet d'exécuter Nginx en tant que processus principal du conteneur. Cette commande ne sera **pas remplacée** si des arguments sont passés au conteneur lors de son lancement. 
   - **ENTRYPOINT** est utilisé ici pour définir un comportement principal et constant : démarrer Nginx.

4. **CMD ["-g", "daemon off;"]**
   - La commande **CMD** définit les arguments par défaut à passer à l'exécutable spécifié dans **ENTRYPOINT**. 
   - Ici, avec `ENTRYPOINT ["nginx"]`, la commande **CMD** passe l'argument `-g "daemon off;"` à Nginx, ce qui permet de le lancer en mode "non-daemon" (c'est-à-dire sans le mettre en arrière-plan). Ce mode est nécessaire dans un conteneur Docker pour que le processus principal reste en premier plan, permettant ainsi au conteneur de continuer à fonctionner correctement. 
   - Si des arguments sont fournis lors du lancement du conteneur, ces derniers remplaceront les valeurs spécifiées dans **CMD**, mais **ENTRYPOINT** restera inchangé.

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
	include /etc/nginx/mime.types;
	default_type application/octet-stream;
	server {
		listen 443 ssl;
		ssl_protocols TLSv1.2 TLSv1.3;
		ssl_certificate /etc/nginx/ssl/nginx_tls_inception.crt;
		ssl_certificate_key /etc/nginx/ssl/nginx_tls_inception.key;

		root /var/www/wordpress; #/var/www/html;
		server_name localhost;
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

#### Explications :

1. **Configuration globale :**
   - **user www-data** : Nginx s'exécute avec l'utilisateur `www-data` pour des raisons de sécurité.
   - **worker_processes auto** : Détermine automatiquement le nombre de processus de travail.
   - **include /etc/nginx/modules-enabled/*.conf** : Inclut les modules supplémentaires de Nginx.

2. **Bloc `http` :**
   - **ssl_protocols TLSv1.2 TLSv1.3** : Active TLS 1.2 et 1.3 pour les connexions sécurisées.
   - **ssl_certificate /etc/nginx/ssl/nginx_tls_inception.crt** : Définit le certificat SSL.
   - **root /var/www/wordpress** : Spécifie le répertoire racine du site.
   - **server_name localhost** : Le serveur répond à `localhost`.
   - **index index.php index.html** : Liste des fichiers index.

3. **Bloc `location / { ... }` :**
   - **try_files $uri $uri/ /index.php$is_args$args** : Recherche des fichiers ou redirige vers `index.php` si non trouvé.

4. **Bloc `location ~ \.php$ { ... }` :**
   - **fastcgi_pass wordpress:9000** : Envoie les requêtes PHP au serveur PHP-FPM.
   - **include snippets/fastcgi-php.conf** : Inclut la configuration PHP pour FastCGI.
   - **fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name** : Définit le chemin du fichier PHP.

En résumé, ce fichier configure un serveur Nginx sécurisé pour servir un site WordPress en HTTPS, rediriger les requêtes PHP vers PHP-FPM et gérer les fichiers statiques.

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