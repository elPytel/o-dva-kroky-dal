---
layout: post
title:  "Výběr grafické karty"
author: "Jarda"
description: Výběr vhodné grafické karty pro Lenovo ThinkCentre M920Q Tiny
categories: 
    - NVIDIA
    - Intel
tags: 
    - RTX
    - GTX 1050 Ti
    - GTX 1650
    - Arc
thumbnail: /assets/pc/Nvidia T400.webp
---

Plánuji si pořídit počítač Lenovo ThinkCentre M920Q Tiny a ze stoláku udělat domácí server.

Myšlenka serveru je taková, že z něj půjde streamovat hry do obýváku, takže potřebuji grafickou kartu, která zvládne dekódovat video a zároveň bude mít dostatečný výkon pro hraní indie her.

Počítač má jeden half-height PCIe slot, takže je potřeba hledat grafické karty s nízkým profilem (low-profile) a zároveň s co nejnižší spotřebou, aby se vešly do malého prostoru a byly kompatibilní s napájením počítače. Maximální spotřeba by měla být kolem 75 W, ideálně méně, abych předešel problémům s chlazením a napájením.

- [Starší grafické karty od NVIDIA](#starší-grafické-karty-od-nvidia)
  - [Yeston GTX 1050 ti 4GD5](#yeston-gtx-1050-ti-4gd5)
  - [SRhonyra GTX 1650 Low Profile 4GB Graphics](#srhonyra-gtx-1650-low-profile-4gb-graphics)
- [Moderní grafické karty od NVIDIA](#moderní-grafické-karty-od-nvidia)
  - [NVIDIA T400](#nvidia-t400)
  - [NVIDIA T600](#nvidia-t600)
  - [NVIDIA T1000](#nvidia-t1000)
  - [NVIDIA A400](#nvidia-a400)
  - [NVIDIA A1000](#nvidia-a1000)
  - [Yeston RTX 3050 6GB](#yeston-rtx-3050-6gb)
  - [X-VISION RTX 3050M 8GB Low Profile](#x-vision-rtx-3050m-8gb-low-profile)
  - [NVIDIA RTX 5060 Low Profile](#nvidia-rtx-5060-low-profile)
- [Intel](#intel)
  - [Intel Arc A310 Low Profile](#intel-arc-a310-low-profile)
  - [Zdroje:](#zdroje)

# Starší grafické karty od NVIDIA

## Yeston GTX 1050 ti 4GD5

![]({{ site.baseurl }}/assets/pc/YESTON GTX 1050 ti 4GB.webp)
*Yeston GTX 1050 ti 4GB GDDR5*

| Parametr | hodnota |
| --- | --- |
| Cena | 140 USD |
| Paměť | 4 GB GDDR5 |
| PCIE | 3.0 x16 |
| Cuda | 768 |

## SRhonyra GTX 1650 Low Profile 4GB Graphics

![]({{ site.baseurl }}/assets/pc/SRhonyra GTX 1650.jpg)
*SRhonyra GTX 1650 Low Profile 4GB Graphics*

| Parametr | hodnota |
| --- | --- |
| Cena | 5 000 Kč |
| TDP | 60 W |
| Paměť | 4 GB GDDR5 |
| PCIE | 3.0 x16 |
| Cuda | 896 |

# Moderní grafické karty od NVIDIA

## NVIDIA T400

NVIDIA T400 je aktuálně vůbec nejmenší RTX karta na světě (velikostně je shodná s modely T600 a T1000, které vyšly ve stejnou dobu).

![]({{ site.baseurl }}/assets/pc/Nvidia T400.webp)
*NVIDIA T400*

NVIDIA tuto kartu běžně nepropaguje pod herním označením RTX, ale oficiální produktový list potvrzuje, že spadá do profesionální řady **RTX Professional**. Jedná se o levnou grafiku pro pracovní stanice (budget workstation GPU).

Je extrémně malá a vejde se do miniaturního počítače Lenovo (Lenovo tiny PC), který je tlustý pouhých 3,8 cm (1,5 palce).

| Parametr | hodnota |
| --- | --- |
| TDP | 30 W |
| Paměť | 4 GB GDDR5-6 |
| CUDA jader | 384 |

Přestože papírově patří do profesionální RTX rodiny, Nvidia u ní musela kvůli rozměrům udělat zásadní hardwarové škrty:

* **Absence Tensor jader:** Karta fyzicky nemá žádná Tensor jádra. Kvůli tomu v hrách **vůbec nelze zapnout DLSS** (volba je plně zašedlá).
* **Absence Ray Tracing jader:** Karta nemá žádná RT jádra. Moderní hry detekují, že GPU nemá schopnost zpracovávat ray tracing, a tuto herní funkci vůbec nedovolí zapnout.

## NVIDIA T600

| Parametr | hodnota |
| --- | --- |
| TDP | 40 W |
| Paměť | 4 GB GDDR6 |
| CUDA jader | 640 |

## NVIDIA T1000

| Parametr | hodnota |
| --- | --- |
| TDP | 50 W |
| Paměť | 4 GB GDDR6 |
| CUDA jader | 896 |

## NVIDIA A400

![]({{ site.baseurl }}/assets/pc/Nvidia A400.webp)
*NVIDIA A400*

| Parametr | hodnota |
| --- | --- |
| TDP | 50 W |
| Paměť | 4 GB GDDR6 |
| CUDA jader | 768 |

## NVIDIA A1000

| Parametr | hodnota |
| --- | --- |
| TDP | 50 W |
| Paměť | 8 GB GDDR6 |
| CUDA jader | 2304 |

## Yeston RTX 3050 6GB

![]({{ site.baseurl }}/assets/pc/YESTON RTX 3050 6GB.jpg)
*Yeston RTX 3050 6GB*

| Parametr | hodnota |
| --- | --- |
| Cena | 220 USD |
| TDP | 70 W |
| Paměť | 6 GB GDDR6 |
| PCIE | 4.0 x8 |
| CUDA jader | 2304 |
| 3DMark Time Spy | 4 700 |

## X-VISION RTX 3050M 8GB Low Profile

X‑VSION NVIDIA GeForce RTX 3050 Mobile GPU poskytuje vysoký výkon pro hráče i tvůrce obsahu. Je postavena na architektuře Ampere — druhé generaci RTX od NVIDIE — a přináší co nejrealističtější ray‑tracingovou grafiku a špičkové AI funkce, například NVIDIA DLSS.

![]({{ site.baseurl }}/assets/pc/X-Vision_rtx3050m.jpg)
*X-VISION RTX 3050M 8GB Low Profile*

| Parametr | hodnota |
| --- | --- |
| Cena | 200 USD |
| Paměť | 8 GB GDDR6 |
| PCIE | 4.0 x8 |
| CUDA jader | 2304 |
| 3DMark Time Spy | 4 600 |

## NVIDIA RTX 5060 Low Profile

Half-height dvou slotová grafická karta. Do počítače Lenovo ThinkCentre M920Q Tiny se "vejde", ale bude potřeba odstranit zadní kryt.

| Parametr | hodnota |
| --- | --- |
| Cena | 300 USD |
| Paměť | 8 GB GDDR7 |
| PCIE | 5.0 x8 |
| CUDA jader | 3840 |

# Intel

## Intel Arc A310 Low Profile

Grafická karta SPARKLE Intel Arc A310 ECO s 4GB operační pamětí GDDR6 nabízí špičkovou energetickou účinnost s příkonem pouhých 50 W. Model je vybaven low-profile konstrukcí a v balení naleznete i krátký bracket pro instalaci do kompaktních sestav.

![]({{ site.baseurl }}/assets/pc/Intel_arc_a310.webp)

| Parametr | hodnota |
| --- | --- |
| Cena | 3000 Kč |
| TDP | 50 W |
| Paměť | 4 GB GDDR6 |
| PCIE | 4.0 x16 |

## Zdroje:
- [techpowerup](https://www.techpowerup.com/)