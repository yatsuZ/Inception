#!/bin/bash

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
RESET='\033[0m'

# Répertoire à vérifier
REQUIRED_DIRECTORY="./secrets"

echo -e "${CYAN}🔧 Vérification de l'existence du répertoire : ${YELLOW}$REQUIRED_DIRECTORY${RESET}"
if [ ! -d "$REQUIRED_DIRECTORY" ]; then
  echo -e "${RED}❌ Répertoire manquant :${YELLOW} $REQUIRED_DIRECTORY${RESET}"
  echo -e "${RED}🚨 Assurez-vous que le répertoire existe avant de continuer.${RESET}"
  exit 1
fi

echo -e "${GREEN}✔ Le répertoire ${YELLOW}$REQUIRED_DIRECTORY ${GREEN}est présent !${RESET}"

# Décommenter cette section si tu veux vérifier des fichiers spécifiques
# # Fichiers nécessaires
# REQUIRED_FILES=(
#   "./secrets/sql_password_root.txt"
#   "./secrets/sql_password_user.txt"
# )

# # Vérifier chaque fichier
# echo -e "${CYAN}🔧 Vérification des fichiers secrets${RESET}"
# for FILE in "${REQUIRED_FILES[@]}"; do
#   if [ ! -f "$FILE" ]; then
#     echo -e "${RED}❌ Fichier manquant :${YELLOW} $FILE${RESET}"
#     echo -e "${RED}🚨 Assurez-vous que tous les fichiers secrets sont présents avant de continuer.${RESET}"
#     exit 1
#   fi
# done

# echo -e "${GREEN}✔ Tous les fichiers secrets sont présents !${RESET}"
