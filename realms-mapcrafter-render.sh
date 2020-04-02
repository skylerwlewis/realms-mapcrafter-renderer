#!/bin/bash
#
# Minecraft Realms + Mapcrafter
# Update & render script
#
# Usage:
# realms-mapcrafter-render.sh <WORKING_DIRECTORY> <MOJANG_USERNAME> <MOJANG_PASSWORD> <MINECRAFT_VERSION> <MAPCRAFTER_REPO> <MAPCRAFTER_BRANCH>
#
# Example:
# realms-mapcrafter-render.sh ~/Desktop/working minecraft.user@example.com 4gr347p4$$w0rd 1.15.2 https://github.com/miclav/mapcrafter.git world115
#

if [ "$#" -ne 6 ]; then
    echo "Wrong number of parameters passed"
    echo "Usage:"
    echo "$0 <WORKING_DIRECTORY> <MOJANG_USERNAME> <MOJANG_PASSWORD> <MINECRAFT_VERSION> <MAPCRAFTER_REPO> <MAPCRAFTER_BRANCH>"
    exit
fi

CURRENT_DIRECTORY="$(dirname $(realpath $0))"
WORKING_DIRECTORY=$1

MOJANG_USERNAME=$2
MOJANG_PASSWORD=$3
MINECRAFT_VERSION=$4

MAPCRAFTER_REPO=$5
MAPCRAFTER_BRANCH=$6

#Create working directory
mkdir -p $WORKING_DIRECTORY

#Download latest world backup if necessary
$CURRENT_DIRECTORY/update-realms-world.sh $WORKING_DIRECTORY/realms_world $MOJANG_USERNAME $MOJANG_PASSWORD $MINECRAFT_VERSION

#Cloning or updating Mapcrafter repo and building if necessary
$CURRENT_DIRECTORY/update-mapcrafter.sh $WORKING_DIRECTORY/mapcrafter $MAPCRAFTER_REPO $MAPCRAFTER_BRANCH

#Create Mapcrafter configuration file if necessary
$CURRENT_DIRECTORY/create-mapcrafter-config.sh $WORKING_DIRECTORY/mapcrafter.conf $WORKING_DIRECTORY/realms_world/world $WORKING_DIRECTORY/output

mkdir -p $WORKING_DIRECTORY/output

#Running Mapcrafter
$WORKING_DIRECTORY/mapcrafter/src/mapcrafter -c $WORKING_DIRECTORY/mapcrafter.conf -j 4