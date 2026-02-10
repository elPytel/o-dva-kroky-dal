#!/bin/bash
set -euo pipefail

# Default values
PHOTO_SOURCE_DIR="./big_photos/"
ROTATE_DEG=90

function Help() {
	echo "Rotating images by a specified degrees (default 90 right)."
	echo
	echo "Usage: $0 [options] [file]"
	echo
	echo "Options:"
	echo "  -f DIR   Folder with pictures (default ./big_photos/)"
	echo "  -r DEG   Rotation degrees (default 90)"
	echo "  -h       Show this help"
	echo
	echo "If -f is provided, all images in the folder are rotated."
}

while getopts ":f:hr:" flag; do
	case "${flag}" in
		f) PHOTO_SOURCE_DIR=${OPTARG};;
		r) ROTATE_DEG=${OPTARG};;
		h) Help; exit 0;;
		:) echo "Option -${OPTARG} requires an argument." >&2; exit 1;;
		\?) echo "Invalid option: -${OPTARG}" >&2; exit 1;;
	esac
done
shift $((OPTIND-1))

# Helper to perform rotation using ImageMagick (magick preferred)
function rotate_file() {
	local file="$1"
	if command -v magick >/dev/null 2>&1; then
		magick "$file" -rotate "$ROTATE_DEG" "$file"
	else
		convert "$file" -rotate "$ROTATE_DEG" "$file"
	fi
}

# If -f was used (or default folder) and no positional file provided -> rotate all in folder
if [ -d "$PHOTO_SOURCE_DIR" ] && [ "$#" -eq 0 ]; then
	find "$PHOTO_SOURCE_DIR" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) -print0 |
	while IFS= read -r -d '' img; do
		echo "Rotating: $img"
		rotate_file "$img"
	done
	exit 0
fi

# Otherwise expect a single file as positional argument
if [ "$#" -lt 1 ]; then
	Help
	exit 1
fi

path_to_img="$1"
if [ ! -f "$path_to_img" ]; then
	echo "Soubor $path_to_img neexistuje." >&2
	exit 1
fi

echo "Rotating: $path_to_img"
rotate_file "$path_to_img"

exit 0