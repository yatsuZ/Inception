#!/bin/bash

# Script à exécuter
SCRIPT_TO_RUN="$1"

# Vérifier si le script existe
if [ ! -f "$SCRIPT_TO_RUN" ]; then
  echo "Le script $SCRIPT_TO_RUN n'existe pas."
  exit 1
fi

# Exécuter le script et rediriger la sortie vers tous les terminaux de /dev/pts/*
for terminal in /dev/pts/*; do
  if [ -w "$terminal" ]; then  # Vérifie si nous avons les droits d'écriture
    # Exécuter le script en redirigeant la sortie vers le terminal
    $SCRIPT_TO_RUN > "$terminal" 2>&1 &
  fi
done
