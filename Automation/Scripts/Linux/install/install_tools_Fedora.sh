#!/bin/bash


#sudo apt update
sudo dnf update

# Add any repos
#sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

#Install base tools
sudo dnf -y install nmap #installs
sudo dnf -y install wireshark #installs
#sudo dnf -y install docker #installs as containerd
#sudo dnf -y install docker-compose-switch
#sudo dnf -y install docker-compose
#sudo dnf -y install docker-compose-plugin
#sudo dnf -y install podman-compose
sudo dnf -y install fail2ban #installs

#Let user know what was isntalled
echo "---Here is what was installed.---"
#echo "Docker :" | docker version | head -n 1
echo "Nmap :" | nmap --version | head -n 1
echo "Fail2Ban :" | fail2ban-client version | head -n 1
#echo "Docker compose :" | docker compose version --short | head -n 1
echo "Wireshark :" | wireshark --version | head -n 1
sleep 5

#Standardize Fedora with similar Ubuntu tools

#Specific setup for Fedora done, rest of tool setup is in general and should be in the main.sh
