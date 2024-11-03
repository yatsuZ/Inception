FROM alpine:3.19


RUN apk update; apk upgrade
RUN apk add nginx
RUN apk add vim
RUN apk add curl
RUN apk add bash
RUN apk add openssl

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

## Creation de certifica et de la clée

RUN /root/generateur_certifica_dans_image.sh

## Modification du html de base de nginx

#RUN echo "Bienvenue sur mon serveur NGINX !" > /var/www/html/index.html

### Exposition du port 443 pour y aceder en de hors du docker metre
# les parametre en moment de run -p 443:443
EXPOSE 443

## Execution de nginx avec daemon metre le parametre -d au moment de run

CMD [ "nginx", "-g", "daemon off;" ]
