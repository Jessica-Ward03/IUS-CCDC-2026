#!/bin/bash

users=$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd)

if [ -z "$users" ]; then
    echo "No regular users found to change passwords for."
    exit 1
fi

echo "Users to update:"
echo "$users"
echo
read -p "Press Enter to continue or Ctrl+C to cancel..."
echo

success_count=0
fail_count=0

for user in $users; do
    echo
    echo "Changing password for user: $user"
    
    if passwd "$user"; then
        ((success_count++))
    else
        echo "[ERROR] Failed to change password for $user"
        ((fail_count++))
    fi
done

echo
echo "===== Summary ====="
echo "Successfully changed: $success_count"
echo "Failed: $fail_count"
echo "==================="
