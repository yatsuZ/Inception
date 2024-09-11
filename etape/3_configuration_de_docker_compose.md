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

