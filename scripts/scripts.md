# Skripty pro blog

- [Skripty pro blog](#skripty-pro-blog)
  - [Jekyll](#jekyll)
    - [Instalace Jekyll](#instalace-jekyll)
    - [Instalace závislostí](#instalace-závislostí)
    - [Spuštění serveru](#spuštění-serveru)
  - [Generování stránky kategorií](#generování-stránky-kategorií)
  - [Obrázky](#obrázky)
    - [Rotace obrázků](#rotace-obrázků)
    - [Skript pro konverzi fotek do WebP](#skript-pro-konverzi-fotek-do-webp)
  - [Skript pro počítání slov v blogu](#skript-pro-počítání-slov-v-blogu)


## Jekyll
[dokumentace](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/creating-a-github-pages-site-with-jekyll)


### Instalace Jekyll
Pro lokální testování je potřeba nainstalovat Jekyll a Ruby. Následující příkazy nainstalují Ruby a Jekyll na Debian/Ubuntu:

```bash
sudo apt-get install ruby-full
sudo apt install jekyll
```

### Instalace závislostí
Pro instalaci závislostí použijte bundler:
```bash
bundle install
```

### Spuštění serveru
Lokální spuštění: `jekyll serve`
```bash
bundle exec jekyll serve --baseurl="" --livereload
```

## Generování stránky kategorií

Pro generování stránky kategorií použijte skript `generate_category_pages.py`:
```bash
pip install pyyaml
python3 scripts/generate_category_pages.py
```

Tento skript vytvoří soubory pro každou kategorii v adresáři `kategorie/`, které obsahují seznam příspěvků v dané kategorii.

Nebo lze použít příkaz:
```bash
make build
```

## Obrázky
Pro zmenšení obrázků použijte příkaz:
```bash
mogrify -resize 1920x1920\> -quality 75 -strip *.jpg
```
Tento příkaz zmenší všechny obrázky v aktuálním adresáři na maximální rozměr 1920x1920 pixelů, nastaví kvalitu na 75 a odstraní metadata z obrázků.

### Rotace obrázků

```bash
convert input.jpg -rotate 90 output.jpg
```

### Skript pro konverzi fotek do WebP

`convert_to_webp.sh`

Konvertování všech fotek v zadaném adresáři `big_photos` do formátu WebP s kvalitou 80.

## Skript pro počítání slov v blogu

`count_words.sh`

Jak skript používat:
Základní spuštění (v kořenu blogu): 
```bash
./count_words.sh
```

S přepočtem na strany (default 250): 
```bash
./count_words.sh -p
```
S vlastním počtem slov na stranu: 
```bash
./count_words.sh --pages 300
```
Cesta k jinému adresáři: 
```bash
./count_words.sh ~/projects/my-blog --pages 250
```