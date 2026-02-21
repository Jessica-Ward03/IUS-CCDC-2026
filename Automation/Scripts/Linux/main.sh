#!/bin/bash


# This finds distro and branches stuff.
############################################################# 
setup(){
	#Set enviroment variables.
	# 1. Check if .env file exists, this is used for password and user stuff
	
	if [ -f .env ]; then
    		# 2. Start 'allexport' mode
    		set -a
    		# 3. Source the .env file
    		source .env
    		# 4. Stop 'allexport' mode
    		set +a
    		echo "Environment variables loaded."
	else
    		echo ".env file not found!"
    		#exit 1
	fi


	#Find OS and start methods just for those OS's
	if [ -f /etc/os-release ]; then
		. /etc/os-release	
	else
		. /usr/lib/os-releaseE
	fi

	if [ "$ID" = "ubuntu" ]; then
		run_ubuntu
	elif [ "$ID" = "fedora" ]; then
       		run_fedora
	else
	echo "WARNING: Unable to complete setup because OS was not found. Please manually prepare the machine or run each script."
	echo "Or you may be on splunk, which case means this main.sh does not work."
	fi
}


##############################################################
#! Put all the individual scripts to be run here.
#############################################################
run_ubuntu(){

	echo "----Conducting Initial Hardening...----"
	sudo ./admins/initial_hardening.sh

	echo "----Creating Admin Accounts----"
	sudo ./admins/create_admins.sh

	echo "----Locking old account----"
	sudo ./admins/lock_old_account.sh

	echo "----COMPLETE----"
	
}

run_fedora(){
	
	echo "----Conducting Initial Hardening...----"
	sudo ./admins/initial_hardening.sh

	echo "----Creating Admin Accounts----"
	sudo ./admins/create_admins.sh
	
	echo "----Locking old account----"
	sudo ./admins/lock_old_account.sh

	echo "----COMPLETE----"
	
}

setup_home() {
sudo git clone $git_repo /home/$backup1/git_repo
sudo chown $backup1:$backup1 /home/$backup1/git_repo
sudo chmod 700 /home/$backup1/git_repo

sudo git clone $git_repo /home/$backup2/git_repo
sudo chown $backup2:$backup2 /home/$backup2/git_repo
sudo chmod 700 /home/$backup2/git_repo
}

## Script starts here
setup
