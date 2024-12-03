# Inception

- [Inception](#inception)
  - [Objectif général](#objectif-général)
  - [Plan d'action](#plan-daction)
  - [**Résumé et plan de mise en œuvre**](#résumé-et-plan-de-mise-en-œuvre)
  - [Structure du projet](#structure-du-projet)
  - [Prérequis](#prérequis)
  - [Utilisation du projet](#utilisation-du-projet)
  - [Auteur](#auteur)


## Objectif général

"Inception" est un projet d'administration système visant à approfondir mes compétences en virtualisation et en conteneurisation à l'aide de Docker.
L'objectif principal est de concevoir une infrastructure composée de plusieurs services conteneurisés, tous gérés dans un environnement virtualisé.

---

## Plan d'action

| Tâche                              | Statut      | Lien                                                |
|------------------------------------|-------------|----------------------------------------------------|
| **Documentation et préparation**  | ✔️          |                                                    |
| Lire le sujet et rédiger les [objectifs](./objectif.md) | ✔️ | [objectif.md](./objectif.md)                     |
| Écrire et documenter toutes les [notions](./concepts/) nécessaires | ✔️ | [documentation générale](./concepts/documentation.md) |
| **Mise en œuvre technique**       | ✔️          |                                                    |
| Étape 1 : Création de la VM       | ✔️          | [1_Creation_de_la_VM.md](./etape/1_Creation_de_la_VM.md) |
| Étape 1.1 : Installation et utilisation de SSH | ✔️ | [1-1_SSH_utilisation.md](./etape/1-1_SSH_utilisation.md) |
| Étape 2 : Installation de Docker  | ✔️          | [2_installation_de_docker.md](./etape/2_installation_de_docker.md) |
| Étape 3 : Réalisation des services individuels | ✔️ | [3_installation_des_services.md](./etape/3_installation_des_services.md) |
| Étape 3.1 : Installation de Nginx | ✔️          | [3-1_Instalation_Nginx.md](./etape/Instalation_des_services/1_Instalation_Nginx.md) |
| Étape 3.2 : Installation de MariaDB | ✔️        | [3-2_Instalation_MariaDB.md](./etape/Instalation_des_services/2_Instalation_MariaDB.md) |
| Étape 3.3 : Installation de WordPress | ✔️      | [3-3_Instalation_WordPress.md](./etape/Instalation_des_services/3_Instalation_WordPress.md) |
| Étape 4 : Rédaction du fichier Docker Compose | ✔️ | [4_redaction_du_docker_compose.md](./etape/4_redaction_du_docker_compose.md) |
| Étape 5 : Finalisation et objectifs finaux du projet | ✔️ | [5_faire_les_derniere_objefctif_du_projet.md](./etape/5_faire_les_derniere_objefctif_du_projet.md) |

---

## **Résumé et plan de mise en œuvre**

Pour réussir ce projet, suivez les étapes clés :

1. **Créer un Dockerfile pour Nginx**
   - Configurer le fichier `nginx.conf` pour répondre aux exigences du projet.
   - Conteneuriser Nginx et valider son bon fonctionnement.

2. **Créer un Dockerfile pour MariaDB**
   - Configurer MariaDB avec des utilisateurs, des bases de données, et automatiser leur création via des scripts.
   - Tester la connectivité du service.

3. **Configurer WordPress et PHP**
   - Intégrer WordPress dans un conteneur avec PHP-FPM.
   - Configurer les fichiers nécessaires pour la connexion à MariaDB.
   - Finaliser la configuration avec Docker Compose.

4. **Mettre en place les volumes, réseaux et variables d'environnement**
   - Configurer des volumes pour persister les données entre les conteneurs.
   - Ajouter des secrets pour sécuriser les données sensibles (comme les mots de passe).

5. **Assurer la connectivité entre les conteneurs**
   - Vérifier que chaque conteneur accède correctement aux variables d'environnement et aux fichiers secrets.

6. **Créer le Makefile**  
   - Automatiser le lancement, l'arrêt et le nettoyage de l'infrastructure avec des commandes simples comme `make`, `make re`, etc.

---

## Structure du projet

- **`README.md`** : Introduction et vue d'ensemble du projet.
- **[`fr.subject.Inception.pdf`](./fr.subject.Inception.pdf)** : Sujet officiel détaillé du projet.
- **[`objectif.md`](./objectif.md)** : Objectifs spécifiques à atteindre pour le projet.
- **[`concepts`](./concepts/)** : Documentation sur les concepts clés :
  - [Configuration de Nginx](./concepts/configuration_de_nginx.md)
  - [Docker vs Docker Compose](./concepts/docker_vs_docker_compose.md)
  - [Génération de certificats SSL](./concepts/generer_un_certificat_ssl.md)
- **`etape`** : Étapes détaillées du projet :
  - Création de la VM
  - Installation des services conteneurisés
  - Rédaction des configurations Docker Compose
- **`rendu`** : Contient le rendu final, y compris le Makefile et les configurations requises.
- **`script`** : Scripts utilitaires pour automatiser certaines tâches.

---

## Prérequis

1. Avoir **Docker** et **Docker Compose** installés.
2. Disposer d’un **navigateur web avec une interface graphique** pour tester l’accès aux services.
3. Cloner ce dépôt Git et naviguer dans le dossier `rendu`.

---

## Utilisation du projet

1. Clonez ce dépôt :
   ```bash
   git clone https://github.com/yatsuZ/inception.git
   cd inception/rendu
   ```
2. Lancez l'infrastructure avec `make` :
   ```bash
   make
   ```
3. Si des ports sont déjà utilisés, supprimez les conteneurs existants et relancez :
   ```bash
   docker ps -q | xargs docker stop | xargs docker rm
   make re
   ```
   *(Cette commande nettoie les conteneurs conflictuels avant de relancer l’infrastructure.)*

4. Accédez aux services via votre navigateur web :
   - [https://localhost](https://localhost)

## Auteur

Ce projet a été réalisé par moi-même, **[yatsuZ](https://github.com/yatsuZ)** ! 😊
Pour toute question ou collaboration, n'hésitez pas à me contacter via GitHub.

