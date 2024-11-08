#!/usr/bin/env sh

# Afficher les valeurs des variables d'environnement
echo "SQL_NAME_DATABASE: ${SQL_NAME_DATABASE}"
echo "SQL_NAME_USER: ${SQL_NAME_USER}"
echo "SQL_PASSWORD_USER: ${SQL_PASSWORD_USER}"
echo "SQL_PASSWORD_ROOT: ${SQL_PASSWORD_ROOT}"

if find /var/lib/mysql -mindepth 1 -maxdepth 1 | read; then
    echo "db exists"
else
    echo "need to create db"
    mysql_install_db -umysql --ldata=/var/lib/mysql
    mariadbd -umysql &
    sleep 1

    echo "created by using a script sql"
    # Exécuter le script SQL avec des variables d'environnement
    envsubst < /bin/init_db.sql | mysql -u root
    if [ $? -ne 0 ]; then
        echo "Error during database creation"
        exit 1
    fi

    echo "Database and user created"

    mysqladmin shutdown -p"${SQL_PASSWORD_ROOT}"
fi

exec mariadbd -umysql

#echo "SELECT User, Host FROM mysql.user;" | mysql -u root -p"${SQL_PASSWORD_ROOT}" -h 127.0.0.1 -P 3306
