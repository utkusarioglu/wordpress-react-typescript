source scripts/shared/check_env.sh
source .env
source scripts/shared/vars.sh
source scripts/shared/parse_args.sh
source scripts/shared/check_container_online.sh
source scripts/shared/exit_if_in_devcontainer.sh

check_container_online "${DB_CONTAINER_NAME}"

function get_activeplugins {
  PLUGINS_RAW=$(docker exec -it \
    "${DB_CONTAINER_NAME}" \
    bash -c "mysql -h 127.0.0.1 \
      -uroot \
      -proot \
      exampledb \
      -ss --raw -N -e \
      'SELECT option_value FROM wp_options WHERE option_name=\"active_plugins\"'" \
      | grep -v "Using a password")

  SPLAT=($(echo $PLUGINS_RAW | grep -oP '".*?"'))

  for i in "${SPLAT[@]}"
  do
    DASHED=$(echo $i | awk -F'["/]' '{print($2)}')
    echo ${DASHED//-/ }
  done;
}

parse_args_basic $@
get_activeplugins