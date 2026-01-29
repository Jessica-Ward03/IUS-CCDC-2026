#!/bin/bash


# This finds distro and branches stuff.
############################################################# 
setup(){

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
			
	#Change passwords
	sudo ./change_local_passwords.sh


		#Put external scripts here!






		#Tools 
	echo "----Installing Ubuntu tools...----"
	sudo ./Ubuntu/install_tools_Ubuntu.sh
	
	echo "----Starting UFW config----"
	sudo ./general/ufw.sh
	sudo ./general/open_ports_ufw.sh

	echo "----Starting Selinux_config----"
	sudo ./general/selinux_config.sh
	
		#Docker setup for splunk
	echo "----Setting up Docker Splunk forwarder----"
	sudo ./general/docker_setup.sh

		#Nmap scan
	echo "-----Starting Nmap scan-----"
	sudo ./general/nmap_baseline.sh
	sudo ./general/nmap_compare.sh
	
		# ?Wireshark scan?
		#Reboot to apply various tools, like selinux, correctly.
	echo "----Rebooting to apply tools and other settings...----"
	sleep 8
	sudo reboot
}

run_fedora(){
	#Change passwords
	sudo ./change_local_passwords.sh
		#Put external scripts here!
	
		#Tools 
	echo "-----Installing Fedora tools...-----"
	sudo ./Fedora/install_tools_Fedora.sh
		# UFW setup
	echo "-----Starting UFW config------"
	sudo ./general/ufw.sh
	sudo ./general/open_ports_ufw.sh

		## Seperate command
	echo "----Starting Selinux_config----"
	sudo ./general/selinux_config.sh
	
		#Run set up scripts for each.

		#Docker setup for splunk
	echo "-----Setting up Docker Splunk forwarder-----"
	sudo ./general/docker_setup.sh

		#Nmap scan
	echo "-----Starting Nmap scan-----"
	sudo ./general/nmap_baseline.sh
	sudo ./general/nmap_compare.sh
	
		#Other stuff
	echo "----Changing Banner----"
	sudo ./banner_change.sh
	
	
		# ?Wireshark scan?
	echo "Rebooting to apply tools and other settings..."
	sleep 8
	sudo reboot
}

backup_admin_setup_ubuntu(){
	echo "...Setting up"
	#backup1="batman"
	#backup2="robin"
	
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
	echo "$backup1:$backup1pass" | chpasswd
	echo "$backup2:$backup2pass" | chpasswd
	#Remove passwords from memory
	unset backup1pass
	unset backup2pass
	#Setup home dir
	setup_home

	echo "+ Backup admins completed!"
	echo "Please switch to backup admins, since all other user accounts will be given random passwords."
}


backup_admin_setup_fedora(){
	echo "...Setting up"
	#backup1="batman"
	#backup2="robin"
	
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
	echo "$backup1:$backup1pass" | chpasswd
	echo "$backup2:$backup2pass" | chpasswd
	#Remove passwords from memory
	unset backup1pass
	unset backup2pass
	#setup home dir
	setup_home
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
