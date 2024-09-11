#!/bin/sh

# Mise a jour des paquets
apk update

# Installation du paquet de docker
apk add docker

# Demmarage de docker + activation

service docker start
rc-update add docker

# Version de ocker installer

docker --version

