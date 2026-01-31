#!/bin/bash

# --- CONFIGURATION ---
# Replace with your Splunk Indexer IP/DNS
INDEXER_IP="172.20.242.20" 
MGMT_PORT="9997"
#SPLUNK_ADMIN="admin"
#SPLUNK_PASS="Changed123!" # Choose a strong password
# URL for the 9.4.0 RPM (Check Splunk site for the latest download link)
DOWNLOAD_URL="https://download.splunk.com/products/universalforwarder/releases/10.2.0/linux/splunkforwarder-10.2.0-d749cb17ea65-linux-amd64.deb"
SPLUNK_RPM="splunkforwarder-10.2.0-d749cb17ea65-linux-amd64.deb" 

#VM arm testing link
#wget -O splunkforwarder-10.2.0-d749cb17ea65-linux-arm64.deb "https://download.splunk.com/products/universalforwarder/releases/10.2.0/linux/splunkforwarder-10.2.0-d749cb17ea65-linux-arm64.deb"

#Correct AMD 64 bit for comp
#wget -O splunkforwarder-10.2.0-d749cb17ea65-linux-amd64.deb "https://download.splunk.com/products/universalforwarder/releases/10.2.0/linux/splunkforwarder-10.2.0-d749cb17ea65-linux-amd64.deb"

echo "--- Starting Splunk UF Installation on Fedora ---"

export SPLUNK_HOME="/opt/splunkforwarder"

useradd -m splunkfwd
groupadd splunkfwd

# 1. Download the DebM
echo "Downloading Splunk RPM..."
wget -O "$SPLUNK_RPM" "$DOWNLOAD_URL"

# 2. Install via dpkg
echo "Installing RPM..."
sudo dpkg -i ./"$SPLUNK_RPM"

# 3.
echo "Splunk packages installed, please manually setup and start splunk!"
