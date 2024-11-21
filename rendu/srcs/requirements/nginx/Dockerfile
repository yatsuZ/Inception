FROM alpine:3.19

RUN apk update; apk upgrade
RUN apk add nginx
RUN apk add vim
RUN apk add curl
RUN apk add bash
RUN apk add openssl
RUN apk add envsubst

RUN mkdir -p /etc/nginx/ssl
RUN mkdir -p /var/run/nginx
RUN mkdir -p /var/www/html
RUN adduser -S -G www-data www-data
RUN mkdir -p /etc/nginx/snippets

RUN chmod 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html

COPY ./tools/generateur_certifica.sh /root/generateur_certifica_dans_image.sh
COPY ./conf/config_vim /root/.vimrc 
COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./conf/fastcgi-php.conf /etc/nginx/snippets/fastcgi-php.conf


RUN /root/generateur_certifica_dans_image.sh

#RUN echo "Bienvenue sur mon serveur NGINX !" > /var/www/html/index.html

EXPOSE 443

ENTRYPOINT [ "nginx" ]

CMD ["-g", "daemon off;" ]
