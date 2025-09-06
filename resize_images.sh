#!/bin/bash

# Cesta ke složce s fotkami
PHOTO_DEST_DIR="./assets/fotky/"
PHOTO_DEST_DIR="./big_photos/"
PHOTO_SOURCE_DIR="./big_photos/"

# Maximální velikost souboru (500 KB = 500000 bytes)
MAX_SIZE=500000
RESOLUTION="1920x1920"
RESOLUTION="1280x1280"
COMPRESION="75"

function Help() {
	echo "Compresing images in source dir."
	echo
	echo "Usage: $0 [options] [arguments]"
	echo
	echo "Options:"
	echo "-s source         source foulcer"
	echo "-c compresion     Compresion quality, defoult: 75"
	echo "-h                Description of the script operation"
}

while getopts s:d:r:c:h flag
do
	case "${flag}" in
        s) PHOTO_SOURCE_DIR=${OPTARG};;
		d) PHOTO_DEST_DIR=${OPTARG};;
		r) RESOLUTION=${OPTARG};;
        c) COMPRESION=${OPTARG};;
		h) Help
		   exit;;
	esac
done

# Projít všechny JPG soubory ve složce
for img in $(ls "${PHOTO_SOURCE_DIR}"*.jpg); do
    # Zjistit velikost souboru v bytech
    FILE_SIZE=$(stat -c %s "$img")


    # Pokud je obrázek větší než 500 KB
    if [ $FILE_SIZE -gt $MAX_SIZE ]; then
        # Změnit velikost obrázku
        mogrify -resize $RESOLUTION\> -quality $COMPRESION -strip "$img"
        FILE_SIZE=$(stat -c %s "$img")
        echo "Obrázek $img byl zmenšen na velikost $FILE_SIZE bytes."
    else
        echo "Obrázek $img je již menší než 500 KB, nic se neděje."
    fi
done

# Projít všechny PNG soubory ve složce a zmenšit je pomocí pngquant
for img in $(ls "${PHOTO_SOURCE_DIR}"*.png); do
    # Kontrola dostupnosti pngquant
    if ! command -v pngquant &> /dev/null; then
        echo "Chyba: pngquant není nainstalován. Nainstalujte jej například příkazem: sudo apt install pngquant"
        exit 1
    fi

    FILE_SIZE=$(stat -c %s "$img")
    if [ $FILE_SIZE -gt $MAX_SIZE ]; then
        pngquant --quality=65-80 --ext .png --force "$img"
        FILE_SIZE=$(stat -c %s "$img")
        echo "PNG $img byl zkomprimován na velikost $FILE_SIZE bytes."
    else
        echo "PNG $img je již menší než 500 KB, nic se neděje."
    fi
done

echo -e "Done."