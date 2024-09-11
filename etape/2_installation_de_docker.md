# 2 Installation de docker

Deuxieme etape du projet Instalation de docker.
voici ce qu'il y aura :

## C'est quoi ?

![docker ilustration](./../ilustration/docker.png.png)

Il y a des explication dans la [documentation](./../concepts/documentation.md#docker).
Mais voici un rapelle.

Docker est [une plateforme](./../concepts/Plateforme_vs_aplication.md) open-source permettant de créer, déployer et exécuter des applications dans des conteneurs.
Les conteneurs sont des environnements légers et portables qui isolent les applications et leurs dépendances, garantissant ainsi que celles-ci fonctionnent de manière cohérente sur différentes environnements.

## Permet de faire quoi ?

En resumée c'est sa qui permetre de faire fonctioner des service / application comme nginx mariadb et wordpress peut importe l'os de base.
et de les faire intergire entre eux.

- **Isolation** : Les conteneurs permettent d'exécuter des applications dans des environnements isolés, réduisant les conflits entre les dépendances.
- **Portabilité** : Les conteneurs Docker peuvent être déployés sur n'importe quel système prenant en charge Docker, que ce soit en local, sur un serveur ou dans le cloud.
- **Consistance** : Assure que les applications se comportent de la même manière sur différents environnements de développement, de test et de production.
- **Scalabilité** : Facilite le déploiement de multiples instances d'applications et leur mise à l'échelle horizontale.
- **Efficacité** : Les conteneurs partagent le noyau du système d'exploitation hôte, ce qui les rend plus légers et rapides par rapport aux machines virtuelles traditionnelles.

## Comment l'installer

### Sur Alpine

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