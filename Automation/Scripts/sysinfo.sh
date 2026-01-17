#!/bin/bash
#
#This works for multiple distros.
#
#Mostly from WGU public github

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
