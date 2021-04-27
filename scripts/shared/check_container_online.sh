source scripts/shared/messages.sh 

# Checks whether the container with the given name is among the running
# containers. exits with 1 after displaying an error if it's not.
# @param container name: the name of the container to be checked
function check_container_online {
  if [ -z "$(docker ps --format={{.Names}} | grep $1 )" ]; then
    db_container_offline $1
    exit 1
  fi
}
