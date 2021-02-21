#!/bin/bash
#
# Get textures for Mapcrafter from specific client jar
#
# Usage:
# get-client-textures.sh <CLIENT_DIRECTORY> <TEXTURES_PYTHON_SCRIPT> <RESOURCES_DIRECTORY> <MINECRAFT_VERSION>
#
# Example:
# get-client-textures.sh ~/Desktop/working/clients ~/Desktop/working/mapcrafter/src/tools/mapcrafter_textures.py ~/Desktop/working/mapcrafter/src/data 1.15.2
#

if [ "$#" -ne 4 ]; then
    echo "Wrong number of parameters passed"
    echo "Usage:"
    echo "$0 <CLIENT_DIRECTORY> <TEXTURES_PYTHON_SCRIPT> <RESOURCES_DIRECTORY> <MINECRAFT_VERSION>"
    exit
fi

CLIENT_DIRECTORY="$1"
TEXTURES_PYTHON_SCRIPT="$2"
RESOURCES_DIRECTORY="$3"
MINECRAFT_VERSION="$4"

if [ ! -d "$CLIENT_DIRECTORY" ]
then
    mkdir "$CLIENT_DIRECTORY"
fi

CLIENT_BACKUP_FILE="$CLIENT_DIRECTORY/$MINECRAFT_VERSION.jar"
if [ ! -f "$CLIENT_BACKUP_FILE" ]
then
    DOWNLOAD_LINK=`curl https://mcversions.net/download/$MINECRAFT_VERSION | grep -o -E "https[^\"']*client\.jar"`
    curl $DOWNLOAD_LINK --output "$CLIENT_BACKUP_FILE"
fi

#Run texture copy script
python3 "$TEXTURES_PYTHON_SCRIPT" -f "$CLIENT_BACKUP_FILE" "$RESOURCES_DIRECTORY"
