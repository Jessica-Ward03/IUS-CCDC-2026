#!/usr/bin/env bash

set -e

# Root check
if [[ $EUID -ne 0 ]]; then
    echo "Run as root (sudo)."
    exit 1
fi

echo "===== Initial System Hardening ====="

# Password change
echo
echo "You will now be prompted to change the default user's password."
passwd "${SUDO_USER:-$USER}"

# Detect OS
. /etc/os-release
OS_ID=$ID

echo
echo "Detected OS: $NAME"

# Endpoint selection
echo
echo "Select endpoint:"
echo "1) Ubuntu Workstation"
echo "2) Fedora Webmail"
echo "3) Ubuntu E-commerce"
echo "4) Oracle Splunk"

read -rp "Enter choice [1-4]: " ROLE

################################
# Install & Use UFW Everywhere
################################

echo
echo "Installing and configuring UFW..."

# Install UFW depending on distro
if [[ "$OS_ID" == "ubuntu" || "$OS_ID" == "debian" ]]; then
    apt update
    apt install -y ufw
elif [[ "$OS_ID" == "fedora" || "$OS_ID" == "ol" || "$OS_ID" == "oraclelinux" ]]; then
    dnf install -y ufw

    # Disable firewalld if it exists
    if systemctl list-unit-files | grep -q firewalld; then
        systemctl disable --now firewalld || true
    fi
else
    echo "Unsupported OS."
    exit 1
fi

# Reset UFW
ufw --force reset
ufw default deny incoming
ufw default allow outgoing

# Always allow NTP
ufw allow 123/udp

################################
# Role-based rules
################################

case "$ROLE" in
    1)
        echo "Ubuntu Workstation selected."
        ufw allow 8089/tcp
        ;;
    2)
        echo "Fedora Webmail selected."
        ufw allow 25/tcp
        ufw allow 110/tcp
        ufw allow 587/tcp
        ufw allow 8089/tcp
        ;;
    3)
        echo "Ubuntu E-commerce selected."
        ufw allow 80/tcp
        ufw allow 443/tcp
        ufw allow 8089/tcp
        ;;
    4)
        echo "Oracle Splunk selected."
        ufw allow 8000/tcp
        ufw allow 8089/tcp
        ufw allow 9997/tcp
        ;;
    *)
        echo "Invalid selection."
        exit 1
        ;;
esac

# Enable UFW
ufw --force enable
ufw status verbose

echo
echo "===== Hardening Complete ====="
