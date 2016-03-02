
# Use cases for testing the eudat docker images

## Testing GSI

```bash

docker-compose -f gsitest.yml up -d

docker-compose ps

docker exec -it usecases_irods_1 bash
# You can now install everything with the script '/install'

docker exec -it usecases_client_1 bash

```