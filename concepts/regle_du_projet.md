# Règles du projet

1. Réalisation du projet dans une machine virtuelle.
2. Utilisation obligatoire de **docker-compose**.
3. Les images Docker doivent porter le même nom que le service.
4. Chaque service doit tourner dans un container dédié.
5. Utiliser l’avant-dernière version stable d’Alpine ou Debian.
6. Chaque service doit avoir son propre Dockerfile écrit par vous-même.
7. Les Dockerfiles doivent être appelés via un Makefile dans **docker-compose.yml**.
8. Interdiction d’utiliser des images toutes faites ou DockerHub (sauf Alpine/Debian).
9. Les containers doivent redémarrer en cas de crash.