FROM alpine:3.19

RUN apk update && \
    apk add --no-cache \
    mariadb mariadb-client \
    bash \
	vim \
	curl \
	tree \
    && rm -rf /var/cache/apt/*

RUN mkdir -p /var/lib/mysql /run/mysqld
RUN chown -R mysql:mysql /var/lib/mysql /run/mysqld


COPY ./config_vim /root/.vimrc
COPY ./mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf
#COPY ./init-mysql.sh /usr/local/bin/init-mysql.sh

#RUN /usr/local/bin/init-mysql.sh
