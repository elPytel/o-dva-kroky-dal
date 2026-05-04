---
layout: post
title:  "RPi Zero W vs AMD 8080"
author: "Jarda"
description: Srovnání RPi Zero W a AMD 8080
categories: 
    - pc
tags: 
    - Raspberry Pi
    - AMD
    - AMD 8080
thumbnail: /assets/RPi/RPi_Zero_04.jpg
---

# RPi Zero W vs AMD 8080

- [RPi Zero W vs AMD 8080](#rpi-zero-w-vs-amd-8080)
  - [Proč má AMD na sobě i logo Intelu?](#proč-má-amd-na-sobě-i-logo-intelu)
  - [Skutečný klenot počítačové historie](#skutečný-klenot-počítačové-historie)
  - [Střeva ze SAPI-1?](#střeva-ze-sapi-1)
    - [Proč je tam AMD a ne Tesla?](#proč-je-tam-amd-a-ne-tesla)


| Parametr | RPi Zero W | AMD 8080 |
| --- | --- | --- |
| Rok | 2017 | 1975 |
| Architektura | 32-bit | 8-bit |
| Frekvence | 1GHz | až 4MHz |

![RPi Zero W]({{ site.baseurl }}/assets/RPi/RPi_Zero_04.jpg)
![RPi Zero W]({{ site.baseurl }}/assets/RPi/RPi_Zero_05.jpg)

Po RPi je počítač na kterém maturovala moje máma v roce 1989 na Průmyslovce. Já z něj dostal to co zbylo při svém studiu, když se vyklízel bordel v laboratořích.

## Proč má AMD na sobě i logo Intelu?
V 70. a 80. letech fungoval takzvaný **„Second Sourcing“**. Velcí odběratelé (zejména **IBM** a armáda) odmítali kupovat procesory od firmy, která by byla jediným dodavatelem. Kdyby Intel zkrachoval nebo mu vyhořela továrna, IBM by neměla co dávat do počítačů.
* **Dohoda z roku 1976:** Intel musel podepsat smlouvu s AMD a poskytnout jim své návrhy (masky), aby AMD mohlo vyrábět identické čipy jako „záložní zdroj“.
* **Identické vnitřnosti:** Tyhle čipy nebyly jen napodobeniny, byly to legitimní kopie vyrobené podle dokumentace Intelu. Proto se na nich často objevovalo logo Intelu (jako držitele patentu/autorských práv) i značka AMD (jako výrobce).

| Typ pouzdra                   | Odhadovaná cena      | Poznámka                                                |
| :---------------------------- | :------------------- | :------------------------------------------------------ |
| **Plastové (černé)**          | **300 – 600 Kč**     | Běžná průmyslová verze.                                 |
| **Keramické (bílé/fialové)**  | **1 000 – 2 500 Kč** | Vysoce ceněné sběrateli, často s pozlacenými piny.      |
| **Vojenská verze (Mil-Spec)** | **3 000 Kč+**        | Pokud má na sobě speciální značení nebo je v TOP stavu. |


> **Zajímavost:** Tenhle čip je přímým předkem architektury **x86**, na které běží i dnešní Ryzen. Je to v podstatě „pradědeček“ současných počítačů.

## Skutečný klenot počítačové historie

![RPi Zero W]({{ site.baseurl }}/assets/RPi/RPi_Zero_03.jpg)

Tady je rozbor toho, co na té fotce vidíme:
* **Zlaté víčko (Gold Lid):** To, že má čip uprostřed tenhle zlatý čtvereček, z něj dělá "Svatý grál" mezi verzemi 8080. Nejenže to skvěle vypadá na poličce, ale u sběratelů to okamžitě posouvá cenu k té horní hranici, protože tyhle verze se zlatem byly určeny pro náročné průmyslové nebo vojenské nasazení.
* **Datum výroby (7736):** Ten kód pod názvem znamená, že procesor sjel z linky ve **36. týdnu roku 1977**. To je září '77. Jen pro kontext: v té době v kinech běžely první Star Wars (Epizoda IV) a Apple II byl úplná novinka.
* **Kombinace log:** Je tam krásně vidět logo AMD (to stylizované "A") hned vedle kódu Intelu (C8080A). Je to fascinující připomínka doby, kdy AMD bylo v podstatě "náhradním výrobcem" pro Intel.

## Střeva ze SAPI-1?
S největší pravděpodobností se díváte na moduly z legendárního československého mikropočítačového systému **SAPI-1** (Systém Automatického Programování a Inženýrství).

Tento systém nebyl „jeden počítač v krabici“ jako dnešní notebooky, ale skládačka z jednotlivých desek (plošných spojů) ve formátu **VPE** (standardizované karty).
* **Tři desky:** Základní funkční sestava pro výuku se obvykle skládala ze tří hlavních modulů:
 1. **JPR-1 (Jednotka procesoru):** To je právě ta deska, na které máš tenhle **AMD 8080**. Je to mozek celého systému.
 2. **REM-1 (Paměť):** Deska s pamětí RAM a EPROM, kde byl uložen operační systém (často MIKROS nebo CP/M).
 3. **AND-1 nebo DSM-1:** Deska pro komunikaci s displejem, klávesnicí nebo pro řízení strojů.
* **Maturita v roce '89:** Na průmyslovkách (zejména obory zaměřené na automatizaci a strojírenství) byl SAPI-1 v té době standardem. Studenti na něm v assembleru (strojovém kódu) psali programy pro řízení modelů křižovatek, výtahů nebo jednoduchých robotických ramen.

### Proč je tam AMD a ne Tesla?
V československých systémech se standardně používaly tuzemské klony **Tesla MHB8080A**. Čip v počítači **AMD AM9080ADC**, znamená to, že šlo o kus z rané výroby nebo o desku, kde se kladl důraz na maximální spolehlivost (keramika od AMD byla tehdy považována za špičku, zatímco plastové Tesly občas "zlobily"). Pro školu to byl v té době drahý a vzácný kus hardwaru.

