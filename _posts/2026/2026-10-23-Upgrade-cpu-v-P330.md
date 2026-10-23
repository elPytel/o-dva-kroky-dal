---
layout: post
title:  "Upgrade cpu v P330"
author: "Jarda"
description: Z i5-8500 na i7-8700 za pár set korun
categories: 
    - Lenovo
    - pc
tags:  
    - P330
    - cpu
    - i5
    - i7
thumbnail: /assets/pc/p330/i7-8700.png
---

- [Upgrade CPU v Lenovo ThinkStation P330 Tiny](#upgrade-cpu-v-lenovo-thinkstation-p330-tiny)
  - [Hardwarové srovnání: i5-8500 vs. i7-8700](#hardwarové-srovnání-i5-8500-vs-i7-8700)
  - [Limity chlazení a instalace ve formátu Tiny](#limity-chlazení-a-instalace-ve-formátu-tiny)
  - [Výsledky po zátěži a reálné chování teplot](#výsledky-po-zátěži-a-reálné-chování-teplot)
  - [Reference](#reference)


# Upgrade CPU v Lenovo ThinkStation P330 Tiny

Původní osazený procesor Intel Core i5-8500 sice odváděl dobrou práci, ale říkal jsem si zda se výkonově ještě nemohu posunout dále na stejné platformě. Tak tam dáme Hyper-Threading! Řešením se ukázal nákup použitého procesoru Intel Core i7-8700 na Aukru za zhruba 2000 Kč. Za tuto částku jde o velmi efektivní posun celkového výpočetního výkonu.

P330 má celou řadu podporovaných procesorů, takže upgrade je možný bez zásahu do BIOSu. Stačí jen vyjmout původní čip a osadit nový. Vzhledem k tomu, že se jedná o stejnou generaci Coffee Lake, tak není potřeba řešit kompatibilitu s chipsetem.

Ukázka dostupných procesorů pro P330 Tiny:

| Processor Name  | Cores | Threads | Cache |
| --- | --- | --- | --- |
| Core i3-8100T|4|4| 6 MB|
| Core i5-8500T|6|6| 9 MB|
| Core i5-8500 |6|6| 9 MB|
| Core i7-8700 |6|12| 12 MB|
| Core i7-9700 |8|8| 12 MB|
| Core i9-9900 |8|16| 16 MB|

A mnoho ještě dalších variant mezi temito vybranými zástupci.

{: .tip}
> Procesory s TDP 35W (označené písmenem T) mají nižší základní frekvenci a menší turbo boost. Vzhledem k tomu, že P330 Tiny má chlazení dimenzované na 65W, tak je vhodné volit procesory s TDP 65W.

Nešáhl jsem po nejvýkonějším procesoru, který je možné do P330 Tiny osadit, ale zvolil jsem solidní upgrade na 12 vláken. Výkonější procesory s 8 jádry a 16 vlákny jsou již cenově výrazně dražší a to in a trhu s použitými procesory.

P330 podporuje i procesory 9. generace, ale mým cílem bylo získat co nejvíce vláken za co nejnižší cenu, předpokládám že až jednou nasadím Proxmox na P330, tak mi to umožní provozovat více virtuálních strojů a kontejnerů současně a to zejména ve srovnání s i5-7600K 4c4t, který je v Zalmanu.

## Hardwarové srovnání: i5-8500 vs. i7-8700

Hlavním lákadlem přechodu na i7 je jednoznačně dvojnásobný počet vláken a vyšší takty při zachování stejného tepelného vyzařování (TDP). Větší L3 cache a Hyper-Threading znamenají mnohem lepší odezvu celého systému a rychlejší zpracování úloh.

| Parametr | Intel Core i5-8500 | Intel Core i7-8700 | Rozdíl |
| --- | --- | --- | --- |
| Jádra / Vlákna | 6 / 6 | 6 / 12 | +6 vláken |
| Základní frekvence | 3.00 GHz | 3.20 GHz | +0.20 GHz |
| Max Turbo frekvence | 4.10 GHz | 4.60 GHz | +0.50 GHz |
| L3 Cache | 9 MB | 12 MB | +3 MB |
| TDP | 65 W | 65 W | Stejné |
| Rok vydání | 2018 | 2017 | ~ |
| Lithography | 14 nm | 14 nm | Stejné |


![]({{ site.baseurl }}/assets/pc/p330/20261023_114848.webp)
*Sundaný chladič*
![]({{ site.baseurl }}/assets/pc/p330/20261023_115725.webp)
*Osazený nový cpu: i7-8700*
![]({{ site.baseurl }}/assets/pc/p330/20261023_115956.webp)
![]({{ site.baseurl }}/assets/pc/p330/20261023_120302.webp)
![]({{ site.baseurl }}/assets/pc/p330/20261023_115715.webp)
*Původní cpu: i5-8500*

## Limity chlazení a instalace ve formátu Tiny

Při upgradu v 1L šasi je nejčastějším problémem dimenzování chladiče. Výhodou tohoto konkrétního kusu bylo, že původní procesor i5-8500 nebyl úspornou „T“ variantou (která mívá pouze 35W TDP). Základní deska už z výroby disponovala silnějším 65W chladičem s masivnějším pasivem a heatpipe. Fyzická výměna tedy nevyžadovala shánění výkonnějšího chlazení, šasi je na 65W čip připravené.

Při usazování čipu jsem k přepastování využil ARCTIC MX-2 z edice 2019. Výrobce u této pasty deklaruje trvanlivost 8 let, a jelikož vizuální kontrola i konzistence obsahu tuby ukázaly, že je hmota stále ve výborné kondici, nebyl důvod kupovat novou.

## Výsledky po zátěži a reálné chování teplot

Osadit 65W i7 do litrového prostoru znamená narazit na neúprosné fyzikální limity. Při trvalé 100% zátěži ve stress testu se procesor osciluje mezi takty v rozmezí 3.1 až 3.4 GHz, přičemž teplota spolehlivě sedí na hranici 90 °C. Pro neznalého uživatele může číslo znít kriticky, ale pro tento specifický formát a procesor (s kritickou teplotou Tjunction na 100 °C) je to naprosto standardní chování. BIOS Lenova agresivně řídí power limity, aby čip udržel v bezpečných mezích a zamezil tvrdému podtaktování pod základní frekvenci.

![]({{ site.baseurl }}/assets/pc/p330/i7-8700.png)
*Mission center: i7-8700*

## Reference
- [intel: Core i5-8500](https://www.intel.com/content/www/us/en/products/sku/129939/intel-core-i58500-processor-9m-cache-up-to-4-10-ghz/specifications.html)
- [intel: Core i7-8700](https://www.intel.com/content/www/us/en/products/sku/126686/intel-core-i78700-processor-12m-cache-up-to-4-60-ghz/specifications.html)