# 1.5 Utilisation de SSH

- [1.5 Utilisation de SSH](#15-utilisation-de-ssh)
  - [Intro](#intro)
  - [Qu'est-ce que SSH](#quest-ce-que-ssh)
    - [Objectif](#objectif)
  - [Comment faire](#comment-faire)
    - [1. Installer SSH](#1-installer-ssh)
      - [Alpine](#alpine)
      - [Debian](#debian)
    - [2. Configurer SSH](#2-configurer-ssh)
      - [Activer SSH au démarrage pour Alpine](#activer-ssh-au-démarrage-pour-alpine)
    - [3. Autoriser la connexion root (optionnel)](#3-autoriser-la-connexion-root-optionnel)
      - [Debian](#debian-1)
      - [Alpine](#alpine-1)
    - [4. Configurer VirtualBox](#4-configurer-virtualbox)
    - [5. Vérification de la connexion](#5-vérification-de-la-connexion)
      - [Avec la redirection de port :](#avec-la-redirection-de-port-)
      - [Avec l'adresse IP de la VM :](#avec-ladresse-ip-de-la-vm-)
    - [Conclusion](#conclusion)

---

## Intro

> **Optionnelle**, mais très utile : SSH permet de manipuler votre VM depuis votre PC hôte en ligne de commande.  
> Cela simplifie l'administration et améliore la productivité par rapport à l'utilisation directe de l'interface de la VM.

Cette étape suit la [création de la VM](./1_Creation_de_la_VM.md). Elle documente l'installation et la configuration de SSH pour accéder à la VM, en mettant l'accent sur les systèmes Linux. Une solution pour Windows n'est pas abordée ici, mais des outils comme [PuTTY](https://www.putty.org/) peuvent être envisagés.

---

## Qu'est-ce que SSH

SSH (Secure Shell) est un protocole cryptographique qui permet de se connecter à une machine distante de manière sécurisée. Il est principalement utilisé pour l'administration des serveurs et des machines virtuelles via une interface en ligne de commande.

### Objectif

Configurer une connexion SSH depuis votre terminal hôte vers la VM pour :
- Accéder facilement à la VM.
- Administrer la machine sans interface graphique.

---

## Comment faire

### 1. Installer SSH

#### Alpine

Pour installer le serveur SSH sur Alpine Linux :

```sh
apk update
apk add openssh
```

Vérifiez que SSH est bien installé avec la commande suivante :

```sh
ssh -V
```

#### Debian

Pour installer OpenSSH sur Debian :

```bash
sudo apt update && sudo apt upgrade
sudo apt install openssh-server
```

Vérifiez le statut du service SSH avec :

```bash
sudo systemctl status ssh
```

---

### 2. Configurer SSH

#### Activer SSH au démarrage pour Alpine

1. Ajoutez le service SSH au démarrage :
   ```sh
   rc-update add sshd
   ```
2. Démarrez immédiatement le service :
   ```sh
   service sshd start
   ```
3. Vérifiez que le service SSH est activé :
   ```sh
   rc-status | grep sshd
   ```

---

### 3. Autoriser la connexion root (optionnel)

> **Attention :** L'activation de la connexion root via SSH peut représenter un risque de sécurité. À utiliser uniquement si nécessaire.

#### Debian

1. Modifiez le fichier de configuration SSH :
   ```bash
   sudo nano /etc/ssh/sshd_config
   ```
2. Trouvez et remplacez la ligne suivante :
   ```bash
   #PermitRootLogin prohibit-password
   ```
   et
   ```bash
   #Port 22
   ```
   Par :
   ```bash
   PermitRootLogin yes
   ```
   et (le port que vous shouaitez)
   ```bash
   Port 4242
   ```

3. Redémarrez le service SSH :
   ```bash
   sudo systemctl restart ssh
   ```

#### Alpine

1. Éditez le fichier de configuration SSH :
   ```sh
   vi /etc/ssh/sshd_config
   ```
2. Appliquez les mêmes modifications que pour Debian :
   ```sh
   PermitRootLogin yes
   ```
   et (le port que vous shouaitez)
   ```bash
   Port 4242
   ```
3. Redémarrez le service SSH :
   ```sh
   service sshd restart
   ```

---

### 4. Configurer VirtualBox

Configurez la redirection de port pour permettre la connexion SSH entre votre PC hôte et la VM :

1. **VirtualBox > Paramètres > Réseau > Adaptateur 1 > Avancé > Redirection de ports**.
2. Ajoutez une règle avec les paramètres suivants :
   - **Host port** : `4244`
   - **Guest port** : `4242`
3. Validez les modifications.

![rule_host_guest_port](./../ilustration/rule_host_guest_port.png)

---

### 5. Vérification de la connexion

Testez la connexion SSH depuis votre terminal hôte :

#### Avec la redirection de port :
```sh
ssh root@localhost -p 4244
```

#### Avec l'adresse IP de la VM :
```sh
ssh root@<ip_de_la_vm> -p 4242
```

---

### Conclusion

Vous avez maintenant configuré et testé SSH sur votre VM. Grâce à SSH, vous pouvez administrer la machine à distance de manière plus efficace, sans avoir besoin de son interface graphique.

![ssh_succes](./../ilustration/ssh_succes.png)

