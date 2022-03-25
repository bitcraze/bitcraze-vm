# Bitcraze Virtual Machine

This project contains scripts and templates to automatically create the Bitcraze VM with [Packer](https://www.packer.io).
It's also used for tracking issues and improvements.

The Bitcraze VM contains everything you need for running the Bitcraze projects and doing development for them. It's a great way to quickly get started without having the hassle of installing dependencies and setting up the development environment.

Here is a non-exhaustive list of what's included:

* Xubuntu 20.04 pre-configured
* VirtualBox guest additions pre-installed
* udev rules and pre-configured USB filtering for the Crazyradio and it's bootloader (NRF BOOT)
* Most of our projects pre-cloned
* QTCreator
* Firefox
* KiCad
* vscode prepared for compiling/debugging/flashing the Crazyflie firmware
* SDCC 3.2 for compiling of Crazyradio firmware

# How to build the Bitcraze VM

## Pre-requisites

* This script has only been tested on a Linux machine, therefore it's recommended to use Linux to build the Bitcraze VM
* VirtualBox must be installed as well as the VirtualBox Extension Pack
* Virtual box guest additions
* [Packer](https://www.packer.io)  (can be installed with `apt install packer`)

## Local build

1. Run ```createBitcrazeVM.sh```
2. Wait 40-60 minutes depending on machine and internet connection speed

### What does createBitcrazeVM.sh do?
Run the two [Packer](https://www.packer.io) templates
    * Create the VM and run a preseeded installation (```bitcrazeVM_createVM.json```)
    * Provision the VM (```bitcrazeVM_provisionVM.json```)

### Why are there two packer templates?

To separate the VM creation and installation from the provisioning.
If there is a problem during provisioning, the whole process does not have to start from scratch again.
This saves a lot of time.

### What do the packer templates do?

#### bitcrazeVM_createVM.json

1. Download an ISO and create a VirtualBox image
2. Start the so-called "preseeding", which automatically runs the Ubuntu installer
3. Export VM image to OVA file

#### bitcrazeVM_provisionVM.json
Copy the files specified in the JSON template to the VM and run the `provision.sh` script so setup the image.

### Help! Something does not work.

Please take a look at the log files ```packerlog_create.txt``` and ```packerlog_provision.txt```.


Downloading
-----------
The Bitcraze VM can either be downloaded via torrent or via direct download.

[Bitcraze VM download page](https://wiki.bitcraze.io/projects:virtualmachine:index)

Installing
----------
The virtual appliance can be imported into [VirtualBox](https://www.virtualbox.org/ "VirtualBox").

It can be used with oter virtual machine manager however setting up the guest addition might be required. The following have been tested 

* [Gnome Boxes](https://wiki.gnome.org/Apps/Boxes)
* [VM Player](http://www.vmware.com/products/player/ "WM Player")

Using the virtual machine
-------------------------
After importing just run the machine. It logs in automatically but use the following credentials if needed:
```
User: bitcraze
Pass: crazyflie
```

For more information on debugging, building, flashing and updating to the latest version have a look at our [Documentation](https://www.bitcraze.io/documentation/tutorials/getting-started-with-crazyflie-2-x/#inst-comp "Getting started with the Crazyflie 2.X")

## Contribute
Go to the [contribute page](https://www.bitcraze.io/contribute/) on our website to learn more.
