---
layout: post
title:  "Jak sestavovat programy pro Nokii N900 v roce 2026"
author: "Jarda"
description: Cross-kompilace pro Maemo 5 z moderního Ubuntu. Workshop, sysroot z Fremantle SDK, wrapper pro gcc a balíčky .deb.
categories:
    - n900
    - Claude
tags:
    - Maemo
    - cross-kompilace
    - Workshop
thumbnail: https://github.com/elPytel/nokia-n900-notes/blob/main/assets/91lsz9ZdF7L._AC_SL1500_.jpg?raw=true
---

- [Co musíme postavit a pro vývoj](#co-musíme-postavit-a-pro-vývoj)
  - [Prostředí: Ubuntu Workshop](#prostředí-ubuntu-workshop)
  - [Sysroot z Fremantle SDK](#sysroot-z-fremantle-sdk)
  - [Wrapper pro gcc](#wrapper-pro-gcc)
- [První program pod qemu](#první-program-pod-qemu)
  - [Sysroot není telefon](#sysroot-není-telefon)
- [Jedna složka, jedna aplikace](#jedna-složka-jedna-aplikace)
  - [Balíček .deb a testy na telefonu](#balíček-deb-a-testy-na-telefonu)
  - [Co tohle neověří](#co-tohle-neověří)

Nokia N900 (Maemo 5, kódové jméno Fremantle) je z roku 2009, ale pořád se na ní dá pracovat. Chybí jí hlavně nové programy: původní SDK (Scratchbox) je dávno mrtvé a repozitáře Nokie zmizely. Tenhle článek popisuje, jak jsem si na novém počítači postavil prostředí, ve kterém se dají programy pro N900 překládat z aktuálního Ubuntu 26.04 a rovnou balit do `.deb`. Na tomto stojí všechno ostatní, co kolem N900 jde dnes dělat.

## Co musíme postavit a pro vývoj

Telefon má ARMv7 (Cortex-A8, 600 MHz), 256 MB RAM, jádro 2.6.28 a **glibc 2.5**. Moderní program, který chce novější glibc, se prostě nespustí. Kompilátor na samotném telefonu nemá smysl, takže jediná rozumná cesta kupředu je pomocí PC (cross-kompilace) a výsledek posílát na telefon (`.bin`, `.deb`).

### Prostředí: Ubuntu Workshop

Používám [Ubuntu Workshop](https://ubuntu.com/workshop/docs/), který staví na LXD. Ten nám dává izolovaný kontejner, do kterého se mountuje adresář projektu jako `/project`. Jeho definice je v jednom souboru `.workshop/n900.yaml`, a když na stroji instalaci znovu vytvoříte, dostanete identické prostředí.

```bash
sudo snap install --channel=6/stable lxd
sudo snap install --classic workshop
sudo lxd init                      # jednou, výchozí hodnoty stačí

cd N900
workshop launch n900
workshop run n900 -- toolchain     # gcc-arm-linux-gnueabi + qemu-user
workshop run n900 -- sysroot       # sysroot z Fremantle SDK
workshop run n900 -- cpp-hello     # přeloží hello.c a spustí ho pod qemu
```

Příkazy uvnitř kontejneru spouštím přes `workshop exec n900 -- ...`. Z `Makefile` v kořeni projektu je volám zkratkami, takže na hostiteli stačí `make`.

### Sysroot z Fremantle SDK

Aby kompilátor věděl, s čím linkovat, potřebuje **sysroot**: hlavičky a knihovny stejné verze jako na telefonu. Ty jsou v balíčcích Fremantle SDK. Nokiin server už neexistuje, ale kopie repozitáře z roku 2017 stále žije u komunity na `maemo.plan9.de`. Napsal jsem si malý skript `scripts/fetch_sysroot.py` (jen standardní knihovna Pythonu), který:

1. stáhne index `Packages` z SDK,
2. vybere nejnovější verzi každého balíčku a vyřeší závislosti,
3. stáhne jen potřebné `.deb` (po jednom, s malou pauzou, ať cizí server nezatěžuji),
4. rozbalí je přes `dpkg-deb -x` do `sysroot/`.

Výchozí sada má 111 balíčků a po rozbalení asi 91 MB. V sysrootu je `glibc 2.5.1`, `GCC 4.2.1`, `ncurses 5.7`, `GTK 2.14`, `glib 2.20` nebo `OpenSSL 0.9.8n`. To všechno jsou verze, na které je potřeba při psaní kódu pamatovat.

### Wrapper pro gcc

Obyčejné `arm-linux-gnueabi-gcc --sysroot=sysroot` nestačilo. Narazil jsem na dva problémy:

1. Ubuntu 24.04 má cross-gcc 13.3, který hledá **vlastní glibc 2.39** dřív než sysroot. Výsledná binárka pak chce symbol `GLIBC_2.34` a na Maemo 5 se nespustí.
2. Linker `ld.bfd` 2.42 padá na assertion v `elf32-arm.c`, když linkuje objekty z glibc 2.5.

Řešení je krátký skript `scripts/maemo-gcc`, který kompilátor donutí používat jen sysroot (`-B`, `-L`, `-nostdinc`, `-isystem`) a použije linker `gold` (`-fuse-ld=gold`). Přidává ještě `-march=armv7-a -mfpu=neon -mfloat-abi=softfp` pro procesor telefonu a `-fgnu89-inline`, protože hlavičky glibc 2.5 používají starý styl `extern inline`.

Po každém překladu kontroluju, jaké nejvyšší symboly glibc binárka chce:

```bash
arm-linux-gnueabi-objdump -T moje-binarka | grep GLIBC
```

Cílem je, aby tam nebylo nic vyššího než `GLIBC_2.5`.

## První program pod qemu

Ověřit, že se program aspoň slinkuje a běží, jde bez telefonu pomocí `qemu-user`:

```bash
qemu-arm -L /project/sysroot build/hello
Hello from Maemo 5 (armel, glibc 2.5)
```

Binárka je `ELF 32-bit LSB executable, ARM, EABI5`, interpreter `/lib/ld-linux.so.3`, NEON je zapnutý a nejvyšší symbol je `GLIBC_2.4`. 

{: .warning }
> **Pozor:** tohle ověřuje linkování proti glibc 2.5, ne chování na skutečném telefonu.

### Sysroot není telefon

První skutečný program, který jsem takhle zkusil, byl textový editor WordGrinder. Dostal jsem lekci, která se pak opakovala u skoro všeho: **SDK je vývojová sada, telefon má jen běhové knihovny a ne všechny.** WordGrinder potřebuje `ncursesw` (široké znaky), jenže telefon má jen `libncurses5` bez „w". Řešení je statické linkování: `libncursesw.a` z SDK se přidá přímo do binárky.

Z toho vyplynulo pravidlo, kterým se řídím u všech balíčků:

| Co | Jak |
|---|---|
| Základ systému (`libc6`, `libm`, `libpthread`) | závislost, hlídat symboly |
| Běžně přítomné knihovny (`libz`, `libssl0.9.8`, GTK, Hildon) | závislost, **ověřit na telefonu** (`ldd`, `dpkg -l`) |
| Na telefonu chybí (`libncursesw`) | statické linkování |
| Novější než systém (OpenSSL 3, nové libstdc++) | staticky, nebo soukromá kopie v `/opt/<aplikace>/lib` |

## Jedna složka, jedna aplikace

Každá aplikace má vlastní složku `apps/<jméno>/` s několika soubory:

```
apps/tty-clock/
├── Makefile       # jen pár řádků: název, verze, závislosti
├── build.sh       # stáhne upstream podle tagu a přeloží ve Workshopu
├── package.sh     # složí strom souborů a zavolá debpack_build
└── test.sh        # testy, které poběží na telefonu
```

Upstream zdrojáky **nekopíruji do repozitáře**. `build.sh` je stáhne podle tagu a do gitu patří jen skripty a případné záplaty. Společný `Makefile` (`mk/app.mk`) ke každé složce vytvoří cíle `build`, `deb`, `install`, `test` a `clean`, takže celý proces je jeden příkaz:

```bash
make tty-clock             # přeloží
make debs APP=tty-clock    # postaví .deb
make debs APP=tty-clock INSTALL=1   # a nainstaluje na telefon přes ssh
```

`make debs` bez parametru projde všechny aplikace a postaví jen ty, které jsou zastaralé (poznává to podle razítek v `build/stamps`). Aplikace mohou mít `DEPS := openssl curl`, takže se závislosti postaví napřed a jejich změna způsobí přestavbu aplikace.

### Balíček .deb a testy na telefonu

`package.sh` je krátký. Složí strom souborů do adresáře (programy dávám do `/opt/<aplikace>` a odkazy do `/usr/bin`, aby se nikdy nepřepsal systémový balíček), nastaví pár proměnných a zavolá pomocnou funkci `debpack_build` ze `scripts/debpack.sh`:

```bash
PKG=tty-clock
VERSION="${VERSION:-2.3}"
SECTION=user/utilities
DEPENDS="libc6 (>= 2.5), libncurses5 (>= 5.7)"
DISPLAY_NAME="tty-clock"
SHORT_DESC="Digital clock for the terminal"
debpack_desktop "tty-clock" "/usr/bin/$PKG" "$PROJ/apps/tty-clock/icon.png"   # záznam v menu
debpack_build
```

Funkce vytvoří `DEBIAN/control`, doplní údaje pro Application Manager (jméno a ikonu) a zavolá `dpkg-deb`. Verze balíčku je verze upstreamu s naší příponou, třeba `2.3-1maemo1`.

Testy v `test.sh` se spouštějí **na skutečném telefonu**: `make -C apps/tty-clock test` pošle skripty přes `ssh` a vypíše, co prošlo a co ne. Používají se pomocné funkce jako `ok` (příkaz vrátí 0), `contains` (výstup obsahuje text) nebo `skip`. Je to jednoduché, ale zachytí věci, které qemu nikdy neukáže, třeba chybějící knihovnu.

### Co tohle neověří

Pro úplnost, co je potřeba mít na paměti:

- `qemu-user` ověří jen linkování a základní běh, ne jádro 2.6.28 ani grafiku. Proto testy na telefonu.
- Wrapper `maemo-gcc` je zatím jen pro C. Pro C++ by chyběly hlavičky libstdc++ a bylo by potřeba ji linkovat staticky.
- Sysroot pochází ze snapshotu z roku 2017. Dlouhodobě bude potřeba vlastní kopie, o tom bude samostatný článek.

Celý projekt je pod organizací [n900-resurrection](https://github.com/n900-resurrection) na GitHubu a hotové balíčky jsou v apt repozitáři `https://n900-resurrection.github.io/n900-repository`. V dalších článcích se podíváme na to, co všechno už na N900 běží.
