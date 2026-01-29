#!/bin/bash
set -e

echo "=== Create Backup Admin Users ==="

# Must be run with sudo
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root or with sudo"
    exit 1
fi

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
else
    echo "Cannot detect OS"
    exit 1
fi

# Determine admin group
if [ "$ID" = "ubuntu" ]; then
    ADMIN_GROUP="sudo"
elif [ "$ID" = "fedora" ]; then
    ADMIN_GROUP="wheel"
else
    echo "Unsupported OS: $ID"
    exit 1
fi

create_admin() {
    local USERNAME="$1"

    if id "$USERNAME" &>/dev/null; then
        echo "User $USERNAME already exists. Skipping."
        return
    fi

    echo "Creating user $USERNAME..."
    useradd -m -s /bin/bash "$USERNAME"
    usermod -aG "$ADMIN_GROUP" "$USERNAME"

    echo "Set password for $USERNAME"
    passwd "$USERNAME"

    echo "✔ $USERNAME created and added to $ADMIN_GROUP"
    echo
}

# Get usernames
read -p "Enter backup admin 1 username: " BACKUP1
read -p "Enter backup admin 2 username: " BACKUP2

echo
create_admin "$BACKUP1"
create_admin "$BACKUP2"

echo "=== Done creating backup admins ==="
echo "IMPORTANT: Test login before disabling any other admins!"
