# Wordpress - React

A Wordpress development environment for react typescript themes. This repo is 
your primary choice if you'd like to develop a **React Typescript based 
WordPress theme that runs in a devcontainer**.

## Usage

1. Clone the repo

1. Create an .env file with the following variables:

   - THEME_NAME: The name for the theme that you are developing
   - DB_USER: Username for wp's mysql access
   - DB_PASS: Password for wp's mysql access
   - DB_NAME: Name for the schema that wp will use
   - DB_ROOT_PASS: Mysql root user password

1. Run `bootstrap.sh` to set the theme name and get project dependencies

1. Start your devcontainer. Note that this may take a while as some packages will be added to the wp image (such as git).

1. Open localhost (or your ip, if you prefer that) and do the all-too-familiar WP setup.

1. Once the setup is done, go to wp-admin -> Appearance -> Themes and select your react theme. Its name will be "theme".

1. Visit your site and watch the spinning react logo.

## Scripts

The repo comes with a few helpful scripts that will automate common and 
cumbersome dev and backup tasks.

- `bootstrap.sh` helps you set your theme name and get your dependencies. Using
this script is recommended as without your theme name properly set, you will
have issues viewing your site.

- `docker_prune.sh` removes all containers, volumes, networks associates with your
development environment. It will also take a sql backup before removing the db
volume. This script takes some optional parameters:
  - `-n`, `--no-backup`: This will make the script disable automatic backup feature.
  - `-f`, `--filename` [filename]: Allows setting a custom filename for the backup 
  file. Read `db_backup.sh` section for details

- `theme_clean.sh` removes the files created by react wptheme scripts

- `build.sh` builds the theme and places it inside `build` directory

- `db_backup.sh` creates a backup of the wordpress db and places it inside `backups/sql` directory. If no particular filename is specified, the names of files generated will follow the pattern: `[date]-[time].sql`.
This script takes some optional params:
  - `-f`, `--filename` [filename]: Allows setting a custom filename for the backup file.

- `db_restore.sh` restores the latest or any other specified backup inside `backups/sql`. This script takes some optional params:
  - `-f`, `--filename` [filename]: Allows setting a custom sql file from which to
  restore the db data. If this value is not specified, the latest sql file will be restored.

## Repo management note

Please note that react source files are not a separate repository. This entire
codebase is governed as a single entity. This is different from regular react
repos where one folder above react src is typically the repo root.

## Acknowledgements

This repo uses
[create-react-wptheme](https://github.com/devloco/create-react-wptheme) by
devloco for wp and react integration.
