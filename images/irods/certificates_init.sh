#!/bin/bash

# Install irods&friends
/install
# Launch irods after install
yes $IRODS_PASS | sudo -S /etc/init.d/irods start

################################
## Create and sign a user certificate on the iRODS server side
# More info on this guide:
# http://toolkit.globus.org/toolkit/docs/latest-stable/simpleca/admin/#simpleca-admin-installing

# create authority
grid-ca-create
# Note: you MUST specify a passphrase (e.g. 'paolo')

# create certificate for user
grid-cert-request -nopw
# I reply with a user 'paulie'

# Note: the certificate is created inside the shared volume
# with the full path '/home/irods/.globus/usercert_request.pem'

# sign the certificate
cd .globus/
grid-ca-sign -in usercert_request.pem -out usercert.pem
