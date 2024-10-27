FROM alpine:3.19
RUN apk update
RUN apk add php php-fpm php-pdo php-mysqli php-phar php-mbstring php-iconv php-tokenizer php-redis

ADD  https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar /usr/local/bin/wp
RUN chmod +x /usr/local/bin/wp

COPY www.conf /etc/php82/php-fpm.d/
COPY wp-config-sample.php /etc/wp-config-sample.php
COPY launch.sh /bin/launch.sh


CMD ["sh", "/bin/launch.sh"]
