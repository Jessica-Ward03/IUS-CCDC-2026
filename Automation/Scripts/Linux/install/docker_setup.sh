#!/bin/bash

#do any setup

#install/containers.
cd Docker_files/splunk-forwarder
mkdir /forwader-data
touch .env #if not already there.
#May not need this, would be safer to only have everything in the image itself.

#Get enviroment addr for splunk
read -s -p "Enter splunk password: " pass
read -p "Enter splunk index addr: " addr

# Set in .env file
echo "PASSWORD=$pass" > .env
echo "SPLUNK_INDEX_IP=$addr" >> .env
echo "USER=root" >> .env 	#lol
echo "GROUP=root" >> .env 	#lmao
#Start container + download image
sudo docker compose up -d
