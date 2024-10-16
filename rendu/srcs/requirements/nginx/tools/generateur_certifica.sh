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
# L'option '-nodes' permet de ne pas chiffrer la clé privée. Cela signifie qu'aucune phrase de passe
# ne sera demandée lors de l'utilisation de la clé privée, ce qui est pratique pour les scripts automatisés.


# -out spécifie le fichier où sera sauvegardé le certificat généré.
# -keyout spécifie le fichier où sera enregistrée la clé privée générée.
# -subj permet de définir toutes les informations du certificat (pays, ville, organisation) sans interaction utilisateur.

# Chemin où sera stocké le certificat
CERT_PATH="/etc/nginx/ssl/nginx_tls_inception.crt"

# Chemin où sera stockée la clé privée
KEY_PATH="/etc/nginx/ssl/nginx_tls_inception.key"

# Informations à inclure dans le certificat via le champ -subj
SUBJECT="/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=yzaoui.42.fr/UID=yzaoui"

# Création du certificat auto-signé avec les chemins spécifiés pour la clé et le certificat
openssl req -x509 -nodes -out $CERT_PATH -keyout $KEY_PATH -subj "$SUBJECT"

