#!/bin/bash

ROUGE="\e[31m"
NOCOLOR="\e[0m"

# Vérification si 'openssl' est installé
if ! command -v openssl &> /dev/null
then
    # Afficher le message en rouge
    echo -e $ROUGE "Erreur : 'openssl' n'est pas installé. Veuillez l'installer pour continuer." $NOCOLOR
    exit 1
fi

# 'openssl' est un outil en ligne de commande qui permet d'exécuter diverses opérations cryptographiques,
# comme la création de certificats, de clés, et la gestion des signatures numériques.

# 'req' permet de créer une demande de signature de certificat (CSR) ou un certificat auto-signé.
# L'option '-x509' permet de générer un certificat auto-signé au lieu d'une CSR.
# Nous allons l'utiliser pour générer un certificat auto-signé.

openssl req -x509

