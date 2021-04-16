# Wordpress - React - Typescript

A Wordpress development environment for React + Typescript themes. This repo is
your primary choice if you'd like to develop a **React Typescript based
WordPress theme that runs in a devcontainer**.

## Usage

### Usage with a new project

This is the list you should follow if you are using this repo to start a new
project.

1. Use the template to create your own repo, then clone it on your dev machine.

1. Create an `.env` file with the following variables:

   - `THEME_NAME`: The name for the theme that you are developing
   - `DB_USER`: Username for WordPress' MySql access
   - `DB_PASS`: Password for WordPress' MySql access
   - `DB_NAME`: Name for the schema that WordPress will use
   - `DB_ROOT_PASS`: MySql root user password

1. Run `bootstrap.sh` to set the theme name and get project dependencies

1. Start your devcontainer. Note that this may take a while as some packages
   will be added to the WordPress image (such as Git).

1. If you have a WordPress database backup, you can include the steps from the
   section **Usage with pre-existing database image** at this step. If you do,
   the next step may not apply for your case.

1. Open localhost (or your ip, if you prefer that) and do the all-too-familiar
   WordPress setup.

1. Once the setup is done, go to wp-admin -> Appearance -> Themes and select
   your React theme. Its name will be "theme".

1. Visit your site or press F5\* and watch the spinning React logo.

### Usage with a pre-existing React project

This is the list you should follow if you are adapting a pre-existing React
project as a WordPress theme.

1. Follow the points 1, 2 and 3 from section **Usage with a new project**.

1. Copy the `src` content of the pre-exiting React project inside `src` folder
   of this repo. Please note that you are only copying the `src` folder, not the
   entire React project.

1. Copy files from `public` folder into this repo's `public` folder. Note that
   this repo contains a `style.css` file that is not normally needed by React.
   However, WordPress uses stylesheets to validate its themes. Make sure that
   the file provided by this repo or some legally formatted `style.css` is
   available in `public`. WordPress doesn't require this file to be imported by
   `index.html`.

1. Adapt the `package.json` of this repo with the dependencies and other
   properties of the pre-existing React project's `package.json`.

1. Start your devcontainer. Note that this may take a while as some packages
   will be added to the WordPress image (such as Git).

1. If you have a WordPress database backup, you can include the steps from the
   section **Usage with pre-existing database image** at this step.

1. Go to wp-admin -> Appearance -> Themes and select your React theme. Its name
   will be the name specified in `style.css`.

1. Visit your site or press F5\* and see your pre-existing React project being
   served by WordPress.

### Usage with a pre-existing WordPress database image

If you want to use a pre-existing WordPress database image, follow the steps
below:

1. Place your db backup in `backups/sql` and run `db_restore.sh`. You can refer
   to the **Scripts** section of this readme to learn more about the usage of
   the said script.

1. You may have the need to update the WordPress home url. For this, you can run
   `db_replace_url.sh` to correct the previous WordPress home url with the one
   you want to use for your dev environment. This may be localhost or some
   ip/url you'd like to set. Please refer to **Scripts** section of this readme
   to learn more about the said script.

## Scripts

The repo comes with some few helpful scripts that will automate common and
cumbersome dev and backup tasks.

- `bootstrap.sh` helps you set your theme name and get your dependencies. Using
  this script is recommended as without your theme name properly set, you will
  have issues viewing your site.

- `docker_prune.sh` removes all containers, volumes, networks associated with
  your development environment. It will also take a sql backup before removing
  the db volume. This script takes some args:

  - `-n`, `--no-backup` (optional): This will make the script disable automatic
    backup feature.
  - `-f`, `--filename` `[filename]` (optional): Allows setting a custom filename
    for the backup file. Read `db_backup.sh` section for details

- `theme_clean.sh` removes runtime files created by React WordPress theme
  scripts.

- `theme_build.sh` builds the WordPress theme and places it inside `build`
  directory.

- `db_backup.sh` creates a backup of the WordPress database and places it inside
  `backups/sql` directory. If no particular filename is specified, the names of
  files generated will follow the pattern: `[date]-[time].sql`. This script
  takes some args:

  - `-f`, `--filename` `[filename]` (optional): Allows setting a custom filename
    for the backup file.

- `db_restore.sh` restores the latest or any other specified backup inside
  `backups/sql`. This script takes some args:

  - `-f`, `--filename` `[filename]` (optional): Allows setting a custom sql file
    from which to restore the db data. If this value is not specified, the
    latest sql file will be restored.

- `db_replace_url.sh` replaces the current WordPress home url with the url
  specified. This script takes a single arg:
  - `-n`, `--new-url` `[url]`: The url that will be written instead of WordPress
    home url

## Repo management note

Please note that React source files are not a separate repository. This entire
codebase is governed as a single entity. This is different from regular React
projects where one folder above React src is typically the repo root.

## Acknowledgements

This repo uses
[create-react-wptheme](https://github.com/devloco/create-react-wptheme) by
devloco for WordPress and React integration.

---

\*: This requires Chrome extension to be installed
