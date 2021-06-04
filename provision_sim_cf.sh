#!/bin/bash -e

# Step 1:
# Install basics dependencies and the protobuf library, which is used as
# interface to Gazebo.
sudo apt -y install git zip qtcreator cmake genromfs ninja-build
sudo apt -y install protobuf-compiler libgoogle-glog-dev libeigen3-dev libxml2-utils

# Step 2:
# Install ROS (Robotic Operating System).
# You will also need mav-comm and joy package installed on your computer in
# order to compile the crazyflie_gazebo ROS package.
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
sudo apt update
sudo apt -y install ros-noetic-ros-base
sudo apt -y install ros-noetic-libmavconn ros-noetic-joy ros-noetic-tf
sudo apt -y install ros-noetic-rqt-multiplot ros-noetic-cv-bridge
source /opt/ros/noetic/setup.bash

sudo apt -y install python3-rosdep python3-rosinstall
sudo apt -y install python3-rosinstall-generator python3-wstool build-essential

sudo rosdep init || echo "hmm"
rosdep update || echo "hmm..."

# Step 3:
# Install packages needed to build sim_cf
#
sudo apt -y install libgazebo9-dev gazebo9 libopencv-dev python3-opencv

# Step 4:
# Initialize the build workspace
[ -d ~/catkin_ws/src ] || {
    mkdir -p ~/catkin_ws/src
    cd ~/catkin_ws/src
    catkin_init_workspace
}

source ~/catkin_ws/devel/setup.bash
cd ~/catkin_ws/ 
catkin_make

# Step 5:
# Build crazyflie_gazebo package
#
# We need to fetch so projects from GitHub and place them in the src dir,
# they will magicaly be built by cmake.
cd ~/catkin_ws/src
[ -d ~/catkin_ws/src/crazyflie_ros ] || {
    git clone https://github.com/whoenig/crazyflie_ros.git
}
cd crazyflie_ros
git submodule update --init --recursive

[ -d ~/catkin_ws/src/crazyflie_ros/sim_cf ] || {
    git clone https://github.com/wuwushrek/sim_cf.git
}
cd sim_cf/
git submodule update --init --recursive

cd ~/catkin_ws/src
[ -d ~/catkin_ws/src/mav_comm ] || {
    git clone https://github.com/jonasdn/sim_cf.git -b jonadn/21
}

cd ~/catkin_ws
catkin_make

# Step 6:
# Build the Crazyflie firmware for SITL (Software in the loop).
# Because Ubuntu 20.04 does not have a 'python' binary and this script expects
# one, we need to symlink python3.
#
# And to be able to build this version of firmware with the toolchain available
# we need to disable a warning.
sudo ln -fs /usr/bin/python3 /usr/bin/python
cd ~/catkin_ws/src/crazyflie_ros/sim_cf/crazyflie-firmware/sitl_make

mkdir -p build
cd build
cmake -D CMAKE_CXX_FLAGS="-Wno-address-of-packed-member"  -D CMAKE_C_FLAGS="-Wno-address-of-packed-member" ..
make
