#!/bin/bash

os_name=$(uname -s)

# Fonction pour afficher un message caractère par caractère
afficher_message() {
    local message="$1"
    local couleur="$2"

    for ((i = 0; i < ${#message}; i++)); do
        # Affiche le caractère avec la couleur
        echo -ne "\e[${couleur}m${message:i:1}\e[0m"
        sleep 0.1  # Délai entre chaque caractère
    done
    echo  # Sauter à la ligne après le message
}

# Fonction pour mélanger un tableau
melanger_tableau() {
    local array=("$@")
    local shuffled=()
    
    while [ ${#array[@]} -gt 0 ]; do
        # Choisir un index aléatoire
        index=$(( RANDOM % ${#array[@]} ))
        shuffled+=("${array[index]}")
        unset 'array[index]'
        array=("${array[@]}")  # Reconstituer le tableau sans l'index choisi
    done

    echo "${shuffled[@]}"
}

# Fonction pour afficher un mot avec chaque caractère dans une couleur différente
afficher_message_colore() {
    local message="$1"
    local couleurs=(31 32 33 34 35 36 37)  # Rouge, Vert, Jaune, Bleu, Magenta, Cyan, Blanc

    # Mélanger les couleurs
    couleurs=($(melanger_tableau "${couleurs[@]}"))

    for ((i = 0; i < ${#message}; i++)); do
        # Récupère la couleur correspondant à chaque caractère
        couleur=${couleurs[i % ${#couleurs[@]}]}
        # Affiche le caractère avec la couleur
        echo -ne "\e[${couleur}m${message:i:1}\e[0m"
        sleep 0.5  # Délai entre chaque caractère
    done
    echo  # Sauter à la ligne après le mot
}

# Messages à afficher
message1="Bienvenue"
message2="Vous êtes sur"
message3="LA VM DE YASSINE"
message4="OS : $os_name"
message5="Pour le projet"
lastword="INCEPTION !!!"

# Couleurs (code ANSI)
couleur1="32"  # Vert
couleur2="34"  # Bleu
couleur3="33"  # Jaune
couleur4="35"  # Magenta
couleur5="31"  # Rouge 

# Affichage des messages
afficher_message "$message1" "$couleur1"
sleep 0.3
afficher_message "$message2" "$couleur2"
sleep 0.3
afficher_message "$message3" "$couleur3"
sleep 0.3
afficher_message "$message4" "$couleur4"
sleep 0.3
afficher_message "$message5" "$couleur5"
sleep 0.3
# Affichage du mot "INCEPTION" avec chaque caractère dans une couleur différente
afficher_message_colore "$lastword"
echo ":D"