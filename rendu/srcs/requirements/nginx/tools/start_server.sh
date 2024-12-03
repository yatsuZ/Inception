#!/bin/sh

# Remplace la variable $SERVER_NAME dans nginx.conf par sa valeur dans l'environnement
envsubst '${SERVER_NAME}' < /etc/nginx/nginx.conf > /etc/nginx/nginx_TMP.conf
mv /etc/nginx/nginx_TMP.conf /etc/nginx/nginx.conf
echo $SERVER_NAME > /res.txt

# Lancer Nginx avec la commande "daemon off" pour qu'il fonctionne en premier plan
exec nginx -g "daemon off;"
