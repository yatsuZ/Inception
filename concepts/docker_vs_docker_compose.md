# Docker vs Docker compose

- [Docker vs Docker compose](#docker-vs-docker-compose)
	- [**Docker**](#docker)
		- [**Qu'est-ce que Docker ?**](#quest-ce-que-docker-)
		- [**Fonctionnalités Clés :**](#fonctionnalités-clés-)
		- [**Commandes Clés :**](#commandes-clés-)
	- [**Docker Compose**](#docker-compose)
		- [**Qu'est-ce que Docker Compose ?**](#quest-ce-que-docker-compose-)
		- [**Fonctionnalités Clés :**](#fonctionnalités-clés--1)
		- [**Commandes Clés :**](#commandes-clés--1)
	- [**Comparaison et Complémentarité**](#comparaison-et-complémentarité)
	- [**Exemple d’Utilisation :**](#exemple-dutilisation-)

## **Docker**

### **Qu'est-ce que Docker ?**

Docker est une plateforme qui permet de créer, déployer et exécuter des applications dans des conteneurs. Les conteneurs Docker sont des unités légères et portables qui encapsulent une application et toutes ses dépendances, garantissant ainsi que l'application fonctionne de manière cohérente sur n'importe quel environnement, qu'il s'agisse de développement, de test ou de production.

### **Fonctionnalités Clés :**

- **Création de Conteneurs :** Utilise des images Docker pour créer des conteneurs. Les images sont des modèles statiques qui définissent le système d'exploitation, les bibliothèques et les dépendances nécessaires pour exécuter une application.
- **Isolation :** Fournit un environnement isolé pour chaque application, ce qui réduit les conflits entre les applications et permet une meilleure sécurité.
- **Portabilité :** Les conteneurs peuvent être exécutés sur n'importe quelle machine qui supporte Docker, ce qui facilite le déploiement multi-environnements.
- **Gestion des Conteneurs :** Permet de démarrer, arrêter, supprimer et gérer des conteneurs individuellement.

### **Commandes Clés :**

- `docker build` : Crée une image Docker à partir d'un Dockerfile.
- `docker run` : Exécute un conteneur à partir d'une image.
- `docker ps` : Affiche les conteneurs en cours d'exécution.
- `docker stop` : Arrête un conteneur en cours d'exécution.

## **Docker Compose**

### **Qu'est-ce que Docker Compose ?**

Docker Compose est un outil qui permet de définir et de gérer des applications multi-conteneurs. Il utilise un fichier de configuration YAML (`docker-compose.yml`) pour spécifier les services, les réseaux et les volumes nécessaires à l'application, ainsi que les dépendances entre eux. Docker Compose simplifie la gestion des environnements complexes où plusieurs conteneurs doivent interagir.

### **Fonctionnalités Clés :**

- **Configuration Multi-Conteneurs :** Permet de définir plusieurs conteneurs dans un seul fichier, ainsi que leurs configurations (variables d'environnement, volumes, ports, etc.).
- **Orchestration :** Automatise le démarrage, l'arrêt et la gestion des conteneurs comme un groupe, en respectant les dépendances entre eux.
- **Simplicité :** Facilite le déploiement et la gestion des environnements complexes avec des configurations prédéfinies.

### **Commandes Clés :**

- `docker-compose up` : Démarre tous les services définis dans le fichier `docker-compose.yml`. Les conteneurs sont créés et lancés en arrière-plan.
- `docker-compose down` : Arrête et supprime les conteneurs, les réseaux et les volumes créés par `docker-compose up`.
- `docker-compose build` : Construit les images Docker définies dans le fichier `docker-compose.yml`.
- `docker-compose logs` : Affiche les logs des conteneurs gérés par Docker Compose.

## **Comparaison et Complémentarité**

- **Docker :** Gère les conteneurs individuels. Utile pour des tâches simples comme le déploiement d'une seule application ou le test de conteneurs individuels.
- **Docker Compose :** Gère des ensembles de conteneurs qui interagissent entre eux. Idéal pour des applications multi-conteneurs, comme celles qui ont besoin d'une base de données, d'un serveur web et d'autres services.

## **Exemple d’Utilisation :**

- **Docker Seul :** Tu souhaites exécuter une application web simple dans un conteneur. Tu utilises `docker run` pour lancer l'application.
  
- **Docker avec Docker Compose :** Tu développes une application web qui a besoin d'une base de données et d'un service de cache. Tu définis tous ces services dans un fichier `docker-compose.yml` et utilises `docker-compose up` pour démarrer l'ensemble de l'application avec tous ses composants.

En résumé, Docker est l'outil principal pour créer et gérer des conteneurs, tandis que Docker Compose simplifie la gestion de plusieurs conteneurs qui composent une application plus complexe.