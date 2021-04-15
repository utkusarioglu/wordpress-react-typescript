# Removes trailing slash and protocol from url string
function clean_url {
  URL=$1
  # Removes the trailing slash if there is one
  if [ "${URL: -1}" == "/" ]; then
      URL=${URL: 0: $(expr ${#URL} - 1)}
  fi
  # Removes prefixes if there are any
  PREFIXES=("http://" "https://")
  for prefix in ${PREFIXES[@]}; do
      if [ "${URL:0:${#prefix}}" == $prefix ]; then
          URL=${URL:${#prefix}:${#URL}}
      fi
  done
  echo $URL
}