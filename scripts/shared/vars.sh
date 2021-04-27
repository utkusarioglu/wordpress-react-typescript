# This file contains variables relevant for more than one script file
# Be weary of altering these values without learning where they occur
# Not all (ie docker-compose) use variables to set these

source scripts/shared/check_env.sh
source .env

HOST_BACKUPS_DIR=backups/sql
HOST_UPLOADS_DIR=uploads
HOST_PLUGINS_DIR=plugins

THEME_SRC_DIR=theme/react-src

HOST_SCRIPTS=scripts/host
PRODUCTION_SCRIPTS=scripts/production

CONTAINER_BACKUPS_DIR=backups/sql

WP_CONTAINER_NAME=${THEME_NAME}__wp__dev
DB_CONTAINER_NAME=${THEME_NAME}__db__dev