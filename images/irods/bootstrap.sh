#!/bin/bash

# Enable sudo withouth password
yes $IRODS_PASS | sudo -S echo "privilege"
# Remove tmp
sudo rm -rf /tmp/*
# Fix permissions
sudo chown $UID:$GROUPS -R /var/lib/irods
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
