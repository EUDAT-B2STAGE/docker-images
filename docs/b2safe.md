# The B2SAFE service

These are the instructions for emulating the [B2SAFE EUDAT service](http://www.eudat.eu/b2safe) inside a Docker container stack.

## Prerequisites

You need to install [docker-engine](https://docs.docker.com/engine/installation/) `v 1.9+` and [docker-compose](https://docs.docker.com/compose/install/) `v 1.5+`

```bash
# Download the b2safe docker stack configuration
wget https://raw.githubusercontent.com/EUDAT-B2STAGE/docker-images/master/usecases/b2safe.yml
```

Please remeber the file system path where you download this file.
From now one every command should be executed from the same path.

```bash
# See what is the current path
$ pwd
/opt/b2safe_docker
```

## Customization

The YAML file `b2safe.yml`, downloaded in the previous command,
will describe the stack to run the B2SAFE service.

There will be two main containers.

1. One will be the Postgresql database server needed from iRODS to store the metadata.

2. The other will be the iRODS server with the B2SAFE service installed

You will always find an `irods` user to administrate any part of the service,
both as Postgresql admin for the `ICAT` database, or as UNIX user, with sudo privileges.

To change the main password for all the accounts, you may edit the YAML file,
changing the value of the `POSTGRES_PASSWORD` variable.

By default it will be set to:
```yaml
  POSTGRES_PASSWORD: mysecretpassword
```

## Initialization

This phase is necessary only the very first time you prepare the service environment

```bash
# Setup the command in your current shell
com="docker-compose -f b2safe.yml"

# Clean the environment
$com stop
$com rm -f

# Update container local images
$com pull

# Remove previous container volumes if any
# Note: they start only with the 'b2safe_' prefix
docker volume rm $(docker volume ls | grep b2safe_ | awk '{print $2}')

# Init the environment
$com run b2safe /install
```

## Run

Once you setup the environment with the initialization phase,
you may proceed to use the service:

```bash
# Bring the service up
$com up -d

# Check the container processes currently running
$com ps
```

## Open a shell inside containers

The `docker exec` command will allow you to open a bash inside any running container:

```bash
# access the iRODS (b2safe) server
docker exec -it $(docker ps | grep _b2safe_ | awk '{print $NF}') bash
irods@rodserver:~$

# access the Postgresql server
docker exec -it $(docker ps | grep _sql_ | awk '{print $NF}') bash
root@psql:/#
```

## Connect to iRODS with a client

The docker compose stack will open the default port `1247`.

