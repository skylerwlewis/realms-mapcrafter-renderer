#!/bin/bash
#
# Update Realms world script
#
# Usage:
# update-realms-world.sh <WORLD_DIRECTORY> <MOJANG_USERNAME> <MOJANG_PASSWORD> <MINECRAFT_VERSION>
#
# Example:
# update-realms-world.sh ~/Desktop/working/realms_world minecraft.user@example.com 4gr347p4$$w0rd 1.15.2
#

if [ "$#" -ne 4 ]; then
    echo "Wrong number of parameters passed"
    echo "Usage:"
    echo "$0 <WORLD_DIRECTORY> <MOJANG_USERNAME> <MOJANG_PASSWORD> <MINECRAFT_VERSION>"
    exit
fi

WORLD_DIRECTORY="$1"

MOJANG_USERNAME="$2"
MOJANG_PASSWORD="$3"
MINECRAFT_VERSION="$4"

#Make world directory
mkdir -p "$WORLD_DIRECTORY"

#Authenticating with Mojang
CLIENT_TOKEN=`uuidgen`
AUTH_BODY=`jq -n --arg username "$MOJANG_USERNAME" --arg password "$MOJANG_PASSWORD" --arg clientToken "$CLIENT_TOKEN" '
{
    "agent": {
        "name": "Minecraft",
        "version": 1
    },
    "username": $username,
    "password": $password,
    "clientToken": $clientToken,
    "requestUser": false
}'`
echo "Authorizing with Mojang"
AUTH_RESPONSE=`curl -s --data "$AUTH_BODY" https://authserver.mojang.com/authenticate --header "Content-Type:application/json"`
AUTH_ERROR=`echo $AUTH_RESPONSE | jq '.errorMessage // empty' --raw-output`
if [[ "$AUTH_ERROR" != "" ]]
then
    echo $AUTH_ERROR
    exit
fi

ACCESS_TOKEN=`echo $AUTH_RESPONSE | jq '.accessToken' --raw-output`
PROFILE_ID=`echo $AUTH_RESPONSE | jq '.selectedProfile.id' --raw-output`
PROFILE_NAME=`echo $AUTH_RESPONSE | jq '.selectedProfile.name' --raw-output`
AUTH_HEADER="Cookie: sid=token:$ACCESS_TOKEN:$PROFILE_ID;user=$PROFILE_NAME;version=$MINECRAFT_VERSION"

#Downloading world
echo "Checking realms worlds"
WORLDS_RESPONSE=`curl -s https://pc.realms.minecraft.net/worlds --header "$AUTH_HEADER"`
WORLD_ID=`echo $WORLDS_RESPONSE | jq '.servers[0].id'`
ACTIVE_SLOT=`echo $WORLDS_RESPONSE | jq '.servers[0].activeSlot'`

#Fetching most recent backup ID
echo "Fetching most recent update ID"
BACKUPS_RESPONSE=`curl -s https://pc.realms.minecraft.net/worlds/$WORLD_ID/backups --header "$AUTH_HEADER"`
BACKUP_ID=`echo $BACKUPS_RESPONSE | jq '.backups[0].backupId' --raw-output`

LATEST_BACKUP_FILE="${WORLD_DIRECTORY}/backup_${BACKUP_ID}.tar.gz"
if [ ! -f "$LATEST_BACKUP_FILE" ]
then
    WORLD_RESPONSE=`curl -s https://pc.realms.minecraft.net/worlds/$WORLD_ID/slot/$ACTIVE_SLOT/download --header "$AUTH_HEADER"`
    if [ "$WORLD_RESPONSE" = "Retry again later" ]
    then
        echo "Retry again later"
    else
        echo "Downloading latest realms world"
        DOWNLOAD_LINK=`echo $WORLD_RESPONSE | jq '.downloadLink' --raw-output`
        curl $DOWNLOAD_LINK --output "$LATEST_BACKUP_FILE"

    fi
else
    echo "Realms world is already up-to-date"
fi

#Invalidating access token
INVALIDATE_BODY=`jq -n --arg accessToken "$ACCESS_TOKEN" --arg clientToken "$CLIENT_TOKEN" '
{
    "accessToken": $accessToken,
    "clientToken": $clientToken
}'`
echo "Invalidating API access token"
curl -s --data "$INVALIDATE_BODY" https://authserver.mojang.com/invalidate --header "Content-Type:application/json"

if [ -f "$LATEST_BACKUP_FILE" ]
then
    #Removing old decompressed world
    rm -rf "$WORLD_DIRECTORY/world"

    #Decompressing latest world backup
    tar -xf "$LATEST_BACKUP_FILE" -C "$WORLD_DIRECTORY"
fi
