function missing_argument_error {
  echo "Error: Argument for $1 is missing" >&2
}

function unsupported_flag_error {
  cat >&2 << EOF

Operation failed. "$1" is not a supported flag. 
Please review your options below:

EOF
}

function no_home_set_error {
  cat >&2 << EOF

Operation failed. There is no home setting in the database.
Please check that you have completed your WordPress setup.

EOF
}