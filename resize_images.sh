#!/bin/bash

# Cesta ke složce s fotkami
PHOTO_DIR="./assets/fotky/"

# Maximální velikost souboru (500 KB = 500000 bytes)
MAX_SIZE=500000

# Projít všechny JPG soubory ve složce
for img in $(ls "$PHOTO_DIR"*.jpg); do
  # Zjistit velikost souboru v bytech
  FILE_SIZE=$(stat -c %s "$img")

  # Pokud je obrázek větší než 500 KB
  if [ $FILE_SIZE -gt $MAX_SIZE ]; then
    # Změnit velikost obrázku
    mogrify -resize 1920x1920\> -quality 75 -strip "$img"
    echo "Obrázek $img byl zmenšen na velikost menší než 500 KB."
  else
    echo "Obrázek $img je již menší než 500 KB, nic se neděje."
  fi
done

echo -e "Done."