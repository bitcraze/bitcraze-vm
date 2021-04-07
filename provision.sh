#!/bin/bash -x
# Add KiCad stable PPA
add-apt-repository --yes ppa:js-reynaud/kicad-5

# Update keys and repos
apt-key update
apt-get update

# Install packages
apt-get -y install build-essential git gitg sdcc firefox python3-dev python3-pip python3-zmq python3-usb\
                   python3-pyqt5 python3-pyqt5.qtsvg python3-numpy qtcreator kicad libsdl2-dev openjdk-11-jdk\
                   meld dfu-util openocd gcc-arm-none-eabi || { echo 'apt-get install failed' ; exit 1; }

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

# Extract Eclipse
tar xf eclipse-cpp-2018-09-linux-gtk-x86_64.tar.gz -C /opt
echo "\nPATH=\$PATH:/opt/eclipse" >> ~/.profile
rm eclipse-cpp-2018-09-linux-gtk-x86_64.tar.gz

#Extract eclipse project folders
tar xf eclipse-project-files.tar.gz -C ~/
rm eclipse-project-files.tar.gz

#Install GNU ARM Eclipse plugin
/opt/eclipse/eclipse -clean -consolelog -nosplash -application org.eclipse.equinox.p2.director -repository http://download.eclipse.org/releases/mars,http://gnuarmeclipse.sourceforge.net/updates -installIU ilg.gnuarmeclipse.debug.gdbjtag.openocd,ilg.gnuarmeclipse.debug.gdbjtag.jlink,ilg.gnuarmeclipse.debug.gdbjtag.qemu -tag AddGnuArm -destination /opt/eclipse/ -profile epp.package.cpp
chown bitcraze:bitcraze -R .eclipse

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

# Workaround for autosave error in Eclipse
mkdir -p ~/workspace/.metadata/.plugins/org.eclipse.core.resources/.projects/RemoteSystemsTempFiles/
touch ~/workspace/.metadata/.plugins/org.eclipse.core.resources/.projects/RemoteSystemsTempFiles/.markers
chown bitcraze:bitcraze -R ~/workspace

# Clean up VM
apt-get -y autoremove
apt-get -y autoclean
apt-get -y clean
fstrim -v /
