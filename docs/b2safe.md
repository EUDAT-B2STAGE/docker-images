# The B2SAFE service

These are the instructions for emulating the [B2SAFE EUDAT service](http://www.eudat.eu/b2safe) inside a Docker container stack.

## Prerequisites

You need to install [docker-engine](https://docs.docker.com/engine/installation/) `v 1.9+` and [docker-compose](https://docs.docker.com/compose/install/) `v 1.5+`

```bash
# Create a directory for your project
cd ~
mkdir usecase
cd usecases

# Download the b2safe docker stack configuration
wget https://raw.githubusercontent.com/EUDAT-B2STAGE/docker-images/master/usecases/b2safe.yml
```

## Initialization

This phase is necessary only the very first time you prepare the service environment

```bash
# Setup the command
com="docker-compose -f b2safe.yml"

# Clean the environment
$com stop
$com rm -f

# Update container local images
$com pull

# Remove previous container volumes if any
docker volume rm EUDAT_VOLUMES_LIST

# Init the environment
$com run b2safe /install
```

## Run

Once you setup the environment with the initialization phase,
you may proceed to use the service:

```bash
# Bring the service up
$com up -d

# Check the container processes
$com ps
```