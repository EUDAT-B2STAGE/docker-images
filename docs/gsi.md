# Testing GSI

Testing the GSI authentication has been a requested feature
to allow user accounting towards the EUDAT REST HTTP API.

See related issue [#1](https://github.com/EUDAT-B2STAGE/docker-images/issues/1)

```bash

# Download the gsitest.yml file
wget https://raw.githubusercontent.com/EUDAT-B2STAGE/docker-images/master/usecases/gsitest.yml

# Set up
compose_com="docker-compose -f gsitest.yml"

################################
## Clean everything
$compose_com stop
$compose_com rm -f
# Remove previous container volumes if any
# Note: they start only with the 'gsi_' prefix
docker volume rm $(docker volume ls | grep gsi_ | awk '{print $2}')

################################
## Update, launch and check the stack
$compose_com pull
$compose_com up -d
$compose_com ps

################################
## Use the irods server shell
docker exec -it $($compose_com ps | grep _irods_ | awk '{print $1}') bash

## Install irods db, init the service, create and sign a guest certificate
irods@rodserver:~$ /init

################################
## Use the client to test the certificate
docker exec -it $($compose_com ps | grep _client_ | awk '{print $1}') bash
guest@flask:~$ ils
/tempZone/home/guest:

```
