#!/usr/bin/env sh


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

#echo "SHOW DATABASES;" | mariadb -u root -p"${SQL_PASSWORD_ROOT}"
#echo "SHOW TABLES;" | mariadb -u root -p"${SQL_PASSWORD_ROOT}" ${SQL_NAME_DATABASE}
echo "SELECT User, Host FROM mysql.user;" | mariadb -u root -p"${SQL_PASSWORD_ROOT}"

exec mariadbd -umysql

#echo "SELECT User, Host FROM mysql.user;" | mysql -u root -p"${SQL_PASSWORD_ROOT}" -h 127.0.0.1 -P 3306
