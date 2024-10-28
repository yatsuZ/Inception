# Dockerfile

Ce fichier a pour but d'expliquer les principes de base et utiles du Dockerfile :

1. Définir ce que c'est.
2. Comment rédiger et connaître les mots-clés.
3. Comment manipuler et exécuter un Dockerfile.
4. Sources de documentation.

## Qu'est-ce qu'un **Dockerfile** ?

Un **Dockerfile** est un fichier texte contenant des instructions permettant de créer une **image Docker**. Il définit tout ce dont votre application a besoin pour fonctionner, telles que les dépendances, les fichiers, les variables d'environnement, et les commandes qui doivent être exécutées lorsque l'image est utilisée pour lancer un conteneur.

### Pourquoi utiliser un Dockerfile ?

- **Automatisation** : Le Dockerfile permet de construire des images de manière reproductible et automatisée.
- **Portabilité** : Les images Docker peuvent être utilisées sur n'importe quel système supportant Docker, garantissant ainsi la portabilité de l'application.
- **Simplicité** : Toutes les dépendances et configurations sont incluses dans l'image, facilitant ainsi le déploiement de l'application sur divers systèmes.

---

## Mots-clés

1. **FROM**  
   Le mot-clé **FROM** est le premier à utiliser dans un Dockerfile. Il permet de définir l'image de base sur laquelle le conteneur sera construit, c'est-à-dire le système d'exploitation de départ. Exemple :
   ```Dockerfile
   FROM alpine:3.19
   ```

2. **RUN**  
   Le mot-clé **RUN** permet d'exécuter une commande dans le conteneur lors de la création de l'image. Exemple :
   ```Dockerfile
   RUN apk update
   ```

3. **COPY**  
   Le mot-clé **COPY** permet de copier un fichier ou un répertoire depuis l'hôte vers le conteneur. Exemple :
   ```Dockerfile
   COPY ./conf/config_vim /root/.vimrc 
   ```

4. **EXPOSE**  
   Le mot-clé **EXPOSE** permet d'exposer un port du conteneur vers le système hôte. Attention, vous devez aussi spécifier ce port lors de l'exécution de `docker run`. Exemple :
   ```Dockerfile
   EXPOSE 443
   ```
   ```bash
   # Lors de l'exécution avec 'docker run'
   $> docker run -p 443:443 [ID ou nom de l'image]
   ```

5. **CMD**  
   Le mot-clé **CMD** permet de spécifier la commande à exécuter lorsque le conteneur est démarré. Si plusieurs commandes sont spécifiées, la dernière prendra effet. Exemple :
   ```Dockerfile
   CMD [ "nginx", "-g", "daemon off;" ]
   ```
   Si vous souhaitez exécuter le conteneur en mode détaché (en arrière-plan), vous pouvez utiliser l'option `-d` lors de l'exécution :
   ```bash
   # Lors de l'exécution avec 'docker run'
   $> docker run -d [ID ou nom de l'image]
   ```

6. **ENTRYPOINT**

   Définit la commande principale qui sera toujours exécutée lorsque le conteneur démarre.
   Exemple :
   ```Dockerfile
   ENTRYPOINT ["nginx"]
   ```

---

## Commandes Docker

1. **Dockerfile**  
   Un **Dockerfile** est un fichier texte qui contient les instructions nécessaires pour construire une image Docker.

2. **Image**  
   Une **image** Docker est une instance immuable qui contient tous les éléments nécessaires à l'exécution d'un conteneur (par exemple, le système d'exploitation, les dépendances, les fichiers d'application).

3. **Conteneur**  
   Un **conteneur** est une instance en cours d'exécution d'une image Docker. Il fonctionne comme une unité isolée, en exécutant l'application et ses dépendances.

Donc, en résumé :

- **Dockerfile** = Code source (instructions pour construire l'image).
- **Image** = Compilation (résultat prêt à l'exécution).
- **Conteneur** = Exécution (instance fonctionnelle qui utilise l'image).


Pour utiliser les commandes Docker, il faut d'abord appeler le mot-clé `docker`, puis choisir l'une des commandes suivantes :

### 1. **docker build**  
   La commande **`docker build`** permet de construire une image à partir d'un Dockerfile. Avec l'option `-t`, on peut nommer l'image générée. Exemple :
   ```bash
   # Construire une image à partir du Dockerfile dans le répertoire courant
   $ docker build .
   
   # Construire une image et la nommer "docker_name"
   $ docker build -t docker_name .
   
   # Construire une image et la nommer "docker_name" à partir d'un autre répertoire
   $ docker build -t docker_name [chemin_du_dossier]
   ```

### 2. **docker run**  
   La commande **`docker run`** permet de créer et exécuter un conteneur à partir d'une image. L'option `-d` permet d'exécuter le conteneur en mode détaché (en arrière-plan), et l'option `-p` permet de mapper des ports entre le conteneur et l'hôte. L'option `-it` permet d'interagir avec le conteneur via le terminal (fonctionne uniquement si le conteneur n'est pas en mode détaché). Exemple :
   ```bash
   # Lancer un conteneur en mode interactif
   $ docker run -it [ID ou nom de l'image]
   
   # Lancer un conteneur en mode détaché et rediriger les ports
   $ docker run -d -p 443:443 [ID ou nom de l'image]
   
   # Lancer un conteneur en mode détaché et rediriger les ports
   $ docker run -d -p 443:443 docker_name
   ```

### 3. **docker exec**  
   La commande **`docker exec`** permet d'exécuter une commande dans un conteneur déjà en cours d'exécution. Elle est similaire à **`docker run`**, mais fonctionne uniquement si le conteneur est déjà en fonctionnement. Exemple :
   ```bash
   # Exécuter une commande dans un conteneur en cours d'exécution
   $ docker exec -it [ID ou nom du conteneur] bash
   ```

### 4. **docker ps**  
   La commande **`docker ps`** permet d'afficher la liste des conteneurs en cours d'exécution. L'option `-q` permet d'afficher uniquement les IDs des conteneurs. Exemple :
   ```bash
   # Afficher les conteneurs en cours d'exécution
   $ docker ps
   
   # Afficher uniquement les IDs des conteneurs
   $ docker ps -q
   ```

### 5. **docker stop**  
   La commande **`docker stop`** permet d'arrêter un conteneur en cours d'exécution. Exemple :
   ```bash
   # Arrêter un conteneur
   $ docker stop [ID ou nom du conteneur]
   ```

### 6. **docker rm**  
   La commande **`docker rm`** permet de supprimer un conteneur arrêté. Exemple :
   ```bash
   # Supprimer un conteneur arrêté
   $ docker rm [ID ou nom du conteneur]
   ```

### 7. **docker rmi**  
   La commande **`docker rmi`** permet de supprimer une image Docker. Exemple :
   ```bash
   # Supprimer une image
   $ docker rmi [ID ou nom de l'image]
   ```

### 8. **docker images**  
   La commande **`docker images`** permet d'afficher la liste des images Docker présentes sur votre système. Exemple :
   ```bash
   # Afficher la liste des images
   $ docker images
   ```

---

## Liens utiles pour en savoir plus

1. [Documentation officielle de Docker sur les Dockerfiles](https://docs.docker.com/engine/reference/builder/)
2. [Tutoriel Dockerfile par Docker](https://docs.docker.com/get-started/part2/)
3. [Dockerfile Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)

Ces ressources fournissent des informations détaillées pour maîtriser l'écriture des Dockerfiles et construire des images efficaces pour vos projets.

