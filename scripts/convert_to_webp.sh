#!/bin/bash

# Defaultní hodnoty
PHOTO_SOURCE_DIR="./big_photos/"
PHOTO_DEST_DIR="./assets/fotky/"
QUALITY="75"
RESOLUTION="1280"

function Help() {
    echo "Moderní WebP konverze pro 'O dva kroky dál'"
    echo
    echo "Usage: $0 [-s source] [-d destination] [-q quality] [-r resolution]"
    echo
    echo "Options:"
    echo "-s source      Zdrojová složka (default: ./big_photos/)"
    echo "-d dest        Cílová složka (default: ./assets/fotky/)"
    echo "-q quality     Kvalita WebP (0-100, default: 75)"
    echo "-r resolution  Max šířka/výška (default: 1280)"
}

while getopts s:d:q:r:h flag
do
    case "${flag}" in
        s) PHOTO_SOURCE_DIR=${OPTARG};;
        d) PHOTO_DEST_DIR=${OPTARG};;
        q) QUALITY=${OPTARG};;
        r) RESOLUTION=${OPTARG};;
        h) Help; exit;;
    esac
done

# Kontrola závislostí (nástroj cwebp z balíčku webp)
if ! command -v cwebp &> /dev/null; then
    echo "Chyba: cwebp není nainstalován. (sudo apt install webp)"
    exit 1
fi

mkdir -p "$PHOTO_DEST_DIR"

# Zpracování JPG a PNG dohromady
# Používáme find, abychom se vyhnuli problémům s mezerami v názvech
find "$PHOTO_SOURCE_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | while read -r img; do
    
    filename=$(basename -- "$img")
    extension="${filename##*.}"
    filename_noext="${filename%.*}"
    dest_file="${PHOTO_DEST_DIR}${filename_noext}.webp"

    echo -n "Zpracovávám: $filename ... "

    # Magie cwebp:
    # -q: kvalita
    # -resize: 0 na jedné straně zachová poměr stran
    # -metadata all: zachová EXIF (důležité pro tvůj cestopis!)
    cwebp -q "$QUALITY" -resize "$RESOLUTION" 0 -metadata all "$img" -o "$dest_file" -short

    OLD_SIZE=$(stat -c %s "$img")
    NEW_SIZE=$(stat -c %s "$dest_file")
    
    echo "Hotovo ($((OLD_SIZE / 1024))KB -> $((NEW_SIZE / 1024))KB)"
done

echo -e "\nKonverze dokončena. Nezapomeň v Jekyllu aktualizovat přípony na .webp!"