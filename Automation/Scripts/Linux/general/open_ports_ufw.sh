#!/bin/bash

#Check currently used services.

echo "---Current Services and their ports---"
sudo lsof -i -P -n

echo "--- UFW Port Opener ---"
echo "Enter the port numbers you wish to open."
echo "Type any non-number (e.g., 'exit' or 'done') to quit."
echo "-----------------------"

while true; do
    read -p "Enter port number: " USER_INPUT

    # Check if the input is a positive integer
    if [[ "$USER_INPUT" =~ ^[0-9]+$ ]]; then
        ufw allow "$USER_INPUT"
    else
        echo "Non-number detected. Exiting script."
        break
    fi
done

# Show current status and the newly added rules
ufw status
