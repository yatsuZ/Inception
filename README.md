# Inception

## Objectif général

"Inception" est un projet d'administration système qui vise à approfondir mes compétences en virtualisation et en conteneurisation à l'aide de Docker.  
L'objectif principal est de créer et de gérer une infrastructure composée de plusieurs services conteneurisés dans un environnement virtualisé.

## Plan d'action

| Tâche | Statut | Lien |
|-------|--------|------|
| **Documentation et préparation** | | |
| Lire le sujet et rédiger les [objectifs](./objectif.md) | ✔️ | [objectif.md](./objectif.md) |
| Écrire et documenter toutes les [notions](./concepts/) nécessaires | ✔️ | [documentation GENERAL !!](./concepts/documentation.md) |
| **Mise en œuvre technique** | | |
| Étape 1 : Création de la VM | ✔️ | [1_Creation_de_la_VM.md](./etape/1_Creation_de_la_VM.md) |
| Étape 1.1 : Installation et utilisation de SSH | ✔️ | [1-1_SSH_utilisation.md](./etape/1-1_SSH_utilisation.md) |
| Étape 2 : Installation de Docker | ✔️ | [2_installation_de_docker.md](./etape/2_installation_de_docker.md) |
| Étape 3 : Réalisation des services individuels | ✔️ | [3_installation_des_services.md](./etape/3_installation_des_services.md) |
| Étape 3.1 : Installation de Nginx | ✔️ | [3-1_Instalation_Nginx.md](./etape/Instalation_des_services/1_Instalation_Nginx.md) |
| Étape 3.2 : Installation de MariaDB | ✔️ | [3-2_Instalation_MariaDB.md](./etape/Instalation_des_services/2_Instalation_MariaDB.md) |
| Étape 3.3 : Installation de WordPress | ✔️ | [3-3_Instalation_WordPress.md](./etape/Instalation_des_services/3_Instalation_WordPress.md) |
| Étape 4 : Rédaction du fichier Docker Compose | 🔄 En cours | [4_redaction_du_docker_compose.md](./etape/4_redaction_du_docker_compose.md) |
| Étape 5 : Finalisation et objectifs finaux du projet | ❌ | [5_faire_les_derniere_objefctif_du_projet.md](./etape/5_faire_les_derniere_objefctif_du_projet.md) |

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
- **`labo`** : Dossier contenant des expérimentations et tests avant implémentation finale.  
- **`illustration`** : Contient des schémas et des diagrammes explicatifs.  
- **`rendu`** : Contient le rendu final, y compris le Makefile et les configurations requises.  
- **`script`** : Scripts utilitaires pour automatiser certaines tâches.  

## Auteur

Ce projet a été réalisé par moi-même, **[yatsuZ](https://github.com/yatsuZ)** ! 😊  
Pour toute question ou collaboration, n'hésitez pas à me contacter via GitHub.

