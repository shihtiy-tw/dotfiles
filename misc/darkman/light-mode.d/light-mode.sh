#!/usr/bin/env bash

# Change the global Plasma Theme. On Manjaro you can use "org.manjaro.breath-light.desktop"
# or you can create your own global Plasma Theme with the "Plasma Look And Feel Explorer".
# Reference: https://userbase.kde.org/Plasma/Create_a_Global_Theme_Package
#
# Since Plasma 5.26 the lookandfeeltool does not work anymore without "faking" the screen.
# Reference: https://bugs.kde.org/show_bug.cgi?id=460643

lookandfeeltool -platform offscreen --apply "org.kde.breeze.desktop"

WALLPAPER_PATH="/home/$USER/.local/share/wallpapers/Nothing2/contents/images/2337x1080.png"

qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript 'var allDesktops = desktops();print (allDesktops);for (i=0;i<allDesktops.length;i++) {d = allDesktops[i];d.wallpaperPlugin = "org.kde.image";d.currentConfigGroup = Array("Wallpaper", "org.kde.image", "General");d.writeConfig("Image", "file://'"$WALLPAPER_PATH"'")}'


~/dotfiles/tmux/themes/switch-theme.sh light
