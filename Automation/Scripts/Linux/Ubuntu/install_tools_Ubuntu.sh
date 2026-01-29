#!/bin/bash

# Ubuntu tools

#sudo apt update
sudo apt update
#sudo apt upgrade -y


#Add Docker repo via offical instructions.
echo "Adding repos to apt..."

# Add Docker's official GPG key:
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

#Install base tools
sudo apt install -y nmap
sudo apt install -y wireshark
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo apt install -y fail2ban

#What was installed
#Let user know what was isntalled
echo "---Here is what was installed---."
echo "Docker :" | docker version | head -n 1
echo "Nmap :" | nmap --version | head -n 1
echo "Fail2Ban :" | fail2ban-client version | head -n 1
echo "Docker compose :" | docker compose version --short | head -n 1
echo "Wireshark :" | wireshark --version | head -n 1

sleep 5

#selinux needs to be rebooted to correctly apply
sudo apt install selinux selinux-basics selinux-policy-default auditd audispd-plugins
echo "---To apply selinux, the computer must be rebooted.---"

#Start ufw, should be auto installed.
sudo enable ufw
