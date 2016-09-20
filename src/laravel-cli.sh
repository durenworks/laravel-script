#!/bin/bash

if [ "$(id -u)" -eq 0 ]; then
  echo 'This script can only run by user (non-root user)'
  exit 1
fi

source .env

PROJECT_DIR=$(pwd)

BASH_RC_FILE=$(mktemp)
trap "rm -f $BASH_RC_FILE" 0 2 3 15
echo "export PS1='\h:\w\$ '" > "$BASH_RC_FILE"

CACHE_DIR="${HOME}/.cache/docker-cache"
DOCKER_HOME_DIR="/home/user"
mkdir -p "${CACHE_DIR}"
mkdir -p "src/node_modules"

docker run -ti --rm \
  -v "${PROJECT_DIR}/src:/srv/web" \
  -v "${COMPOSE_PROJECT_NAME}_node_modules:/srv/web/node_modules" \
  -v "${BASH_RC_FILE}:/.bashrc" \
  -v "${CACHE_DIR}:${DOCKER_HOME_DIR}" \
  -w "/srv/web" \
  --link "${COMPOSE_PROJECT_NAME}_database_1:database" \
  --net "${COMPOSE_PROJECT_NAME}_default" \
  --user "${UID}" \
  -e "HOME=${DOCKER_HOME_DIR}" \
  "${LARAVEL_CLI_IMAGE}" bash --rcfile "/.bashrc" 
