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
    echo "Enter a new  password for $OLD_ADMIN before disabling:"
    read -s NEW_PASS
    echo
    read -s -p "Confirm password: " CONFIRM_PASS
    echo

    if [ "$NEW_PASS" != "$CONFIRM_PASS" ]; then
        echo "Passwords do not match. Exiting."
        exit 1
    fi

    echo "$OLD_ADMIN:$NEW_PASS" | chpasswd

    echo "Disabling $OLD_ADMIN..."
    usermod -L "$OLD_ADMIN"
    chage -E 0 "$OLD_ADMIN"

    echo "Account has been disabled."
else
    echo "User does not exist."

fi
