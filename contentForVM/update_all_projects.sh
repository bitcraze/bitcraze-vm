#!/bin/bash
#
# Simple script to update all the repos to the latest version.

for f in /home/bitcraze/projects/*
do
	if [ -d "$f" ]; then
		echo "Updating $f"
		cd $f
		git pull
		cd ..
	fi
done
read -p "Press any key to exit" -n1 -s