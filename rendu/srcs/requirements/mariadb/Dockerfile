FROM alpine:3.19

RUN apk update && \
	apk add --no-cache \
	vim \
	bash \
	mariadb mariadb-client \
	envsubst \
	&& rm -rf /var/cache/apt/*

RUN mkdir -p /var/lib/mysql/ /run/mysqld
RUN chown -R mysql:mysql /var/lib/mysql/ /run/mysqld

COPY ./config/mariadb-server.cnf  /etc/my.cnf.d/
COPY ./config/config_vim  /root/.vimrc
COPY ./tool/init_maria_mysql.sh /bin/init_maria_mysql.sh
COPY ./tool/init_db.sql /bin/init_db.sql

CMD ["sh", "/bin/init_maria_mysql.sh"]
