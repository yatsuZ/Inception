#!/usr/bin/env sh


if find /var/lib/mysql -mindepth 1 -maxdepth 1 | read; then
	echo "db exists"
else
	echo "need to create db"
	mysql_install_db -umysql --ldata=/var/lib/mysql
	mariadbd -umysql &
	
	sleep 1

	echo "created by using a script sql"

	mariadb -u root < /bin/sql_create_db.sql

fi

echo "SHOW DATABASES;" | mariadb -u root
echo "SHOW TABLES;" | mariadb -u root wordpress
echo "SELECT * FROM utilisateurs;" | mariadb -u root wordpress


#exec mariadbd -umysql
