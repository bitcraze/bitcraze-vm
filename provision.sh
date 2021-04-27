#!/bin/bash -x
# Add KiCad stable PPA
sudo add-apt-repository --yes ppa:kicad/kicad-5.1-releases

# Update keys and repos
apt-key update
apt-get update

# Install packages
apt-get -y install build-essential git sdcc firefox python3-dev python3-pip qtcreator kicad \
                   dfu-util openocd gcc-arm-none-eabi gdb-multiarch || { echo 'apt-get install failed' ; exit 1; }

# Required for the VSCode embedded debug to work
ln -s /usr/bin/gdb-multiarch /usr/local/bin/arm-none-eabi-gdb

# Installing VirtualBox GuestAdditions
VBOX_ISO=VBoxGuestAdditions.iso
mkdir /tmp/isomount
mount -o loop ~/$VBOX_ISO /tmp/isomount
sh /tmp/isomount/VBoxLinuxAdditions.run
umount /tmp/isomount
rm -rf isomount ~/$VBOX_ISO

# Adding udev rules for Crazyradio and Crazyflie
usermod -a -G plugdev $USER
sh -c 'echo SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"1915\", ATTRS{idProduct}==\"7777\", MODE=\"0664\", GROUP=\"plugdev\" > /etc/udev/rules.d/99-crazyradio.rules'
sh -c 'echo SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"1915\", ATTRS{idProduct}==\"0101\", MODE=\"0664\", GROUP=\"plugdev\" >> /etc/udev/rules.d/99-crazyradio.rules'
sh -c 'echo SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"0483\", ATTRS{idProduct}==\"5740\", MODE=\"0664\", GROUP=\"plugdev\" >> /etc/udev/rules.d/99-crazyflie.rules'

# Add user to dialout group, to give access to serial ports
usermod -a -G dialout $USER

# Clone the git repos
mkdir ~/projects
cd ~/projects
git clone git://github.com/bitcraze/crazyflie-clients-python.git
git clone git://github.com/bitcraze/crazyflie-lib-python.git
git clone git://github.com/bitcraze/crazyflie-firmware.git --recursive
git clone git://github.com/bitcraze/crazyflie-bootloader.git
git clone git://github.com/bitcraze/crazyradio-firmware.git
git clone git://github.com/bitcraze/crazyflie-android-client.git
git clone git://github.com/bitcraze/crazyflie2-exp-template-electronics.git
git clone git://github.com/bitcraze/crazyflie2-stm-bootloader.git
git clone git://github.com/bitcraze/crazyflie2-nrf-bootloader.git
git clone git://github.com/bitcraze/crazyflie2-nrf-firmware.git
git clone git://github.com/bitcraze/lps-node-firmware.git --recursive
cd ~/
chown bitcraze:bitcraze -R projects
ln -s ~/projects ~/Desktop/projects

# Install VSCode
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

apt install apt-transport-https
apt update
apt install code # or code-insiders

# Install VSCode extensions
sudo -H -u bitcraze code --install-exteman nsion ms-python.python
sudo -H -u bitcraze code --install-extension ms-python.vscode-pylance
sudo -H -u bitcraze code --install-extension ms-vscode.cpptools
sudo -H -u bitcraze code --install-extension seanwu.vscode-qt-for-python
sudo -H -u bitcraze code --install-extension marus25.cortex-debug

# Setup update_all_projects script
chmod +x ~/update_all_projects.sh
mv ~/update_all_projects.sh ~/bin/update_all_projects.sh

# Set background image
#DISPLAY=:0 xfconf-query --channel xfce4-desktop --list
#DISPLAY=:0 xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitor0/image-path --set ~/Pictures/vm_background.jpg
#DISPLAY=:0 xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitor0/workspace0/last-image --set ~/Pictures/vm_background.jpg
#HACK
cp /usr/share/xfce4/backdrops/xubuntu-wallpaper.png /usr/share/xfce4/backdrops/xubuntu-wallpaper-old.png
cp ~/Pictures/vm_background.png /usr/share/xfce4/backdrops/xubuntu-wallpaper.png

# Add user to vboxsf group so shares with host can be used
usermod -a -G vboxsf $USER

# Set up crazyflie-clients-python to use crazyflie-lib-python from source
sudo -H -u bitcraze bash -c 'pip3 install --user -e ~/projects/crazyflie-lib-python'
sudo -H -u bitcraze bash -c 'pip3 install --user -e ~/projects/crazyflie-clients-python'

# Disable screen saver (workaround)
mv /etc/xdg/autostart/light-locker.desktop /etc/xdg/autostart/light-locker.desktop.old

# Clean up VM
apt-get -y autoremove
apt-get -y autoclean
apt-get -y clean
fstrim -v /
