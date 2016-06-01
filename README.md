# Bitcraze Virtual Machine

This project contains scripts and templates to automatically create the Bitcraze VM with [Packer](https://www.packer.io).
It's also used for tracking issues and improvements.

The Bitcraze VM contains everything you need for running the Bitcraze projects and doing development for them. It's a great way to quickly get started without having the hassle of installing dependencies and setting up the development environment.

Here is a list of what's included:

* Xubuntu 14.04.4 pre-configured
* VirtualBox guest additions pre-installed
* UDEV rules and pre-configured USB filtering for the Crazyradio and it's bootloader (NRF BOOT)
* Most of our projects pre-cloned
* gnu-arm-none-eabi toolchain and build tools
* pyusb, pygame and pyqt
* PyQtGraph
* Qt4 and QtDesigner
* KiCad
* Eclipse for compiling/debugging/flashing (pre-configured for BusBlaster)
* gedit
* SDCC 3.2 for compiling of Crazyradio firmware
* EmbSys RegView for Eclipse

For more info see our [wiki](https://wiki.bitcraze.se/projects:virtualmachine:index/ "Bitcraze VM Wiki").

# How to build the Bitcraze VM

## Pre-requisites

* This script has only been tested on a Linux machine, therefore it's recommended to use Linux to build the Bitcraze VM
* VirtualBox must be installed (tested with version 5.0.14)

## Local build

1. Run ```createBitcrazeVM.sh```
2. Wait 40-60 minutes depending on machine and internet connection speed

### What does createBitcrazeVM.sh do?

1. Download the ISO file (currently Xubuntu-14.04.4-desktop-i386.iso) if it does not already exist.
2. Download the following files if they do not already exist:
    * ```gcc-arm-none-eabi-<version>-linux.tar.bz2```
    * ```eclipse-cpp-<version>-linux-gtk.tar.gz```
    * ```pycharm-community-<version>.tar.gz```
3. Install [Packer](https://www.packer.io) if it is not already installed.
4. Run the two [Packer](https://www.packer.io) templates
    * Create the VM and run a preseeded installation (```bitcrazeVM_xubuntu-14.04.4-desktop_createVM.json```)
    * Provision the VM (```bitcrazeVM_xubuntu-14.04.4-desktop_provisionVM.json```)

### Why are there two packer templates?

To separate the VM creation and installation from the provisioning.
If there is a problem during provisioning, the whole process does not have to start from scratch again.
This saves a lot of time.

### What do the packer templates do?

#### bitcrazeVM_xubuntu-14.04.4-desktop_createVM.json

1. Create a VirtualBox image
2. Start the so-called "preseeding", which automatically runs the Ubuntu installer
3. Export VM image to OVA file

#### bitcrazeVM_xubuntu-14.04.4-desktop_provisionVM.json

1. Copy the following files into the VirtualBox image:
    * Desktop shortcuts and readme file
    * Desktop background image and Crazyflie client icon
    * Update script (```update_all_projects.sh```)
    * GCC ARM toolchain (```gcc-arm-none-eabi-<version>-linux.tar.bz2```)
    * Eclipse (```eclipse-cpp-<version>-linux-gtk.tar.gz```)
    * PyCharm (```pycharm-community-<version>.tar.gz```)
2. Provision the image (```provision.sh```)
    * Install packages
    * Install VirtualBoxGuestAdditions
    * Add udev rules for Crazyradio and Crazyflie
    * Clone the Bitcraze Git repositories
    * Setup GCC ARM toolchain
    * Extract PyCharm and Eclipse
    * Setup update script
    * Set desktop background image
    * Clean up VM image
    * Export VM image to OVA file

### What needs to be done after the VM has been created and provisioned?

Some steps still have to be done manually:

1. Import the generated OVA file (e.g. ```output-virtualbox-ovf/BitcrazeVM.ova```) into VirtualBox (File -> Import appliance...)
2. Start the Bitcraze VM
3. Open a terminal
4. Setting up PyCharm
    * Run ```pycharm.sh``` to set up PyCharm (installs start menu entry and desktop shortcut?)
5. Setting up Eclipse (Work in progress)
    * See the [Bitcraze VM wiki](https://wiki.bitcraze.io/projects:virtualmachine:create_vm#setting_up_eclipse) for more information

### Help! Something does not work.

Please take a look at the log files ```packerlog_create.txt``` and ```packerlog_provision.txt```.


Downloading
-----------
The Bitcraze VM can either be downloaded via torrent or via direct download.

[Bitcraze VM download page](https://wiki.bitcraze.io/projects:virtualmachine:index)

Installing
----------
The virtual appliance can be imported into the virtual machine manager of your choice:

* [VirtualBox](https://www.virtualbox.org/ "VirtualBox")

* [VM Player](http://www.vmware.com/products/player/ "WM Player")

Using the virtual machine
-------------------------
After importing just run the machine. It logs in automatically but use the following credentials if needed:
```
User: bitcraze
Pass: crazyflie
```

For more information on debugging, building, flashing and updating to the latest version have a look at the [Bitcraze VM Wiki](http://wiki.bitcraze.se/projects:virtualmachine:index/ "Bitcraze VM Wiki")
