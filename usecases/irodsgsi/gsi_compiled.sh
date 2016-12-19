#!/bin/bash

# TO FIX: link missing libraries
cd /usr/lib/x86_64-linux-gnu/
ln -s libglobus_callout.so.0 libglobus_callout.so
ln -s libglobus_gss_assist.so.3 libglobus_gss_assist.so
ln -s libltdl.so.7 libltdl.so

# TO FIX: download from git and get ready to compile
cd /tmp
wget https://github.com/irods/irods_auth_plugin_gsi/archive/1.4.tar.gz
tar xvzf 1.4*
rm 1.4.tar*
cd irods_auth_plugin_gsi-1.4
sed -i '11s/boost/boost -I\/usr\/include\/globus/' Makefile.base

packaging/build.sh && dpkg -i build/irods-auth-plugin-gsi-1.4.deb


# su - guest
# export X509_CERT_DIR=/opt/certificates/caauth
# export X509_USER_CERT=/opt/certificates/guest/usercert.pem
# export X509_USER_KEY=/opt/certificates/guest/userkey.pem