#!/bin/sh

docker build -t image_test .
if [ $? -ne 0 ]; then  # Vérifie si la commande a échoué (code de retour différent de 0)
    exit 1
fi

echo "Vouloir manipuler directement la VM ? (y/n)"
read go_in
echo "Run en détaché ? (y/n)"
read answer

if [ "$answer" = "y" ]; then
    docker run -d --name contenair_test image_test
    if [ "$go_in" = "y" ]; then
        docker exec -it contenair_test sh  # Lancement d'un shell interactif dans le conteneur
    fi
else
    if [ "$go_in" = "y" ]; then
        docker run -it --name contenair_test image_test
    else
        docker run --name contenair_test image_test
    fi
fi

