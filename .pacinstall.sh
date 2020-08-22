#!/bin/sh
#######################################
# Bash script to install packages  on a new system (Manjaro/Arch Linux)
# Written by Chuu
#######################################


PACKAGELIST="
chromium
curl
bleachbit
discord
gcc
git
htop
latte-dock
nano
neofetch
python-pip
sudo
vlc
vscode
wget
youtube-dl"

## Initial Update of packages and system Upgrade
sudo pacman -Syyyu
sudo pacman -S $PACKAGELIST

# Git Configuration
echo "Enter the Global Username for Git:";
read GITUSER;
git config --global user.name "${GITUSER}"
echo "Enter the Global Email for Git:";
read GITEMAIL;
git config --global user.email "${GITEMAIL}"

echo 'Git has been configured!'
git config --list

#Post install and repo cloning
mkdir ~/GitHub && cd GitHub
git clone https://github.com/zzag/kwin-effects-yet-another-magic-lamp.git
