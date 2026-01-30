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

useradd -m splunkfwd
groupadd splunkfwd

# 1. Download the DebM
echo "Downloading Splunk RPM..."
wget -O "$SPLUNK_RPM" "$DOWNLOAD_URL"

# 2. Install via dpkg
echo "Installing RPM..."
sudo dpkg -i ./"$SPLUNK_RPM"

# 3. Create user-seed.conf (Sets admin password automatically)
echo "Setting credentials..."

read -s -p "Enter username :" SPLUNK_ADMIN
read -s -p "Enter Passwords :" SPLUNK_PASS

sudo tee /opt/splunkforwarder/etc/system/local/user-seed.conf > /dev/null <<EOF
[user_info]
USERNAME = $SPLUNK_ADMIN
PASSWORD = $SPLUNK_PASS
EOF

# 4. Enable Boot Start and Start Splunk
echo "Accepting license and enabling boot-start..."
sudo /opt/splunkforwarder/bin/splunk enable boot-start -user splunk --accept-license --no-prompt

# 5. Configure Forwarding
echo "Configuring forwarder to talk to $INDEXER_IP..."
sudo /opt/splunkforwarder/bin/splunk start
sudo /opt/splunkforwarder/bin/splunk add forward-server $INDEXER_IP:$MGMT_PORT -auth $SPLUNK_ADMIN:$SPLUNK_PASS

# 6. Add Ubuntu Security Logs (var/log/*.log)
echo "Adding /var/log/auth.log to monitor..."
sudo /opt/splunkforwarder/bin/splunk add monitor /var/log/*.log -sourcetype syslog

echo "--- Installation Complete! ---"
sudo /opt/splunkforwarder/bin/splunk restart
