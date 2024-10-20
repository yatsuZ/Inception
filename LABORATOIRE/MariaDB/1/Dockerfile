FROM alpine:3.19
RUN apk update && apk add vim mariadb mariadb-client

RUN mkdir /var/lib/mysql/
RUN chown mysql:mysql /var/lib/mysql/
RUN mkdir /run/mysqld
RUN chown mysql:mysql /run/mysqld

COPY mariaDB.cnf /etc/my.cnf.d/
COPY init.sh /bin/launch.sh
#COPY bdd.sql /etc/wordpress.sql

#CMD ["sh", "/bin/launch.sh"]
