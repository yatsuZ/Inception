# L'installation des services grâce à Docker

Après avoir installé Docker et Docker Compose, je vais maintenant configurer et déployer mes services. Voici le plan à suivre.

## 1. Préparer le dossier de rendu

Le sujet fournit un exemple d'arborescence, illustrée ci-dessous :

![Arborescence du rendu](./../ilustration/arboraissance_du_rendu.png)

Voici une explication des différents fichiers et dossiers de l'arborescence :
- **`Makefile`** : Ce fichier est utilisé pour automatiser la gestion des services Docker.
- **`secrets/`** : Dossier contenant des fichiers sensibles comme les mots de passe de la base de données. **Important** : Ces informations doivent être protégées et ne jamais être incluses dans le dépôt Git lors du rendu.
- **`srcs/`** : Ce dossier contient tous les fichiers nécessaires pour configurer et exécuter les services Docker.
  - **`docker-compose.yml`** : Fichier principal pour orchestrer les différents services conteneurisés.
  - **`.env`** : Fichier d'environnement pour stocker les variables sensibles.

Voici l'arborescence complète des fichiers :

```sh
.
├── Makefile
├── secrets
│   ├── credentials.txt
│   ├── db_password.txt
│   └── db_root_password.txt
└── srcs
    ├── docker-compose.yml
    ├── .env
    └── requirements
        ├── bonus
        │   └── [... fichiers spécifiques ...]
        ├── mariadb
        │   ├── conf
        │   ├── Dockerfile
        │   ├── .dockerignore
        │   └── tools
        ├── nginx
        │   ├── conf
        │   ├── Dockerfile
        │   ├── .dockerignore
        │   └── tools
        ├── tools
        └── wordpress
            └── [... fichiers spécifiques ...]
```

## 2. Installation des services Docker

### C'est quoi Docker ?

Docker est une plateforme permettant de développer, expédier et exécuter des applications dans des conteneurs. Les conteneurs permettent de créer des environnements isolés et reproductibles pour chaque service. Pour plus d'informations sur Docker et comment il fonctionne, tu peux consulter [ce lien sur Dockerfile](./../concepts/Dockerfile_info.md).

### 2.1. [Installer le service NGINX](./Instalation_des_services/1_Instalation_Nginx.md)

Dans le dossier **[nginx](./../rendu/srcs/requirements/nginx/)**, rédige le Dockerfile et toute information utile.

**Objectif** : Mettre en place un conteneur contenant NGINX avec TLSv1.2, qui servira de serveur web pour héberger les pages.

### 2.2. [Installer le service MariaDB](./Instalation_des_services/2_Instalation_MariaDB.md)

Dans le dossier **[mariadb](./../rendu/srcs/requirements/mariadb/)**, rédige le Dockerfile et toute information utile.

**Objectif** : Mettre en place un conteneur contenant MariaDB, qui servira de gestionnaire de base de données pour stocker les informations nécessaires à WordPress.

### 2.3. [Installer le service WordPress](./Instalation_des_services/3_Instalation_WordPress.md)

Dans le dossier **[wordpress](./../rendu/srcs/requirements/wordpress/)**, rédige le Dockerfile et toute information utile.

**Objectif** : Mettre en place un conteneur contenant WordPress, qui servira de système de gestion de contenu pour créer et gérer des pages web.

## 3. Rédaction du Docker Compose

Une fois que chaque service (NGINX, MariaDB, WordPress) est installé et configuré, il est temps de les relier dans un fichier `docker-compose.yml`. Ce fichier permettra de gérer ces services ensemble et facilitera leur orchestration.

Pour plus de détails, consulte la section dédiée sur [la rédaction du Docker Compose](./4_redaction_du_docker_compose.md).