#!/bin/bash

# Install irods&friends
/install
# Launch irods after install
yes $IRODS_PASS | sudo -S /etc/init.d/irods start

################################
## Create and sign a user certificate on the iRODS server side
# More info on this guide:
# http://toolkit.globus.org/toolkit/docs/latest-stable/simpleca/admin/#simpleca-admin-installing

# It should be changed to EXPECT
answers="/tmp/answers"
echo "y" > $answers
echo "irods@rodserver" >> $answers
echo "99999" >> $answers
echo $IRODS_PASS >> $answers
echo $IRODS_PASS >> $answers

# create authority
grid-ca-create < $answers

# create certificate for user
grid-cert-request -nopw << EOF
guest
EOF

# I reply with a user 'paulie'

# Note: the certificate is created inside the shared volume
# with the full path '/home/irods/.globus/usercert_request.pem'

# sign the certificate
cd .globus/
echo $IRODS_PASS > $answers
grid-ca-sign -in usercert_request.pem -out usercert.pem < $answers

# clean answers
rm $answers
