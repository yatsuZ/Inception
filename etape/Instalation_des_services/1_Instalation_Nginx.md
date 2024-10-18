# 1. Installation de Nginx

Objectif : Mettre en place un conteneur contenant NGINX avec TLSv1.2

voir [les règles](./../../concepts/regle_du_projet.md).

## Lecon

1. Rediger un docker file pour installer nginx
2. Genere un certificat SSL 
3. Comprendre la configuration de nginx
4. Connaitre les differente commande de docker

## C'est quoi

qu'es que c'est que [NGINX](./../../concepts/documentation.md#nginx-et-tls) et [TLSv](./../../concepts/documentation.md#nginx-et-tls) ?

## Comment faire ?

### L'arobraissance

Dans un premiere temp j'ai teste dans laboratoire les base de Dockerfile et j'ai developper au fur et a mesure.
Donc je vais expliquer le resultat et expliquer au fur et a mesure.

Voci l'arboraissance rendu de nginx :

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

- Le fichier Dockerfile et ce qui permet de dire comment build une image puis run le conteneur
- Le dossier conf contien tout type de fichier de configuration que je vais copier ensuite dans mon docker
- Le dossier tools contient tout outil utls en locurence la il sagit de script

### Le contenue du Docker file

voir [Docker info si vous ne comprenz pas certain mot clée](./../../concepts/Dockerfile_info.md).

```Dockerfile
# specifie l'image
FROM alpine:3.19

# Installation de service mais avant mise a jour des paquets
RUN apk update; apk upgrade

# le serveur web.
RUN apk add nginx
# un éditeur de texte.
RUN apk add vim
# un outil pour transférer des données.
RUN apk add curl
# un interpréteur de commandes.
RUN apk add bash
# pour gérer les certificats SSL.
RUN apk add openssl

# Creation de dossier et droit de groupe
RUN mkdir -p /etc/nginx/ssl
RUN mkdir -p /var/run/nginx
RUN mkdir -p /var/www/html
RUN adduser -S -G www-data www-data
RUN mkdir -p /etc/nginx/snippets

RUN chmod 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html

# Copie de fichier de configuration + script sh
COPY ./tools/generateur_certifica.sh /root/generateur_certifica_dans_image.sh
COPY ./conf/config_vim /root/.vimrc 
COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./conf/fastcgi-php.conf /etc/nginx/snippets/fastcgi-php.conf

# Genere une clée et un certifica tls
RUN /root/generateur_certifica_dans_image.sh

EXPOSE 443

CMD [ "nginx", "-g", "daemon off;" ]
```

EXPLICATION :

1. RUN mkdir -p ... et RUN adduser ...
   - Ces commandes créent les répertoires nécessaires à Nginx et ajoutent un utilisateur www-data (utilisé généralement par les services web).
   - chmod 755 /var/www/html : donne les permissions appropriées au répertoire /var/www/html.
   - chown -R www-data:www-data /var/www/html : attribue la propriété du répertoire à l'utilisateur www-data.

2. EXPOSE 443
   - Cette instruction expose le port 443, utilisé pour les connexions HTTPS, afin que l'image Docker sache qu'elle écoute ce port.

3. CMD ["nginx", "-g", "daemon off;"]
   - La commande CMD définit l'action par défaut à exécuter lorsque le conteneur démarre. Ici, il s'agit de démarrer Nginx en mode "non-daemon", c'est-à-dire sans passer en arrière-plan, ce qui est nécessaire dans un conteneur Docker.


---

## Explication des fichiers de configuration

### `config_vim`

Ce fichier est optionnel. Il permet de configurer directement l'éditeur Vim à l'intérieur du conteneur. Si vous avez des préférences spécifiques pour l'édition de texte, ce fichier les appliquera automatiquement lors de l'utilisation de Vim.

### `fastcgi-php.conf`

> A suprimer car sa sera le contenair wordpress qui devra son occupée

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
     - La ligne **`# fastcgi_pass wordpress:9000;`** est commentée, mais elle pourrait être utilisée pour rediriger les requêtes PHP vers un service PHP (par exemple, un conteneur Docker exécutant PHP-FPM).

Voici une version révisée de l'explication pour le script de génération de clé et de certificat, avec quelques clarifications.

---

## Générateur de clé et de certificat

### `generateur_certifica.sh`

Le script suivant est utilisé pour générer un certificat SSL/TLS et une clé privée en utilisant `openssl`. Cela peut être nécessaire pour sécuriser un serveur web, comme dans le cas de Nginx, qui nécessite des certificats SSL pour activer HTTPS.

```sh
#!/bin/bash

ROUGE="\e[31m"
NOCOLOR="\e[0m"

if ! command -v openssl &> /dev/null
then
    echo -e $ROUGE "Erreur : 'openssl' n'est pas installé. Veuillez l'installer pour continuer." $NOCOLOR
    exit 1
fi

CERT_PATH="/etc/nginx/ssl/nginx_tls_inception.crt"
KEY_PATH="/etc/nginx/ssl/nginx_tls_inception.key"
SUBJECT="/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=yzaoui.42.fr/UID=yzaoui"

openssl req -x509 -nodes -out $CERT_PATH -keyout $KEY_PATH -subj "$SUBJECT"
```

### Explication des commandes

1. **Définition des couleurs** :
   - `ROUGE="\e[31m"` et `NOCOLOR="\e[0m"` : Ces variables permettent de colorer le texte de sortie en rouge pour les messages d'erreur. Cela rend les erreurs plus visibles dans le terminal.

2. **Vérification de la commande `openssl`** :
   ```sh
   if ! command -v openssl &> /dev/null
   then
       echo -e $ROUGE "Erreur : 'openssl' n'est pas installé. Veuillez l'installer pour continuer." $NOCOLOR
       exit 1
   fi
   ```
   - Ce bloc vérifie si la commande `openssl` est disponible sur le système. Si `openssl` n'est pas installé, un message d'erreur est affiché et le script se termine (`exit 1`).

3. **Définition des chemins du certificat et de la clé** :
   ```sh
   CERT_PATH="/etc/nginx/ssl/nginx_tls_inception.crt"
   KEY_PATH="/etc/nginx/ssl/nginx_tls_inception.key"
   ```
   - Ces variables définissent l'emplacement des fichiers de certificat (`.crt`) et de clé privée (`.key`). Ces fichiers seront utilisés par Nginx pour la connexion sécurisée HTTPS.

4. **Définition du sujet (Subject)** :
   ```sh
   SUBJECT="/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=yzaoui.42.fr/UID=yzaoui"
   ```
   - Le **sujet** définit les informations sur l'entité qui possède le certificat :
     - `/C=FR` : Pays (France)
     - `/ST=IDF` : État (Île-de-France)
     - `/L=Paris` : Localité (Paris)
     - `/O=42` : Organisation (42, par exemple une école ou une entreprise)
     - `/OU=42` : Unité organisationnelle
     - `/CN=yzaoui.42.fr` : Nom commun (nom de domaine ou nom d'utilisateur associé au certificat)
     - `/UID=yzaoui` : ID utilisateur (identifiant unique)

5. **Commande `openssl req -x509 -nodes`** :
   ```sh
   openssl req -x509 -nodes -out $CERT_PATH -keyout $KEY_PATH -subj "$SUBJECT"
   ```
   - **`openssl req`** : Utilise la commande `req` pour créer une demande de certificat.
   - **`-x509`** : Cette option génère un certificat auto-signé au lieu de créer une demande de signature de certificat (CSR). Cela est utile pour les tests internes ou les environnements de développement.
   - **`-nodes`** : Indique de ne pas chiffrer la clé privée. Cela permet à Nginx de l'utiliser directement sans nécessiter de mot de passe.
   - **`-out $CERT_PATH`** : Spécifie l'emplacement du certificat généré (`$CERT_PATH`).
   - **`-keyout $KEY_PATH`** : Spécifie l'emplacement de la clé privée générée (`$KEY_PATH`).
   - **`-subj "$SUBJECT"`** : Utilise le sujet précédemment défini pour remplir les informations du certificat.

### Tester le conteneur

1. **Construire l'image Docker** :
   Utilisez la commande suivante pour construire l'image Docker à partir du `Dockerfile` :

   ```bash
   docker build -t docker_name .
   ```

   - **Vérification** : Pour vérifier si l'image a bien été créée, utilisez la commande suivante :

   ```bash
   docker images
   ```

   Cela vous permettra de lister toutes les images Docker présentes sur votre machine.

2. **Exécuter le conteneur** :
   Pour créer et exécuter le conteneur à partir de l'image construite, utilisez cette commande :

   ```bash
   docker run -d -p 443:443 docker_name
   ```

   - **Options** :
     - `-d` : Exécute le conteneur en mode détaché (en arrière-plan).
     - `-p 443:443` : Mappe le port 443 du conteneur vers le port 443 de votre machine hôte (port HTTPS).

   **Manipuler le conteneur** : Pour accéder au conteneur et exécuter des commandes à l'intérieur, utilisez la commande suivante :

   ```bash
   docker exec -it [ID du conteneur] sh
   ```

   Cela vous donnera un shell interactif dans le conteneur.

3. **Tester la connexion HTTPS** :
   Vous pouvez tester la connexion HTTPS à votre conteneur avec la commande `curl` ou via votre navigateur web.

   - **Via `curl`** :

   ```bash
   curl -k https://localhost
   ```

   - L'option `-k` est utilisée pour ignorer les erreurs liées à l'auto-signature du certificat SSL (généralement utilisé pour les certificats non vérifiés).

   - **Via le navigateur** : Accédez à `https://localhost` et vous devriez voir la page web servie par Nginx, même si le certificat SSL est auto-signé.

4. **Arrêter et supprimer le conteneur** :
   - **Arrêter le conteneur** : Si vous souhaitez arrêter le conteneur en cours d'exécution, utilisez la commande suivante en remplaçant `[ID du conteneur]` par l'ID du conteneur :

   ```bash
   docker stop [ID du conteneur]
   ```

   - **Supprimer le conteneur** : Une fois le conteneur arrêté, vous pouvez le supprimer avec cette commande :

   ```bash
   docker rm [ID du conteneur]
   ```

5. **Supprimer l'image** :
   Pour supprimer l'image Docker, utilisez la commande suivante en remplaçant `[docker_name]` par le nom de votre image :

   ```bash
   docker rmi docker_name
   ```

   Cela supprimera l'image de votre machine.

## FIN

passer ensuite a la creation de du dockerfile de maridb.