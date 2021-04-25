#!/bin/bash

source /scripts/clean_url.sh

# Returns the currently active home url value from the wordpress database
# ! function gets the db access params from environment variables supplied by docker
function get_home_url() {
  read -r -d '' GET_HOME_QUERY << EOM
  SELECT option_value 
  FROM wp_options 
  WHERE option_name = 'home';
EOM

  CURRENT_URL=$(mysql -s -N \
    --user="$MYSQL_USER" \
    --password="$MYSQL_PASSWORD" \
    --database="$MYSQL_DATABASE" \
    --execute="$GET_HOME_QUERY")
  CURRENT_URL=$(clean_url $CURRENT_URL)
  echo $CURRENT_URL
}