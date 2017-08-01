# PRC for Python 3

---

Note:
You must change [this line](docker.compose.yml#L54) before using the test case.

STEP 1: Clone this repo and go inside the root directory

```bash
git clone https://github.com/EUDAT-B2STAGE/docker-images.git dim && cd dim
```

STEP 2: Bring up the environment with Docker

```bash
cd usecases/prc3

# Clean current instances
docker-compose down -v

# Get the original irods available
git clone https://github.com/irods/python-irodsclient.git prc2

# Clean volumes
docker volume rm $(docker volume ls -q | grep "^prc3_")

# Init
docker-compose -f docker-compose.yml -f init.yml up icat

# Launch
docker-compose up -d
```

STEP 3: Use it

```bash
# check status
docker-compose ps

# Jump into prc2/prc3 container
docker-compose exec prc2 bash
docker-compose exec prc3 bash
# run tests:
# cd prc/irods/test/ && python runner.py 
```

To install requirements for running tests:

```bash
for container in prc2 prc3; do
    echo $container
    docker-compose exec --user root $container /bin/sh -c "pip install xmlrunner"
done
```

To see logs in irods:
```bash
docker-compose exec icat tailf /var/lib/irods/iRODS/server/log/rodsLog*
```
