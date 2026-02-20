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

##############################
# Ubuntu UFW
##############################

if [[ "$OS_ID" == "ubuntu" || "$OS_ID" == "debian" ]]; then
    echo "Using UFW..."

    if ! command -v ufw >/dev/null; then
        apt update
        apt install -y ufw
    fi

    ufw --force reset
    ufw default deny incoming
    ufw default allow outgoing

    ufw allow 123/udp

case "$ROLE" in
    1)
      echo "Ubuntu Workstation selected (NTP only)."
      ;;
    3)
      echo "Ubuntu E-commerce selected."
      ufw allow 80/tcp
      ufw allow 443/tcp
      ;;
    *)
      echo "Invalid role for Ubuntu."
      exit 1
      ;;
  esac

  ufw --force enable
  ufw status verbose
  exit 0
fi

##############################
# Fedora / Oracle (firewalld)
##############################

if [[ "$OS_ID" == "fedora" || "$OS_ID" == "ol" || "$OS_ID" == "oraclelinux" ]]; then
  echo "Using firewalld..."

  dnf install -y firewalld
  systemctl enable --now firewalld

  # Set sane defaults
  firewall-cmd --set-default-zone=public

  # Always allow NTP
  firewall-cmd --permanent --add-service=ntp

  case "$ROLE" in
    2)
      echo "Fedora Webmail selected."
      firewall-cmd --permanent --add-port=25/tcp
      firewall-cmd --permanent --add-port=110/tcp
      firewall-cmd --permanent --add-port=587/tcp
      ;;
    4)
      echo "Oracle Splunk selected."
      firewall-cmd --permanent --add-port=8000/tcp
      firewall-cmd --permanent --add-port=8089/tcp
      firewall-cmd --permanent --add-port=9997/tcp
      ;;
    *)
      echo "Invalid role for this OS."
      exit 1
      ;;
  esac

  firewall-cmd --reload
  firewall-cmd --list-all
  exit 0
fi

echo "Unsupported OS."
exit 1
