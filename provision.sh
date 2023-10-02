#!/bin/bash -x

# This script must not run as root since this will not change the settings for the "bitcraze" user

# Set background image
gsettings set org.gnome.desktop.background picture-uri "file:///home/bitcraze/Pictures/vm_background.jpg"

# Disable screen saver
gsettings set org.gnome.desktop.screensaver lock-enabled false

# Disable welcome screen
systemctl --user --now mask gnome-initial-setup-first-login.service

# Allow launching of all shortcuts on the Desktop
find Desktop/ -type f -exec gio set {} metadata::trusted true \;
find Desktop/ -type f -exec chmod +x {} \;

# Make executable
chmod +x ~/update_all_projects.sh
