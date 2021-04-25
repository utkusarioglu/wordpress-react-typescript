# Wrt Api

Wordpress - React - Typescript Api entrypoint is `./wrt.sh`. For readability,
the rest of this guide is going to assume that the following alias is set:

```bash
alias wrt="./wrt.sh"
```

## Getting command line help

All methods with some exceptions under the `production` api, offer help
documentation through `-h` and `--help` flags. You can refer to these for
on-the-fly refreshers.

## Top-level api: wrt [options] [command]

The top-level api consists of the following commands:

| Command    | Action                                                                     |
| ---------- | -------------------------------------------------------------------------- |
| (none)     | Show help information                                                      |
| bootstrap  | Set the theme name and download the dependencies                           |
| db         | Tools for managing the WordPress MySQL database                            |
| docker     | Manage your project's Docker containers                                    |
| production | Communicate with the project's production environment, pull and push items |
| theme      | Build, clean, package the theme                                            |

| Flags      | Params | Action                |
| ---------- | ------ | --------------------- |
| -h, --help |        | Show help information |

### wrt bootstrap [options]

Sets the theme name using the `.env/THEME_NAME` variable in multiple locations.
It will also install all the NPM dependencies by using yarn.

| Command | Action                      |
| ------- | --------------------------- |
| (none)  | Run the bootstrap operation |

| Flags      | Params | Action                |
| ---------- | ------ | --------------------- |
| -h, --help |        | Show help information |

### wrt db [options] [command]

Hierarchical parent for controlling devcontainer for WordPress database. The
children consist of the following commands:

| Command          | Action                                         |
| ---------------- | ---------------------------------------------- |
| (none)           | Show help information                          |
| backup           | Create a backup of the current wp database     |
| get-home-url     | Return the currently active WordPress home url |
| restore          | Restore a sql backup to your wp instance       |
| replace-home-url | Replace the wp home url                        |

| Flags      | Params | Action                |
| ---------- | ------ | --------------------- |
| -h, --help |        | Show help information |

#### wrt db backup [options]

Creates a sql backup of the development environment WordPress MySQL database. By
default, the created file will have a name with the format: `[date]-[time].sql`.
However, it's possible to define a custom name through the flag `-f`.

| Command | Action                      |
| ------- | --------------------------- |
| (none)  | Run the db backup operation |

| Flags          | Params         | Action                                                   |
| -------------- | -------------- | -------------------------------------------------------- |
| -f, --filename | [sql filename] | Custom filename for the backup file that will be created |
| -h, --help     |                | Show help information                                    |

#### wrt db get-home-url [options]

Returns the currently active WordPress home url. If this setting doesn't
coincide with the url that you are using to browse to your site, then you won't
be able to so open most pages as WordPress will redirect the request to the home
url. You can change the home url setting to any address that you need using
`wrt db replace-home-url` api.

| Command | Action                                         |
| ------- | ---------------------------------------------- |
| (none)  | Return the currently active WordPress home url |

| Flags      | Params | Action                |
| ---------- | ------ | --------------------- |
| -h, --help |        | Show help information |

#### wrt db replace-home-url [options]

Replaces the WordPress `home` url value in settings, posts and all other places
it appears. By default, the api will replace `home` with `localhost` but it's
possible to define a custom value through the flag `-n`.

If you are doing development on a pre-existing database image, it's possible
that you may see your url being rewritten, followed by your browser telling you
the page is not working. This is because WordPress is redirecting your browser
using the `home` value inside `wp_options` schema, which results in a failing
page load. Replacing the `home` url fixes this issue.

After the development on your WordPress project is complete, you may have the
need to run the same command to replace your dev address with your site's public
address. Otherwise, your production instance may redirect the client browser to
`localhost` or any other setting you use in your dev environment.

| Command | Action                            |
| ------- | --------------------------------- |
| (none)  | Run the url replacement operation |

| Flags         | Params | Action                                               |
| ------------- | ------ | ---------------------------------------------------- |
| -n, --new-url | [url]  | Url to which the current home url shall be corrected |
| -h, --help    |        | Show help information                                |

#### wrt db restore [options]

Restores a sql image placed inside `backups/sql` directory. By default, this
command will restore the most recent image by creation date inside the
directory. But it's possible to set a particular restoration file through the
flag `-f`.

| Command | Action                       |
| ------- | ---------------------------- |
| (none)  | Run the db restore operation |

| Flags          | Params         | Action                      |
| -------------- | -------------- | --------------------------- |
| -f, --filename | [sql filename] | Restores the given sql file |
| -h, --help     |                | Show help information       |

### wrt docker [options] [command]

This repo creates a devcontainer environment for your WordPress project,
ensuring isolation between the host machine and the development. Which means
that, as long as this repo is used in the way it was intended, you will have 2
containers running:

- ${THEME_NAME}\_\_wp\_\_dev: WordPress container
- ${THEME_NAME}\_\_db\_\_dev: MySQL container

Wrt provides you with some tools to handle containerization details.

| Command | Action                                                                           |
| ------- | -------------------------------------------------------------------------------- |
| (none)  | Show help information                                                            |
| prune   | Remove containers, volumes and networks associated with your wrt dev environment |

| Flags      | Params | Action                |
| ---------- | ------ | --------------------- |
| -h, --help |        | Show help information |

Well, just one tool for now...

#### wrt docker prune [options]

By default, this repo does not clean up its devcontainers. Instead, you are
offered the `prune` api to easily stop and remove the containers, volumes, and
networks associated with your development environment.

Before the removal, the command also takes a database backup and puts it inside
`backups/sql`.

| Command | Action                                                    |
| ------- | --------------------------------------------------------- |
| (none)  | Take a sql backup and then run the docker prune operation |

| Flags                 | Params         | Action                     |
| --------------------- | -------------- | -------------------------- |
| -n, --no-backup       |                | Skip taking the sql backup |
| -b, --backup-filename | [sql filename] | Set custom sql filename    |
| -h, --help            |                | Show help information      |

### wrt production [options] [command]

Api for controlling production side for your project. This api mostly consists
of placeholder scripts which you can alter to create an intuitive access to your
production files and settings.

This repo was written with the assumption that after the development is
complete, the WordPress theme and the sql data created will be running on a
traditional environment with no containers, no orchestration and just a single
instance. So, the api was designed to account for pulling and pushing uploads,
theme, and other components of the WordPress production in pieces.

Though I see no reason why this repo could not be adapted to service a more
scalable architecture. A Docker / Kubernetes push endpoint for images could be
easily included in this repo. If you get to that before I do, you are very much
welcome to send a PR.

| Command | Action                                          |
| ------- | ----------------------------------------------- |
| (none)  | Show help information                           |
| init    | Initialize your production environment          |
| pull    | Download items from your production environment |
| push    | Upload items to your production environment     |

| Flags      | Params | Action                |
| ---------- | ------ | --------------------- |
| -h, --help |        | Show help information |

#### wrt production init

This is a placeholder endpoint for the user to populate for any kind of
initialization script that they require for their production environment. This
may include creation of containers or migrating config files. The content of
this file is up to the developer.

The placeholder script file is located at:
`scripts/production/production_init.sh`

#### wrt production pull [options] [command]

A hierarchical parent for user populated scripts that pull items from the
production environment. The paths for the placeholder script files that need to
be edited for the apis to work is listed in the table below.

| Command    | Action                                         | File Path                                        |
| ---------- | ---------------------------------------------- | ------------------------------------------------ |
| (none)     | Show help information                          |                                                  |
| sql-backup | Pull sql backup from production                | scripts/production/production_pull_sql_backup.sh |
| uploads    | Pull wp uploads folder content from production | scripts/production/production_pull_uploads.sh    |
| plugins    | Pull wp plugins folder content from production | scripts/production/production_pull_plugins.sh    |

| Flags      | Params | Action                |
| ---------- | ------ | --------------------- |
| -h, --help |        | Show help information |

#### wrt production push [options] [command]

A hierarchical parent for user populated scripts that push items to the
production environment. The paths for the placeholder script files that need to
be edited for the apis to work is listed in the table below.

| Command    | Action                                              | File Path                                        |
| ---------- | --------------------------------------------------- | ------------------------------------------------ |
| (none)     | Show help information                               |                                                  |
| sql-backup | Push a sql backup to be used in production          | scripts/production/production_push_sql_backup.sh |
| uploads    | Push wp uploads folder content to production        | scripts/production/production_push_uploads.sh    |
| plugins    | Push wp plugins folder content to production        | scripts/production/production_push_plugins.sh    |
| theme      | Push wp theme that you are developing to production | scripts/production/production_push_theme.sh      |

| Flags      | Params | Action                |
| ---------- | ------ | --------------------- |
| -h, --help |        | Show help information |

### wrt theme [options] [command]

Hierarchical parent for actions that relate to managing your WordPress theme.

| Command | Action                                                         |
| ------- | -------------------------------------------------------------- |
| (none)  | Show help information                                          |
| clean   | Remove runtime files created by React WordPress theme scripts. |
| build   | Build the WordPress theme and place it inside build directory  |
| dist    | Create theme package at <root>/dist.zip                        |

| Flags      | Params | Action                |
| ---------- | ------ | --------------------- |
| -h, --help |        | Show help information |

#### wrt theme clean [options]

Removes all the temporary files that are created by runtime scripts.
Essentially, it removes all the files inside the theme folder that are ignored
by git.

| Command | Action                  |
| ------- | ----------------------- |
| (none)  | Run the clean operation |

| Flags      | Params | Action                |
| ---------- | ------ | --------------------- |
| -h, --help |        | Show help information |

#### wrt theme build [options]

Builds, minimizes the theme files and places them inside `build` folder.

| Command | Action                  |
| ------- | ----------------------- |
| (none)  | Run the build operation |

| Flags      | Params | Action                |
| ---------- | ------ | --------------------- |
| -h, --help |        | Show help information |

#### wrt theme package [options]

Builds, minimizes and zips the theme files, creating a package that could be
used by wordpress.org or by your own production WordPress instance.

| Command | Action                      |
| ------- | --------------------------- |
| (none)  | Run the packaging operation |

| Flags      | Params | Action                |
| ---------- | ------ | --------------------- |
| -h, --help |        | Show help information |
