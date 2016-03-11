#!/bin/bash

##########################################
## IRODS USER PASSWORD

newp="$DB_ENV_POSTGRES_PASSWORD"
oldp="$IRODS_PASS"

if [ "$newp" == "$oldp" ]; then
    echo "Main pw unchanged"
else
    if [ -z "$newp" ]; then
        echo "Empty [new] password. Skipping."
        sleep 2
    else
        sudo su -c "echo 'IRODS_PASS=\"$newp\"' > /etc/environment"
        sudo su -c "yes $newp | passwd $IRODS_USER"
        if [ "$?" == "0" ]; then
            echo "Changed pw"
        else
            echo "Failed :/"
            exit 1
        fi
    fi
fi
