#!/bin/bash

# --- CONFIGURATION ---
# Replace with your Splunk Indexer IP/DNS
INDEXER_IP="172.20.242.20" 
MGMT_PORT="9997"
#SPLUNK_ADMIN="admin"
#SPLUNK_PASS="Changed123!" # Choose a strong password
# URL for the 9.4.0 RPM (Check Splunk site for the latest download link)
DOWNLOAD_URL="https://download.splunk.com/products/universalforwarder/releases/10.2.0/linux/splunkforwarder-10.2.0-d749cb17ea65.x86_64.rpm"
SPLUNK_RPM="splunkforwarder-10.2.0-d749cb17ea65.x86_64.rpm"

echo "--- Starting Splunk UF Installation on Fedora ---"

export SPLUNK_HOME="/opt/splunkforwarder"

useradd -m splunkfwd
groupadd splunkfwd

# 1. Download the RPM
echo "Downloading Splunk RPM..."
wget -O "$SPLUNK_RPM" "$DOWNLOAD_URL"

# 2. Install via DNF
echo "Installing RPM..."
sudo dnf install -y ./"$SPLUNK_RPM"

echo "Splunk packages installed, please manually set up and start splunk!"
