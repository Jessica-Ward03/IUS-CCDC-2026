#!/bin/bash


# This finds distro and branches stuff.
############################################################# 
setup(){
	#Set enviroment variables.
	# 1. Check if .env file exists
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
    		exit 1
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
	echo "WARNING: Unable to complete setup because OS was not found. Please manually prepare the machine."
	fi	
}


##############################################################
! Put all the individual scripts to be run here.
#############################################################
run_ubuntu(){
	#Password setup
	backup_admin_setup_ubuntu
	change_all_user_passwords
	#Put external scripts here!
}

run_fedora(){
	#Password setup
	backup_admin_setup_fedora
	change_all_user_passwords
	#Put external scripts here!
}

backup_admin_setup_ubuntu(){
	echo "...Setting up"
	backup1="batman"
	backup2="robin"
	
	useradd -m -s /bin/bash $backup1 | echo "+ Created backup user 1"
	useradd -m -s /bin/bash $backup2 | echo "+ Created backup user 2"
	usermod -aG sudo $backup1 | echo "+ added 1 to sudoers"
	usermod -aG sudo $backup2 | echo "+ added 2 to sudoers"
	#Assign passwords
	echo "Terminal is on silent mode and won't show you entering the passwords here."
	read -s -p "Enter password for backup user 1 :" backup1pass
	echo
	read -s -p "Enter password for backup user 2 :" backup2pass
	echo
	echo "...finishing setting up backup users."
	echo "$backup1:$backup2pass" | chpasswd
	echo "$backup2:$backup2pass" | chpasswd
	#Remove passwords from memory
	unset backup1pass
	unset backup2pass
	echo "+ Backup admins completed!"
	echo "Please switch to backup admins, since all other user accounts will be given random passwords."
}


backup_admin_setup_fedora(){
	echo "...Setting up"
	backup1="batman"
	backup2="robin"
	
	useradd -m -s /bin/bash $backup1 | echo "+ Created backup user 1"
	useradd -m -s /bin/bash $backup2 | echo "+ Created backup user 2"
	usermod -aG wheel $backup1 | echo "+ added 1 to sudoers"
	usermod -aG wheel $backup2 | echo "+ added 2 to sudoers"
	#Assign passwords
	echo "Terminal is on silent mode and won't show you entering the passwords here."
	read -s -p "Enter password for backup user 1 :" backup1pass
	echo
	read -s -p "Enter password for backup user 2 :" backup2pass
	echo
	echo "...finishing setting up backup users."
	echo "$backup1:$backup2pass" | chpasswd
	echo "$backup2:$backup2pass" | chpasswd
	#Remove passwords from memory
	unset backup1pass
	unset backup2pass
	echo "+ Backup admins completed!"
	echo "Please switch to backup admins, since all other user accounts will be given random passwords."
}

change_all_user_passwords() {
	for i in $(cat user_list.txt);
	do
		PASS=$(tr -dc A-Za-z0-9 < /dev/urandom | head -c 31)
		echo "Changing passwod for $i"
		
		#For testing
		#echo "$PASS" | cat -A
		
		#echo "$i,$PASS" >> userlist.txt
		echo "$i:$PASS" | chpasswd
	done
}
