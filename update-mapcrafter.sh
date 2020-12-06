#!/bin/bash
#
# Mapcrafter update + build script
#
# Usage:
# update-mapcrafter.sh <MAPCRAFTER_DIRECTORY> <MAPCRAFTER_REPO> <MAPCRAFTER_BRANCH>
#
# Example:
# update-mapcrafter.sh ~/Desktop/working/mapcrafter https://github.com/miclav/mapcrafter.git world115
#

if [ "$#" -ne 3 ]; then
    echo "Wrong number of parameters passed"
    echo "Usage:"
    echo "$0 <MAPCRAFTER_DIRECTORY> <MAPCRAFTER_REPO> <MAPCRAFTER_BRANCH>"
    exit
fi

MAPCRAFTER_DIRECTORY="$1"

MAPCRAFTER_REPO="$2"
MAPCRAFTER_BRANCH="$3"

#Update or clone Mapcrafter and build if necessary
if [ -d "$MAPCRAFTER_DIRECTORY" ] 
then
    pushd "$MAPCRAFTER_DIRECTORY" > /dev/null
    git fetch origin
    if [[ `git log HEAD..origin/$MAPCRAFTER_BRANCH --oneline` != "" ]]
    then
        echo "Updating Mapcrafter"
        git clean -fdx
        git merge origin/$MAPCRAFTER_BRANCH
        echo "Rebuilding Mapcrafter"
        cmake .
        make
    else
        echo "Mapcrafter is already up-to-date"
    fi
    popd > /dev/null
else
    echo "Cloning and building Mapcrafter"
    git clone $MAPCRAFTER_REPO --branch $MAPCRAFTER_BRANCH "$MAPCRAFTER_DIRECTORY"
    echo "Building Mapcrafter"
    pushd "$MAPCRAFTER_DIRECTORY" > /dev/null
    cmake .
    make
    popd > /dev/null
fi
