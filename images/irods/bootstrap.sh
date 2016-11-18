#!/bin/bash

##########################################
## CHECK if installation was enabled
if [ ! -f "/etc/irods/service_account.config" ]; then
    echo ""
    echo "FATAL: missing configuration files!"
    echo ""
    echo "Did you properly install iRODS?"
    echo "Please run the init phase, e.g."
    echo "$ ./do init"
    echo ""
fi

##########################################
## BOOT UP
source ~/.bashrc

# Enable sudo withouth password
yes $IRODS_PASS | sudo -S echo "privilege"

# Fix permissions, just to be sure
sudo chown -R $UID:$GROUPS /var/lib/$IRODS_USER

# Start irods
sudo /etc/init.d/irods start
if [ "$?" == "0" ]; then
    echo "iRODS online"
    # Leave a process open to let the container stay awake
    sleep infinity
else
    echo "Error launching irods..."
    exit 1
fi

##########################################
