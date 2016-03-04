
# Use cases for testing the eudat docker images

A list of possible use case we tested inside the docker environment

## Testing GSI

Testing the GSI authentication in a first draft.

See related issue [#1](https://github.com/EUDAT-B2STAGE/docker-images/issues/1)

```bash

################################
## In case you want to clean everything
# WARNING - YOU WILL LOOSE EVERY DOCKER DATA YOU HAVE
$ docker rm -f $(docker ps -a -q);
$ docker volume rm $(docker volume ls -q)

################################
## Launch and check the stack
$ docker-compose -f gsitest.yml up -d
$ docker-compose -f gsitest.yml ps

################################
## Open the irods server
$ docker exec -it usecases_irods_1 bash

# You can now install everything with the init script '/install'
irods@rodserver:~$ /install

# After install you can launch irods with:
irods@rodserver:~$ yes $IRODS_PASS | sudo -S /etc/init.d/irods start

################################
## Create and sign a user certificate on the iRODS server side

# More info on this guide:
# http://toolkit.globus.org/toolkit/docs/latest-stable/simpleca/admin/#simpleca-admin-installing

# create authority
irods@rodserver:~$ grid-ca-create
# Note: you MUST specify a passphrase (e.g. 'paolo')

# create certificate for user
irods@rodserver:~$ grid-cert-request -nopw
# I reply with a user 'paulie'

# Note: the certificate is created inside the shared volume
# with the full path '/home/irods/.globus/usercert_request.pem'

# sign the certificate
irods@rodserver:~$ cd .globus/
irods@rodserver:~$ grid-ca-sign -in usercert_request.pem -out usercert.pem

To sign the request
please enter the password for the CA key:

The new signed certificate is at: /home/irods/.globus/simpleCA/newcerts/01.pem

################################
## Open the flask server
$ docker exec -it usecases_client_1 bash

# Check the globus certificates
root@flask:~$ ls /home/irods/.globus

simpleCA  usercert.pem  usercert_request.pem  userkey.pem

# To connect to the irods server
# you may copy the irods user configuration from the shared volume
root@flask:~$ cp -r /home/irods/.irods ~/

root@flask:~$ ils
Enter your current iRODS password:

```