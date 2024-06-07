#!/bin/env bash

echo -e "\e[1;30mThis error"
echo -e " -> docker: Error response from daemon: network lorekeeper_network not found."
echo -e "means you have to start the compose first with $ docker compose up -d\e[0m"
echo
echo -e "Starting interactive shell"
echo -e "Type 'exit' to stop"
echo
docker run \
       -it \
       -v $(pwd):/var/www/ \
       --workdir /var/www/ \
       --rm \
       --entrypoint=bash \
       --net lorekeeper_network \
       --env-file .env \
       --env-file docker/LK_docker.env \
       lorekeeper-lorekeeper_front
