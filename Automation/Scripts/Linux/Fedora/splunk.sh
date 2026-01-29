#!/bin/bash

# --- Configuration ---
# Replace this URL with the latest RPM link from splunk.com
SPLUNK_INSTALLER="splunkforwarder-10.2.0-d749cb17ea65.x86_64.rpm".
SPLUNK_HOME="/opt/splunkforwarder"
# Set your deployment server (e.g., 192.168.1.10:8089)
DEPLOY_SERVER="172.20.242.20" 

# --- Execution ---

echo "--- Starting Splunk Universal Forwarder Installation ---"

# 1. Download the RPM
echo "Step 1: Downloading Splunk UF..."
wget -O splunkforwarder-10.2.0-d749cb17ea65.x86_64.rpm "https://download.splunk.com/products/universalforwarder/releases/10.2.0/linux/splunkforwarder-10.2.0-d749cb17ea65.x86_64.rpm"

# 2. Install via DNF
echo "Step 2: Installing RPM..."
sudo dnf install -y ./$SPLUNK_INSTALLER

# 3. Enable boot-start and accept license
echo "Step 3: Configuring boot-start and license..."
# Using --accept-license and providing a default password 'Splunk123'
# Change this immediately after login!
sudo $SPLUNK_HOME/bin/splunk enable boot-start --accept-license --answer-yes --no-prompt

#Setting up the monitor

sudo -u splunk $SPLUNK_HOME/bin/splunk add monitor /var/log/messages admin:$SPLUNK_ADMIN_PASS

sudo -u splunk $SPLUNK_HOME/bin/splunk monitor /var/log/secure admin:$SPLUNK_ADMIN_PASS

sudo -u splunk $SPLUNK_HOME/bin/splunk add monitor /var/log/*.log  admin:$SPLUNK_ADMIN_PASS

sudo -u splunk $SPLUNK_HOME/bin/splunk add monitor /opt/splunkforwarder/var/log/splunkauth admin:$SPLUNK_ADMIN_PASS

# 4. Connect to Deployment Server (Optional)

if [ -n "$DEPLOY_SERVER" ]; then
    echo "Step 4: Setting deployment server to $DEPLOY_SERVER..."
    sudo $SPLUNK_HOME/bin/splunk set deploy-poll "$DEPLOY_SERVER" -auth admin:Splunk123 
# 5. Start the service
echo "Step 5: Starting Splunk..."
sudo systemctl start splunk

# 6. Cleanup
rm $SPLUNK_INSTALLER

echo "--- Installation Complete! ---"
echo "Note: Default credentials are admin / Splunk123"
