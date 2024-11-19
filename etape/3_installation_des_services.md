# L'installation des services grâce à Docker

Après avoir installé Docker et Docker Compose, je peux commencer à les configurer. Voici mon plan.

## 1. Préparer le dossier de rendu

Le sujet fournit un exemple d'arborescence, illustrée ci-dessous :

![Arborescence du rendu](./../ilustration/arboraissance_du_rendu.png)

Voici une explication des différents fichiers et dossiers de mon arborescence :
- **`Makefile`** : Utilisé pour automatiser la gestion des services Docker.
- **`secrets/`** : Contient des fichiers sensibles, comme les mots de passe de la base de données. **Note : Ces informations doivent être protégées et ne jamais être incluses dans Git lors du rendu.**
- **`srcs/`** : Contient tous les fichiers nécessaires pour configurer et exécuter les services Docker.
  - **`docker-compose.yml`** : Fichier principal pour orchestrer les différents services conteneurisés.
  - **`.env`** : Fichier d'environnement pour stocker les variables sensibles.

Arborescence complète :

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
        │   └── [...]
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
            └── [...]
```

## 2. Installation des services Docker

### C'est quoi Docker ?

Pour plus d'informations sur Docker et comment il fonctionne, tu peux consulter [ce lien sur Dockerfile](./../concepts/Dockerfile_info.md).

### 2.1. [Commencer à installer le service NGINX](./Instalation_des_services/1_Instalation_Nginx.md)

Dans le dossier **[nginx](./../rendu/srcs/requirements/nginx/)**, rédige le Dockerfile et toute information utile.

**Objectif** : Mettre en place un conteneur contenant NGINX avec TLSv1.2, qui fera office de serveur web.

### 2.2. [Commencer à installer le service MariaDB](./Instalation_des_services/2_Instalation_MariaDB.md)

Dans le dossier **[mariadb](./../rendu/srcs/requirements/mariadb/)**, rédige le Dockerfile et toute information utile.

**Objectif** : Mettre en place un conteneur contenant MariaDB, qui fera office de gestion de base de données.

### 2.3. [Commencer à installer le service WordPress](./Instalation_des_services/3_Instalation_WordPress.md)

Dans le dossier **[wordpress](./../rendu/srcs/requirements/wordpress/)**, rédige le Dockerfile et toute information utile.

**Objectif** : Mettre en place un conteneur contenant WordPress, qui fera office de gestion de pages web.

## 3. Rédaction du Docker Compose

Après avoir installé et configuré chaque service Docker (NGINX, MariaDB, WordPress), nous allons maintenant les mettre en relation dans un fichier `docker-compose.yml`. Ce fichier permettra de gérer plusieurs services Docker ensemble, facilitant ainsi leur orchestration.

Pour plus de détails, consulte la section dédiée sur [la rédaction du Docker Compose](./4_redaction_du_docker_compose.md).
