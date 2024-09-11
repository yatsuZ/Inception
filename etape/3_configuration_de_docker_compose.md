# Debut des configurations de docker-compose 

Apres avoir installer docker et doocker compose je peux commencer a le configurer voici mon plan

## 1. Preparer le dossier rendu

Dans le pdf du sujet ils nous montre l'aroboraissance du rendu voici l'image :

![arboraissance du rendu](./../ilustration/arboraissance_du_rendu.png)

```sh
.
├── Makefile
├── secrets
│   ├── credentials.txt
│   ├── db_password.txt
│   └── db_root_password.txt
└── srcs
    ├── docker-compose.yml
    ├── .env
    └── requirements
        ├── bonus
        │   └── [...]
        ├── mariadb
        │   ├── conf
        │   ├── Dockerfile
        │   ├── .dockerignore
        │   └── tools
        ├── nginx
        │   ├── conf
        │   ├── Dockerfile
        │   ├── .dockerignore
        │   └── tools
        ├── tools
        └── wordpress
        	└── [...]
```
> Atention tout info privée sensible [ tous les identifiants, clés API, variables env etc...] Ne devront etre que enregistrer localement !! Faire un git ignore

fais les modification de : docker-compose.yml
aux fur et a mesure.

## 2. [Comence a installer le service NGINX](./Instalation_des_services/1_Instalation_Nginx.md)


