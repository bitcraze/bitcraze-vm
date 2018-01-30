#!/bin/bash -x
sh -c 'echo deb http://luke.campagnola.me/debian dev/ > /etc/apt/sources.list.d/pyqtgraph.list'
# Add KiCad stable PPA
add-apt-repository --yes ppa:js-reynaud/kicad-4

# Update keys and repos
apt-key update
apt-get update

#apt-get -y upgrade
apt-get -y install build-essential git gitg sdcc python2.7 python-pip python-usb python-qt4 python3-pyqt5 python3-numpy qt4-designer kicad libsdl2-dev openjdk-7-jdk meld leafpad dfu-util || { echo 'apt-get install failed' ; exit 1; }
#apt-get python-pyqtgraph	#The following packages cannot be authenticated!
pip -y install pysdl2

# Works only on Ubuntu 15.04+
apt-get -y install python3 python3-usb python3-pyqt4 python3-pyqtgraph python3-zmq

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

if [ $ENABLE_ROS -eq 1 ]; then
  # Install ROS
  echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list
  apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net --recv-key 0xB01FA116
  apt-get update
  apt-get -y install ros-indigo-desktop-full libusb-1.0-0-dev
  rosdep init
  rosdep update
  echo "source /opt/ros/indigo/setup.bash" >> ~/.bashrc
fi

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

if [ $ENABLE_ROS -eq 1 ]; then
  # Create a ROS workspace with the Loco Positioning projects
  mkdir -p ~/catkin_ws/src
  cd ~/catkin_ws/src
  catkin_init_workspace
  git clone git://github.com/bitcraze/lps-ros.git
  git clone git://github.com/whoenig/crazyflie_ros
  cd ~/catkin_ws
  catkin_make
  cd ~/
  chown bitcraze:bitcraze -R ~/catkin_ws
  chown -R bitcraze:bitcraze ~/.ros
  ln -s ~/catkin_ws ~/Desktop/catkin_ws
  echo 'echo -e "Setting up \e[1m\e[32m~/catkin_ws\e[0m ROS workspace."' >> ~/.bashrc
  echo 'source $HOME/catkin_ws/devel/setup.sh' >> ~/.bashrc
fi

# Setup gcc-arm-none-eabi toolchain
tar --strip-components=1 -xjf gcc-arm-none-eabi-*.tar.bz2
mkdir -p ~/bin/gcc-arm-none-eabi
mv gcc-arm-none-eabi-*/ ~/bin/gcc-arm-none-eabi
echo "\nPATH=\$PATH:$HOME/bin/gcc-arm-none-eabi/bin" >> ~/.profile
rm gcc-arm-none-eabi-*.tar.bz2

# Extract Eclipse
tar xf eclipse-cpp-mars-1-linux-gtk.tar.gz -C /opt
echo "\nPATH=\$PATH:/opt/eclipse" >> ~/.profile
rm eclipse-cpp-mars-1-linux-gtk.tar.gz

# Extract OpenOCD and copy udev rules
mkdir -p /opt/gnuarmeclipse
tar xf gnuarmeclipse-openocd-debian32-0.9.0-201505190955.tgz -C /opt/gnuarmeclipse
echo "\nPATH=\$PATH:/opt/gnuarmeclipse/openocd/0.9.0-201505190955/bin" >> ~/.profile
rm gnuarmeclipse-openocd-debian32-0.9.0-201505190955.tgz
cp /opt/gnuarmeclipse/openocd/0.9.0-201505190955/contrib/99-openocd.rules /etc/udev/rules.d/

# Link scripts from openocd to config directory
ln -s /opt/gnuarmeclipse/openocd/0.9.0-201505190955/scripts ~/.openocd

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
