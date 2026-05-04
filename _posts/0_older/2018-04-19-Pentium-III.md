---
layout: post
title:  "Pentium III"
author: "Jarda"
description: Úlovek do sbírky historických počítačů
categories: 
    - pc
tags: 
    - Intel
    - Pentium III
thumbnail: /assets/pc/Pentium_III_03.jpg
---


![Pentium_III]({{ site.baseurl }}/assets/pc/Pentium_III_02.jpg)

## SECC2 (Single Edge Contact Cartridge)
SECC2 byla slepá ulička vývoje, která ale ve své době dávala perfektní smysl.


![Pentium_III]({{ site.baseurl }}/assets/pc/Pentium_III_01.jpg)
![Pentium_III]({{ site.baseurl }}/assets/pc/Pentium_III_03.jpg)

Na obnažené desce, si můžete všimnout několika zajímavých věcí:
 * **Procesorové jádro:** Uprostřed je samotný křemíkový čip (jádro Katmai). Na rozdíl od dnešních procesorů, které jsou malé a schované pod kovovým rozvaděčem tepla, je tady vidět, jak je všechno rozprostřené na PCB.
 * **Symetrie cache:** Samsung čipy. Je to fascinující ukázka tehdejších limitů – vyrobit 512 KB rychlé paměti přímo na stejném kousku křemíku jako procesor bylo tehdy příliš drahé a technologicky náročné, tak ji Intel prostě „přilepil“ vedle.
 * **Sběrnice:** Všimněte si těch zlatých kontaktů na spodní straně. Slot 1 vypadá spíš jako slot pro RAM nebo grafiku, což byl záměr – Intel tím chtěl vytlačit konkurenci (AMD), která tehdy ještě používala patice (Socket 7).

### Samsung L2 Cache SRAM
Čipy vpravo od proceoru jsou **Samsung L2 Cache SRAM** (Synchronous Burst SRAM). Konkrétní modelové označení je **M736V604AMT-4**.

Technické detaily:
 * **Určení:** Tato paměť se používala jako externí **L2 cache**
 * **Kapacita:** Každý tento čip má kapacitu **256 KB** (2 Mbit).
 * **Rychlost:** Koncovka **-4** v modelovém čísle značí přístupovou dobu **4 ns**. Tato cache běžela obvykle na poloviční frekvenci procesoru.
 * **Datum výroby:** Kód **943** znamená, že čip byl vyroben ve **43. týdnu roku 1999** (přibližně konec října).

### Pentium III 500 MHz

Cache čipy s vysokou pravděpodobností určují i frekvenci Pentia:
**4 ns** přístupová doba odpovídá frekvenci 250 MHz. U jádra Katmai běžela L2 cache vždy na polovině frekvence procesoru.

$$250 \text{ MHz} \times 2 = \mathbf{500 \text{ MHz}}$$

### Kontext
Jakmile Intel přešel na novější jádro „Coppermine“, začal integrovat L2 cache přímo do křemíku procesoru. Tím se výrazně zvýšil výkon a potřeba těchto externích SRAM čipů zanikla.



