# Bitcraze Virtual Machine

This project is for Bitcraze VM but doesn't contain any code or VM, it's used for tracking issues and improvements.

The Bitcraze VM contains everything you need for running the Bitcraze projects and doing development for them. It's a great way to quickly get started without having the hassle of installing dependencies and setting up the development environment.

There's a list of what's included:

* Xubuntu 13.10 pre-configured

* UDEV rules and pre-configured USB filtering for the Crazyradio and it's bootloader (NRF BOOT)

* Most of our projects pre-cloned

* The VirtualBox guest additions pre-installed

* gnu-arm-none-eabi toolchanin and build tools

* Mercurial and TortoiseHG

* pyusb, pygame and pyqt

* PyQtGraph

* PyCharm

* Oracle Java JRE (for PyCharm)

* KDE Marble built with Python-bindings

* Qt4 and QtDesigner

* KiCad

* Eclipse for compiling/debugging/flashing (pre-configured for BusBlaster)

* gedit

* SDCC 3.2 for compiling of Crazyradio firmware

* EmbSys RegView for Eclipse

For more info see our [wiki](http://wiki.bitcraze.se/projects:virtualmachine:index/ "Bitcraze VM Wiki").

Downloading
-----------
The Bitcraze VM can either be downloaded via torrent or via direct download:

* [Bitcraze VM 0.5 torrent](http://files.bitcraze.se/dl/Bitcraze_VM_0.5.ova.torrent "Bitcraze VM 0.5 torrent") (preferred)

* [Bitcraze VM 0.5 direct download](http://files.bitcraze.se/dl/Bitcraze_VM_0.5.ova "Bitcraze VM 0.5 direct download")

Installing
----------
The virtual applicance can be imported into the virtual machine manager of your choice:

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

