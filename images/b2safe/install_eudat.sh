#!/bin/bash

#####################################
yes $IRODS_PASS | sudo -S echo "Enabling priviledges"

#####################################
# Resources
echo "Fix resources"
iadmin rmresc demoResc
# Create resources dirs
sudo chown -R $UID:$GROUPS $RESOURCES_DIR
mkdir -p $MAINRES_DIR $REPLICA_DIR
# Create resources
iadmin mkresc $MAINRES unixfilesystem $IRODS_HOST:$MAINRES_DIR
iadmin mkresc $REPLICARES unixfilesystem $IRODS_HOST:$REPLICA_DIR
# Set new default
sed -i "4s/demoResc/$MAINRES/" ~/.irods/irods_environment.json
sed -i "15s/demoResc/$MAINRES/" /etc/irods/server_config.json

# TO DO

## source:http://irods.org/post/configuring-irods-for-high-availability/#.VktEE98veGg
# iadmin mkresc BaseResource replication
# iadmin mkresc Resource1 'unixfilesystem' Resource1.example.org:/var/lib/irods/Vault
# iadmin mkresc Resource2 'unixfilesystem' Resource2.example.org:/var/lib/irods/Vault
# iadmin addchildtoresc BaseResource Resource1
# iadmin addchildtoresc BaseResource Resource2
# ilsresc --tree

#####################################
## B2SAFE SERVICE

# Install package
yes $IRODS_PASS | sudo -S dpkg -i /tmp/debbuild/irods*.deb
echo "Install successful. Ready to configure."

# Configure
sudo chown -R $UID:$GROUPS /opt/*
cd /opt/eudat/b2safe/packaging
source $HANDLECONF

# This will change dynamic parameters
keytochange='CHANGEME'
sudo chown $UID $EUDAT_CONFIGF
sed -i "14s/$keytochange/$MAINRES/" $EUDAT_CONFIGF
sed -i "19s/$keytochange/$HOSTNAME/" $EUDAT_CONFIGF
sed -i "22s/$keytochange/$HANDLE_BASE/" $EUDAT_CONFIGF
sed -i "23s/$keytochange/$HANDLE_USER/" $EUDAT_CONFIGF
sed -i "24s/$keytochange/$HANDLE_PREFIX/" $EUDAT_CONFIGF
cp $EUDAT_CONFIGF install.conf

# Install b2safe mod
PASSFILE='mypass'
echo $HANDLE_PASS > $PASSFILE
./install.sh < $PASSFILE
rm $PASSFILE

# Check scripts
cd /opt/eudat/b2safe/cmd
nohup ./authZmanager.py -h \
    && nohup ./epicclient.py --help \
    && nohup ./logmanager.py -h \
    && nohup ./messageManager.py -h \
    && nohup ./metadataManager.py -h \
    && echo "EUDAT setup completed"

################################
## Add and validate the B2ACCESS certification authority
cadir="/opt/certificates/caauth"
# echo "LET'S TRY"
# sleep 3

## DEV
cp /tmp/b2access.ca.dev.* $cadir/
cd /opt/certificates/caauth
caid=$(openssl x509 -in b2access.ca.dev.pem -hash -noout)
echo "Label is $caid"
mv b2access.ca.dev.pem ${caid}.0
mv b2access.ca.dev.signing_policy ${caid}.signing_policy
sudo chown -R irods:irods /opt/certificates /tmp/*
cp /opt/certificates/caauth/$caid* /etc/grid-security/certificates/

## PROD

# to do...
# sleep 20
