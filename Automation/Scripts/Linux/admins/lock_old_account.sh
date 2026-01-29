#!/bin/bash
set -e

# Must be run with sudo
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root or with sudo"
    exit 1
fi

# Ask for admin to remove
read -p "Enter the admin username to disable: " OLD_ADMIN

if id "$OLD_ADMIN" &>/dev/null; then
    echo "Disabling $OLD_ADMIN..."
    usermod -L "$OLD_ADMIN"
    chage -E 0 "$OLD_ADMIN"

    echo "Account has been disabled."
else
    echo "User does not exist."
fi