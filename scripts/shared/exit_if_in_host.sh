source scripts/shared/messages.sh

# Error checking for whether script is run inside the devcontainer
REPO_NAME="$(basename "$PWD")"
if [ $REPO_NAME != 'workspace' ]; then
  running_inside_host_error
  exit 1
fi
