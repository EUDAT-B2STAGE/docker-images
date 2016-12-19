# Pyirods

(Compiling irods gsi and testing python irods client)

---

Note:
You must change [this line](docker.compose.yml#L36) to make the compose work
inside your enviroment.

STEP 0: Clone this repo and go inside the root directory

STEP 1: Bring up the server

```bash
cd usecases/irodsgsi

# Clean current instances
docker-compose stop; docker-compose rm -f

# Clean volumes
docker volume rm $(docker volume ls -q | grep "^gsi_")

# Init
docker-compose -f docker-compose.yml -f init.yml up icat

# Launch
docker-compose up -d

# Open root shell inside the icat server
docker-compose exec --user root icat bash

# Download and compile GSI for the first time
bash /compile.sh

```

STEP 2: To change something again something in GSI compiling

```bash
docker-compose exec --user root icat bash
cd /tmp/irods_auth_plugin_gsi-1.4
vi gsi/libgsi.cpp
# EDIT SOMETHING
packaging/build.sh && dpkg -i build/irods-auth*deb
```

STEP 3: Now you may open a client in another container
to start developing

```bash
docker-compose exec pyirods bash

python testgsi.py
```

To see logs in irods:

```bash
docker-compose exec icat tailf /var/lib/irods/iRODS/server/log/rodsLog*
```

