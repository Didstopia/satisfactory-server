FROM didstopia/base:nodejs-14-steamcmd-ubuntu-20.04

LABEL maintainer="Didstopia <support@didstopia.com>"

# Fix apt-get warnings
ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      expect \
      tcl && \
    rm -rf /var/lib/apt/lists/*

# Create the volume directories
RUN mkdir -p /steamcmd/satisfactory

# Add the steamcmd installation script
ADD install.txt /app/install.txt

# Copy the satisfactory startup script
ADD start.sh /app/start.sh

# Copy extra files
COPY README.md LICENSE.md /app/

# Set the current working directory
WORKDIR /

# Fix permissions
RUN chown -R 1000:1000 \
    /steamcmd \
    /app

# Run as a non-root user by default
ENV PGID 1000
ENV PUID 1000

# Expose necessary ports
EXPOSE 7777/udp
EXPOSE 15000/udp
EXPOSE 15777/udp

# Setup default environment variables for the server
ENV SATISFACTORY_SERVER_STARTUP_ARGUMENTS "FactoryGame -log -NoSteamClient -unattended"
ENV SATISFACTORY_BRANCH "experimental"
ENV SATISFACTORY_START_MODE "0"

# Define directories to take ownership of
ENV CHOWN_DIRS "/app,/steamcmd"

## FIXME: How do we handle data persistence?

# Expose the volumes
# VOLUME [ "/steamcmd/satisfactory" ]

# Start the server
CMD [ "bash", "/app/start.sh"]
