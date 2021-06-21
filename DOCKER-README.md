# BEACON and Docker

<p align="center">
  <a href="https://beacon.support/">
    <img src="https://github.com/wearefuturegov/beacon/blob/master/app/assets/images/beacon.png?raw=true" width="350px" />
  </a>
</p>


# Using Docker & Docker Compose for development

## Table of contents


- [Advantages/Benefits](#advantages-benefits)
- [Background](#background)
- [Basics & Setup](#basics)
- [Dockerfile](#dockerfile)
- [Docker Compose](#docker-compose)
  - [Basics of `docker-compose` commands](#interacting-with-beacon-using-docker-compose-commands)
    - [The basis of most compose commands](#basis-of-most-compose-commands)
    - [Running a shell from within a Docker Container](running-a-shell-from-within-a-container)
    - [How do I know if a containers status?](#'how-do-i-know-container-status)
    - [What to do if the relevant service/container is not running?](#what-to-do-if-service-is-not-running)
  - [Rails Console](#using-rails-console-under-docker)
  - [Rails DB Migrations](#using-docker-compose-and-rails-migrations)
  - [Running Tests](#using-docker-compose-to-run-tests)
    - [RSpec](#running-rspec)
    - [Cucumber](#running-cucumber)
    - [Rails & Docker logs](#rails-and-docker-logs)
    - [Rails Generators](#using-docker-compose-and-rails-generators)
  - [Rails DB Console (bin/rails dbconsole)](#using-docker-compose-to-interact-with-dbconsole)
  - [Adding Gems / Yarn packages to BEACON](#adding-gems-and-yarn-packages-to-beacon)
    - [Postresql](#directly-using-postgresql)
- [3rd Party Tools and Docker:](#third-party-tools-and-docker)
- [Gotchas:](#gotchas)
- [Installation Troubleshooting:](#installation-troubleshooting)


## <a name="advantages-benefits">Advantages / Benefits</a>

Some of the advantages of running a development environment locally with `Docker` and `Docker Compose` are:

- **Minimal setup** necessary for Rails and Rack application. Works out of the box with Docker.
- **It just works** no messing around with `homebrew` on Linux or OSX
- **No need** to install `rbenv` or `rvm` ruby version managers, nor `nvm` or `node` on local machine
- **No need** to install a database or any other services locally
- **No more** It doesn't work on my machine


## <a name="background">Background</a>

On joining the project in late 2020 there existed a `docker-compose.yml` file consisting solely of a service for the database used on the project `Postgresql`

The addition of another service to the existing compose file for the __BEACON__ applicaton (app) and a `Dockerfile.dev` file meant that the entire project could be run by any developer joining the team.

## <a name="basics">Basics & Setup</a>

This document is not meant to be Docker 101. In a section entitled [Background reading](#background-reading) the reader will find some links to help with all things Docker.

It is recommended that the reader if not familiar with Docker as a technology read the associated links.

At the simplest level two files are the key to understanding how Docker is setup within __BEACON__

**Setup** as per the instructions in the main [README](https://github.com/wearefuturegov/beacon/blob/master/README.md)


## <a name="dockerfile"></a>Dockerfile

A `Dockerfile` is a template to build an `image` and contains instructions on how the image should be constructed/configured.

Images are then used to create containers which are effectively lightweight sandboxes for running software.

Both the commands `docker` and `docker-compose` intereact with a specified image.

Images can be tagged using `docker -t <image_tag_name>:<version> <location_of_image_to_tag>`. Normally the location is the current directory.

A project can have one or more `Dockerfiles`, in the case of __**BEACON**__ there is a file for development `Dockerfile.dev` in the projects root directory

```ruby
docker run --rm -it <image_tag_name>(:<version>) <command>
```

A named image can be run with the command below. 
 - `--rm` this tells the Docker Engine that we want a disposable container that will not exist beyond the session/command.
 - `-it` this says run an `Interactive` session and enable `TTY`
 - `image:version` - the name of an image e.g. ruby and `version` e.g 2.7 (runs a ruby 2.7 image)
 - `command` you want to run e.g. bash or bin/rails db:migrate


## <a name="docker-compose"></a>Docker Compose

Docker Compose is a tool that allows multiple containers to be brought up for a single project. In the case of __**BEACON**__ we have two services (containers) defined in the `docker-compose.yml` file:
- app - this is the actual Ruby on Rails web application
- postgresql - the database

A service is simply a container.


## <a name="interacting-with-beacon-using-docker-compose-commands"></a>Interacting with BEACON using `docker-compose` commands

* Getting help - refer to the relevant [Docker Documentation](#background-reading) or ask for help using `docker-compose --help` 

##### <a name='basis-of-most-compose-commands'></a>The basis of most compose commands is:

`docker-compose <action> <service> <command>` were:

- `<action>` is either `run` or more commonly `exec`
- `<service >` is either `postgresql` or more commonly `app`
- `<command>` generally the command you would use outside of docker to interact with Rails

Use `run` for a throwaway container or when the container for the service is not running
Use `exec` for when the results of `docker-compose ps` show the container is running. `exec` on works on running containers.


Basically if the output of `docker-compose ps` shows both services are **`Up`** then any command your would run SANS Docker (without) you simply prefix with `docker-compose exec app `


OR 

you can run directly in the container normal rails commands by running from within the containers SHELL


##### <a name='running-a-shell-from-within-a-container'></a>Running a shell from within a Docker Container

`docker-compose exec app <shell>`

In the `Dockerfile.dev` on line 1 [ruby:2.6.1](https://github.com/wearefuturegov/beacon/blob/master/Dockerfile.dev#L1) we specifiy a base `Debian` image. As such the default shell is `bash`

Alpine Linux variants have `BusyBox ash` as the default SHELL. `bash` has to be installed


```shell
docker-compose exec app bash
root@63f4cf8bbaa8:/app#
```

In the above output the following apply:

- user is `root` (the default user in Docker unless specified as `USER <username>` in the Dockerfile.
- `@63f4cf8bbaa8` is the hostname
- `/app` is the directory - specified in the [Dockerfile](https://github.com/wearefuturegov/beacon/blob/master/Dockerfile.dev#L9) with the `WORKDIR` command


##### <a name='how-do-i-know-container-status'></a>How do I know if a containers status?

We have 2 containers as specified in the project `docker-compose.yml` file
- app
- postgresql

And they look like this from the `ps` command above:
```
docker-compose ps
       Name                      Command               State           Ports
-------------------------------------------------------------------------------------
beacon_app_1          entrypoint.sh rails server ...   Up      0.0.0.0:3000->3000/tcp
beacon_postgresql_1   docker-entrypoint.sh postgres    Up      5432/tcp
```

RAILS_ENV is `development` by default

##### <a name='what-to-do-if-service-is-not-running'></a>What to do if the relevant service/container is not running?

If container is not running one can either start it with 

`docker-compose up <service>`

OR 

can create a throwaway container using the `run` variant

`docker-compose run --rm -it app <command>`


## <a name='using-rails-console-under-docker'></a>Rails Console

`docker-compose exec app bin/rails c`


## <a name="using-docker-compose-and-rails-migrations"></a>Rails DB Migrations

`docker-compose exec -e RAILS_ENV=development app bin/rails db:migrate`

Change RAILS_ENV to be appropriate

To check status of migrations run

`docker-compose exec -e RAILS_ENV=development app bin/rails db:migrate:status`


** N.B.. `docker-compose ps` **MUST** show both the app and postgresql as **`Up`**

## <a name="using-docker-compose-to-run-tests"></a>Running Tests

Prepare the test DB as you normally would in respect to migrations by running:

`docker-compose exec app bin/rails db:test:prepare`


##### <a name='running-rspec'></a>RSpec

`docker-compose exec -e RAILS_ENV=test app bundle exec rspec <spec_path>/**/<spec_file>_spec.rb`

##### <a name='running-cucumber'></a>Cucumber

Run Cukes (cucumber) with: 

** This is WIP at present and needs to be resolved.


## <a name="using-docker-compose-to-interact-with-dbconsole"></a>Rails DB Console

`docker-compose exec app bin/rails dbconsole -p`  the -p means no need to type in password


## <a name='rails-and-docker-logs'></a>Rails & Docker logs

To view container logs run the following:

`docker-compose logs <service name>` 

Use the `-f` flag if you want to `tail` the logs like this 

`docker-compose logs -f <service name>`


## <a name='using-docker-compose-and-rails-generators'></a>Using Rails Generators

To run a generator use
docker-compose exec app bin/rails g <generator_name>


** N.B. If you are on LINUX you will also need to run `chown -R <username>:<username> .` in the root of the project every time you run a rails generator (migration / model / controller / resource creation) as our Dockerfile.dev does not specify a user to run as.

You might need sudo depending on how you have setup your system

You can also add the user and group ID as part of running a container or container build - TBC


## <a name='adding-gems-and-yarn-packages-to-beacon'></a>Adding Gems / Yarn packages to BEACON

Add `<gem_name>:<gem_version>` to `Gemfile`
`docker-compose exec app bundle install`

`docker-compose exec app build` - builds the image which is then a container when running
`docker-compose stop app && docker-compose up -d --force-recreate app`

This does 3 things:
1) builds a new image
2) stops the exisiting running `app` (or <service>) container
3) rebuilds `app` based on new image generated in 2 and brings up just the app

--force-recreate I think this is only needed when adding new services or updating their configurations, but I use it all the time as a belt & braces approach. 

TBC - clarify above

** N.B. If you don't use the `-d` flag on bringing up the containers to run you will get the logging for all services in the current terminal. `-d` instructs the process to run in the background


## <a name='directly-using-postgresql'></a>Postresql

To interact with postgresql defined in the docker-compose file run the following:

`docker-compose run --rm postgresql psql -U dev_local_user -h postgresql`


## <a name='third-party-tools-and-docker'></a>3rd Party Tools and Docker

There are a number of 3rd party tools that you might want to use to interact with the postresql service

- Postico
- phpAdmin

Most of these will be fairly similar in their setup


### <a name='background-reading'>Background reading</a>

- [Official Docker Docs](https://docs.docker.com/)
- [High Level Overview (getting started)](https://docs.docker.com/get-started/overview/)
- [Docker Engine Overview](https://docs.docker.com/engine/)
- [Docker Compose Overview](https://docs.docker.com/compose/)
- [Main Reference](https://docs.docker.com/reference/)
- [Dockerfile Reference](https://docs.docker.com/engine/reference/builder/)
- [Docker Compose File](https://docs.docker.com/compose/compose-file/)

This book is also a good reference [Docker for Rails Developers](https://pragprog.com/titles/ridocker/docker-for-rails-developers/)


## <a name="gotchas">Gotchas</a>

One issue with way our current Docker is setup is addition of gems. Have to bundle install in container and also rebuild the container to persist to the directory on your local machines.

## <a name="installation-troubleshooting">Installation Troubleshooting</a>

There may be some issues with the installation, while a fix is being investigate the following have been found to work:

A. Issue with `yarn install --integrity-check`

To get past this issue run it seems that running the `yarn install` command from within the container with volume mapping ` -v $PWD:/app` fixes the issue.


1. `docker run --rm -it -v $PWD:/app beaconv3_app bash`
2. `cd to /app`
3. `yarn install --check-files`

Action: Raise a ticket to look at issue and fix

B. Pending migrations

Solved by clicking on the `pending migrations` option in the browser

OR

by following the instructions in the section on DB migrations

