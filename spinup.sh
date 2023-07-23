#!/bin/bash
############################################################
# Start up multiple tinycoin docker containers
#
# v1.0, 22 July 2023
# Bjoern Winkler
############################################################

# Set variables
Version="1.0"
Date="22 July 2023"
PORT_START=5000

############################################################
# Help                                                     #
############################################################
Help()
{
   # Display Help
   echo "Spins up <number> of tinycoin docker containers."
   echo
   echo "Syntax: spinup.sh -n <int> [-h|V]"
   echo "options:"
   echo "-n <int> Spin up <int> instances of tinycoin containers"
   echo "h     Print this Help."
   echo "V     Print software version and exit."
   echo
}

############################################################
# Version                                                  #
############################################################
Version()
{
   # Display Help
   echo "spinup.sh ${Version}, ${Date}"
   echo
}

############################################################
############################################################
# Main program                                             #
############################################################
############################################################

############################################################
# Process the input options. Add options as needed.        #
############################################################
# Get the options
while getopts ":hVn:" option; do
    case $option in
        h) # display Help
            Help
            exit;;
        V) # display Version and exit
            Version
            exit;;
        n) # Enter the number of containers
            CONTAINERS=$OPTARG;;
        \?) # Invalid option
            echo "Error: Invalid option"
            exit;;
    esac
done


# build the docker image
/usr/bin/docker build -t tinycoin .

# start up a number of containers
for (( i=1; i<=${CONTAINERS}; i++ ))
do
    echo "Spinning up tinycoin node ${i}"
    PORT=$((${PORT_START} + ${i}))
    # /usr/bin/docker run --env PORT=${PORT} --publish ${PORT}:5000 --rm --detach tinycoin
    /usr/bin/docker run --publish ${PORT}:5000 --rm --detach tinycoin
done