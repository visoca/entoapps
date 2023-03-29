#!/bin/bash

# This script mounts the cluster share on the Entomology 
# and Insectary Platform workstation
# For this script to work, and admin with root access needs 
# to add the following lines to /etc/fstab
#	# entomics
#	//jic-hpc-data/Project-Scratch/entomics      /entomics       cifs    domain=nr4,noauto,user 0 0
# and create the target folder and change permissions so that users of the group can write:
#	sudo mkdir /entomics
#	sudo chmod +775 /entomics

# Check if it is already mounted
if [[ $(grep -c '/entomics' /proc/mounts) == 1 ]];
then
	echo "entomics already mounted"
else
	echo "mounting entomics..."
	mount -t cifs -o user=${USER},uid=${UID},gid=$(id -g ${USER}) //jic-hpc-data/Project-Scratch/entomics /entomics
fi
