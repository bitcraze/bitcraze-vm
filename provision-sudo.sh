#!/bin/bash -x

# Remove unused packages to keep the size down
apt remove  \
thunderbird \
transmission-gtk \
gnome-todo \
baobab \
rhythmbox \
cheese \
vino \
shotwell \
totem \
usb-creator-gtk \
deja-dup \
gnome-calendar \
remmina \
simple-scan \
thunderbird-gnome-support \
aisleriot \
gnome-mahjongg \
gnome-mines \
gnome-sudoku \
branding-ubuntu \
libreoffice-style-breeze \
libreoffice-gnome \
libreoffice-writer \
libreoffice-calc \
libreoffice-impress \
libreoffice-math \
libreoffice-ogltrans \
libreoffice-pdfimport \
example-content \
libreoffice-l10n-en-gb \
libreoffice-l10n-es \
libreoffice-l10n-zh-cn \
libreoffice-l10n-zh-tw \
libreoffice-l10n-pt \
libreoffice-l10n-pt-br \
libreoffice-l10n-de \
libreoffice-l10n-fr \
libreoffice-l10n-it \
libreoffice-l10n-ru \
libreoffice-l10n-en-za \
libreoffice-help-en-gb \
libreoffice-help-es \
libreoffice-help-zh-cn \
libreoffice-help-zh-tw \
libreoffice-help-pt \
libreoffice-help-pt-br \
libreoffice-help-de \
libreoffice-help-fr \
libreoffice-help-it \
libreoffice-help-ru \
libreoffice-help-en-us \
thunderbird-locale-en \
thunderbird-locale-en-gb \
thunderbird-locale-en-us \
thunderbird-locale-es \
thunderbird-locale-es-ar \
thunderbird-locale-es-es \
thunderbird-locale-zh-cn \
thunderbird-locale-zh-hans \
thunderbird-locale-zh-hant \
thunderbird-locale-zh-tw \
thunderbird-locale-pt \
thunderbird-locale-pt-br \
thunderbird-locale-pt-pt \
thunderbird-locale-de \
thunderbird-locale-fr \
thunderbird-locale-it \
thunderbird-locale-ru \
gir1.2-rb-3.0 \
gir1.2-totem-1.0 \
gir1.2-totemplparser-1.0 \
libabw-0.1-1 \
libavahi-ui-gtk3-0 \
libdmapsharing-3.0-2 \
libexttextcat-2.0-0 \
libexttextcat-data \
libfreehand-0.1-1 \
libgnome-games-support-1-3 \
libgnome-games-support-common \
libgom-1.0-0 \
libgrilo-0.3-0 \
liblangtag-common \
liblangtag1 \
libmessaging-menu0 \
libmhash2 \
libminiupnpc10 \
libmwaw-0.3-3 \
libmythes-1.2-0 \
libnatpmp1 \
libneon27-gnutls \
libpagemaker-0.0-0 \
librdf0 \
libreoffice-avmedia-backend-gstreamer \
libreoffice-base-core \
libreoffice-common \
libreoffice-core \
libreoffice-draw \
libreoffice-gtk3 \
libreoffice-style-elementary \
libreoffice-style-galaxy \
libreoffice-style-tango \
libraptor2-0 \
librasqal3 \
librevenge-0.0-0 \
librhythmbox-core10 \
libtotem0 \
libvisio-0.1-1 \
libwpd-0.10-10 \
libwpg-0.3-3 \
libwps-0.4-4 \
libyajl2 \
python3-uno \
rhythmbox-data \
rhythmbox-plugin-alternative-toolbar \
rhythmbox-plugins \
remmina-common \
remmina-plugin-rdp \
remmina-plugin-secret \
remmina-plugin-vnc \
duplicity \
seahorse-daemon \
shotwell-common \
totem-common \
totem-plugins \
transmission-common \
cheese-common \
gnome-todo-common \
libgnome-todo \
gnome-video-effects \
libcheese-gtk25 \
libcheese8 \
uno-libs3 \
ure \
zeitgeist-core \
hunspell-de-at-frami \
hunspell-de-ch-frami \
hunspell-de-de-frami \
hunspell-en-au \
hunspell-en-ca \
hunspell-en-gb \
hunspell-en-za \
hunspell-es \
hunspell-fr \
hunspell-fr-classical \
hunspell-it \
hunspell-pt-br \
hunspell-pt-pt \
hunspell-ru \
hyphen-de \
hyphen-en-ca \
hyphen-en-gb \
hyphen-en-us \
hyphen-fr \
hyphen-hr \
hyphen-it \
hyphen-pl \
hyphen-pt-br \
hyphen-pt-pt \
hyphen-ru \
mythes-de \
mythes-de-ch \
mythes-en-au \
mythes-en-us \
mythes-fr \
mythes-it \
mythes-pt-pt \
mythes-ru


# Installing VirtualBox GuestAdditions
VBOX_ISO=VBoxGuestAdditions.iso
mkdir /tmp/isomount
mount -o loop ~/$VBOX_ISO /tmp/isomount
sh /tmp/isomount/VBoxLinuxAdditions.run
umount /tmp/isomount
rm -rf isomount ~/$VBOX_ISO

# Update keys and repos
apt-key update
apt-get update

Install packages
apt-get -y install build-essential git sdcc python3-dev python3-pip qtcreator \
                   dfu-util openocd gcc-arm-none-eabi gdb-multiarch docker.io || { echo 'apt-get install failed' ; exit 1; }

snap install firefox

# Required for the VSCode embedded debug to work
ln -s /usr/bin/gdb-multiarch /usr/local/bin/arm-none-eabi-gdb

# Adding udev rules for Crazyradio and Crazyflie
usermod -a -G plugdev bitcraze
sh -c 'echo SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"1915\", ATTRS{idProduct}==\"7777\", MODE=\"0664\", GROUP=\"plugdev\" > /etc/udev/rules.d/99-crazyradio.rules'
sh -c 'echo SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"1915\", ATTRS{idProduct}==\"0101\", MODE=\"0664\", GROUP=\"plugdev\" >> /etc/udev/rules.d/99-crazyradio.rules'
sh -c 'echo SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"0483\", ATTRS{idProduct}==\"5740\", MODE=\"0664\", GROUP=\"plugdev\" >> /etc/udev/rules.d/99-crazyflie.rules'

# Add user to dialout group, to give access to serial ports
usermod -a -G dialout bitcraze

# Add user to docker group
usermod -a -G docker bitcraze

# Clone the git repos
mkdir ~/projects
cd ~/projects
git clone https://github.com/bitcraze/crazyflie-clients-python.git
git clone https://github.com/bitcraze/crazyflie-lib-python.git
git clone https://github.com/bitcraze/crazyflie-firmware.git --recursive
git clone https://github.com/bitcraze/crazyflie-bootloader.git
git clone https://github.com/bitcraze/crazyradio-firmware.git
git clone https://github.com/bitcraze/crazyflie-android-client.git
git clone https://github.com/bitcraze/crazyflie2-exp-template-electronics.git
git clone https://github.com/bitcraze/crazyflie2-stm-bootloader.git
git clone https://github.com/bitcraze/crazyflie2-nrf-bootloader.git
git clone https://github.com/bitcraze/crazyflie2-nrf-firmware.git
git clone https://github.com/bitcraze/lps-node-firmware.git --recursive
cd ~/
chown bitcraze:bitcraze -R projects
ln -s ~/projects ~/Desktop/projects

# Install VSCode
snap install --classic code

# Install VSCode extensions
sudo -H -u bitcraze code --install-exteman nsion ms-python.python
sudo -H -u bitcraze code --install-extension ms-python.vscode-pylance
sudo -H -u bitcraze code --install-extension ms-vscode.cpptools
sudo -H -u bitcraze code --install-extension seanwu.vscode-qt-for-python
sudo -H -u bitcraze code --install-extension marus25.cortex-debug

# Add user to vboxsf group so shares with host can be used
usermod -a -G vboxsf bitcraze

# Set up crazyflie-clients-python to use crazyflie-lib-python from source
sudo -H -u bitcraze bash -c 'pip3 install --user -e ~/projects/crazyflie-lib-python'
sudo -H -u bitcraze bash -c 'pip3 install --user -e ~/projects/crazyflie-clients-python'

# Clean up VM to minimize image size
apt-get -y autoremove
apt-get -y autoclean
apt-get -y clean
e4defrag /
fstrim -v /
