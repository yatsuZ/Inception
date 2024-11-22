# Mis en place du docker-compose

### Rappel : Objectif du Docker Compose

Le but de ce fichier `docker-compose.yml` est de gérer l'interconnexion des services. Il permet de configurer les conteneurs pour qu'ils puissent se communiquer et fonctionner ensemble de manière cohérente. Dans ce cas, Nginx agira comme un serveur proxy pour servir WordPress, tandis que MariaDB fournira la base de données nécessaire à WordPress.

## Comment faire ?

1. **Créer le fichier `docker-compose.yml`** : Ce fichier permet de définir les services (nginx, mariadb, wordpress) et leurs configurations, comme les volumes et les variables d'environnement.

2. **Configurer les services** : 
   - **nginx** : sert de proxy pour WordPress.
   - **mariadb** : gère la base de données de WordPress.
   - **wordpress** : héberge le site web et dépend de mariadb.

3. **Définir les volumes** : Assurer la persistance des données de WordPress et MariaDB entre les redémarrages.

4. **Configurer le réseau** : Créer un réseau `inception` pour connecter les services entre eux.

5. **Tester les services** : Utiliser `docker-compose down -v --rmi all && docker-compose build && docker-compose up -d` pour tester et redémarrer les services.

6. **Vérification** : Vérifier que tout fonctionne avec `docker-compose ps`.

### Arborescence

```zsh
➜  srcs git:(main) ✗ tree
.
├── docker-compose.yml
├── .env
└── requirements
    ├── bonus
    │   └── info.txt
    ├── mariadb
    │   └── [...]
    ├── nginx
    │   └── [...]
    └── wordpress
        └── [...]

14 directories, 18 files
```

## Le docker-compose

```yml
services:
  nginx:
    init: true
    container_name: nginx
    build:
      context: requirements/nginx
      dockerfile: Dockerfile
    image: nginx-img
    volumes:
      - wordpress:/var/www/wordpress
    networks:
      - inception
    depends_on:
      - wordpress
    env_file: .env
    ports:
      - "443:443"
    restart: always

  mariadb:
    init: true
    container_name: mariadb
    build: 
      context: requirements/mariadb
      dockerfile: Dockerfile
    image: mariadb-img
    networks:
      - inception
    env_file: .env
    environment:
      - MARIA_PATH=${MARIA_PATH}
      - SQL_NAME_DATABASE=${SQL_NAME_DATABASE}
      - SQL_NAME_USER=${SQL_NAME_USER}
      - SQL_PASSWORD_USER=${SQL_PASSWORD_USER}
      - SQL_PASSWORD_ROOT=${SQL_PASSWORD_ROOT}
    volumes:
      - mariadb:/var/lib/mysql
    restart: always
    ports:
      - "3306:3306"
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      interval: 20s
      timeout: 10s
      retries: 15
      start_period: 30s

  wordpress:
    init: true
    container_name: wordpress
    build:
      context: requirements/wordpress
      dockerfile: Dockerfile
    depends_on:
      mariadb:
        condition: service_healthy
    image: wordpress-img
    volumes:
      - wordpress:/var/www/wordpress
    networks:
      - inception
    env_file: .env
    environment:
      - TITLE_OF_SITE=${TITLE_OF_SITE}
      - SERVER_NAME=${SERVER_NAME}
      - SQL_NAME_DATABASE=${SQL_NAME_DATABASE}
      - SQL_NAME_USER=${SQL_NAME_USER}
      - SQL_PASSWORD_USER=${SQL_PASSWORD_USER}
      - SQL_PASSWORD_ROOT=${SQL_PASSWORD_ROOT}
    restart: always
    ports:
      - "9000:9000"

volumes:
  wordpress:
    driver: local
    driver_opts:
      type: 'none'
      o: 'bind'
      device: './data_docker_compose/wordpress'
  mariadb:
    driver: local
    driver_opts:
      type: 'none'
      o: 'bind'
      device: './data_docker_compose/mariadb'

networks:
  inception:
    driver: bridge
```

## Explication Generale

### Partie Services

Le fichier `docker-compose.yml` définit trois services principaux : **nginx**, **mariadb** et **wordpress**. Ces services interagissent entre eux pour fournir un environnement fonctionnel pour le site WordPress.

1. **Nginx** : Le service **nginx** sert de **proxy inverse** pour WordPress. Il reçoit les requêtes HTTP(S) de l'utilisateur et les redirige vers le service WordPress, tout en assurant la gestion des connexions sécurisées via HTTPS.
   - Nginx dépend du service **wordpress** pour fonctionner, car il doit interagir avec les fichiers du site stockés dans le volume `wordpress`.
   - Ce service est configuré pour redémarrer automatiquement en cas de panne grâce à l'option `restart: always`.

2. **MariaDB** : Le service **mariadb** est responsable de la gestion de la base de données. Il fournit une base de données MySQL compatible où WordPress peut stocker ses données (articles, utilisateurs, paramètres, etc.).
   - Ce service dépend de variables d'environnement qui sont définies dans le fichier `.env` et qui permettent de configurer la base de données (nom, utilisateur, mot de passe).
   - Il est configuré avec une **vérification de l'état de santé** via `healthcheck`, qui vérifie régulièrement si le service est en bonne santé et le redémarre si nécessaire.

3. **WordPress** : Le service **wordpress** héberge le site web lui-même. Il interagit directement avec MariaDB pour stocker et récupérer les informations du site.
   - Il dépend du service **mariadb**, mais également de la condition `service_healthy` pour s'assurer que MariaDB est opérationnel avant de démarrer.
   - Il expose le port 9000 pour communiquer avec Nginx et permet l'accès à l'application via le réseau `inception`.
   - Il utilise un volume persistant pour stocker les fichiers WordPress, garantissant ainsi que les données du site sont conservées même en cas de redémarrage ou de suppression du conteneur.

## Explication Technique

### Partie Nginx
Le service **nginx** est utilisé comme un proxy inverse pour WordPress. Il écoute sur le port 443 (HTTPS) et sert de point d'entrée pour les requêtes HTTP/HTTPS entrantes.

- **`init: true`** : Spécifie que le conteneur sera initialisé avec des configurations spécifiées.
- **`container_name: nginx`** : Donne un nom explicite au conteneur.
- **`build`** : Le contexte de construction pour l'image de Nginx. Le `dockerfile` indique que le fichier Dockerfile est situé dans le répertoire `requirements/nginx`.
- **`image: nginx-img`** : L'image Docker construite sera étiquetée `nginx-img`.
- **`volumes`** : Monte un volume pour persister les fichiers de WordPress dans `/var/www/wordpress` dans le conteneur Nginx.
- **`networks`** : Le conteneur est connecté au réseau `inception`, ce qui permet la communication avec les autres services comme WordPress.
- **`depends_on`** : Assure que Nginx attend que WordPress soit lancé avant de démarrer.
- **`ports`** : Mappe le port 443 du conteneur vers le port 443 de l'hôte pour l'accès HTTPS.
- **`restart: always`** : Redémarre le conteneur automatiquement en cas d'échec.

### Partie MariaDB
Le service **mariadb** gère la base de données utilisée par WordPress.

- **`init: true`** : Comme pour Nginx, indique que le service MariaDB doit être initialisé.
- **`container_name: mariadb`** : Définit le nom du conteneur MariaDB.
- **`build`** : Le service MariaDB est construit à partir du répertoire `requirements/mariadb` où le Dockerfile est situé.
- **`image: mariadb-img`** : L'image Docker construite est étiquetée `mariadb-img`.
- **`environment`** : Contient des variables d'environnement pour configurer la base de données, comme le nom de la base de données et les utilisateurs.
- **`volumes`** : Monte un volume pour persister les données de la base de données dans le répertoire `/var/lib/mysql`.
- **`healthcheck`** : Vérifie la santé du service en utilisant la commande `mysqladmin ping`, redémarrant le conteneur si un problème est détecté.
- **`restart: always`** : Redémarre le conteneur automatiquement en cas d'échec.

### Partie WordPress
Le service **wordpress** gère le site web et interagit avec MariaDB pour gérer les données du site.

- **`init: true`** : L'initialisation du conteneur WordPress est activée.
- **`container_name: wordpress`** : Définit un nom explicite pour le conteneur.
- **`build`** : Spécifie le contexte de construction du conteneur WordPress à partir de `requirements/wordpress`.
- **`depends_on`** : Assure que le service WordPress attend que le service MariaDB soit opérationnel avant de démarrer.
- **`image: wordpress-img`** : L'image Docker construite sera étiquetée `wordpress-img`.
- **`volumes`** : Monte un volume pour persister les fichiers de WordPress dans `/var/www/wordpress` dans le conteneur.
- **`environment`** : Contient des variables d'environnement pour configurer le site WordPress (nom de la base de données, utilisateur, etc.).
- **`ports`** : Mappe le port 9000 du conteneur vers le port 9000 de l'hôte pour accéder à WordPress via PHP.
- **`restart: always`** : Le conteneur redémarre en cas d'échec, garantissant ainsi la disponibilité continue du service.

### Partie Volumes
Les volumes permettent de persister les données des services entre les redémarrages de conteneurs.

- **`wordpress`** : Ce volume persiste les données de WordPress dans le répertoire `./data_docker_compose/wordpress` de l'hôte. Cela garantit que les fichiers WordPress seront conservés même si le conteneur est supprimé.
- **`mariadb`** : Ce volume persiste les données de la base de données MariaDB dans `./data_docker_compose/mariadb`.

### Partie Networks
Les **réseaux** définissent la manière dont les conteneurs communiquent entre eux.

- **`inception`** : Un réseau de type **bridge** est créé pour que tous les services (Nginx, MariaDB, et WordPress) puissent communiquer entre eux. Cela garantit que chaque service peut se retrouver en utilisant leur nom de conteneur comme adresse réseau.
