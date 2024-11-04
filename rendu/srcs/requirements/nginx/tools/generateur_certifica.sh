#!/bin/bash

ROUGE="\e[31m"
NOCOLOR="\e[0m"

if ! command -v openssl &> /dev/null
then
    echo -e $ROUGE "Erreur : 'openssl' n'est pas installé. Veuillez l'installer pour continuer." $NOCOLOR
    exit 1
fi

openssl req -x509 -nodes -out $CERT_PATH -keyout $KEY_PATH -subj "$INFORMATION_FOR_SSL"
