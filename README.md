# Docker Perforce Images

A collection of [Perforce](http://perforce.com) docker images:

- Perforce Base, an image containing the official repo and the p4 client
- Perforce Server
- Perforce Swarm

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

## Credits
* Obviously, most of the scripting comes from the forked [Ambakshi repository](https://github.com/ambakshi/docker-perforce)
* Found it thanks to [Froyok blog](https://www.froyok.fr/blog/2018-09-setting-up-perforce-with-docker-for-unreal-engine-4)
* Typemap script found in [Froyok's fork](https://github.com/Froyok/froyok-perforce)
* PUID/PGUID fixes (allowing to move server data to shared folder on Synology NAS) found in [7xanthus's fork](https://github.com/7xanthus/docker-perforce)

