#!/bin/bash

# Ubuntu tools

#sudo apt update
sudo apt update
sudo apt upgrade -y


#Install base tools
sudo apt install -y nmap
sudo apt install -y wireshark
#sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo apt install -y fail2ban

#What was installed
#Let user know what was isntalled
echo "---Here is what was installed---."
#echo "Docker :" | docker version | head -n 1
echo "Nmap :" | nmap --version | head -n 1
echo "Fail2Ban :" | fail2ban-client version | head -n 1
#echo "Docker compose :" | docker compose version --short | head -n 1
echo "Wireshark :" | wireshark --version | head -n 1

sleep 5

#selinux needs to be rebooted to correctly apply
#sudo apt install selinux selinux-basics selinux-policy-default auditd audispd-plugins
#echo "---To apply selinux, the computer must be rebooted.---"

#Start ufw, should be auto installed.
sudo enable ufw
