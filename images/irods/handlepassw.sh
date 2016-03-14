#!/bin/bash

##########################################
## IRODS USER PASSWORD

if [ -z "$oldp" ]; then
    echo "Don't know current password"
    exit 1
fi

rcfile="/home/$theuser/.bashrc"
pw="$oldp"

if [ "$newp" == "$oldp" ]; then
    echo "Main pw unchanged"
else
    if [ -z "$newp" ]; then
        echo "Empty [new] password! Skipping."
        sleep 2
    else
        pw="$newp"
        yes $newp | passwd $theuser 2> /dev/null
        if [ "$?" == "0" ]; then
            echo "Changed pw"
        else
            echo "Failed :/"
            exit 1
        fi
    fi
fi

# Fix bash rc
tmp="/tmp/bashrc"
echo "export IRODS_PASS=\"$pw\"" > $tmp
cat $rcfile >> $tmp
mv $tmp $rcfile
chown $theuser:$theuser $rcfile
echo "Exported passw"
