#!/bin/bash -x
sh -c 'echo deb http://luke.campagnola.me/debian dev/ > /etc/apt/sources.list.d/pyqtgraph.list'
# Add KiCad stable PPA
add-apt-repository --yes ppa:js-reynaud/kicad-4

# Update keys and repos
apt-key update
apt-get update

#apt-get -y upgrade
apt-get -y install build-essential git gitg sdcc python2.7 python-pip python-usb python-qt4 qt4-designer kicad libsdl2-dev openocd openjdk-7-jdk meld leafpad dfu-util || { echo 'apt-get install failed' ; exit 1; }
#apt-get python-pyqtgraph	#The following packages cannot be authenticated!
pip install pysdl2

# Works only on Ubuntu 15.04+
#apt-get -y install python3 python3-usb python3-pyqt4 python3-pyqtgraph python3-zmq

# Necessary on Ubuntu 14.04
apt-get -y install python3 python3-pip python3-pyqt4 python3-zmq || { echo 'apt-get install failed' ; exit 1; }
pip3 install pyusb==1.0.0b2
pip3 install pyqtgraph

# Installing VirtualBox GuestAdditions
VBOX_ISO=VBoxGuestAdditions.iso
mkdir /tmp/isomount
mount -o loop ~/$VBOX_ISO /tmp/isomount
sh /tmp/isomount/VBoxLinuxAdditions.run
umount /tmp/isomount
rm -rf isomount ~/$VBOX_ISO

# Install ROS
echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list
apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net --recv-key 0xB01FA116
apt-get update
apt-get install ros-indigo-desktop-full
rosdep init
rosdep update
echo "source /opt/ros/indigo/setup.bash" >> ~/.bashrc

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
cd ..
chown bitcraze:bitcraze -R projects
ln -s ~/projects ~/Desktop/projects

# Create a ROS workspace with the Loco Positioning projects
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws/src
catkin_init_workspace
git clone git://github.com/bitcraze/lps-ros.git
git clone git://github.com/whoenig/crazyflie_ros
catkin_make
cd ../..
chown bitcraze:bitcraze -R catkin_ws
ln -s ~/catkin_ws ~/Desktop/catkin_ws

# Setup gcc-arm-none-eabi toolchain
tar xjf gcc-arm-none-eabi-*.tar.bz2
mkdir -p ~/bin/gcc-arm-none-eabi
mv gcc-arm-none-eabi-*/ ~/bin/gcc-arm-none-eabi
echo "\nPATH=\$PATH:$HOME/bin/gcc-arm-none-eabi/bin" >> ~/.bashrc
rm gcc-arm-none-eabi-*.tar.bz2

# Extract PyCharm
tar -xf pycharm-community-*.tar.gz -C /opt/
mv /opt/pycharm-community-* /opt/pycharm-community
echo "\nPATH=\$PATH:/opt/pycharm-community/bin" >> ~/.bashrc
rm pycharm-community-*.tar.gz

# Extract Eclipse
tar -xf eclipse-cpp-*.tar.gz -C /opt
echo "\nPATH=\$PATH:/opt/eclipse" >> ~/.bashrc
rm eclipse-cpp-*.tar.gz

# Setup update_all_projects script
chmod +x ~/update_all_projects.sh
mv ~/update_all_projects.sh ~/bin/update_all_projects.sh

# Set up crazyflie-clients-python to use crazyflie-lib-python from source
pip3 install -e ~/projects/crazyflie-lib-python

# Set background image
#DISPLAY=:0 xfconf-query --channel xfce4-desktop --list
#DISPLAY=:0 xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitor0/image-path --set ~/Pictures/vm_background.jpg
#DISPLAY=:0 xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitor0/workspace0/last-image --set ~/Pictures/vm_background.jpg
#HACK
cp /usr/share/xfce4/backdrops/xubuntu-wallpaper.png /usr/share/xfce4/backdrops/xubuntu-wallpaper-old.png
cp ~/Pictures/vm_background.png /usr/share/xfce4/backdrops/xubuntu-wallpaper.png

# Clean up VM
apt-get autoremove
apt-get autoclean
apt-get clean
fstrim -v /
