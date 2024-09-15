# 2 Installation de docker et docker compose

Deuxieme etape du projet Instalation de docker.
voici ce qu'il y aura :

## C'est quoi ?

![docker ilustration](./../ilustration/docker.png)

Il y a des explication dans la [documentation](./../concepts/documentation.md#docker).
Mais voici un rapelle.

Docker est [une plateforme](./../concepts/Plateforme_vs_aplication.md) open-source permettant de créer, déployer et exécuter des applications dans des conteneurs.
Les conteneurs sont des environnements légers et portables qui isolent les applications et leurs dépendances, garantissant ainsi que celles-ci fonctionnent de manière cohérente sur différentes environnements.

## Permet de faire quoi ?

En resumée c'est sa qui permetre de faire fonctioner des service / application comme nginx mariadb et wordpress peut importe l'os de base.

et docker compose permet de gere de multpile image de les faire intergire entre eux.

[docmentation docker vs docker-compose](./../concepts/docker_vs_docker_compose.md)


- **Isolation** : Les conteneurs permettent d'exécuter des applications dans des environnements isolés, réduisant les conflits entre les dépendances.
- **Portabilité** : Les conteneurs Docker peuvent être déployés sur n'importe quel système prenant en charge Docker, que ce soit en local, sur un serveur ou dans le cloud.
- **Consistance** : Assure que les applications se comportent de la même manière sur différents environnements de développement, de test et de production.
- **Scalabilité** : Facilite le déploiement de multiples instances d'applications et leur mise à l'échelle horizontale.
- **Efficacité** : Les conteneurs partagent le noyau du système d'exploitation hôte, ce qui les rend plus légers et rapides par rapport aux machines virtuelles traditionnelles.

## Comment l'installer

### Sur Alpine

0. **Ajouter le Dépôt Community**

Docker peut être dans le dépôt `community`. Assure-toi que ce dépôt est activé dans ton fichier `/etc/apk/repositories`. Tu peux le vérifier en ouvrant ce fichier avec un éditeur de texte comme `vi` :

```sh
vi /etc/apk/repositories
```

Assure-toi que la ligne suivante est présente (ajoute-la si nécessaire) :

```sh
http://dl-cdn.alpinelinux.org/alpine/v3.15/community
```

(Remplace `v3.15` par la version d'Alpine que tu utilises.)

1. **Mettre à jour les paquets :**

   ```sh
   apk update
   ```

2. **Installer Docker :**

   ```sh
   apk add docker
   ```

3. **Démarrer et activer Docker :**

   ```sh
   service docker start
   rc-update add docker
   ```

4. **Vérifier que Docker fonctionne correctement :**

   ```sh
   docker --version
   ```

#### installation de docker compose

1. **Mettre à jour les paquets :**

   ```sh
   apk update
   ```

2. **Installation des dépendances :**

   ```sh
   apk add --no-cache curl py3-pip
   ```

3. **Téléchargement de la dernière version stable de Docker Compose:**

   ```sh
   DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
   curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
   ```

4. **Droit dexecution de docker-compose :**

   ```sh
   chmod +x /usr/local/bin/docker-compose
   ```

4. **Vérifier que Docker-Compose fonctionne correctement :**

   ```sh
   docker-compose --version
   ```

