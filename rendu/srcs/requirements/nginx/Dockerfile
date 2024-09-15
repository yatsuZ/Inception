# 1. Utiliser une image de base Alpine
FROM alpine:3.19

# 2. Installer les dépendances nécessaires (Nginx et OpenSSL -> pour tsl)
RUN apk add --no-cache nginx openssl

# 3. Copier les fichiers de configuration Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# 4. Copier les certificats SSL (assurez-vous que les certificats sont présents dans le même répertoire que le Dockerfile)
COPY ssl/ /etc/nginx/ssl/

# 5. Exposer le port 443 pour HTTPS / et demander dans le sujet en +
EXPOSE 443

# 6. Définir le répertoire de travail
WORKDIR /etc/nginx

# 7. Démarrer Nginx en arrière-plan
CMD ["nginx", "-g", "daemon off;"]
