#!/bin/sh

docker stop $(docker ps -q) 2>/dev/null || echo "Aucun conteneur à arrêter."
docker rm $(docker ps -aq) 2>/dev/null || echo "Aucun conteneur à supprimer."
docker rmi $(docker images -q) 2>/dev/null || echo "Aucune image à supprimer."
