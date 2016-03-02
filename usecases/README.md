
# Use cases for testing the eudat docker images

## Testing GSI

```bash

## Launch and check the stack
$ docker-compose -f gsitest.yml up -d
$ docker-compose -f gsitest.yml ps

## Open the irods server
$ docker exec -it usecases_irods_1 bash

# You can now install everything with the init script '/install'
irods@rodserver:~$ /install

# After install you can launch irods with:
irods@rodserver:~$ yes $IRODS_PASS | sudo -S /etc/init.d/irods start

# Also change permission for the volume
irods@rodserver:~$ yes $IRODS_PASS | sudo -S chown irods:irods /home/irods/.globus

## Open the flask server
$ docker exec -it usecases_client_1 bash
# Requires iinit
root@flask:~$ iinit

```