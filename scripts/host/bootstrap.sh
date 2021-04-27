#!/bin/bash

source scripts/shared/check_env.sh
source .env
source scripts/shared/vars.sh
source scripts/shared/messages.sh
source scripts/shared/parse_args.sh

DEV_COMPOSE_FILE="${PWD}/docker-compose.dev.yaml"
THEMES_DIR=/var/www/html/wp-content/themes

function title {
  title_template "Bootstrap Api"
}

function commands_and_options {
  cat << EOF
Usage: wrt bootstrap [options]

Commands:
  (none)        Run the bootstrap operation

Options:
  -h, --help    Shows this help information

EOF
}

function do_bootstrap {
  echo "Setting theme name as ${THEME_NAME}..."
  cd $THEME_SRC_DIR
  sed -i "/homepage/c\  \"homepage\": \"\/wp-content\/themes\/$THEME_NAME\"," ./package.json
  # Notice that this one doesn't add a comma at the end
  sed -i "/homepage/c\  \"homepage\": \"\/wp-content\/themes\/$THEME_NAME\"" ./user.prod.json 

  echo "Starting containers..."
  docker-compose -f $DEV_COMPOSE_FILE up -d
  
  echo "Waiting for the containers to be ready..."
  WAIT=TRUE
  READY_STRING="resuming normal operations"
  while [ $WAIT == TRUE ]
  do
    if [ ! -z "$(docker logs "$WP_CONTAINER_NAME" 2>&1 | grep "$READY_STRING")" ]; then
      echo "Installing NPM packages using Yarn, this may take a while..."
      docker exec -it ${WP_CONTAINER_NAME} bash -c "cd ${THEMES_DIR}/${THEME_NAME}/react-src && yarn"
      docker-compose -f $DEV_COMPOSE_FILE down 
      WAIT=FALSE
    fi
  done
}

parse_args_basic $@
do_bootstrap
bootstrap_complete_message