#!/bin/bash
#
# Mapcrafter configuration create script
#
# Usage:
# create-mapcrafter-config.sh <CONFIG_FILE> <INPUT_WORLD_DIRECTORY> <OUTPUT_DIRECTORY>
#
# Example:
# create-mapcrafter-config.sh ~/Desktop/working/mapcrafter.conf ~/Desktop/working/realms_world/world ~/Desktop/working/output
#

if [ "$#" -ne 3 ]; then
    echo "Wrong number of parameters passed"
    echo "Usage:"
    echo "$0 <CONFIG_FILE> <INPUT_WORLD_DIRECTORY> <OUTPUT_DIRECTORY>"
    exit
fi

CONFIG_FILE=$1

INPUT_WORLD_DIRECTORY=$2
OUTPUT_DIRECTORY=$3

echo "output_dir = $OUTPUT_DIRECTORY" > $CONFIG_FILE

echo "[global:map]" >> $CONFIG_FILE
echo "render_mode = daylight" >> $CONFIG_FILE
echo "rotations = top-left top-right bottom-right bottom-left" >> $CONFIG_FILE

echo "[global:world]" >> $CONFIG_FILE
echo "input_dir = $INPUT_WORLD_DIRECTORY" >> $CONFIG_FILE

echo "[world:overworld]" >> $CONFIG_FILE
echo "dimension = overworld" >> $CONFIG_FILE

echo "[world:end]" >> $CONFIG_FILE
echo "dimension = end" >> $CONFIG_FILE

echo "[map:overworld_day]" >> $CONFIG_FILE
echo "world = overworld" >> $CONFIG_FILE
echo "name = Overworld - Day" >> $CONFIG_FILE

echo "[map:overworld_night]" >> $CONFIG_FILE
echo "world = overworld" >> $CONFIG_FILE
echo "name = Overworld - Night" >> $CONFIG_FILE
echo "render_mode = nightlight" >> $CONFIG_FILE

echo "[map:the_end]" >> $CONFIG_FILE
echo "world = end" >> $CONFIG_FILE
echo "name = The End" >> $CONFIG_FILE