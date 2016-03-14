#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage $0 SCRIPT_NAME"
    exit 1
fi

# Clean
SCRIPT=$1
rm -rf $SCRIPT && touch $SCRIPT
# account
echo "$IRODS_USER" >> $SCRIPT
# group
echo "$IRODS_USER" >> $SCRIPT
# zone
echo "tempZone" >> $SCRIPT
# port
echo "1247" >> $SCRIPT
# range begin
echo "20000" >> $SCRIPT
# range end
echo "20199" >> $SCRIPT
# vault
echo "/var/lib/irods/Vault" >> $SCRIPT
# zone key
(openssl rand -base64 16 2>/dev/null | sed 's,/,S,g' | sed 's,+,_,g' \
    | cut -c 1-16  | tr -d '\n' ; echo "") >> $SCRIPT
# negotation key
openssl rand -base64 32 2> /dev/null | sed 's,/,S,g' | sed 's,+,_,g' | cut -c 1-32 \
    >> $SCRIPT
# control plane port
echo "1248" >> $SCRIPT
# control plane key
openssl rand -base64 32 2> /dev/null | sed 's,/,S,g' | sed 's,+,_,g' | cut -c 1-32 \
    >> $SCRIPT
# schema
echo "https://schemas.irods.org/configuration" >> $SCRIPT
# account username
echo "rods" >> $SCRIPT
# account password
echo "$IRODS_PASS" >> $SCRIPT
# Last confirmation
echo "yes" >> $SCRIPT

##############################
# DB accounting

# server host name
echo $DB_NAME | sed 's/\/[a-z_0-9]\+\///' >> $SCRIPT
# db port
echo $DB_PORT | sed 's/tcp\:.\+\://' >> $SCRIPT
# database name
echo "$DB_ENV_POSTGRES_DB" >> $SCRIPT
# database username
echo "$DB_ENV_POSTGRES_USER" >> $SCRIPT
# database password
echo "$IRODS_PASS" >> $SCRIPT
# Last confirmation
echo "yes" >> $SCRIPT

echo "DONE"