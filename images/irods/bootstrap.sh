#!/bin/bash

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
