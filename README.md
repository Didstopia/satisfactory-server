[![Docker Automated build](https://img.shields.io/docker/automated/didstopia/satisfactory-server.svg)](https://hub.docker.com/r/didstopia/satisfactory-server/)
[![Docker Pulls](https://img.shields.io/docker/pulls/didstopia/satisfactory-server.svg)](https://hub.docker.com/r/didstopia/satisfactory-server/)
[![Docker stars](https://img.shields.io/docker/stars/didstopia/satisfactory-server.svg)](https://hub.docker.com/r/didstopia/satisfactory-server)
# Satisfactory Dedicated Server in a Docker Container

This image provides a dedicated server for Satisfactory, designed to run on top of linux and Docker.  
As with all of our other game server images, this is based on our custom base images, which have provided known good, stable and secure images for many years.  
Likewise, this image also automatically updates on [Docker Hub](https://hub.docker.com/r/didstopia/satisfactory-server) whenever our base images change, which can happen on a daily basis if important dependency or security updates are detected by our fully automated system.

Note that the dedicated server itself is still in early development, so expect bugs, as well as potentially high memory and storage usage. These are primarily up to the developer to fix and improve upon.

Finally, be sure to always use `didstopia/satisfactory-server:latest` as the image tag, as otherwise you won't get updates on subsequent pulls.  
For those who prefer it, as well as know how to deal with the persistence changes, a "full installation" tag is also available as `didstopia/satisfactory-server:full`, which bundles the entire dedicated server in the image.

---

## Requirements

- Linux
- Docker
- A relatively powerful x86 CPU
- 4 GB of memory (minimum)
- 10 GB of storage (minimum)

## Quick Start

```sh
# Update to the latest version
docker pull didstopia/satisfactory-server:latest

# Start the server
docker run \
    -it \
    --restart=always \
    --name satisfactory-server \
    -v satisfactory-data:/steamcmd/satisfactory \
    -v satisfactory-saves:/app/.config \
    -p 7777:7777/udp \
    -p 15000:15000/udp \
    -p 15777:15777/udp \
    didstopia/satisfactory-server:latest

# Press CTRL-C to gracefully shut down the server,
# or replace `-it` with `-d` to run it in background
```

## Advanced Configuration

Mountable paths:
```sh
# NOTE: The following container paths can and should be
#       mounted on your host system, to ensure that you
#       don't have to reinstall the server and that your
#       save games or custom configs are safe.

# Server installation path
/steamcmd/satisfactory

# Save game files
/app/.config
```

Available environment variables:
```sh
# Default server startup arguments
SATISFACTORY_SERVER_STARTUP_ARGUMENTS="FactoryGame -log -NoSteamClient -unattended"

# Default branch/version to use (default is "experimental")
# NOTE: When specifying a branch/version other than "" or "public",
#       the "-beta" flag is automatically added for you.
SATISFACTORY_BRANCH="experimental"

# Default server starting mode
# 0 - Check for updates on startup and start the server
# 1 - Check for updates on startup and do not start server (container exits/terminates)
# 2 - Skip update checks on startup and start the server
SATISFACTORY_START_MODE="0"

# Steam query port, same as the port used in-game
# NOTE: Can be changed if hosting multiple instances on the same server
SATISFACTORY_SERVER_QUERY_PORT="15777"
```
