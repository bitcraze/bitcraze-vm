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

		#
		# In order to make sure the user has an up-to-date install of the
		# python lib and client, with all deps, we make sure to re-install it
		# from the source in git.
		#
		if [ -f setup.py ]; then  # true if this is a python project
			pip3 install --user --upgrade --force-reinstall -e .
		fi

		cd ..
	fi
done

read -p "Press any key to exit" -n1 -s
