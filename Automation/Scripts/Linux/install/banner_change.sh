#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "[!] Please run as root"
    exit 1
fi

BANNER_TEXT="**********************************************
*  WARNING: Authorized Access Only            *
*  All activity is monitored and logged       *
*  Unauthorized access is prohibited          *
**********************************************"

echo "[*] Backing up existing banner files (1/4)"

cp /etc/issue /etc/issue.bak 2>/dev/null
cp /etc/issue.net /etc/issue.net.bak 2>/dev/null
cp /etc/motd /etc/motd.bak 2>/dev/null
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak 2>/dev/null

echo "[*] Writing banners... (2/4)"

echo "$BANNER_TEXT" > /etc/issue
echo "$BANNER_TEXT" > /etc/issue.net
echo "$BANNER_TEXT" > /etc/motd

echo "[*] Configuring SSH banner... (3/4)"

if grep -q "^Banner" /etc/ssh/sshd_config; then
    sed -i 's|^Banner.*|Banner /etc/issue.net|' /etc/ssh/sshd_config
else
    echo "Banner /etc/issue.net" >> /etc/ssh/sshd_config
fi

echo "[*] Reloading SSH daemon... (4/4)"

systemctl reload sshd 2>/dev/null || systemctl reload ssh 2>/dev/null || service ssh reload 2>/dev/null

echo "[*] Banner setup complete."
