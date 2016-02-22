Welcome to the Bitcraze VM Version 0.9
======================================

The purpose of this virtual machine is to quickly get started with development
and usage of various Bitcraze projects. It has all of the requirements for
running and developing pre-installed as well as some other useful tools.

NOTE: This file contains instructions on how to do some common tasks. These may
change over time so please have a look at http://wiki.bitcraze.se for up-to-date
instructions.

The virtual machine
-------------------

 * The username is: bitcraze
 * The password is: crazyflie
 * The virtual machine has 30GB drive and 1 GB of RAM
 * The virtual machine is using Xubuntu 14.04.4 LTS

Installed software
------------------
The following software has been pre-installed (besides basic setup)
 * Virtualbox guest additions
 * gnu-arm-none-eabi and build tools
 * Git
 * gitg
 * PyCharm
 * Oracle Java JRE (for PyCharm)
 * pyusb, pygame and pyqt
 * PyQtGraph
 * Qt4 and Qt Designer
 * KDE Marble with Python-bindings
 * KiCad
 * Eclipse with compiling/debugging/flashing
 * Leafpad
 * EmbSys RegView for Eclipse
 * dfu-util

System tweaks
-------------
The udev rules to access the Crazyradio and the NRF bootloader have been added
to the udev configuration. They have also been added to the Virtual Box pre-set
filters.

Projects
--------
The following projects have been pre-cloned into the /home/bitcraze/projects 
directory:
 * crazyflie-pc-client
 * crazyflie-firmware
 * crazyflie-bootloader
 * crazyradio-firmware
 * crazyradio-electronics
 * crazyflie2-nrf-firmware
 * crazyflie2-stm-firmware
 * crazyflie2-stm-bootloader

How to run the Crazyflie PC client
----------------------------------
The Crazyflie PC client can be run by using the following command:

python3 /home/bitcraze/projects/crazyflie-pc-client/bin/cfclient

Or by using the shortcut on the desktop.

PLEASE NOTE!! If no other input device is passed to the VM the
"VirtualBox USB Tablet" device will be used. Do not connect to the Crazyflie
using this device, since the thrust will then be controlled by the mouse
movements on the screen.

How to update to the latest versions of the repositories
--------------------------------------------------------
Updating to the latest versions of all the repositories can be done
by using the following command:

/home/bitcraze/bin/update_all_projects.sh

Or using the shortcut on the desktop.

How to update the Crazyradio firmware
-------------------------------------
Download the latest firmware and run the following commands:

cd /home/bitcraze/projects/crazyradio-firmware
python usbtools/launchBootloader.py 

If you have not activated the USB filter for the NRF bootloader, pass the newly
found "NRF BOOT" USB device to the virtual machine and then run the following
command:

python usbtools/nrfbootload.py flash new_firmware_file.bin

How to build the Crazyflie firmware
-----------------------------------
A version of the Crazyflie firmware that is upgradable using the Crazyradio
bootloader can be built using the following commands:

cd /home/bitcraze/projects/crazyflie-firmware
make CLOAD=1 DEBUG=0

This firmware can then be downloaded to the Crazyflie using the cfclient or the
"Flash using radio" make target in Eclipse.
