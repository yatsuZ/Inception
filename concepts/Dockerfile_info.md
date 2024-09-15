### Qu'est-ce qu'un **Dockerfile** ?

Un **Dockerfile** est un fichier texte contenant des instructions permettant de créer une **image Docker**. Il définit tout ce dont votre application a besoin pour fonctionner, telles que les dépendances, les fichiers, les variables d'environnement, et les commandes qui doivent être exécutées lorsque l'image est utilisée pour lancer un conteneur.

### Pourquoi utiliser un Dockerfile ?

- **Automatisation** : Un Dockerfile permet de construire des images de manière reproductible.
- **Portabilité** : Les images Docker peuvent être utilisées sur n'importe quel système supportant Docker.
- **Simplicité** : Toutes les dépendances et la configuration sont incluses dans l'image, facilitant l'utilisation d'une application sur n'importe quel système.

---



## Structure d'un Dockerfile

1. **Image de base**
   - L'image de base est le point de départ pour construire votre propre image Docker. Elle peut être une distribution Linux comme **Alpine**, **Ubuntu**, ou d'autres images officielles disponibles sur Docker Hub.
   - **Syntaxe** : `FROM <image>[:<tag>]`
   - **Exemple** :
     ```Dockerfile
     FROM alpine:latest
     ```

2. **Installation des dépendances**
   - Utilisez l'instruction **RUN** pour exécuter des commandes de type shell, comme installer des logiciels ou mettre à jour des paquets.
   - **Exemple** :
     ```Dockerfile
     RUN apk add --no-cache nginx
     ```

3. **Copie de fichiers dans l'image**
   - **COPY** et **ADD** permettent de copier des fichiers de votre machine locale vers l'image.
   - **Exemple** :
     ```Dockerfile
     COPY app /usr/share/nginx/html
     ```

4. **Définition des variables d'environnement**
   - **ENV** permet de définir des variables d'environnement à utiliser dans l'image.
   - **Exemple** :
     ```Dockerfile
     ENV APP_ENV=production
     ```

5. **Définition du répertoire de travail**
   - **WORKDIR** définit le répertoire dans lequel les commandes suivantes seront exécutées.
   - **Exemple** :
     ```Dockerfile
     WORKDIR /app
     ```

6. **Exposer un port**
   - **EXPOSE** permet de déclarer les ports que le conteneur utilisera pour communiquer avec l'extérieur.
   - **Exemple** :
     ```Dockerfile
     EXPOSE 80
     ```

7. **Commande à exécuter au démarrage**
   - **CMD** et **ENTRYPOINT** définissent la commande qui sera exécutée lorsque le conteneur démarre.
     - **CMD** est utilisé pour fournir une commande par défaut.
     - **ENTRYPOINT** est utilisé pour définir une commande "immuable" qui sera toujours exécutée.
   - **Exemple** :
     ```Dockerfile
     CMD ["nginx", "-g", "daemon off;"]
     ```

8. **Montage de volumes**
   - **VOLUME** permet de définir des volumes Docker, des points de montage où les données peuvent être persistées.
   - **Exemple** :
     ```Dockerfile
     VOLUME /data
     ```

---

## Exemple complet d'un Dockerfile simple

```Dockerfile
# 1. Utiliser une image de base (Alpine dans ce cas)
FROM alpine:latest

# 2. Installer Nginx
RUN apk add --no-cache nginx

# 3. Copier le code HTML de l'application dans l'image
COPY index.html /usr/share/nginx/html

# 4. Exposer le port 80 pour que Nginx soit accessible
EXPOSE 80

# 5. Démarrer Nginx en arrière-plan
CMD ["nginx", "-g", "daemon off;"]
```

Dans cet exemple, nous :
1. Utilisons **Alpine** comme base.
2. Installons **Nginx** pour servir des fichiers web.
3. Copions un fichier HTML dans le répertoire de Nginx.
4. Exposons le port **80** pour permettre la communication.
5. Utilisons la commande **CMD** pour démarrer Nginx à chaque lancement du conteneur.

---

## Concepts clés du Dockerfile

- **Images de base** : Le point de départ pour construire votre application (par exemple, Alpine, Ubuntu).
- **Layers (Couches)** : Chaque instruction du Dockerfile crée une nouvelle couche dans l'image. Les couches sont empilées et mises en cache, ce qui améliore la réutilisation et l'efficacité lors des modifications mineures.
- **Build context** : Le répertoire local contenant le Dockerfile et les fichiers qui seront utilisés pour créer l'image.
- **Multistage Builds** : Permet de créer des images Docker plus légères en séparant la phase de compilation de la phase d'exécution.

## Différence entre **`EXPOSE`** et **`PUBLISH`**

### **EXPOSE**
- **Usage** : Déclare le port utilisé par le conteneur.
- **Visibilité** : Il ne rend pas le port accessible depuis l'extérieur du conteneur, mais seulement au sein du réseau Docker.
- **Syntaxe** dans Dockerfile :
  ```Dockerfile
  EXPOSE 80
  ```

### **PUBLISH** (ou **`-p`** lors de l'exécution)
- **Usage** : Rend le port accessible depuis l'extérieur du conteneur en mappant un port de l'hôte à celui du conteneur.
- **Syntaxe** lors de l'exécution du conteneur :
  ```bash
  docker run -p 8080:80 my-container
  ```

  Cela mappe le port 8080 de la machine hôte au port 80 du conteneur.

En résumé :
- **EXPOSE** informe Docker sur les ports utilisés dans le conteneur mais ne les rend pas accessibles.
- **PUBLISH** lie les ports du conteneur à ceux de l'hôte, les rendant accessibles de l'extérieur.

---

## Bonnes pratiques pour rédiger un Dockerfile

1. **Utiliser des images légères** : Privilégiez des images de base minimales comme **Alpine** pour réduire la taille des images Docker.
2. **Minimiser les couches** : Combiner les instructions **RUN** pour réduire le nombre de couches.
3. **Utiliser les caches efficacement** : Placer les instructions rarement modifiées (comme **RUN apk add**) au début pour maximiser l'utilisation du cache.
4. **Exécuter des commandes non interactives** : Utiliser des options comme `-y` ou `--no-cache` pour éviter les prompts dans les commandes de type **RUN**.
5. **Éviter d'inclure des fichiers inutiles** : Utiliser `.dockerignore` pour exclure des fichiers de l'image Docker.

---

## Liens utiles pour en savoir plus

1. [Documentation officielle de Docker sur les Dockerfiles](https://docs.docker.com/engine/reference/builder/)
2. [Tutoriel Dockerfile par Docker](https://docs.docker.com/get-started/part2/)
3. [Dockerfile Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)

Ces ressources fournissent des informations détaillées pour maîtriser l'écriture des Dockerfiles et construire des images efficaces pour vos projets.

