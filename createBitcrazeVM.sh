#!/bin/bash

PACKER_URL="https://releases.hashicorp.com/packer/0.8.6/packer_0.8.6_linux_386.zip"

PACKER_FILE1=bitcrazeVM_createVM.json
PACKER_FILE2=bitcrazeVM_provisionVM.json

GCC_ARM_FILE="gcc-arm-none-eabi-7-2018-q2-update-linux.tar.bz2"
GCC_ARM_URL="https://developer.arm.com/-/media/Files/downloads/gnu-rm/7-2018q2/$GCC_ARM_FILE"

ECLIPSE_FILE="eclipse-cpp-2018-09-linux-gtk-x86_64.tar.gz"
ECLIPSE_URL="http://ftp.halifax.rwth-aachen.de/eclipse//technology/epp/downloads/release/2018-09/R/$ECLIPSE_FILE"

ECLIPSE_GNU_ARM_PLUGIN_FILE="ilg.gnuarmeclipse.repository-2.12.1-201604190915.zip"
ECLIPSE_GNU_ARM_PLUGIN_URL="https://github.com/gnuarmeclipse/plug-ins/releases/download/v2.12.1-201604190915/$ECLIPSE_GNU_ARM_PLUGIN_FILE"

OPENOCD_FILE="gnuarmeclipse-openocd-debian32-0.9.0-201505190955.tgz"
OPENOCD_URL="https://github.com/gnuarmeclipse/openocd/releases/download/gae-0.9.0-20150519/$OPENOCD_FILE"

CONTENT_DIR="contentForVM/"

OVA_FILE=BitcrazeVM.ova

#Install packer (only if it's not already installed)
if type "packer" > /dev/null
then
  echo "Packer already installed. Continuing..."
else
  echo "Packer is not installed. Installing..."
  wget $PACKER_URL
  unzip packer*.zip -d $HOME/packer
  sudo ln -s $HOME/packer/packer /usr/bin/packer
  rm packer*.zip
fi

#Download GCC ARM (63MB) (only if it's not already downloaded)
if [ -f "$CONTENT_DIR$GCC_ARM_FILE" ]
then
  echo "$CONTENT_DIR$GCC_ARM_FILE found. Continuing..."
else
  echo "$CONTENT_DIR$GCC_ARM_FILE not found. Starting download..."
  wget -P $CONTENT_DIR $GCC_ARM_URL
fi

#Download Eclipse (182MB) (only if it's not already downloaded)
if [ -f "$CONTENT_DIR$ECLIPSE_FILE" ]
then
  echo "$CONTENT_DIR$ECLIPSE_FILE found. Continuing..."
else
  echo "$CONTENT_DIR$ECLIPSE_FILE not found. Starting download..."
  wget -P $CONTENT_DIR $ECLIPSE_URL
fi

#Download Eclipse GNU ARM plugin (6MB) (only if it's not already downloaded)
if [ -f "$CONTENT_DIR$ECLIPSE_GNU_ARM_PLUGIN_FILE" ]
then
  echo "$CONTENT_DIR$ECLIPSE_GNU_ARM_PLUGIN_FILE found. Continuing..."
else
  echo "$CONTENT_DIR$ECLIPSE_GNU_ARM_PLUGIN_FILE not found. Starting download..."
  wget -P $CONTENT_DIR $ECLIPSE_GNU_ARM_PLUGIN_URL
fi

#Download OpenOCD 0.9 (3MB) (only if it's not already downloaded)
if [ -f "$CONTENT_DIR$OPENOCD_FILE" ]
then
  echo "$CONTENT_DIR$OPENOCD_FILE found. Continuing..."
else
  echo "$CONTENT_DIR$OPENOCD_FILE not found. Starting download..."
  wget -P $CONTENT_DIR $OPENOCD_URL
fi

# Compressing eclipse project files in one tgz
pushd .
echo "Compressing eclipse-project-files.tar.gz"
cd $CONTENT_DIR/eclipse-project-files
tar -czf ../eclipse-project-files.tar.gz *
popd

#Run packer
echo "Running packer..."
export PACKER_LOG=1

#If OVA already exists, skip VM creation step
if [ -f "output-virtualbox-iso/$OVA_FILE" ]
then
  echo "OVA file found. Skipping VM creation..."
else
  echo "OVA file not found. Starting VM creation..."
  export PACKER_LOG_PATH="packerlog_create.txt"
  packer build $PACKER_FILE1
fi
echo "Starting VM provisioning..."
export PACKER_LOG_PATH="packerlog_provision.txt"
packer build $PACKER_FILE2
