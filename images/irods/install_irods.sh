#!/bin/bash

paths="/home/$IRODS_USER /etc/$IRODS_USER /var/lib/$IRODS_USER /etc/grid-security"

########################################################
yes $IRODS_PASS | sudo -S echo "Enabling priviledges"

# Fix permissions
sudo chown -R $UID:$GROUPS $paths

# Handle password for main user and irods db
sudo \
    oldp=$IRODS_PASS newp=$DB_ENV_POSTGRES_PASSWORD \
    theuser=$IRODS_USER \
    /pass
if [ "$?" != "0" ]; then exit; fi

# Reload variables
source $HOME/.bashrc

# Wait for sql init/creation
echo "Waiting for postgres db to be ready..."
sleep 7

#########################################################
# Connect server to DB and init
cd /tmp

# Set up the irods installation answers
echo "Configure & connect"
MYDATA="/tmp/answers"
./expect_irods $MYDATA

# Launch the installation
sudo /var/lib/irods/packaging/setup_irods.sh < $MYDATA

# Verify how it went
if [ "$?" == "0" ]; then
    echo ""
    echo "iRODS INSTALLED!"
else
    echo "Failed to install irods..."
    exit 1
fi

#########################################################
# Install plugins

# This plugin requires db already initialized and connected.
# For this reason it cannot be used at image building
sudo -S dpkg -i $IRODSGSI_DEB
echo "Installed GSI"

#########################################################
# Refix permission one last time
echo "Fix permissions back"
sudo chown -R $UID:$GROUPS $paths

#########################################################
# Check if it works
sleep 3
echo "Testing"
yes $IRODS_PASS | ils 2> /dev/null
if [ "$?" -ne 0 ]; then
    echo "Failed to use irods commands!"
    echo "Please check your internet connection,"
    echo "as irods configuration need to be validated online..."
    exit 1
else
	if [ -f $EXTRA_INSTALLATION_SCRIPT ]; then
		echo "Executing: extra configuration"
		$EXTRA_INSTALLATION_SCRIPT
	fi
    echo "Connected"
fi

#########################################################
# Remove tmp
sudo rm -rf /tmp/*
