# Mis en place du docker-compose

- [Mis en place du docker-compose](#mis-en-place-du-docker-compose)
    - [Rappel : Objectif du Docker Compose](#rappel--objectif-du-docker-compose)
    - [Comment faire ?](#comment-faire-)
    - [Arborescence](#arborescence)
  - [Le docker-compose](#le-docker-compose)
    - [Explication Générale](#explication-générale)
      - [Partie Services](#partie-services)
    - [Explication Technique](#explication-technique)
      - [Partie Nginx](#partie-nginx)
    - [Partie MariaDB](#partie-mariadb)
    - [Partie WordPress](#partie-wordpress)
    - [Partie Volumes](#partie-volumes)
    - [Partie Networks](#partie-networks)
    - [Partie Secrets](#partie-secrets)
    - [Conclusion](#conclusion)

### Rappel : Objectif du Docker Compose

Le but de ce fichier `docker-compose.yml` est de gérer l'interconnexion des services. Il permet de configurer les conteneurs pour qu'ils puissent se communiquer et fonctionner ensemble de manière cohérente. Dans ce cas, Nginx agira comme un serveur proxy pour servir WordPress, tandis que MariaDB fournira la base de données nécessaire à WordPress.

---

### Comment faire ?

1. **Créer le fichier `docker-compose.yml`** : Ce fichier permet de définir les services (nginx, mariadb, wordpress) et leurs configurations, comme les volumes et les variables d'environnement.

2. **Configurer les services** : 
   - **nginx** : sert de proxy pour WordPress.
   - **mariadb** : gère la base de données de WordPress.
   - **wordpress** : héberge le site web et dépend de mariadb.

3. **Définir les volumes** : Assurer la persistance des données de WordPress et MariaDB entre les redémarrages.

4. **Définir les variables d'environnement et les fichiers secrets** : Gérer les informations sensibles comme les mots de passe.

5. **Configurer le réseau** : Créer un réseau `inception` pour connecter les services entre eux.

6. **Tester les services** : Utiliser `docker-compose down -v --rmi all && docker-compose build && docker-compose up -d` pour tester et redémarrer les services.

7. **Vérification** : Vérifier que tout fonctionne avec `docker-compose ps` pour afficher l'état des conteneurs.

---

### Arborescence

Voici un exemple de l'arborescence des fichiers dans ton projet :

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
```

## Le docker-compose

```yml
services:
  nginx:
    init: true
    container_name: container-nginx
    build:
      context: requirements/nginx
      dockerfile: Dockerfile
    env_file: .env
    environment:
      - SERVER_NAME=${SERVER_NAME}
    image: nginx
    volumes:
      - wordpress:/var/www/wordpress
    networks:
      - inception
    depends_on:
      - wordpress
    ports:
      - "443:443"
    restart: always

  mariadb:
    init: true
    container_name: container-mariadb
    build: 
      context: requirements/mariadb
      dockerfile: Dockerfile
    image: mariadb
    networks:
      - inception
    env_file: .env
    environment:
      - SERVER_NAME=${SERVER_NAME}
      - MARIA_PATH=${MARIA_PATH}
      - SQL_NAME_DATABASE=${SQL_NAME_DATABASE}
      - SQL_NAME_USER=${SQL_NAME_USER}
      - SQL_NAME_ADMIN=${SQL_NAME_ADMIN}
    secrets:
      - sql_password_admin
      - sql_password_user
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
    container_name: container-wordpress
    build:
      context: requirements/wordpress
      dockerfile: Dockerfile
    depends_on:
      mariadb:
        condition: service_healthy
    image: wordpress
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
      - SQL_NAME_ADMIN=${SQL_NAME_ADMIN}
    secrets:
      - sql_password_admin
      - sql_password_user
    restart: always
    ports:
      - "9000:9000"

volumes:
  wordpress:
    driver: local
    driver_opts:
      type: 'none'
      o: 'bind'
      # device: './data_docker_compose/wordpress'
      device: '/home/yzaoui/data/wordpress'
  mariadb:
    driver: local
    driver_opts:
      type: 'none'
      o: 'bind'
      device: '/home/yzaoui/data/mariadb'
      # device: './data_docker_compose/mariadb'

networks:
  inception:
    driver: bridge

secrets:
  sql_password_admin:
    file: ./../secrets/sql_password_admin.txt
  sql_password_user:
    file: ./../secrets/sql_password_user.txt
```

### Explication Générale

#### Partie Services

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

### Explication Technique

#### Partie Nginx
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

Le service **MariaDB** permet à WordPress de stocker et de récupérer toutes les données nécessaires à son fonctionnement, telles que les articles, les utilisateurs et les paramètres de configuration du site. Voici les détails spécifiques concernant la configuration du service MariaDB :

- **`init: true`** : Cette option assure que le service MariaDB sera correctement initialisé lorsque Docker démarrera le conteneur, garantissant ainsi une mise en place correcte de la base de données avant d'être utilisé.
- **`container_name: mariadb`** : Attribue un nom spécifique au conteneur pour faciliter sa gestion, le nom "mariadb" sera donc utilisé pour ce conteneur.
- **`build`** : La section `build` spécifie que le conteneur MariaDB sera construit à partir d'un Dockerfile situé dans le répertoire `requirements/mariadb`. Ce fichier Dockerfile permet de personnaliser l'image MariaDB (ajouter des configurations supplémentaires, des scripts d'initialisation, etc.).
- **`image: mariadb-img`** : Le conteneur MariaDB sera basé sur une image Docker construite localement, étiquetée `mariadb-img`. Cette image est construite à partir du Dockerfile mentionné ci-dessus.
- **`environment`** : Cette section contient les variables d'environnement qui permettent de personnaliser la configuration de MariaDB, telles que le nom de la base de données, les utilisateurs de la base, et les mots de passe associés. Ces variables sont lues depuis le fichier `.env` et permettent de rendre le service facilement configurable.
- **`volumes`** : Un volume est monté pour persister les données de MariaDB. Cela permet de stocker les fichiers de données de la base dans le répertoire `/var/lib/mysql` du conteneur. Ce volume est crucial pour préserver les données entre les redémarrages du conteneur.
- **`healthcheck`** : Le service de santé est activé pour surveiller l'état du service MariaDB. La commande `mysqladmin ping` permet de vérifier si le serveur MariaDB est bien en ligne et répond aux requêtes. Si cette vérification échoue plusieurs fois (selon les paramètres de `interval`, `timeout`, `retries` et `start_period`), Docker redémarrera le conteneur.
- **`restart: always`** : Ce paramètre assure que le conteneur MariaDB sera automatiquement redémarré s'il échoue ou s'il est stoppé, garantissant ainsi la haute disponibilité du service.

### Partie WordPress

Le service **WordPress** est le cœur de l'application web, et il fonctionne en étroite collaboration avec MariaDB pour stocker et gérer les données de contenu du site. Voici les éléments importants de sa configuration :

- **`init: true`** : Indique que le service WordPress sera correctement initialisé lors du démarrage du conteneur, avec la configuration spécifiée dans le fichier `docker-compose.yml` et les autres fichiers associés.
- **`container_name: wordpress`** : Attribue un nom spécifique au conteneur WordPress pour faciliter sa gestion et sa référence dans d'autres configurations.
- **`build`** : La section `build` spécifie que le conteneur WordPress sera construit à partir du répertoire `requirements/wordpress` et du Dockerfile qui s'y trouve. Cela permet de personnaliser l'installation de WordPress (installation de plugins, thèmes, ou autres ajustements).
- **`depends_on`** : Cette option assure que le service WordPress attendra que MariaDB soit complètement opérationnel et sain (grâce à `service_healthy`) avant de démarrer. Cela garantit que WordPress peut se connecter à la base de données sans problème.
- **`image: wordpress-img`** : Le conteneur WordPress sera basé sur l'image Docker personnalisée `wordpress-img`, qui est construite à partir du Dockerfile spécifié.
- **`volumes`** : Un volume est monté pour persister les fichiers de WordPress dans le répertoire `/var/www/wordpress`. Cela garantit que les fichiers du site (images, plugins, thèmes, etc.) seront conservés même après un redémarrage ou une suppression du conteneur.
- **`environment`** : Contient des variables d'environnement permettant de configurer le site WordPress, telles que les informations relatives à la base de données (nom, utilisateur, mot de passe, etc.). Ces informations sont essentielles pour permettre à WordPress de se connecter à MariaDB.
- **`ports`** : Le port 9000 du conteneur est mappé vers le port 9000 de l'hôte, ce qui permet de servir le contenu PHP de WordPress via Nginx. Ce port est principalement utilisé pour la gestion des requêtes PHP-FPM entre Nginx et WordPress.
- **`restart: always`** : Comme pour les autres services, ce paramètre assure que le conteneur WordPress sera redémarré automatiquement en cas d'échec, assurant ainsi sa disponibilité continue.

### Partie Volumes

Les **volumes** jouent un rôle essentiel pour assurer la persistance des données au sein des services Docker. Sans eux, toutes les données stockées dans un conteneur seraient perdues chaque fois que le conteneur est supprimé ou redémarré. Voici les détails de la configuration des volumes dans ce setup :

- **`wordpress`** : Ce volume est monté sur le répertoire `./data_docker_compose/wordpress` de l'hôte. Cela permet de sauvegarder et persister les fichiers importants de WordPress, tels que les médias téléchargés, les plugins, les thèmes et les configurations spécifiques. Ce volume garantit que ces fichiers seront conservés, même si le conteneur WordPress est supprimé ou redémarré.
- **`mariadb`** : Ce volume est monté sur le répertoire `./data_docker_compose/mariadb` de l'hôte. Il permet de stocker les fichiers de données de MariaDB, ce qui inclut toutes les bases de données créées et les informations relatives à celles-ci. Grâce à ce volume, les données de la base de données seront préservées indépendamment du cycle de vie du conteneur MariaDB.

Les volumes offrent une grande flexibilité et sont un élément clé dans la gestion des données des services Docker, en permettant une persistance facile et sécurisée des données critiques.

### Partie Networks 

Les **réseaux** Docker assurent la communication entre les conteneurs. Dans ce cas, un réseau est défini pour connecter les services entre eux :

- **`inception`** : Un réseau de type **bridge** est créé. Le mode **bridge** est le type de réseau par défaut dans Docker, et il permet à chaque conteneur de se connecter entre eux tout en étant isolé du réseau extérieur. Grâce à ce réseau, les services (Nginx, MariaDB et WordPress) peuvent communiquer facilement en utilisant leurs noms de conteneur comme noms d'hôtes. Par exemple, le service WordPress pourra se connecter à MariaDB en utilisant le nom `mariadb` comme adresse réseau, facilitant ainsi la gestion des connexions entre les services sans nécessiter d'adresses IP statiques.

Cette configuration réseau permet de simplifier la gestion des communications internes entre les conteneurs tout en garantissant que les services peuvent se retrouver et interagir de manière fluide.

### Partie Secrets

Les **secrets** dans Docker permettent de gérer de manière sécurisée les informations sensibles telles que les mots de passe, clés API, ou toute autre donnée confidentielle. Bien qu'ils ne soient pas spécifiquement détaillés dans ce segment de configuration, les secrets sont essentiels pour éviter d'inclure des informations sensibles dans les fichiers de configuration (comme `docker-compose.yml`) ou les variables d'environnement non sécurisées.

- **Utilisation des secrets** : Les secrets peuvent être injectés dans les conteneurs lors de la construction ou de l'exécution, et Docker s'assure qu'ils sont stockés de manière sécurisée dans le gestionnaire de secrets. Dans un environnement de production, il est fortement recommandé d'utiliser cette fonctionnalité pour sécuriser les informations telles que les mots de passe de base de données ou les clés d'API.

En résumé, les secrets assurent une gestion sécurisée des données sensibles, tandis que les volumes garantissent la persistance des données et que les réseaux permettent la communication fluide entre les différents services.

### Conclusion

Cette configuration Docker Compose offre une approche structurée et efficace pour déployer une application WordPress avec une base de données MariaDB. En utilisant des volumes pour persister les données, les services sont indépendants du cycle de vie des conteneurs, garantissant ainsi que les données essentielles (comme celles de la base de données et les fichiers de WordPress) sont conservées même après un redémarrage ou une suppression des conteneurs.

Le réseau interne **`inception`** assure une communication fluide entre les services (Nginx, MariaDB, WordPress) grâce à un réseau de type **bridge**, simplifiant ainsi la gestion des connexions entre les conteneurs. De plus, bien que les secrets ne soient pas explicitement configurés ici, il est important de souligner que Docker permet de gérer de manière sécurisée les informations sensibles, renforçant ainsi la sécurité globale de l'application.

Dans l'ensemble, cette architecture est robuste et bien adaptée pour déployer un site WordPress dans un environnement conteneurisé, avec une gestion simplifiée des données, des communications internes et de la sécurité.