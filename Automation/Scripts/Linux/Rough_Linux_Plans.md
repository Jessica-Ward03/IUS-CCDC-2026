# Rough CCDC Plans

# Todo

- Standardize the Linux distros to match the Ubuntu/Debian stuff. (Like UFW, etc)
- Need to get scripts done for Firewalls, passwords, and any tools (like Nmap)
- Collect a list of tools we need.
    1. Nmap
    2. Wireshark
    3. Maybe RK hunter?
    4. Any stuff to make distros distributed.
    5. Tools we will actually use.
    6. Splunk forwarders.
- Firewall wise
    1. Turn off unneeded ports.
    2. Maybe SSH/22?
- Splunk
    1. Windows using event viewer.
    2. Linux syslog
        - Fedora = /var/log/messages
        - Debain = /var/log/syslog
    3. Make sure that logging is enabled on the host systems (ufw, etc)

Tool use workflow

1. Make Distro's similar (uniform tools)
2. Namp > file.txt
3. UFW
    1. UFW by default denies all incoming. Should enable logging though.
    2. NMAP / list of ports on hand so we can reference when adjusting firewall.
    3. Either run a script to change ports, or manually add allowed ports.
4. Splunk??
