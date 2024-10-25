FROM alpine:3.19

RUN apk update && \
    apk add --no-cache \
    bash \
	vim \
	curl \
	tree             \
	php7.3 \
	php-fpm \
	php-mysql \
	mariadb-client \
	wget \
    && rm -rf /var/cache/apt/*


