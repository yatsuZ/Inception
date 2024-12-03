# 2. Installation de MariaDB

- [2. Installation de MariaDB](#2-installation-de-mariadb)
  - [Objectif](#objectif)
  - [Leçon](#leçon)
  - [MariaDB](#mariadb)
  - [Comment faire ?](#comment-faire-)
    - [Arborescence](#arborescence)
    - [Dockerfile](#dockerfile)
      - [Explications :](#explications-)
  - [Fichiers de configuration](#fichiers-de-configuration)
    - [`config_vim`](#config_vim)
    - [`mariadb-server.cnf`](#mariadb-servercnf)
      - [Explications des paramètres :](#explications-des-paramètres-)
  - [Script pour démarrer et initialiser la base de données](#script-pour-démarrer-et-initialiser-la-base-de-données)
    - [`init_maria_mysql.sh`](#init_maria_mysqlsh)
      - [Contenu du script :](#contenu-du-script-)
      - [Résumé](#résumé)
    - [`init_db.sql`](#init_dbsql)
      - [Contenu du fichier :](#contenu-du-fichier-)
      - [Résumé](#résumé-1)
  - [Test](#test)
    - [Créer les fichiers secrets](#créer-les-fichiers-secrets)
    - [Exemple avec Docker](#exemple-avec-docker)
    - [Vérification des utilisateurs dans MariaDB](#vérification-des-utilisateurs-dans-mariadb)
    - [Connexion distante](#connexion-distante)

## Objectif

Créer un conteneur MariaDB.
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
├── Dockerfile
├── config
│   ├── config_vim
│   └── mariadb-server.cnf
└── tool
    ├── init_db.sql
    └── init_maria_mysql.sh

2 directories, 5 files
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

# HEALTHCHECK --start-period=5s --timeout=5s CMD mysql

CMD ["sh", "/bin/init_maria_mysql.sh"]
```

#### Explications :
1. **Base de l'image** : `alpine:3.19` est utilisée pour sa légèreté.
2. **Installation des paquets** :
   - MariaDB et son client sont installés.
   - `vim` et `bash` sont ajoutés pour plus de confort.
   - `envsubst` permet de remplacer des variables dans des fichiers de configuration.
3. **Structure des dossiers** : Les répertoires nécessaires à MariaDB sont créés et leurs permissions ajustées.
4. **Copie des fichiers** : Les fichiers de configuration et les scripts sont copiés dans le conteneur.
5. **Commande par défaut** : Le conteneur lance le script `/bin/init_maria_mysql.sh` au démarrage.

---

## Fichiers de configuration

### `config_vim`

Ce fichier est optionnel. Il permet de configurer directement l'éditeur Vim à l'intérieur du conteneur. Si vous avez des préférences spécifiques pour l'édition de texte, ce fichier les appliquera automatiquement lors de l'utilisation de Vim.

### `mariadb-server.cnf`

Ce fichier de configuration définit les paramètres principaux pour MariaDB. Voici un exemple de contenu (ligne 10 du fichier) :

```cnf
[mysqld]
datadir = /var/lib/mysql
socket = /run/mysqld/mysqld.sock
bind-address = 0.0.0.0
port = 3306
user = mysql
```

#### Explications des paramètres :  
- **`datadir`** : Spécifie le répertoire où sont stockées les bases de données. Dans notre cas, c'est `/var/lib/mysql`.
- **`socket`** : Définit le chemin du fichier socket pour les connexions locales (entre MariaDB et les applications sur la même machine).
- **`bind-address`** : Permet les connexions réseau en écoutant sur toutes les adresses (`0.0.0.0`).
- **`port`** : Indique le port utilisé pour les connexions MariaDB. Par défaut, c'est le **3306**.
- **`user`** : Définit l'utilisateur système qui exécute le serveur MariaDB. Ici, c'est `mysql`.

Voici une version légèrement ajustée pour assurer une bonne lisibilité tout en restant concise :  

---

## Script pour démarrer et initialiser la base de données  

### `init_maria_mysql.sh`  

Ce script effectue les étapes suivantes :  
1. **Charge les secrets** pour le mot de passe admin et utilisateur à partir de fichiers spécifiques.  
2. **Affiche les variables d'environnement** pour le débogage.  
3. **Vérifie si la base de données existe déjà** :  
   - Si elle n'existe pas, initialise MariaDB, exécute un script SQL pour créer la base de données et les utilisateurs, puis arrête le service.  
   - Si elle existe, passe directement à l'étape de démarrage.  
4. **Démarre le serveur MariaDB** en mode premier plan.  

#### Contenu du script :  

```sh
#!/usr/bin/env sh

# Définition des couleurs pour le terminal
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Récupération des mots de passe à partir des fichiers secrets
export SQL_PASSWORD_ADMIN=$(cat /run/secrets/sql_password_admin)
export SQL_PASSWORD_USER=$(cat /run/secrets/sql_password_user)

# Affichage des variables d'environnement pour le débogage
echo -e "${BLUE}MARIA_PATH:${NC} ${MARIA_PATH}"
echo -e "${BLUE}SQL_NAME_DATABASE:${NC} ${SQL_NAME_DATABASE}"
echo -e "${BLUE}SQL_NAME_USER:${NC} ${SQL_NAME_USER}"
echo -e "${BLUE}SQL_PASSWORD_USER:${NC} ${SQL_PASSWORD_USER}"
echo -e "${BLUE}SQL_NAME_ADMIN:${NC} ${SQL_NAME_ADMIN}"
echo -e "${BLUE}SQL_PASSWORD_ADMIN:${NC} ${SQL_PASSWORD_ADMIN}"

# Vérification de l'existence de la base de données
if find ${MARIA_PATH} -mindepth 1 -maxdepth 1 | read; then
    echo -e "${GREEN}La base de données existe déjà.${NC}"
else
    echo -e "${YELLOW}La base de données doit être créée.${NC}"
    mysql_install_db -umysql --ldata=/var/lib/mysql
    mariadbd -umysql &
    sleep 1

    # Exécution du script SQL pour créer la base et les utilisateurs
    echo -e "${YELLOW}Création de la base de données et de l'utilisateur via un script SQL.${NC}"
    envsubst < /bin/init_db.sql | mysql -u root
    if [ $? -ne 0 ]; then
        echo -e "${RED}Erreur lors de la création de la base de données.${NC}"
        exit 1
    fi

    echo -e "${GREEN}Base de données et utilisateur créés avec succès.${NC}"
    mysqladmin shutdown
fi

# Démarrage de MariaDB
echo -e "${GREEN}Démarrage du serveur MariaDB...${NC}"
exec mariadbd -umysql
```

---

#### Résumé  
Le script garantit que MariaDB :  
- **S'initialise proprement** si nécessaire.  
- **Crée les bases et utilisateurs** avec un script SQL personnalisé.  
- **S'exécute en premier plan** pour Docker.  

---

### `init_db.sql`

Ce script SQL exécute les étapes nécessaires pour initialiser la base de données et configurer les utilisateurs.

#### Contenu du fichier :

```sql
-- init_db.sql

-- Création de la base de données si elle n'existe pas déjà
CREATE DATABASE IF NOT EXISTS ${SQL_NAME_DATABASE};

-- Création de l'utilisateur principal
CREATE USER IF NOT EXISTS '${SQL_NAME_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD_USER}';

-- Création de l'utilisateur admin
CREATE USER IF NOT EXISTS '${SQL_NAME_ADMIN}'@'%' IDENTIFIED BY '${SQL_PASSWORD_ADMIN}';

-- Attribution des privilèges à l'utilisateur principal
GRANT ALL PRIVILEGES ON ${SQL_NAME_DATABASE}.* TO '${SQL_NAME_USER}'@'%';

-- Attribution des privilèges globaux à l'admin (incluant les droits de gestion)
GRANT ALL PRIVILEGES ON *.* TO '${SQL_NAME_ADMIN}'@'%' IDENTIFIED BY '${SQL_PASSWORD_ADMIN}' WITH GRANT OPTION;

-- Optionnel : Configuration des droits pour 'root'
-- GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${SQL_PASSWORD_ADMIN}' WITH GRANT OPTION;

-- Application des changements
FLUSH PRIVILEGES;
```

---

#### Résumé

1. **Création de la base de données** : Vérifie si la base spécifiée n'existe pas avant de la créer.  
2. **Création des utilisateurs** :  
   - Un utilisateur dédié à la base de données.  
   - Un administrateur avec des droits globaux et l'option `GRANT`.  
3. **Attribution des droits** :  
   - L'utilisateur principal a accès complet uniquement à la base créée.  
   - L'admin a accès total à toutes les bases et peut gérer les permissions.  
4. **Mise à jour des privilèges** : La commande `FLUSH PRIVILEGES` applique immédiatement les modifications des droits.  

## Test

### Créer les fichiers secrets

Pour des raisons de sécurité, les mots de passe doivent être stockés dans des fichiers secrets. Par exemple :

1. Crée un répertoire pour les secrets :
   ```sh
   mkdir -p ./secrets
   ```

2. Crée des fichiers pour chaque mot de passe :
   ```sh
   echo "my_admin_password" > ./secrets/sql_password_admin
   echo "my_user_password" > ./secrets/sql_password_user
   ```

Assure-toi que ces fichiers sont accessibles par le conteneur.

---

### Exemple avec Docker

1. **Construire l'image Docker** :  
   Créez l'image Docker à partir du `Dockerfile` :  
   ```sh
   docker build -t mariadb-img .
   ```

2. **Démarrer le conteneur** :  
   Lancez un conteneur en spécifiant les variables d'environnement nécessaires :  
   ```sh
   docker run -d \
     --name mariadb-container \
     -e SQL_NAME_DATABASE=my_database \
     -e SQL_NAME_USER=my_user \
     -e SQL_PASSWORD_USER=my_user_password \
     -e SQL_NAME_ADMIN=my_admin \
     -e MARIA_PATH=/var/lib/mysql \
     -v ./secrets:/run/secrets \
     mariadb-img
   ```

3. **Accéder au conteneur** :  
   Ouvrez un terminal dans le conteneur pour effectuer des vérifications ou du débogage :  
   ```sh
   docker exec -it mariadb-container sh
   ```

4. **Vérifier les utilisateurs dans MariaDB** :  
   Depuis l’intérieur du conteneur, utilisez une commande SQL pour lister les utilisateurs :  
   ```sh
   mysql -u root -p"${SQL_PASSWORD_ROOT}" -e "SELECT User, Host FROM mysql.user;"
   ```

   Ou utilisez une commande combinée :  
   ```sh
   echo "SELECT User, Host FROM mysql.user;" | mysql -u root -p"${SQL_PASSWORD_ROOT}"
   ```

5. **Vérifier la base de données** :  
   Assurez-vous que la base de données a été créée avec la commande suivante :  
   ```sh
   mariadb -u root -p"${SQL_PASSWORD_ROOT}" -e "SHOW DATABASES;"
   ```


### Vérification des utilisateurs dans MariaDB

Les commandes fournies dans la section **Test** permettent de vérifier que les utilisateurs ont bien été créés avec les droits corrects.

### Connexion distante

Pour permettre une connexion distante, il faudra installer `mariadb-client` sur le PC hôte et exposer le port 3306 à la fois dans le `docker run` et dans le conteneur. Ensuite, une fois connecté au conteneur, exécute la commande suivante pour accorder les privilèges de connexion à distance :

```sh
echo "GRANT ALL PRIVILEGES ON *.* TO 'my_admin'@'%' IDENTIFIED BY my_admin_password; FLUSH PRIVILEGES;" | mysql -u my_admin -p"my_admin_password" -P 3306
```

Une fois cela fait, tu peux sortir du conteneur et te connecter à la base de données depuis le PC hôte :

```sh
mysql -h 127.0.0.1 -P 3306 -u my_admin -p"my_admin_password"
```
