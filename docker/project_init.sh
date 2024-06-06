#!/bin/env bash

if [ ! -f ./.env ]; then
    echo "No '.env' found. Copy the example env file and name it '.env', then replace any necessary values before continuing"
    exit
fi

# Create docker storage locations
mkdir -p ${DOCKER_DATA_LOCATION}/mysql_data


# anticipating that the cwd will be the root of the project, else it's not
# going to work right, but can't say i didnt warn them lol
docker compose up lorekeeper_db -d
docker run \
       -it \
       -v $(pwd):/var/www/ \
       -f docker/Dockerfile \
       --rm \
       --target runtime \
       bash ./docker/project_init_entrypoint.sh

docker compose down
