#!/bin/bash

# Install irods&friends
/install
# Launch irods after install
yes $IRODS_PASS | sudo -S /etc/init.d/irods start

################################
## Create and sign a user certificate on the iRODS server side
# More info on this guide:
# http://toolkit.globus.org/toolkit/docs/latest-stable/simpleca/admin/#simpleca-admin-installing

## CREATE AUTHORITY?
## there should be already one, actually
## check it with:
# grid-default-ca
## Other wise you should with something like
# grid-ca-create < $answers

echo "$GSI_USER" > /tmp/answers         # create answer
# create certificate for user guest
sudo su $GSI_USER -c "grid-cert-request -nopw < /tmp/answers"
# sign the certificate
certdir="/home/$GSI_USER/.globus"
sudo grid-ca-sign -in $certdir/usercert_request.pem -out $certdir/usercert.pem

# Note: the certificate is created inside the shared volume
# with the full path '/home/$USER/.globus/usercert_request.pem'

# Check certificate
echo "Check certificate"
sudo su $GSI_USER -c "openssl x509 -in ~/.globus/usercert.pem -noout -subject"
sleep 3

# ADD USER
iadmin mkuser $GSI_USER rodsuser
iadmin aua guest "$(openssl x509 -in $certdir/usercert.pem -noout -subject | sed 's/subject= //')"

echo "Check users and certificates"
iadmin lua
sleep 3
