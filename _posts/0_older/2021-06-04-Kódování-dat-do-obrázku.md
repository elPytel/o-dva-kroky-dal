---
layout: post
title:  "Kódování dat do obrázku"
author: "Jarda"
description: Jako ve filmu Marťan!
categories: 
    - TUL
    - Github
tags: 
    - programming
    - ALG
    - Java
---

# Semestrální práce na ALG

První ročník programování na TUL a moje semestrální práce v programovacím jazyce Java. Cílem práce bylo implementovat algoritmus pro kódování dat do obrázku ve formátu PPM.

Odkaz na Github [zde](https://github.com/TUL-IT-2020/data-encryption-to-ppm-image)

Inspiroval jsem se knihou, kterou jsem zrovna četl **Marťan**, kde využijí podobného způsobu aby odeslali na palulubu kosmické lodi program, který je má zpátky dostat na Mars. Program schovávají do opbrázku, protože je to proti vůli vedení NASA. 

## Návrh řešení
Jako výchozí formát obrázku jsem zvolil PPM, s magickou hodnotou P3. PPM je formát, který je sice velice nešetrný co se týče velikosti na disku, ale jeho čtení je opravdu jednoduché. Typ P3 kóduje informaci barvě (true color), 3 kanály (R,G,B) v podobě čísel 0-255 zapsaných jako znaky ASCII do textového souboru. Je tak jednoduché kontrolovat výsledek manipulace dat. Aby zapsaná data nebyla člověkem spatřitelná, využívá se zápisu ze strany LSB (least significatn bit), například pokud je jeden barevný kanál kódovaný do 8-bitů, pak MSB (1. bit z leva) nabívá hodnot 0/128, zatím LSB (1. bit z prava) 0/1. Na rozsahu 256 hodnot se při hloubce zápisu 1-bit doupouštíme zkreslení -+1 (cca <0,5%), což běžným okem na obrázcích typu fotografie krajiny je nespatřitelné. Můj program umožnuje zápis 1/8 (1-bit dat na 8-bitů obrazu) až 8/8, kde však již dochází ke 100% zkreslení původního obrazu.

## Funkční specifikace
Vybrat obrázek pro uložení dat
Vybrat hloubku zápisu dat (1-8)
Přidat soubor do obrázku
Nahrát soubor z obrázku
Vypsat obsah obrázku podle zvoleného setřídění
Uložit modifikovaný obrázek na disk
Smazat uložená data z obrázku

## Objektový model
![Objektový model](https://github.com/TUL-IT-2020/data-encryption-to-ppm-image/raw/main/assets/images/class_diagram.png)
*Objektový model*

## Externí knihovna

Pro splnění zadání jsme měli využít alespoň jednu externí knihovnu. Já jsem zvolil knihovnu JUnit pro testování. Vytvořil jsem několik testů, které měli ověřit správnou funkčnost mého programu. Bylo to vlastně mé úplně první setkání s testováním kódu a hned jsem se vydal na stopu TDD (test-driven development).