#!/usr/bin/env bash

# Enable debugging
#set -x

# Print the user we're currently running as
echo "Running as user: $(whoami)"

# Define the exit handler
exit_handler()
{
	echo "Shutdown signal received"

  ## TODO: Setup additional shutdown logic here,
  ##       such as saving state, backing up data, etc.

	echo "Exiting.."
	exit
}

# Trap specific signals and forward to the exit handler
trap 'exit_handler' SIGINT SIGTERM

# Satisfactory includes a 64-bit version of steamclient.so, so we need to tell the OS where it exists
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/steamcmd/satisfactory/linux64

# Define the install/update function
install_or_update()
{
	# Install Satisfactory from install.txt
	echo "Installing or updating Satisfactory.. (this might take a while, be patient)"
	bash /steamcmd/steamcmd.sh +runscript /app/install.txt

	# Terminate if exit code wasn't zero
	if [ $? -ne 0 ]; then
		echo "Exiting, steamcmd install or update failed!"
		exit 1
	fi
}

# Create the necessary folder structure
if [ ! -d "/steamcmd/satisfactory" ]; then
	echo "Missing /steamcmd/satisfactory, creating.."
	mkdir -p /steamcmd/satisfactory
fi

# Install/update steamcmd
echo "Installing/updating steamcmd.."
curl -s http://media.steampowered.com/installer/steamcmd_linux.tar.gz | bsdtar -xvf- -C /steamcmd

# Check which branch to use
if [ ! -z ${SATISFACTORY_BRANCH+x} ]; then
	echo "Using branch arguments: $SATISFACTORY_BRANCH"

	# Add "-beta" if necessary
	INSTALL_BRANCH="${SATISFACTORY_BRANCH}"
	if [ ! "$SATISFACTORY_BRANCH" == "public" ]; then
	    INSTALL_BRANCH="-beta ${SATISFACTORY_BRANCH}"
	fi
	sed -i "s/app_update 1690800.*validate/app_update 1690800 $INSTALL_BRANCH validate/g" /app/install.txt
else
  sed -i "s/app_update 1690800.*validate/app_update 1690800 validate/g" /app/install.txt
fi

# Disable auto-update if start mode is 2
if [ "$SATISFACTORY_START_MODE" = "2" ]; then
	# Check that Satisfactory exists in the first place
	if [ ! -f "/steamcmd/satisfactory/Engine/Binaries/Linux/UE4Server-Linux-Shipping" ]; then
		install_or_update
	else
		echo "Satisfactory seems to be installed, skipping automatic update.."
	fi
else
	install_or_update
fi

# Start mode 1 means we only want to update
if [ "$SATISFACTORY_START_MODE" = "1" ]; then
	echo "Exiting, start mode is 1.."
	exit
fi

# Remove extra whitespace from startup command
SATISFACTORY_STARTUP_COMMAND=$(echo "$SATISFACTORY_SERVER_STARTUP_ARGUMENTS" | tr -s " ")

# Set the working directory
cd /steamcmd/satisfactory

# Run the server
echo "Starting Satisfactory.."
/steamcmd/satisfactory/Engine/Binaries/Linux/UE4Server-Linux-Shipping \
  $SATISFACTORY_STARTUP_COMMAND \
  -ServerQueryPort=$SATISFACTORY_SERVER_QUERY_PORT &

child=$!
wait "$child"

echo "Exiting.."
exit
