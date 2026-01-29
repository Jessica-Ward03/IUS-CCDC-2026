#!/bin/bash


SED_TARGET="/etc/selinux/config"
    
if [ -f "$SED_TARGET" ]; then
    sed -i 's/^SELINUX=.*/SELINUX=enforcing/' "$SED_TARGET"
    echo "Successfully updated $SED_TARGET"
else
    echo "Error: $SED_TARGET not found. Is SELinux installed?"
    exit 1
fi

# 2. Set current session to Enforcing (Immediate effect)
setenforce 1
    
echo "---------------------------------------"
echo "Current Status: $(getenforce)"
