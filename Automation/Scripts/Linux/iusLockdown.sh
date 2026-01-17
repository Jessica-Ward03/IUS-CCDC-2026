#!/bin/bash

#Get old password list, WGU script

setup(){
	#First get old password list
	
	echo “...Saving /etc/passwd to user_list.txt.”
	cut -d: -f1 /etc/passwd > user_list.txt
	#Check if file has been created.
	
	if [ -f user_list.txt ]; then
		echo "+ user_list.txt created!"
	else
		echo "- Error: user_list.txt not created, passwords have NOT been changed."

	fi

	#Save system information
	record_sysinfo

	#Find OS and start methods just for those OS's
	if [ -f /etc/os-release ]; then
		. /etc/os-release	
	else
		. /usr/lib/os-releaseE
	fi

	if [ "$ID" = "ubuntu" ]; then
		#Do all parts for Ubuntu
		#
		backup_admin_setup_ubuntu
		change_all_user_passwords
		#encrypt_files_ubuntu
		#install tools
	elif [ "$ID" = "fedora" ]; then
	       #Do all parts for Fedora
	       #
	       backup_admin_setup_fedora
		change_all_user_passwords
		#encrypt_files_fedora
		#install tools
       else
	echo "WARNING: Unable to complete setup because OS was not found. Please manually prepare the machine."
	fi	
}

#Mostly from WGU
record_sysinfo(){
	echo "Collecting system in sysinfo.txt" 	
	date -u  >> sysinfo.txt
	uname -a >> sysinfo.txt	
	
	if [ -f /etc/os-release ]; then
		. /etc/os-release	
	else
		. /usr/lib/os-releaseE
	fi
	
	lscpu    >> sysinfo.txt
	lsblk    >> sysinfo.txt
	ip a     >> sysinfo.txt
	sudo netstat -auntp >>sysinfo.txt
	df       >> sysinfo.txt
	ls -latr /var/acc >> sysinfo.txt
	sudo ls -latr /var/log/* >> sysinfo.txt
	sudo ls -la /etc/syslog >> sysinfo.txt
	check_crontab_func
	cat /etc/crontab >> sysinfo.txt
	ls -la /etc/cron.* >> sysinfo.txt
	sestatus >> sysinfo.txt
	getenforce >> sysinfo.txt
	sudo cat /root/.bash_history >> sysinfo.txt
	cat ~/.bash_history >> sysinfo.txt
	cat /etc/group >> sysinfo.txt
	cat /etc/passwd >> sysinfo.txt	
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

encrypt_files_fedora(){
	dnf install openssl
	
	encrypt_files
}

encrypt_files_ubuntu(){
	apt install openssl
	encrypt_files
}

encrypt_files() {
	#Propmt for password
	read -s -p "Please enter the password for the keys: " keypass
	echo
	read -s -p "Please enter the password to use for encrypting the documents: " documentpass
	echo
	#Create keys
	
	#Encrypt files

	#Done!
}

setup
