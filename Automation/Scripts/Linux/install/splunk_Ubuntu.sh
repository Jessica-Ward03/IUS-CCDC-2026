#!/bin/bash

# --- Configuration ---
# Update this URL with the latest .deb link from the Splunk website
SPLUNK_DEB_URL="https://download.splunk.com/products/universalforwarder/releases/10.2.0/linux/splunkforwarder-10.2.0-d749cb17ea65-linux-amd64.deb"
SPLUNK_INSTALLER="splunkforwarder-10.2.0-d749cb17ea65-linux-amd64.deb" 
SPLUNK_HOME="/opt/splunkforwarder"
# Set your deployment server if you have one
DEPLOY_SERVER="" 

# --- Execution ---

echo "--- Starting Splunk UF Installation for Ubuntu ---"

# 1. Update system and Install Dependencies
echo "Step 1: Updating apt and installing wget..."
sudo apt-get update && sudo apt-get install -y wget

# 2. Download the Debian package
echo "Step 2: Downloading Splunk UF..."
wget -O splunkforwarder-10.2.0-d749cb17ea65-linux-amd64.deb "https://download.splunk.com/products/universalforwarder/releases/10.2.0/linux/splunkforwarder-10.2.0-d749cb17ea65-linux-amd64.deb"

# 3. Install the package
echo "Step 3: Installing .deb package..."
sudo dpkg -i ./$SPLUNK_INSTALLER

# 4. Enable boot-start and accept license
# This creates the 'splunk' user and sets up the systemd unit
echo "Step 4: Configuring boot-start and license..."
sudo $SPLUNK_HOME/bin/splunk enable boot-start --accept-license --answer-yes --no-prompt --user splunk

# 5. Fix Permissions
# Ensure the splunk user owns the installation directory
sudo chown -R splunk:splunk $SPLUNK_HOME

sudo -u splunk $SPLUNK_HOME/bin/splunk add monitor /var/log/ admin:$SPLUNK_ADMIN_PASS

sudo -u splunk $SPLUNK_HOME/bin/splunk monitor /var/log/syslog admin:$SPLUNK_ADMIN_PASS

sudo -u splunk $SPLUNK_HOME/bin/splunk add monitor /var/log/*.log  admin:$SPLUNK_ADMIN_PASS

sudo -u splunk $SPLUNK_HOME/bin/splunk add monitor /opt/splunkforwarder/var/log/splunkauth admin:$SPLUNK_ADMIN_PASS


# 6. Start the service
echo "Step 5: Starting Splunk service..."
sudo systemctl start splunk

# 7. Connect to Deployment Server (Optional)

if [ -n "$DEPLOY_SERVER" ]; then
    echo "Step 6: Setting deployment server..."
    # Using default password 'Splunk123' - you'll be prompted to change this on first manual login
    sudo -u splunk $SPLUNK_HOME/bin/splunk set deploy-poll "$DEPLOY_SERVER" -auth admin:Splunk123
fi

# 8. Cleanup
rm $SPLUNK_INSTALLER

echo "--- Installation Complete! ---"
