---
layout: post
title:  "Emulátor N900 na desktopu"
author: "Jarda"
description: Jak zkoušet aplikace pro Maemo 5 na PC bez telefonu. qemu-user, Xvfb, motiv z telefonu a vlastní lišta a přepínač oken.
categories:
    - n900
tags:
    - N900
    - Maemo
    - emulátor
    - Hildon
thumbnail: /assets/n900/n900 emilátor v2 apps.png
---

- [Proč emulovat](#proč-emulovat)
  - [Jak to funguje](#jak-to-funguje)
  - [Spuštění jedné aplikace](#spuštění-jedné-aplikace)
- [Vlastní plocha: lišta, přepínač a spouštěč](#vlastní-plocha-lišta-přepínač-a-spouštěč)
- [Aplikace se najdou samy](#aplikace-se-najdou-samy)
- [D-Bus atrapy](#d-bus-atrapy)
- [Co se neemuluje](#co-se-neemuluje)
  - [Proč nejde skutečný hildon-desktop](#proč-nejde-skutečný-hildon-desktop)

Psát aplikace s grafickým rozhraním pro N900 je pomalé, když je musím pokaždé instalovat na telefon. Úplný emulátor z doby Nokie (Scratchbox a Xephyr) už nejde stáhnout, a tak jsem si na PC postavil vlastní. Není dokonalý, ale vzhled aplikací i logika odpovídají tomu, co uvidíte na telefonu.

## Proč emulovat

- Rychlejší vývoj. Změním kód a okamžitě uvidím výsledek bez `scp` a instalace.
- Mohu dělat **snímky obrazovky** automaticky (screenshoty do dokumentace).
- Chyby, které souvisejí jen s kódem (tlačítka, signály, texty), se najdou bez telefonu.

### Jak to funguje

Princip je jednoduchý:

1. **qemu-user** spouští ARM binárky z telefonu přímo na PC proti **stejným knihovnám** (GTK 2.14, Hildon 2.2), které máme v sysrootu.
2. Obraz jde na virtuální obrazovku **Xvfb** 800×480 uvnitř Workshopu. Okno vypadá jako na telefonu (motiv `beta`, písmo Nokia Sans), protože si motiv, písma a ikony jednou zkopíruju z telefonu: `make hildon-overlay` (asi 100 MB).
3. Aplikace v **Pythonu 2.5 s PyGTK** (mutt-hildon, gPodder) běží s interpreterem, který se zkopíruje z telefonu do sysrootu. Python 3 má vlastní překlad (viz článek Python 3.11 na N900).

Poznámka: musí se nastavit `LC_ALL=C`, protože glibc 2.5 ze sysrootu neumí číst jazykové soubory hostitele.

### Spuštění jedné aplikace

```bash
make hildon-overlay                       # jednou: motiv, písma, ikony a Python 2.5 z telefonu
make python3                              # ARM python3
make hildon-run SCRIPT=src/python3/hildon/proof.py SHOT=/project/build/shot.png   # Python 3, snímek po 6 s
make hildon-run APP=mutt-hildon           # celá aplikace s ukázkovými daty
make hildon-run ... VNC=1                 # obraz navíc přes VNC (port 5999 kontejneru)
```

![Hildon demo]({{ site.baseurl }}/assets/n900/n900 emilátor a terminál.png)
*na pozadí ssh na n900, v popředí emulátor s Hildon demo*

Snímek se uloží do `build/shot.png` na hostiteli, protože `/project` ve Workshopu je kořen repozitáře. Přes VNC (`remmina` nebo `vncviewer`) se dá obraz sledovat a myší klikat, takže dotykové ovládání jde zkoušet přibližně.

![n900 emilátor v1 apps]({{ site.baseurl }}/assets/n900/n900 emilátor v1 apps.png)
*emulátor s menu s aplikacemi*

![n900 emilátor v1 htop3]({{ site.baseurl }}/assets/n900/n900 emilátor v1 htop3.png)
*emulátor s htop3 (ARM binárka z repozitáře)*

![n900 emilátor v1 mutt]({{ site.baseurl }}/assets/n900/n900 emilátor v1 mutt.png)
*emulátor s mutt*

![mutt-hildon]({{ site.baseurl }}/assets/n900/n900 emilátor v1 email menu.png)
*mutt-hildon v emulátoru*

Takhle jsem kontroloval třeba `mutt-hildon`: seznam zpráv se v emulátoru vykreslil stejně jako na telefonu.

## Vlastní plocha: lišta, přepínač a spouštěč

Při práci mi chyběl pocit „skutečného“ telefonu, tak jsem emulátor rozšířil o vlastní plochu: `make emulator`. Skript `hildon-session.sh` spustí Xvfb, správce oken `matchbox-window-manager` a horní lištu napsanou v Pythonu (GTK3). Aplikace dostanou 800×424 pod lištou, stejně jako na N900. 

![apps]({{ site.baseurl }}/assets/n900/n900 emilátor v2 apps.png)
*Spouštěč*
![running]({{ site.baseurl }}/assets/n900/n900 emilátor v2 running.png)
*Přepínač*

Lišta sleduje screenshoty z telefonu:

`[okna] | hodiny a baterie | název aplikace ▾ | [zpět]`

- **Oranžové tlačítko vlevo** přepíná: **aktuální aplikace** → **přepínač** → **všechny aplikace** → **aktuální aplikace**.
  - **Přepínač** ukazuje na ztmavené tapetě kartu každé běžící aplikace (tři v řádku): název, oranžové X pro zavření a obrázek okna.
  - **Spouštěč** zobrazí všechny nainstalované aplikace, pět ikon v řádku.
- **Název aplikace** je tlačítko **Menu** (menu aktivního okna). Oranžová šipka vpravo je **Zpět**.
- Klepnutí na hodiny otevře zjednodušenou kopii stavového menu (baterie, datum, síť).
- Tapeta je původní z telefonu (`background-1.png`), do repozitáře se nekopíruje.

![email menu]({{ site.baseurl }}/assets/n900/n900 emilátor v2 email menu.png)
*Email + menu*

## Aplikace se najdou samy

Spouštěč nabízí dvě skupiny: vývojové kopie (`apps/<app>/hildon-run.sh`) a **každý balíček** v `build/deb/*.deb`, který má záznam `.desktop`. Jméno a ikona se berou z balíčku. Při prvním spuštění se balíček rozbalí do sysrootu (jako instalace) a běží jako na telefonu:

- ARM programy přes qemu-user a `binfmt_misc`,
- obálkové skripty v shellu hostitele,
- `osso-xterm -e …` se otevře ve vlastním xtermu,
- skripty Pythonu 2.5 (gPodder) běží přes interpreter ze sysrootu.

Vyzkoušeno s htop a CMatrix. Menu aplikací řeším tím, že `HildonAppMenu.popup()` bez `hildon-desktop` nic nezobrazí, takže položky ukážu v okně vlastní a klepnutí zavolá původní tlačítko.

## D-Bus atrapy

Aplikace pro Maemo se opírají o služby systému. Skript `hildon-dbus.sh` proto spustí soukromou sběrnici a `hildon-dbus-mocks.py` na ní zaregistruje atrapy: `com.nokia.icd` (démon spojení) a přehrávač MAFW. Modul `conic` v Pythonu 2.5 nahrazuje skript, který vždy hlásí „WLAN“. Díky tomu se gPodder 2.20.3 spustí. Další služby se přidávají jako třídy v jednom souboru.

## Co se neemuluje

- Stavový řádek jako na telefonu, widgety plochy a klávesnice Maemo (používá se klávesnice hostitele).
- Skutečné D-Bus služby, spojení se sítí (aplikace končí chybovou hláškou, třeba bez IMAP serveru).
- Rychlost: qemu je pomalé, start Pythonu trvá pár sekund. Na správnost vzhledu a logiky se spolehnout dá, na rychlost ne.
- Kinetické posouvání (`PannableArea`) jde zkoušet jen přibližně.

### Proč nejde skutečný hildon-desktop

Zkusil jsem to, ale skutečný `hildon-desktop` 2.2 kreslí přes clutter s OpenGL ES 2 na grafice PowerVR (`libIMGegl`, `libpvrPVR2D_*`). Pod qemu-user na PC pro ty knihovny nic nemá, na čem by běžely, a mockováním D-Busu se to nespraví. Zbývají dvě cesty: archivní x86 rootstrap Maemo 5 SDK (Scratchbox, jenže oficiální stahování zaniklo), nebo přeložit hildon-desktop ze zdrojů pro x86_64 s Mesa llvmpipe (pracné, odhaduju na dny). Zatím mi vlastní lišta stačí.

Všechno je v hlavním repozitáři projektu v organizaci [n900-resurrection](https://github.com/n900-resurrection), skripty jsou v `scripts/hildon-*.sh` a `scripts/hildon-shell.py`.
