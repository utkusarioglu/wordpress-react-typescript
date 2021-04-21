source scripts/shared/messages.sh

# Common argument options can be placed in this loop,
# such as -h, --help and responses for faulty flags and commands
function parse_args_essential {
  PARAMS=""
  while (( "$#" )); do
    case "$3" in
      -h|--help)
        $1
        $2
        exit
        ;;

      -*|--*=) # unsupported flags
        unsupported_flag_error "$3"
        $2
        exit 1
        ;;

      *) # preserve positional arguments
        PARAMS="$PARAMS $3"
        unsupported_command_error "$3"
        $2
        exit 1
        ;;
    esac
  done
  eval set -- "$PARAMS"
}

function parse_args_basic {
  PARAMS=""
  while (( "$#" )); do
    case "$1" in
      *)
        parse_args_essential title commands_and_options $@
    esac
  done
  eval set -- "$PARAMS"
}