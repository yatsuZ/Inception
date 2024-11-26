#!/bin/bash

ROUGE="\e[31m"
NOCOLOR="\e[0m"

# sed -i "s|TO_REMPLACE|$SERVER_NAME|" /etc/nginx/nginx_TMP.conf
# mv /etc/nginx/nginx_TMP.conf /etc/nginx/nginx.conf
echo $SERVER_NAME > /res.txt
echo FIN >> /res.txt


if ! command -v openssl &> /dev/null
then
    echo -e $ROUGE "Erreur : 'openssl' n'est pas installé. Veuillez l'installer pour continuer." $NOCOLOR
    exit 1
fi
CERT_PATH="/etc/nginx/ssl/nginx_tls_inception.crt"

KEY_PATH="/etc/nginx/ssl/nginx_tls_inception.key"

SUBJECT="/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=yzaoui.42.fr/UID=yzaoui"

openssl req -x509 -nodes -out $CERT_PATH -keyout $KEY_PATH -subj "$SUBJECT"
