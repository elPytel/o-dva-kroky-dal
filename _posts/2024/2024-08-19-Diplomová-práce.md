---
layout: post
title: "Diplomová práce"
description: Výběr tématu diplomové práce
categories: 
    - TUL
    - DP
thumbnail: https://raw.githubusercontent.com/TUL-IT-2020/Fault-tolerant_filesystem_storage_for_CubeSat/refs/heads/main/assets/sdhc.gif
---

# Realizace úložiště souborového systému Linux odolného proti poruchám určeného pro CubeSat

## Zadání práce:

<iframe src="https://docs.google.com/gview?url=https://raw.githubusercontent.com/TUL-IT-2020/Fault-tolerant_filesystem_storage_for_CubeSat/refs/heads/main/zadání.pdf&embedded=true" width="100%" height="600" style="border:0;"></iframe>

## Bojový plán:
- Nastudovat
- Rozmyslet
- Nakódovat

Rozkovec mi klidně půjčí desku.
Martin má sd řadič s filesystém.

Axi Quad spi 
Fat fs
Vivado sdk fat file system

Opravné kódy 

mtd (memory technologi devices)
- https://github.com/lgirdk/mtd-utils
- ubiFS

Jaký souborový systém používají na satelitu?
Jak VZLU sat ma naformátované úložiště?
ext4 (používají to všichni, používáme to my!)
jffs2 
(většinou read only)

Jak určit stav, nebo zbývající životnost SD karty?
Jak měřit odběr SD karty pomocí FPGA? Práce neobsahuje BIST - build in self test.

Lehce pošťourat filesystémy. 
Podívat lehce na RAID

Používejte to co je nejvíc otestováno, takže to co běží ve všech počítačích na světě. 

ZHP - zinq heigh performence platform (VZLUT sat 2)
Saturnin má 2 paměti

1 paměť může být dostačující pro měsíční misi.

RADHARD  - odolnost proti radiaci
Vyvarovat se - Single point of failure

Problém piny FPGA mohly by dojít (už došly) 
Co s tím?
- Sežeňte si větší FPGA.
- Multiplex na jiná zařízení.

Licenční práva na SD specifikaci?
SPI na SD není SPI takže budu bojovat, má to asi inicializaci.
SPI pro demonstraci stačí.
MMC protokol by mohl být otevřený.

Protokol vs rozhraní 

Jak inicializovat SD po SPI?

Automotive grade alespoň (minimum industry).

Tvářit se jsem jedna velká "SD"
VZLSAT by mi mohlo půjčit desku, mohl bych jim udělat rozšiřující desku.
Vedlejší kanál který hlásí diagnostiku SD karet. 

Podívat se open source projekty.
Mohli by mít pipeline ->
!!!
PEGUtronix SD mux

"Nejlepší součástka je ta kterou nepotřebujete."
Elon Musk

Load switch (10-15 pro odpojování jednotlivých zařízení)
Boot v minimální režimu.
Pak se připojuje postupně další zařízení.
Měříme spotřebu, když je to poškozené radiací, žere to, tak to odpojíme.

Rozšíření práce:
Implementace odpojovače SD, měření spotřeby.

Blokové scénáře

Lze udělat bypass?
Určitě zrychlí čtení.

Jak to napojit na uBoot?
- bude se muset měnit device tree?
- jsem blokové zařízení

Definovat možné chyby disku: 
- Co nám hrozí, jaké jsou příčiny, co s tím můžeme dělat.
- Přehřátí způsobí více problémů než radiace.
- Tomáš VZLU by mohl vědět co kdy selže.

Zeptat se Mazla na slacku 
Pěkné články o sestavě satelitu, které běží na Linuxu.

Tomáš Novotný VZLU Brno satelity, slack
Info na webu

Zdroje:
Školní knihovna
Databáze, podpora vědy, rešerše 
Scopus elsevier
IEEE  explore
Linux for Space - naše stránky 
AIAA
NTK v Praze

Fmeca - fdir thesis na disku
- Jak se zotavovat z chyb
