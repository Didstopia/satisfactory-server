[![Docker Automated build](https://img.shields.io/docker/automated/didstopia/satisfactory-server.svg)](https://hub.docker.com/r/didstopia/satisfactory-server/)
[![Docker Pulls](https://img.shields.io/docker/pulls/didstopia/satisfactory-server.svg)](https://hub.docker.com/r/didstopia/satisfactory-server/)
[![Docker stars](https://img.shields.io/docker/stars/didstopia/satisfactory-server.svg)](https://hub.docker.com/r/didstopia/satisfactory-server)
# Satisfactory Dedicated Server in a Docker Container

_This is still extremely early and undocumented, but if you know what you're doing and have beefy enough hardware, this image might be for you. More information will be available as soon as possible._

***WARNING:*** _As of right now, there is no data persistence set up, but as this is a high priority feature it will be coming soon! In the meantime, you can try mounting `/steamcmd/satisfactory` to at least persist the installation._

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
```

Note that the actual dedicated server is still in early development, so the dedicated server will be buggy and has reasonably high memory and storage requirements. These are up to the developer to fix or improve upon.
