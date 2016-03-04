
# Use cases for testing the eudat docker images

A list of possible use case we tested inside the docker environment

## Testing GSI

Testing the GSI authentication in a first draft.

See related issue [#1](https://github.com/EUDAT-B2STAGE/docker-images/issues/1)

```bash

################################
## In case you want to clean everything
# WARNING - YOU WILL LOOSE EVERY DOCKER DATA YOU HAVE
docker rm -f $(docker ps -a -q);
docker volume rm $(docker volume ls -q)

################################
## Update, launch and check the stack
compose_com="docker-compose -f gsitest.yml"
$compose_com pull
$compose_com up -d
$compose_com ps

################################
## Open the irods server
$ docker exec -it usecases_irods_1 bash

## Install irods db, init the service, create and sign a certificate
irods@rodserver:~$ /init

################################
## Open the flask server
$ docker exec -it usecases_client_1 bash

# It should already work
root@flask:~$ su - guest
guest@flask:~$ ils

```