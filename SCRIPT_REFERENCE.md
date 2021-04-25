# Wrt Scripts Reference

Wrt comes with some helpful utilities which you can use for populating your own
production scripts.

## check_env.sh

Checks whether the `.env` file and the required variables inside it exists.
Exits with 1 if the conditions don't hold.

```bash
source scripts/shared/check_env.sh
```

## check_ownership.sh

The file contains a function named `check_ownership` that checks whether the
given folder name has the same owner as the user. Note that this function cannot
check nested paths.

```bash
source /scripts/shared/check_ownership.sh
check_ownership $PATH_TO_CHECK
```

## exit_if_in_devcontainer.sh

Checks whether the root folder name is workspace as per vscode devcontainer
settings. If it is, the script concludes that it's being run inside a
devcontainer and quits execution

```bash
source /scripts/shared/exit_if_in_devcontainer.sh
```

## exit_if_in_host.sh

Checks whether the root folder name is workspace as per vscode devcontainer
settings. If it is not, the script concludes that it's being run inside the host
and quits execution.

```bash
source /scripts/shared/exit_if_in_host.sh
```

## parse_args.sh

Contains functions for helping you parse your sub-commands and flags.

### parse_args_basic

Introduces the essential flags into the endpoint you are building. To find a
list of the arguments covered, please check function reference for
`parse_args_essential`. This function uses `parse_args_essential` internally to
provide the essential argument coverage.

If you need an example to understand how this function is used, You can check
`scripts/host/bootstrap.sh`. There are many other examples you can find inside
the `scripts` folder.

```bash
source /scripts/shared/parse_args.sh
parse_args_basic $@
```

### parse_args_essential

Allows you to implement the essential arguments inside your custom argument
parsing schemes. This method helps you abstract away these essential arguments
from your code. If you don't have any arguments beyond these essentials, have a
look at `parse_args_basic` function.

You can see multiple examples of how this function is used effectively inside
the scripts folder. One example of this is `./wrt.sh`.

Args covered in `parse_args_essential`:

| Arg            | Definition                                            |
| -------------- | ----------------------------------------------------- |
| `-h`, `--help` | Produce documentation string through use of $1 and $2 |
| `-*`, `--*=`   | Return unsupported flag error                         |
| `*`            | Return unsupported command error                      |

Arguments for `parse_args_essential`:

| Position | Description                                                                              |
| -------- | ---------------------------------------------------------------------------------------- |
| $1       | Title for your api. This is used for printing the title of your api when help is invoked |
| $2       | Commands and options of your api                                                         |
| $@       | Case arguments, this is required for the function to work as expected                    |

```bash
source /scripts/shared/parse_args.sh

function parse_args {
  PARAMS=""
  while (( "$#" )); do
    case "$1" in
      # your custom commands and flags go here

      *)
        parse_args_essential $1 $2 $@
    esac
  done
  eval set -- "$PARAMS"
}
```

## sanitize_sql_filename.sh

Contains a function called `sanitize_sql_filename` which check whether the given
string contains `.sql` extension at the end. If not, it adds the extension and
returns the altered string.

## vars.sh

Contains the variables that are used by many scripts in this repo. You can use
these to integrate your scripts much better with the rest of the repo.

Note that changing these values may break things. Check `docker-compose` and
`devcontainer` files before you decide to make any changes to these values to
make sure that there are no inconsistencies between `vars.sh` and these other
files.
