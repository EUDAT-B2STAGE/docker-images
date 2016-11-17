#!/bin/bash

# Install irods&friends
/install

yes $IRODS_PASS | sudo -S echo "test"
touch /tmp/answers

# # Launch irods after install
# yes $IRODS_PASS | sudo -S /etc/init.d/irods start

################################
## Create and sign a user certificate on the iRODS server side

## IF NOT EXISTS

## Authority: there should be already one, see:
# grid-default-ca

# echo "1" > /tmp/answers
# sudo grid-ca-create -noint -dir /etc/grid-security/simpleca
# sudo mkdir -p /var/lib/globus
# sudo ln -s /etc/grid-security/simpleca /var/lib/globus/simple_ca
# sudo grid-default-ca < /tmp/answers

## IF EXISTS
sudo ln -s /var/lib/globus/simple_ca /etc/grid-security/simpleca

################################
## Host certificates
echo "y" > /tmp/answers
sudo grid-cert-request -host $HOSTNAME -force < /tmp/answers
echo "globus" > /tmp/answers
sudo grid-ca-sign -dir /etc/grid-security/simpleca \
        -in /etc/grid-security/hostcert_request.pem \
        -out /etc/grid-security/hostcert.pem < /tmp/answers

################################
## Fix volume permissions for irods/gsi
sudo chown $IRODS_USER:$IRODS_USER -R /etc/grid-security

#########################################################
## CERTIFICATES
certdir="/opt/certificates"
mkdir -p $certdir && sudo chown $IRODS_USER /opt/certificates

# Copy current certification authority for other containers
cadir="$certdir/caauth"
if [ ! -d "$cadir" ]; then
    sudo rm -rf $cadir && rsync -avq /etc/grid-security/certificates/ $cadir
    echo "Saved auth for outside containers"
fi

# Add a guest user for GSI certificates
rm -rf /opt/certificates/$GSI_USER \
    && /addusercert $GSI_USER
rm -rf /opt/certificates/$GSI_ADMIN \
    && /addusercert $GSI_ADMIN && iadmin moduser $GSI_ADMIN type rodsadmin

# Fix certificate permissions:
# they have to be owned by the same only user who asks as a client
sudo chown -R $UID:$GROUPS $certdir
