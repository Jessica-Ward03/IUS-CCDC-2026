#!/bin/bash

#ufw set up here

sudo ufw enable
#!! All ports will be closed !!

#start logs

sudo ufw logging high
#Can do full, but high should be good enough.

#Enter ports to add to ufw

sudo ./open_ports_ufw.sh
