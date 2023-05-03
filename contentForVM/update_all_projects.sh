#!/bin/bash
#
# Simple script to update all the repos to the latest version.

for f in /home/bitcraze/projects/*
do
	if [ -d "$f" ]; then
		echo "Updating $f"
		cd $f
		git pull
		git submodule init
		git submodule update --recursive

		cd ..
	fi
done

#
# In order to make sure the user has an up-to-date install of the
# python lib and client, with all deps, we make sure to re-install it
# from the source in git.
#
pip3 install --upgrade pip
pip3 install --user --force-reinstall -e /home/bitcraze/projects/crazyflie-lib-python
pip3 install --user --force-reinstall -e /home/bitcraze/projects/crazyflie-clients-python

read -p "Press any key to exit" -n1 -s
