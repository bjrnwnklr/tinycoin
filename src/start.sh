#!/bin/bash

########################################################################
####################### Define environment variables ###################
########################################################################

# Determine and set the hostname/ IP address of the container
# - it will run on a virtual network created by Docker
# hostname -I returns the IP address. 
# Other Linux commands like `ip addr` or `ifconfig` are not installed
# by default on the docker image.
# HOST="$(hostname -I)"
# Please don't use http in host as it is already included.
# 0.0.0.0 means serve all network interfaces
HOST="0.0.0.0"

# PORT=5000

# Please specify http as peer connection protocol 
# PEERS="localhost:5000" 

# MINER_ADDRESS should be unique per node
# Use the docker container name here
MINER_ADDRESS="$(hostname)"

########################################################################
####################### Export environment variables ###################
########################################################################

echo "Exporting HOST=$HOST"
export HOST=$HOST

# echo "Exporting PORT=$PORT"
# export PORT=$PORT

# echo "Exporting PEERS=$PEERS"
# export PEERS=$PEERS

echo "Exporting MINER_ADDRESS=$MINER_ADDRESS"
export MINER_ADDRESS=$MINER_ADDRESS

# Start application
echo "Starting application.... "
python3 app.py
