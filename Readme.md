# Wordpress - React

A Wordpress development environment for react themes. This repo is your primary 
choice if you'd like to develop a **React Typescript based WordPress theme that 
runs in a devcontainer**.

## Usage

1- After cloning the repo, create an .env file with the following variables:

- THEME_NAME: The name for the theme that you are developing
- DB_USER: Username for wp's mysql access
- DB_PASS: Password for wp's mysql access
- DB_NAME: Name for the schema that wp will use
- DB_ROOT_PASS: Mysql root user password

2- Run `bootstrap.sh` to set the theme name and retrieve dependencies

3- Start your devcontainer. This may take a while as some packages will be added to the wp image (such as git).

4- Open localhost (or your ip, if you prefer that) and do the all-too-familliar
WP setup

5- Once the setup is done, go to Appearance -> Themes and select your react 
theme. Its name will be "theme".

6 - Visit your site and watch the spinning react logo

## Scripts

`bootstrap.sh` helps you set your theme name and get your dependencies. Using
this script is recommended as without your theme name properly set, you will 
have issues viewing your site.

`docker_prune.sh` removes all containers, volumes, networks associates with your
development environment.

`theme_clean.sh` removes the files created by react wptheme scripts

## Repo management note

Please note that react source files are not a separate repository. This
entire codebase is governed as a single entity. This is different from regular
react repos where one folder above react src is typically the repo root.

## Acknowledgements

This repo uses [create-react-wptheme](https://github.com/devloco/create-react-wptheme) by devloco for wp and react integration.
