FROM alpine:3.19

ENV SQL_NAME_DATABASE=nom_de_database_test
ENV SQL_NAME_USER=nom_utilisateur 
ENV SQL_PASSWORD_USER=mdp_utilisateur

RUN apk update && \
	apk add --no-cache \
	vim \
	bash \
	mariadb mariadb-client \
	envsubst \
	&& rm -rf /var/cache/apt/*

RUN mkdir -p /var/lib/mysql/ /run/mysqld
RUN chown -R mysql:mysql /var/lib/mysql/ /run/mysqld

COPY ./mariadb-server.cnf  /etc/my.cnf.d/
COPY ./config_vim  /root/.vimrc
COPY ./init_maria_mysql.sh /bin/init_maria_mysql.sh
COPY ./init_db.sql /bin/init_db.sql

CMD ["sh", "/bin/init_maria_mysql.sh"]
