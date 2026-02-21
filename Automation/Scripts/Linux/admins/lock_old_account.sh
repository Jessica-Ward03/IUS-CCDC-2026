#!/usr/bin/env bash
set -euo pipefail

# Must be run as root
if [[ $EUID -ne 0 ]]; then
    echo "Please run as root or with sudo"
    exit 1
fi

read -rp "Enter the admin username to disable: " OLD_ADMIN

if ! id "$OLD_ADMIN" &>/dev/null; then
    echo "User does not exist."
    exit 1
fi

echo "Removing admin privileges (sudo/wheel if present)..."

# Ubuntu admin group
if getent group sudo >/dev/null; then
    gpasswd -d "$OLD_ADMIN" sudo 2>/dev/null || true
fi

# Fedora admin group
if getent group wheel >/dev/null; then
    gpasswd -d "$OLD_ADMIN" wheel 2>/dev/null || true
fi

echo "Disabling login shell..."
usermod -s /sbin/nologin "$OLD_ADMIN"

echo "Locking and expiring account..."
usermod -L "$OLD_ADMIN"
chage -E 0 "$OLD_ADMIN"

echo "Account has been disabled successfully."
