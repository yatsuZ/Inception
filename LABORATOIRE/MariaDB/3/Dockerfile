FROM alpine:3.19
RUN apk update && \
	apk add --no-cache \
	vim \
	bash \
	mariadb mariadb-client \
	tree \
	&& rm -rf /var/cache/apt/*

RUN mkdir -p /var/lib/mysql/ /run/mysqld
RUN chown -R mysql:mysql /var/lib/mysql/ /run/mysqld

COPY ./mariadb-server.cnf  /etc/my.cnf.d/
COPY ./config_vim  /root/.vimrc
COPY init.sh /bin/launch.sh

#CMD ["sh", "/bin/launch.sh"]
