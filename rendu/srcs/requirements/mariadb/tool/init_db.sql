-- init_db.sql 
CREATE DATABASE IF NOT EXISTS ${SQL_NAME_DATABASE};

CREATE USER IF NOT EXISTS '${SQL_NAME_USER}'@'localhost' IDENTIFIED BY '${SQL_PASSWORD_USER}';

GRANT ALL PRIVILEGES ON ${SQL_NAME_DATABASE}.* TO '${SQL_NAME_USER}'@'localhost';

ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_PASSWORD_ROOT}';
-- GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${SQL_PASSWORD_ROOT}';

FLUSH PRIVILEGES;

