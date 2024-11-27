-- init_db.sql
CREATE DATABASE IF NOT EXISTS ${SQL_NAME_DATABASE};

CREATE USER IF NOT EXISTS '${SQL_NAME_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD_USER}';

GRANT ALL PRIVILEGES ON ${SQL_NAME_DATABASE}.* TO '${SQL_NAME_USER}'@'%';

GRANT ALL PRIVILEGES ON *.* TO '${SQL_NAME_ADMIN}'@'%' IDENTIFIED BY '${SQL_PASSWORD_ADMIN}' WITH GRANT OPTION;

FLUSH PRIVILEGES;
