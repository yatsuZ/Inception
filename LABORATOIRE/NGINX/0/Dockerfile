FROM alpine:3.19
# pour le construire faire
# docker build [Le chemin ou est le Dockerfile]
# avec l'option -t je peux precise le nom de mon docker file

# docker build -t testnginx [Chemin]
# > le nome des images tjr en minuscule

# docker images # permet d'afficher tout les images construite
# docker rmi # permet de suprimer le build
# docker run -it # permet de demarrer l'image + rentrer dedans

#RUN echo SALUT Je suis dans le contenaire

### INstallation de paquet 

RUN apk update; apk upgrade
RUN apk add nginx
RUN apk add vim
COPY ./config_vim /root/.vimrc 
COPY ./generateur_certifica.sh /root/generateur_certifica_dans_image.sh
RUN apk add curl

################ pour la generation de clée

RUN apk add bash
RUN mkdir -p /etc/nginx/ssl
RUN apk add openssl

RUN /root/generateur_certifica_dans_image.sh

################ pour le fichier de configuration nginx

RUN mkdir -p /var/run/nginx
COPY ./nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /var/www/html
RUN echo "Bienvenue sur mon serveur NGINX !" > /var/www/html/index.html
RUN chmod 755 /var/www/html
RUN adduser -S -G www-data www-data
RUN chown -R www-data:www-data /var/www/html

RUN mkdir -p /etc/nginx/snippets
COPY ./fastcgi-php.conf /etc/nginx/snippets/fastcgi-php.conf

EXPOSE 443

# A Faire dans le docker en desacitvant cmd
# faire nginx -t # pour verifier que tout est bon
# faire juste nginx pour demarre
# est utilise curl -k https://localhost pour recupere la page daccueil
CMD [ "nginx", "-g", "daemon off;" ]
# Au moment de run faire : 
# docker run -p 443:443 [is docker ou son nom]
