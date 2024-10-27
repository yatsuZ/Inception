FROM alpine:3.19

COPY ./config_vim /root/.vimrc

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

# Télécharger et installer WordPress
RUN mkdir -p /var/www/html && \
    wget https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz -P /var/www && \
    tar -xzf /var/www/wordpress-6.0-fr_FR.tar.gz -C /var/www && \
    rm /var/www/wordpress-6.0-fr_FR.tar.gz && \
    mv /var/www/wordpress/* /var/www/html && \
    chown -R root:root /var/www/html

# Configuration de PHP-FPM
COPY ./php82_php-fpm_d_www.conf /etc/php82/php-fpm.d/

# Installer WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Copier le script de démarrage
COPY ./start_wp.sh /usr/local/bin/start_wp.sh
RUN chmod +x /usr/local/bin/start_wp.sh

# Commande de démarrage
#CMD ["/usr/local/bin/start_wp.sh"]

