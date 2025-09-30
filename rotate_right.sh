#!/bin/bash

path_to_img="$1"
PHOTO_SOURCE_DIR="./big_photos/"

function Help() {
	echo "Rotating image 90 degrees to the right."
	echo
	echo "Usage: $0 [options] [arguments]"
	echo
	echo "Options:"
	echo "-f      Folder with pictures"
	echo "-h      Description of the script operation"
}

while getopts f:h flag
do
	case "${flag}" in
        f) PHOTO_SOURCE_DIR=${OPTARG};;
		h) Help
		   exit;;
	esac
done

# All files in folder
if [ ! -z "$PHOTO_SOURCE_DIR" ]; then
    for img in $(ls "${PHOTO_SOURCE_DIR}"*.jpg); do
        echo "Rotating: $img"
        convert "$img" -rotate 90 "$img"
    done
    exit 0
fi

if [ -z "$path_to_img" ]; then
    echo "Použití: $0 cesta/k/obrazku.jpg"
    exit 1
fi

# Single file
if [ ! -f "$path_to_img" ]; then
    echo "Soubor $path_to_img neexistuje."
    exit 1
fi

convert "$path_to_img" -rotate 90 "$path_to_img"