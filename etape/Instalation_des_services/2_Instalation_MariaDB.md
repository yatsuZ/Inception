# 2. Installation de MariaDB

> ! À modifier : pas la version définitive

**Objectif :** Créer un conteneur MariaDB.  
Consulte [les règles](./../../concepts/regle_du_projet.md).

## Leçon

1. Écrire un Dockerfile pour installer MariaDB.
2. Démarrer MariaDB et utiliser SQL.
3. Utiliser les variables d'environnement.

## MariaDB

Pour plus d'informations, consulte le [site officiel](https://mariadb.com/kb/fr/what-is-mariadb/) ou la [documentation officielle](https://mariadb.com/kb/en/documentation/).

## Comment faire ?

1. Écrire le Dockerfile.
2. Créer un fichier de configuration pour MariaDB.
3. Copier les fichiers de configuration.
4. Créer un script pour initialiser la base de données et démarrer MariaDB.

### Arborescence

```bash
➜  mariadb git:(main) ✗ tree
.
├── config
│   ├── config_vim
│   └── mariadb-server.cnf
├── Dockerfile
└── tool
    ├── init_db.sql
    └── init_maria_mysql.sh
```

### Dockerfile

```Dockerfile
FROM alpine:3.19

# À modifier
ENV SQL_NAME_DATABASE=nom_de_database_test
ENV SQL_NAME_USER=nom_utilisateur 
ENV SQL_PASSWORD_USER=mdp_utilisateur
ENV SQL_PASSWORD_ROOT=mdp_root

RUN apk add --no-cache mariadb mariadb-client bash vim envsubst

RUN mkdir -p /var/lib/mysql/ /run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql/ /run/mysqld

COPY ./config/mariadb-server.cnf /etc/my.cnf.d/
COPY ./config/config_vim /root/.vimrc
COPY ./tool/init_maria_mysql.sh /bin/init_maria_mysql.sh
COPY ./tool/init_db.sql /bin/init_db.sql

# À modifier peut-être
EXPOSE 3306

CMD ["sh", "/bin/init_maria_mysql.sh"]
```

---

## Fichiers de configuration

### `config_vim`

Ce fichier est optionnel. Il permet de configurer directement l'éditeur Vim à l'intérieur du conteneur. Si vous avez des préférences spécifiques pour l'édition de texte, ce fichier les appliquera automatiquement lors de l'utilisation de Vim.


### `mariadb-server.cnf`

```cnf
[mysqld]
datadir = /var/lib/mysql
socket = /run/mysqld/mysqld.sock
bind-address = 0.0.0.0
port = 3306
user = mysql
```

- **`datadir`** : Dossier où sont stockées les bases de données.
- **`socket`** : Fichier pour les connexions locales.
- **`bind_address`** : Permet les connexions réseau.
- **`port`** : Définit le port utilisé (3306 par défaut).
- **`user`** : Utilisateur exécutant MariaDB.

### Script pour demarer et ini la bdd

### `init_maria_mysql.sh`

```sh
#!/usr/bin/env sh

if find /var/lib/mysql -mindepth 1 | read; then
    echo "La base de données existe déjà."
else
    echo "Création de la base de données..."
    mysql_install_db --user=mysql --ldata=/var/lib/mysql
    mariadbd --user=mysql &
    sleep 1

    echo "Création via un script SQL..."
    envsubst < /bin/init_db.sql | mysql -u root
    [ $? -ne 0 ] && echo "Erreur lors de la création de la base de données" && exit 1

    mysqladmin shutdown -p"${SQL_PASSWORD_ROOT}"
fi

exec mariadbd --user=mysql
```

### `init_db.sql`

```sql
CREATE DATABASE IF NOT EXISTS ${SQL_NAME_DATABASE};
CREATE USER IF NOT EXISTS '${SQL_NAME_USER}'@'localhost' IDENTIFIED BY '${SQL_PASSWORD_USER}';
GRANT ALL PRIVILEGES ON ${SQL_NAME_DATABASE}.* TO '${SQL_NAME_USER}'@'localhost';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_PASSWORD_ROOT}';
FLUSH PRIVILEGES;
```

## Test

1. Construire l'image Docker :
   ```sh
   docker build -t docker_name .
   ```

2. Créer et démarrer le conteneur :
   ```sh
   docker run -d --name docker_name_contenair docker_name
   ```

3. Accéder au conteneur :
   ```sh
   docker exec -it docker_name_contenair sh
   ```

4. Voir les utilisateurs dans MariaDB :
   ```sh
   mysql -u root -p"${SQL_PASSWORD_ROOT}" -P 3306 -e "SELECT User, Host FROM mysql.user;"
   ```
   OU
   ```sh
   echo "SELECT User, Host FROM mysql.user;" | mysql -u root -p"${SQL_PASSWORD_ROOT}" -P 3306
   ```

### Connexion distante

Pour permettre une connexion distante, il faudra installer `mariadb-client` sur le PC hôte et exposer le port 3306 à la fois dans le `docker run` et dans le conteneur. Ensuite, une fois connecté au conteneur, exécute la commande suivante pour accorder les privilèges de connexion à distance :

```sh
echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${SQL_PASSWORD_ROOT}'; FLUSH PRIVILEGES;" | mysql -u root -p"${SQL_PASSWORD_ROOT}" -P 3306
```

Une fois cela fait, tu peux sortir du conteneur et te connecter à la base de données depuis le PC hôte :

```sh
mysql -h 127.0.0.1 -P 3306 -u root -p"${SQL_PASSWORD_ROOT}"
```

## FIN