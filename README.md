# Docker Perforce Images

A collection of [Perforce](http://perforce.com) docker images:

- Perforce Base, an image containing the official repo and the p4 client
- Perforce P4D Server
- Perforce Swarm

![Docker Pulls](https://img.shields.io/docker/pulls/mashape/kong.svg)

## Installation

All operations on the images and repositories are encapsulated in Makefiles.

Build images (the Makefile's default target):

    $ make [image]

Tag your images with your repo username and push the images to the Docker registry:

    $ docker login
    $ DOCKER_REPO=ambakshi make image push

## Usage

The perforce server images are contained in their respective directories.
Each server comes with an example 'run' target that you can use to get
a server up and running quickly.

    $ make -C perforce-server run
    $ make -C


### docker-compose

Using docker-compose it is much simpler to setup a working environment. Modify the
`docker-compose.yml` and the supplied `envfile` to customize your site. Once done,
run:

    $ make
    $ docker volume create --name=perforce
    $ docker-compose up -d perforce    # for p4d server

If you want to use a directory on your host to mount into your perforce container,
you'll need to modify the `docker-compose.yml` file accordingly:

    services:
      perforce:
        volumes:
          /path/on/host:/data
      gfperforce:
        volumes:
          /path/on/host:/data
