FROM alpine:3.19


COPY ./config_vim /root/.vimrc
COPY ./other_repo /root/other_repo

RUN cat /root/other_repo >> /etc/apk/repositories

RUN apk update && \
    apk add --no-cache \
    bash \
	vim \
	curl \
	tree            \
	wget \
	mariadb-client \
#	php7.3 \
#	php-fpm \
#	php-mysql \
    && rm -rf /var/cache/apt/*


