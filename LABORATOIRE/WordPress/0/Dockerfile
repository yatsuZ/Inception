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
	php \
	php-fpm \
	php-pdo \
	php-mysqli \
	php-phar \
	php-mbstring \
	php-iconv \
	php-tokenizer \
	php-redis \
	&& rm -rf /var/cache/apt/*

RUN wget https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz -P /var/www
RUN cd /var/www && tar -xzf wordpress-6.0-fr_FR.tar.gz && rm wordpress-6.0-fr_FR.tar.gz
RUN	chown -R root:root /var/www/wordpress

COPY ./php82_php-fpm_d_www.conf /etc/php82/php-fpm.d/

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp


