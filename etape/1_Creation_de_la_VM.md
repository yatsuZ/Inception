# 1 Creation de la VM

Premiere etape du projet crée la Machine Virtuel (VM).
danc ce fichier, il y aura

- [1 Creation de la VM](#1-creation-de-la-vm)<br>
			- [Notion à savoir](#notion-à-savoir)<br>
			- [Virtualisation](#virtualisation)<br>
			- [ISO et OS](#iso-et-os)<br>
	- [Quoi choisire](#quoi-choisire)
	- [Quelle Hyperviseur / Logiciel de virtualisation?](#quelle-hyperviseur--logiciel-de-virtualisation)
		- [Choix d'un OS](#choix-dun-os)
	- [Les différentes architectures](#les-différentes-architectures)
	- [Comment la crée VM?](#comment-la-crée-vm)


### Notion à savoir

#### Virtualisation

La [virtualisation](./../concepts/documentation.md#concepts-de-virtualisation) est la technologie qui permet de créer des environnements virtuels, comme des machines virtuelles (VM), sur du matériel physique. Cela permet d'exécuter plusieurs systèmes d'exploitation ou applications de manière isolée, tout en partageant les ressources physiques.

Le logiciel qui nous pemetre de faire le virtualisation sapelle un [Hyperviseur ou logiciels de virtualisation](./../concepts/documentation.md#hyperviseurs--logiciels-de-virtualisation)

- Voici un tableau des [logiciels de virtualisation / hyperviseur](./../concepts/documentation.md#hyperviseurs--logiciels-de-virtualisation) permettant de manipuler et créer des machines virtuelles (VM) :

| **Logiciel de virtualisation**              | **Description**                                                                 | **Plateforme**           | **Licence**         |
|---------------------------|---------------------------------------------------------------------------------|--------------------------|---------------------|
| [**VirtualBox**](https://www.virtualbox.org/)             | Open-source, permet de créer et gérer des VM sur divers systèmes d'exploitation. | Windows, macOS, Linux     | Gratuit, Open-source |
| [**VMware Workstation Player**](https://www.vmware.com/products/desktop-hypervisor/workstation-and-fusion) | Version gratuite de VMware pour exécuter des VM.                               | Windows, Linux            | Gratuit              |
| [**VMware Workstation Pro**](https://www.vmware.com/products/desktop-hypervisor/workstation-and-fusion) | Version payante avec des fonctionnalités avancées pour créer et gérer des VM.    | Windows, Linux            | Payant               |
| [**Hyper-V**](https://learn.microsoft.com/fr-fr/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v)                | Hyperviseur intégré à Windows pour créer et gérer des VM.                         | Windows Pro, Enterprise   | Gratuit (inclus avec Windows) |
| [**KVM (Kernel-based Virtual Machine)**](https://www.linux-kvm.org/page/Downloads) | Hyperviseur intégré au noyau Linux pour la virtualisation.             | Linux                     | Gratuit, Open-source |
| [**Proxmox VE**](https://www.proxmox.com/en/proxmox-virtual-environment/overview)             | Plateforme de virtualisation open-source pour VM et conteneurs.                  | Linux                     | Gratuit, Open-source |
| [**QEMU**](https://www.qemu.org/)                   | Émulateur et virtualiseur open-source pour plusieurs OS.                         | Windows, macOS, Linux     | Gratuit, Open-source |

#### ISO et OS

**C'est quoi un ISO ?**

Un **ISO** est un type de **fichier image** qui représente une copie exacte d'un disque optique (CD, DVD). Il contient toutes les données et la structure du disque original, y compris les fichiers de démarrage, les partitions et la disposition des fichiers. Les fichiers ISO sont souvent utilisés pour installer des systèmes d'exploitation (OS) sur des machines virtuelles ou physiques sans utiliser de support physique comme un CD ou un DVD. 

**C'est quoi un fichier image ?**

Un **fichier image** est une réplique numérique complète d'un support de stockage (comme un CD, DVD, ou disque dur), qui conserve non seulement les fichiers eux-mêmes, mais aussi la structure et les informations de démarrage. Les fichiers image sont utilisés pour créer des copies précises des disques et peuvent être montés ou gravés pour répliquer l'environnement du disque original.

**C'est quoi un OS ?**

Un **OS (Operating System)** ou système d'exploitation est le logiciel principal qui gère les ressources matérielles d'un ordinateur et fournit des services aux applications. Il est responsable de la gestion des fichiers, de l'exécution des programmes et de la communication avec le matériel. Les exemples les plus connus sont **Windows**, **Linux (Debian, Ubuntu)**, et **macOS**.


---

## Quoi choisire

## Quelle Hyperviseur / Logiciel de virtualisation?

VirtualBox est celui utilisé sur les PC de l'école. J'ai déjà travaillé dessus.

> Je choisi VirtualBox.

### Choix d'un OS

OSEF HAHAHA car le but de co projet nous aprend que peut importe l'os docker nous permetra d'utilise les services.
juste pour le projet installer un os avec une interface graphique.

---

Voici un exemple de texte pour compléter la section sur les différentes architectures :

---

## Les différentes architectures

Les systèmes d'exploitation peuvent être adaptés à différentes architectures de processeurs, chacune ayant ses propres caractéristiques et usages. Voici un aperçu des principales architectures :

| **Architecture** | **Description** | **Utilisation** | **Quand Choisir** |
|------------------|------------------|-----------------|--------------------|
| **aarch64 (ARM 64-bit)** | Architecture ARM 64 bits, aussi connue sous le nom ARMv8-A. Offre de meilleures performances et une plus grande capacité de mémoire par rapport aux versions 32 bits. | Utilisée dans des serveurs ARM modernes, des smartphones récents, et des dispositifs IoT (Internet des Objets). | Choisir pour des serveurs ARM modernes, des projets IoT récents, ou des systèmes nécessitant une performance élevée et une faible consommation d'énergie. |
| **armv7 (ARM 32-bit)** | Architecture ARM 32 bits, plus ancienne que aarch64. Moins puissante mais encore largement utilisée. | Présente dans des appareils plus anciens comme certains smartphones, tablettes, et dispositifs embarqués. | Choisir pour des dispositifs plus anciens ou des applications moins gourmandes en ressources. |
| **x86 (Intel 32-bit)** | Architecture 32 bits développée par Intel. Moins performante et avec une capacité de gestion de mémoire limitée par rapport aux architectures 64 bits. | Utilisée dans des ordinateurs plus anciens et certains serveurs. | Choisir pour des systèmes plus anciens qui ne supportent pas les architectures 64 bits, ou pour des raisons de compatibilité avec du matériel ou des logiciels anciens. |
| **x86_64 (Intel 64-bit)** | Architecture 64 bits, également connue sous le nom AMD64, développée par AMD et adoptée par Intel. Offre des performances supérieures et une meilleure gestion de la mémoire. | Dominante pour les ordinateurs personnels modernes, serveurs, et machines virtuelles. | Choisir pour des systèmes modernes, des serveurs, ou des machines virtuelles pour des performances optimales et une compatibilité avec les systèmes d'exploitation et applications contemporains. |

---

## Comment la crée VM?

Franchement debrouiller vous sinon voici une demo :

### Instalation pour alpine sur virtualbox :

1. Avoir l'iso d'alpine, [lien](https://alpinelinux.org/downloads/) des differents iso d'alpine :
J'ai choisi x86_64.
![different architecture d'iso](./../ilustration/different_iso.png)

[Video de demonstration](https://youtu.be/X7R5oBTb-Tg?si=Z48xGkNkVboBPeya)
documentation d'alpine : https://wiki.alpinelinux.org/wiki/Main_Page

et suivre ve [tuto](https://www.linuxtricks.fr/wiki/alpine-linux-installer-un-environnement-de-bureau-xfce#:~:text=xf86%2Dinput%2Dlibinput-,Installer%20Xfce,-Il%20existe%20une) pour 'installation d'une interface graphique.

Suivre la video de demonstration mais sinon apres aavoir installer se connecter en temp que root et faire setup-alpine puis faire les setup d'instalation.

FIn de linstallation.