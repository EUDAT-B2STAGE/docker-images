
# Use cases for testing the eudat docker images

## Testing GSI

```bash

docker-compose -f gsitest.yml up -d

docker-compose ps

docker exec -it usecases_irods_1 bash
# You can now install everything with the script '/install'
# After install you can launch irods with:
# yes $IRODS_PASS | sudo -S /etc/init.d/irods start

docker exec -it usecases_client_1 bash

```