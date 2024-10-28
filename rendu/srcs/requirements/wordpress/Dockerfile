# Utiliser l'image Alpine 3.19 comme base
FROM alpine:3.19

# Copier la configuration de Vim
COPY ./conf/config_vim /root/.vimrc

# Mettre à jour les paquets et installer les dépendances nécessaires
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

# Configuration de PHP-FPM
COPY ./conf/php82_php-fpm_d_www.conf /etc/php82/php-fpm.d/www.conf

# Installer WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Copier le script de démarrage
COPY ./tools/start_wp.sh /usr/local/bin/start_wp.sh
RUN chmod +x /usr/local/bin/start_wp.sh

# Définir la commande de démarrage
ENTRYPOINT ["/usr/local/bin/start_wp.sh"]
CMD [] 