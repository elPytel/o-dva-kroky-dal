---
layout: post
title: "Přechod na webp"
description: Přechod z formátu JPEG na WebP pro optimalizaci obrázků na webu
categories: 
    - blogging
tags:
    - jekyll
    - webp
thumbnail: /assets/WEBP.webp
---

# Přechod z jpeg na webp
Formát WebP je moderní obrazový formát vyvinutý Googlem, který má za cíl jediné: nahradit letité standardy JPEG, PNG a GIF tím, že nabídne výrazně menší velikost souborů při zachování srovnatelné (nebo lepší) vizuální kvality.

WebP je založen na prediktivním kódování, které vychází z video kodeku VP8.

**Ztrátová komprese** (Lossless): Funguje podobně jako JPEG, ale používá pokročilejší predikci sousedních bloků pixelů. Místo ukládání celého bloku uloží jen rozdíl oproti předpovědi.

**Bezztrátová komprese** (Lossy): Pracuje s transformacemi dat a lokální paletou barev. V tomto režimu je WebP o cca 26 % menší než PNG.

**Alfa kanál**: Na rozdíl od JPEGu podporuje WebP průhlednost, a to i u ztrátové komprese (což je unikátní vlastnost).

Drastická úspora místa: 400 kB na miniaturu se s WebP dostane pravděpodobně pod 80–100 kB bez viditelné ztráty kvality.

Jeden formát pokryje fotky (náhrada JPEGu) i ikonky/loga s průhledností (náhrada PNG).

|Vlastnost|JPEG|PNG|GIF|WebP|
|---|---|---|---|---|
|Ztrátová komprese|Ano|Ne|Ne|Ano|
|Bezztrátová komprese|Ne|Ano|Ano|Ano|
|Průhlednost (Alfa)|Ne|Ano|Ano|Ano|
|Animace|Ne|Ne|Ano|Ano|
|"Metadata (EXIF, XMP)"|Ano|Ne|Ne|Ano|

## Script pro konverzi obrázků na webp
`convert_to_webp.sh`
```Bash
#!/bin/bash

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

if ! command -v cwebp &> /dev/null; then
    echo "Chyba: cwebp není nainstalován. (sudo apt install webp)"
    exit 1
fi

mkdir -p "$PHOTO_DEST_DIR"

find "$PHOTO_SOURCE_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | while read -r img; do
    
    filename=$(basename -- "$img")
    extension="${filename##*.}"
    filename_noext="${filename%.*}"
    dest_file="${PHOTO_DEST_DIR}${filename_noext}.webp"

    echo -n "Zpracovávám: $filename ... "

    # Magie cwebp:
    # -q: kvalita
    # -resize: 0 na jedné straně zachová poměr stran
    # -metadata all: zachová EXIF
    cwebp -q "$QUALITY" -resize "$RESOLUTION" 0 -metadata all "$img" -o "$dest_file" -short

    OLD_SIZE=$(stat -c %s "$img")
    NEW_SIZE=$(stat -c %s "$dest_file")
    
    echo "Hotovo ($((OLD_SIZE / 1024))KB -> $((NEW_SIZE / 1024))KB)"
done

echo -e "\nKonverze dokončena. Nezapomeň v Jekyllu aktualizovat přípony na .webp!"
```

## Integrace do Jekyllu
Na co si dát pozor v Jekyllu (Chirpy). Jelikož měníme příponu z .jpg na .webp, bude potřeba v Markdown příspěvcích hromadně změnit koncovky. Pokud jich je hodně, stačí v kořenu repozitáře pustit:

```Bash
sed -i 's/\.jpg)/.webp)/g' _posts/*.md
```
(Pozor: Tento příkaz předpokládá, že obrázky v MD končí závorkou, např. (image.jpg).)