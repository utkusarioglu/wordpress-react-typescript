function missing_argument_error {
  echo "Error: Argument for $1 is missing" >&2
}

function unsupported_flag_error {
  cat >&2 << EOF

Operation failed. "$1" is not a supported flag. 
Please review your options below:

EOF
}