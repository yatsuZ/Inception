#!/bin/sh

# Charger le contenu des secrets dans les variables d'environnement
export SQL_PASSWORD_ROOT=$(cat /run/secrets/sql_password_root)
export SQL_PASSWORD_USER=$(cat /run/secrets/sql_password_user)

echo salut
