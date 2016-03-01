#!/bin/bash

user=`whoami`
p1="/home/$user"
p2="/etc/$user"
p3="/var/lib/$user"

cd /tmp

########################################################
yes $IRODS_PASS | sudo -S echo "Enabling priviledges"
# Wait for sql init/creation
sleep 7

# ########################################################
# Using the volume
## Note: this should be removed when fixed the hack inside the dockerfile.
echo "Fix missing files for volumes"
sudo cp copy/etcirods/* $p2/

#########################################################
# Note: using docker volumes, it requires a permission fix, until:
#https://github.com/docker/docker/issues/7198
echo "Fixing permissions"
sudo chown -R $UID:$GROUPS $p1 $p2

#########################################################
# Connect server to DB and init
echo "Configure & connect"
MYDATA="/tmp/answers"
./expect_irods $MYDATA
sudo /var/lib/irods/packaging/setup_irods.sh < $MYDATA
if [ "$?" == "0" ]; then
    echo ""
    echo "iRODS INSTALLED!"
else
    echo "Failed to install irods..."
    exit 1
fi
echo "Fixing permissions again"
sudo chown -R $UID:$GROUPS $p1 $p2 $p3

#########################################################
# Install plugins

# This plugin requires db already initialized and connected.
# For this reason it cannot be used at image building
sudo -S dpkg -i $IRODSGSI_DEB
rm $IRODSGSI_DEB
echo "Installed GSI"

#########################################################
# Check if it works
sleep 5
echo "Testing"
yes $IRODS_PASS | ils 2> /dev/null
if [ "$?" -ne 0 ]; then
    echo "Failed. Please check your internet connection!"
else
	if [ -f $EXTRA_INSTALLATION_SCRIPT ]; then
		echo "Executing: extra configuration"
		$EXTRA_INSTALLATION_SCRIPT
	fi
    echo "Connected"
fi
