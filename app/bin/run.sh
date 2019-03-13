#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Find all **/lights.lp in /app/data;
# pair each lights.lp file with matching images (see below);
# create an RTI file for each lights.lp file found.
#
# To use this script, place N JPG images ending in 'jpg' inside a folder;
# place the lights.lp file describing N light sources in the same folder;
# the number of files ending in 'jpg' must match the number of lines in lights.lp.
#
# This script creates an input file for HSH fitting on-the-fly,
# sorting images alphabetically and assigning each one to the corresponding light source.
# It is recommended to name the images MMMM.jpg, such that the image
# taken with light source 1 is named 0001.jpg, 2 is named 0002.jpg, and so on.
# Then, 0001.jpg will be assigned to vector 1, 0002.jpg to vector 2, and so on.
#
# The format of the lights.lp file, that must be placed inside the folder containing
# the images, is as follows.
#
# v_11 v_12 v_13
# v_21 v_22 v_22
# :
# v_n1 v_n2 v_n3
#
# Each v_nm is a float in (0,1), describing the position of a light source.
#
# The file generated for HSH fitting has the following structure.
#
# file1 v_11 v12 v13
# file2 v_21 v22 v23
# :
# filen v_n1 vn2 vn3
#
# Mount the directory containing images and lights.lp files as a Docker volume,
# into /app/data inside the container.

function log {
    echo "{\"message\":\"${1}\",\"level\":\"${2}\",\"timestamp\":\"$(date)\"}"
}

DATA_DIR="$(readlink -f $(dirname $0)/../data)"
log "Data dir: ${DATA_DIR}." "info"
find "$DATA_DIR" -type f -name '*lights.lp' | sort | while read L
do
    NR_LIGHTS=$(wc -l "$L" | cut -d ' ' -f1)
    IMAGE_DIR=$(dirname "$L")
    NR_IMAGES=$(find "$IMAGE_DIR" -name '*.jpg' -type f | wc -l)
    if [ $NR_LIGHTS -ne $NR_IMAGES ]; then
        log "Number of lights in ${L} and number of images in ${IMAGE_DIR} differ, skipping." "warn"
        continue
    fi
    IMAGE_DIR_REL=$(realpath --relative-to="$DATA_DIR" "$IMAGE_DIR")
    RTI_NAME="$(echo "${IMAGE_DIR_REL}" | cut -d '/' -f1,2 | tr '/' '_').rti"
    RTI_FILE="${IMAGE_DIR}/${RTI_NAME}"
    if [ -f "${RTI_FILE}" ];
    then
        log "RTI file ${RTI_FILE} exists, skipping." "warn"
        continue
    fi
    log "Computing RTI, output: ${RTI_FILE}." "info"
    /usr/bin/wine /app/vendor/HSHfitter/hshfitter.exe \
         <(echo '64'; paste -d ' ' <(find "${IMAGE_DIR}" -name '*.jpg' -type f) <(cat "${L}")) \
         3 \
         "$RTI_FILE"
    log "Cleaning up." "debug"
    rm -f "$(pwd)/temp.hsh"
    log "Done generating RTI file: ${RTI_FILE}." "info"
done
