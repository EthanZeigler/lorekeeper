#!/bin/env bash

if [ ! -f ./.env ]; then
    echo "No '.env' found. Copy the example env file and name it '.env', then replace any necessary values before continuing"
    exit
fi


# anticipating that the cwd will be the root of the project, else it's not
# going to work right, but can't say i didnt warn them lol
docker build . -f ./docker/Dockerfile --target runtime -t lorekeeper:local
docker compose up lorekeeper_db -d
docker run \
       -it \
       -v $(pwd):/var/www/ \
       --rm \
       --entrypoint=bash \
       --net lorekeeper_network \
       --env-file .env \
       --env-file docker/LK_docker.env \
       lorekeeper:local \
       /var/www/docker/project_init_entrypoint.sh

docker compose down
