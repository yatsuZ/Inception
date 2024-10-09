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

### INstqllqtion de paquet 

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


