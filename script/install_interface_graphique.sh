#!/bin/bash
apk update
apk upgrade
apk add musl-locales
setup-xorg-base
apk add xf86-video-qxl
apk add xf86-input-libinput
apk add xfce4 xfce4-terminal
apk add adw-gtk3 adwaita-icon-theme adwaita-xfce-icon-theme
apk add xfce4-screensaver
apk add gvfs udisks2
apk add gvfs-fuse
apk add lightdm-gtk-greeter
rc-update add lightdm
rc-update add dbus
setup-devd udev
apk add elogind polkit-elogind
rc-update add elogind
apk add pulseaudio pavucontrol alsa-utils
rc-update add alsa
apk add xfce4-pulseaudio-plugin
apk add lang
echo "LANG=fr_FR.UTF-8
LC_CTYPE=fr_FR.UTF-8
LC_NUMERIC=fr_FR.UTF-8
LC_TIME=fr_FR.UTF-8
LC_COLLATE=fr_FR.UTF-8
LC_MONETARY=fr_FR.UTF-8
LC_MESSAGES=fr_FR.UTF-8
LC_ALL=" > /etc/profile.d/99-fr.sh
mkdir /etc/X11/xorg.conf.d
echo "Section \"InputClass\"
    Identifier \"keyboard\"
    Option \"XkbLayout\" \"fr\"
    Option \"XkbVariant\" \"oss\"
    Option \"XkbOptions\" \"compose:menu\"
    MatchIsKeyboard \"on\"
EndSection" > /etc/X11/xorg.conf.d/99-keyboard.conf