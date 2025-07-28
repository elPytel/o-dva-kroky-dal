---
layout: post
title: "Universal Downloader"
description: "Program pro stahování různých typů souborů z internetu"
categories: Python
---

# Pohled do histore

S kamerády jsme na ještě na střední škole hojně využívali služeb Uložta. Když člověk chtěl v těchti dřevních dobách stahovat rychleji enž je mrzkých 300kbps, tak si musel člověk zaplatit za stažené gigabity dat. Metodou pokud->omyl jsem zjistil, že když začnete stahovat jeden soubor v jednom prolížeči a další v jiném. Tak vás Uložto neodstřihne. Nainstaloval jsem si hned čtyři další webové prohlížeče. Takhle to šlo rok za rokem až jednou jeden z nás narazil na naprosto revoluční způsob stahování: [Vžum!](https://vzum.hys.cz/). 

Malá aplikace, kterou někdo někde naprogramoval a umožnovala stahovat z uložta jako z torentu. Aplikace soubor rozdělila do několika paralelních stahování a soubory poté slepila do hromady. Rychlost stahování to zvedlo třeba 10x! A co bylo ještě lepší?! Instancí vžumu šlo spustit rovnou několik a stahovat v každé z nich.

Jedna z vlatností, která vžumu chybala byla seznam souborů k postupnému stahování. 

# Král je mrtev, ať žije král!

Konec Uložta v Čechách. Když [uložto](https://ulozto.cz/) zakázali/zrušili/nahradili, přestalo fungovat i vžum. Bylo to v době, kdy jsem již koukal na sdílený Netflix a íVysílání, takže mě ztráta uložta vlastně až tak moc nezasáhla. Když jednou zase potřeboval něco stáhnout. Tak jsem po krátkém hledání narazil [sdilej.cz](https://www.sdilej.cz/), který je asi ideologickým nástupcem uložta.

# A co na to já?

Vžumu byla škoda. Rychlé stahování bylo fajn, ale když už máte doma RPi, které se vám jen tak válí ve skříni a NAS s 3TB diskem, tak mnohem důležitější je moci nastavit co **všechno** se má stáhnout a pak už to můžete nechat žít vlastním životem.

Rozhodl jsem se vzít věci do vlastních rukou. Rozhodl jsem se vytvořit vlastní program. Založil jsem si repozitář na GitHubu [Universal downloader](https://github.com/elPytel/Universal_downloader) a začal jsem psát.

# Universal Downloader

Program umožnuje vyhledat podle názvu souboru. Umí preferenční hledání podle typu souboru a setřídit výsledky. Vyhledané soubory lze označit a stáhnout, nebo vyexportovat seznam do souboru. Ze souboru lze seznam opět nažíst třeba jen v terminálovém režimu a stáhnout postupně všechny soubory.

Help v terminálu:
```bash
python3 main.py --help
usage: main.py [-h] [-s SEARCH] [-t {all,video,audio,archive,images}] [-T {relevance,most_downloaded,newest,biggest,smallest}] [-d] [-f FILE] [-F FOLDER] [-n NUMBER]
               [-v] [-D] [-g] [-G] [-r]

Download files from internet.

options:
  -h, --help            show this help message and exit
  -s SEARCH, --search SEARCH
                        Search for files.
  -t {all,video,audio,archive,images}, --file-type {all,video,audio,archive,images}
                        Type of files to search for.
  -T {relevance,most_downloaded,newest,biggest,smallest}, --search-type {relevance,most_downloaded,newest,biggest,smallest}
                        Search format.
  -d, --download        Download the found files.
  -f FILE, --file FILE  File to download.
  -F FOLDER, --folder FOLDER
                        Folder to download to.
  -n NUMBER, --number NUMBER
                        Max number of files to search.
  -v, --verbose         Verbose mode.
  -D, --debug           Debug mode.
  -g, --tui             Start TUI.
  -G, --gui             Start GUI.
  -r, --remove          Remove downloaded files from the list.
```

Le GUI aplikace:
![app](https://github.com/elPytel/Universal_downloader/raw/main/assets/app.png)

Bohužel sdílej přešlo na placený model a tak již moje aplikace nefunguje.

# Přínos

Naučil jsem se:
- [x] jak vytvořit jednoduchou GUI aplikaci,
- [x] lokalizaci pomocí `*.po`, `*.pot` souborů,
- [x] zkrotil jsem *pyinstaller* pro vytváření `.exe` programů z Pythonu,
- [ ] TUI aplikaci,
- [ ] Stahování z různých serverů.