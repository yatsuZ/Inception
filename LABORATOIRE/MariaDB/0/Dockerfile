FROM alpine:3.19

RUN apk update && \
    apk add --no-cache \
    mariadb mariadb-client \
    bash \
	vim \
	curl \
	tree \
    && rm -rf /var/cache/apk/*

#RUN mkdir /var/lib/mysql/
#RUN chown mysql:mysql /var/lib/mysql/
#RUN mkdir /run/mysqld
#RUN chown mysql:mysql /run/mysqld

COPY ./config_vim /root/.vimrc
#COPY ./mariaDB.cnf /etc/my.cnf.d/mariadb-server.cnf

