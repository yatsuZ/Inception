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

RUN apk update && \
	apk add --no-cache \
	vim \
	bash \
	mariadb mariadb-client \
	envsubst \
	&& rm -rf /var/cache/apt/*

RUN mkdir -p /var/lib/mysql/ /run/mysqld
RUN chown -R mysql:mysql /var/lib/mysql/ /run/mysqld

COPY ./config/mariadb-server.cnf  /etc/my.cnf.d/
COPY ./config/config_vim  /root/.vimrc
COPY ./tool/init_maria_mysql.sh /bin/init_maria_mysql.sh
COPY ./tool/init_db.sql /bin/init_db.sql

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
if find ${MARIA_PATH} -mindepth 1 -maxdepth 1 | read; then
    echo -e "${GREEN}La base de données existe déjà.${NC}"
else
    echo -e "${YELLOW}La base de données doit être créée.${NC}"
    mysql_install_db -umysql --ldata=/var/lib/mysql
    mariadbd -umysql &
    sleep 1

    echo -e "${YELLOW}Création de la base de données et de l'utilisateur via un script SQL.${NC}"
    envsubst < /bin/init_db.sql | mysql -u root
    if [ $? -ne 0 ]; then
        echo -e "${RED}Erreur lors de la création de la base de données.${NC}"
        exit 1
    fi

    echo -e "${GREEN}Base de données et utilisateur créés avec succès.${NC}"

    mysqladmin shutdown -p"${SQL_PASSWORD_ROOT}"
fi

echo -e "${GREEN}Démarrage du serveur MariaDB...${NC}"
exec mariadbd -umysql
```

#### résumé

En gros je verifie que la bdd existe deja sinon j'installe mysql  puis execute le script sql qui crée des users.

### `init_db.sql`

```sql
-- init_db.sql
CREATE DATABASE IF NOT EXISTS ${SQL_NAME_DATABASE};
CREATE USER IF NOT EXISTS '${SQL_NAME_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD_USER}';
GRANT ALL PRIVILEGES ON ${SQL_NAME_DATABASE}.* TO '${SQL_NAME_USER}'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${SQL_PASSWORD_ROOT}' WITH GRANT OPTION;
FLUSH PRIVILEGES;
```
#### résumé

1. Je crée un base de donée
2. Je crée un utilisateur
3. Je donne tout les droit aux root (je lui donne un mdp) et aux user
4. Je mets a jour les drois


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