# 2. Installation de MariaDB

**Objectif :** Mettre en place un conteneur contenant MariaDB.  
Voir [les règles](./../../concepts/regle_du_projet.md).

## Leçon

1. Rédiger un Dockerfile pour installer MariaDB.
2. Savoir comment démarrer MariaDB et utiliser les bases de données SQL.
3. Importer les variables d'environnement.

## Qu'est-ce que c'est ?

Qu'est-ce que [MariaDB](./../../concepts/documentation.md#MariaDB) ?  
Le site officiel répond mieux que moi : [Réponse officielle](https://mariadb.com/kb/fr/what-is-mariadb/).

Une source de documentation pour MariaDB : [Documentation officielle de MariaDB](https://mariadb.com/kb/en/documentation/).

## Comment faire ?

1. Rédiger le Dockerfile avec l'installation des services.
2. Rédaction du fichier de configuration de MariaDB.
3. Copier les fichiers de configuration.
4. Script qui permet de créer la base de données, les utilisateurs et d'activer MariaDB en arrière-plan.

### L'arborescence

Dans un premier temps, j'ai testé dans un laboratoire les bases du Dockerfile et j'ai développé au fur et à mesure.  
Voici l'arborescence de MariaDB :

```zsh
➜  mariadb git:(main) ✗ tree
.
├── config
│   ├── config_vim
│   └── mariadb-server.cnf
├── Dockerfile
└── tool
    ├── init_db.sql
    └── init_maria_mysql.sh

2 directories, 5 files
```

- Le fichier Dockerfile spécifie comment construire l'image et exécuter le conteneur.
- Le dossier `config` contient tous les fichiers de configuration que je vais copier dans mon Docker.
- Le dossier `tool` contient tous les outils utiles, notamment des scripts.

### Le contenu du Dockerfile

```Dockerfile
# OS de l'image
FROM alpine:3.19

# Export des variables d'environnement
ENV SQL_NAME_DATABASE=nom_de_database_test
ENV SQL_NAME_USER=nom_utilisateur 
ENV SQL_PASSWORD_USER=mdp_utilisateur
ENV SQL_PASSWORD_ROOT=mdp_root

# Installation des services de manière optimale
RUN apk update && \
    apk add --no-cache \
    vim \
    bash \
    mariadb mariadb-client \
    envsubst \
    && rm -rf /var/cache/apt/*

# Création des dossiers et des droits
RUN mkdir -p /var/lib/mysql/ /run/mysqld
RUN chown -R mysql:mysql /var/lib/mysql/ /run/mysqld

# Copie des fichiers de configuration et scripts utiles
COPY ./config/mariadb-server.cnf /etc/my.cnf.d/
COPY ./config/config_vim /root/.vimrc
COPY ./tool/init_maria_mysql.sh /bin/init_maria_mysql.sh
COPY ./tool/init_db.sql /bin/init_db.sql

# Activation du script
CMD ["sh", "/bin/init_maria_mysql.sh"]
```

---

## Explication des fichiers de configuration

### `config_vim`

Ce fichier est optionnel. Il permet de configurer directement l'éditeur Vim à l'intérieur du conteneur. Si vous avez des préférences spécifiques pour l'édition de texte, ce fichier les appliquera automatiquement lors de l'utilisation de Vim.

### `mariadb-server.cnf`

**Qu'est-ce qu'un fichier `.cnf` ?**  
Un fichier `.cnf` est un fichier de configuration utilisé par de nombreux logiciels, dont MariaDB, pour spécifier les paramètres et options de démarrage. Dans le cas de MariaDB, il détermine la configuration du serveur de base de données.

Il s'agit du fichier de configuration par défaut lors de l'installation de **mariadb mariadb-client**, situé dans `/etc/my.cnf.d/mariadb-server.cnf`. La seule différence se situe au niveau du paramètre **[mysqld]** (pour MySQL daemon). Voici l'original :

```cnf
# This is only for the mysqld standalone daemon
[mysqld]
skip-networking
```

Et voici ma version de configuration :

```cnf
# This is only for the mysqld standalone daemon
[mysqld]
datadir = /var/lib/mysql
socket = /run/mysqld/mysqld.sock
bind_address = *
port = 3306
user = mysql
```

### Explication des paramètres ajoutés et retirés

- **`skip-networking`** : Ce paramètre désactive la capacité du serveur à accepter des connexions réseau. En le retirant, on permet au serveur de MariaDB d'accepter des connexions à partir d'autres hôtes. Cela peut être utile pour des environnements où des applications externes doivent accéder à la base de données.

- **`datadir = /var/lib/mysql`** : Définit le répertoire de données pour MariaDB, où toutes les bases de données seront stockées.

- **`socket = /run/mysqld/mysqld.sock`** : Spécifie le fichier socket que MariaDB utilisera pour les connexions locales. Cela permet aux applications locales de se connecter directement au serveur sans passer par le réseau.

- **`bind_address = *`** : Permet à MariaDB d'accepter les connexions de toutes les interfaces réseau. Cela signifie que le serveur sera accessible depuis n'importe quelle adresse IP.

- **`port = 3306`** : Définit le port sur lequel le serveur MariaDB écoutera les connexions. 3306 est le port par défaut pour MariaDB et MySQL.

- **`user = mysql`** : Définit l'utilisateur sous lequel le processus MariaDB s'exécutera. Cela permet de s'assurer que le serveur s'exécute avec les permissions appropriées.

---

## Explication des fichiers dans le dossier `tool`

Il y a deux fichiers, `init_db.sql` et `init_maria_mysql.sh`. J'explique d'abord le script `sh`, puis le fichier `sql`.

**Qu'est-ce qu'un fichier SQL ?**  
Un fichier `.sql` est un fichier de script contenant des instructions SQL. Il est souvent utilisé pour créer des bases de données, des tables et pour insérer des données dans celles-ci.

### Explication de `init_maria_mysql.sh`

```sh
#!/usr/bin/env sh

if find /var/lib/mysql -mindepth 1 -maxdepth 1 | read; then
    echo "db exists"
else
    echo "need to create db"
    mysql_install_db -umysql --ldata=/var/lib/mysql
    mariadbd -umysql &
    sleep 1

    echo "created by using a script sql"
    envsubst < /bin/init_db.sql | mysql -u root
    if [ $? -ne 0 ]; then
        echo "Error during database creation"
        exit 1
    fi

    echo "Database and user created"

    mysqladmin shutdown -p"${SQL_PASSWORD_ROOT}"
fi

exec mariadbd -umysql
```

#### Explication détaillée du script

1. **Vérification de l'existence de la base de données** : Le premier `if` vérifie si des fichiers existent déjà dans `/var/lib/mysql`. Si c'est le cas, cela signifie que la base de données existe.

2. **Création de la base de données** : Si la base de données n'existe pas, le script utilise `mysql_install_db` pour initialiser le répertoire de données de MySQL. Ensuite, il lance le serveur MariaDB (`mariadbd`) en arrière-plan. 

3. **Exécution du script SQL** : Après une pause (`sleep 1`) pour laisser le serveur démarrer, le script utilise `envsubst` pour substituer les variables d'environnement dans `init_db.sql`, puis exécute le script SQL avec l'utilisateur root. Cela permet de créer les tables et d'insérer des données dans la base.

4. **Gestion des erreurs** : Si l'exécution du script SQL échoue, le script renvoie un message d'erreur et se termine.

5. **Arrêt du serveur MariaDB** : Après la création de la base de données, le script utilise `mysqladmin shutdown` avec le mot de passe root pour arrêter le serveur MariaDB proprement.

6. **Démarrage final du serveur** : Finalement, `exec mariadbd -umysql` démarre le serveur MariaDB en mode daemon pour qu'il puisse accepter des connexions.

#### Différence entre `mysql` et `mariadb`

- **`mysql`** : C'est l'outil client de MySQL, utilisé pour interagir avec le serveur MySQL (ou MariaDB). Il permet d'exécuter des commandes SQL et d'administrer les bases de données.

- **`mariadb`** : C'est un client similaire, mais spécifique à MariaDB. En pratique, les commandes et les fonctionnalités sont très similaires, car MariaDB est un fork de MySQL.

### Contenu de `init_db.sql`

```sql
-- init_db.sql 
CREATE DATABASE IF NOT EXISTS ${SQL_NAME_DATABASE};

CREATE USER IF NOT EXISTS '${SQL_NAME_USER}'@'localhost' IDENTIFIED BY '${SQL_PASSWORD_USER}';

GRANT ALL PRIVILEGES ON ${SQL_NAME_DATABASE}.* TO '${SQL_NAME_USER}'@'localhost';

ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_PASSWORD_ROOT}';

FLUSH PRIVILEGES;
```

### Explication des lignes

1. **`CREATE DATABASE IF NOT EXISTS ${SQL_NAME_DATABASE};`**  
   Crée une base de données si elle n'existe pas déjà.

2. **`CREATE USER IF NOT EXISTS '${SQL_NAME_USER}'@'localhost' IDENTIFIED BY '${SQL_PASSWORD_USER}';`**  
   Crée un utilisateur avec un mot de passe, uniquement accessible depuis `localhost`, si l'utilisateur n'existe pas.

3. **`GRANT ALL PRIVILEGES ON ${SQL_NAME_DATABASE}.* TO '${SQL_NAME_USER}'@'localhost';`**  
   Accorde tous les droits sur la base de données à l'utilisateur créé, lui permettant d'effectuer toutes les opérations.

4. **`ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_PASSWORD_ROOT}';`**  
   Modifie le mot de passe de l'utilisateur root pour renforcer la sécurité.

5. **`FLUSH PRIVILEGES;`**  
   Recharge les privilèges pour appliquer immédiatement les changements effectués.

### Résumé des fonctionnalités

- **Création de base de données** : Le script s'assure qu'une base de données spécifique existe.
- **Gestion des utilisateurs** : Il crée un nouvel utilisateur avec un mot de passe et lui accorde des droits d'accès complets à la base de données.
- **Sécurisation de l'accès root** : Il modifie le mot de passe de l'utilisateur root pour renforcer la sécurité de la base de données.
- **Mise à jour des privilèges** : Il garantit que les modifications de privilèges prennent effet immédiatement.


## Teste 

pour tester mon dockerfile placer vous dans "/Inception/rendu/srcs/requirements/mariadb"

verifier de deja avoir Docker dinstaller.

executer ces commande


1. Construire limage a partir du dockerfile, (-t permer de nommée mon image)
```sh
docker build -t docker_name .
```

2. Cree et activer le conetenaire en mode deamon, (--name permet de nomée mon contenaire)
```sh
docker run -d --name docker_name_contenair docker_name
```

3. 