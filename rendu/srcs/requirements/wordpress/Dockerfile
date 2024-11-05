FROM alpine:3.19

COPY ./conf/config_vim /root/.vimrc

RUN apk update && \
    apk add --no-cache \
    bash \
    vim \
    curl \
    tree \
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
    php-curl \
    php-json \
    php-xml


RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY ./conf/php82_php-fpm_d_www.conf /etc/php82/php-fpm.d/www.conf
COPY ./tools/start_wp.sh /usr/local/bin/start_wp.sh
COPY ./conf/wp-config-sample.php /etc/wp-config-sample.php 


ENTRYPOINT ["/usr/local/bin/start_wp.sh"]
CMD [] 
