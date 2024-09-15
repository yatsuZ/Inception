# Configuration de Nginx pour TLS

## Objectif

Configurer Nginx pour qu'il supporte TLS, en utilisant des certificats SSL pour sécuriser les connexions. Ce guide vous montrera comment créer une configuration Nginx simple pour activer TLSv1.3 et utiliser un certificat SSL.

## Étapes

### Créer le Fichier de Configuration Nginx

Voici un exemple de fichier de configuration Nginx (`nginx.conf`) pour activer TLS :

```nginx
server {
    listen 443 ssl;
    server_name yzaoui.42.fr;  # Remplacez par votre domaine

    # Chemins vers les certificats SSL
    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/private-key.pem;

    # Configuration de base pour TLS
    ssl_protocols TLSv1.2 TLSv1.3;  # Activer TLSv1.2 et TLSv1.3
    ssl_ciphers 'TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256';  # Suite de chiffrement sécurisée
    ssl_prefer_server_ciphers off;  # Préférer les paramètres des clients pour la négociation

    # Configuration de la session SSL
    ssl_session_cache shared:SSL:10m;  # Cache des sessions SSL
    ssl_session_timeout 10m;  # Durée de vie des sessions SSL

    # Configuration du site
    location / {
        root /usr/share/nginx/html;  # Répertoire racine des fichiers du site
        index index.html;  # Page d'accueil
    }

    # Configuration pour une meilleure sécurité
    ssl_stapling on;  # Activer le stapling OCSP
    ssl_stapling_verify on;  # Vérifier le stapling OCSP
}
```

### Explications des Directives

- **listen 443 ssl;** : Configure Nginx pour écouter les connexions HTTPS sur le port 443.
- **ssl_certificate** et **ssl_certificate_key** : Chemins vers les fichiers de certificat SSL et de clé privée.
- **ssl_protocols** : Spécifie les versions de TLS à utiliser (ici TLSv1.2 et TLSv1.3).
- **ssl_ciphers** : Liste des suites de chiffrement sécurisées à utiliser.
- **ssl_prefer_server_ciphers** : Détermine si le serveur ou le client choisit les suites de chiffrement.
- **ssl_session_cache** et **ssl_session_timeout** : Gère la mise en cache et la durée des sessions SSL.
- **ssl_stapling** et **ssl_stapling_verify** : Améliore la validation des certificats SSL via OCSP Stapling.

## Documentation

Pour plus de détails sur la configuration SSL/TLS avec Nginx, vous pouvez consulter les documents suivants :

- [Documentation Nginx SSL/TLS](https://nginx.org/en/docs/http/ngx_http_ssl_module.html)
- [Meilleures Pratiques de Configuration TLS](https://www.digitalocean.com/community/tutorials/ssl-configuration-best-practices)