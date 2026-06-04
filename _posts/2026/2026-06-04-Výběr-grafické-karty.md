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
    - GTX 1050
    - GTX 1650
    - Arc
thumbnail: /assets/pc/Nvidia T400.webp
---

Plánuji si pořídit počítač Lenovo ThinkCentre M920Q Tiny a ze stoláku udělat domácí server.

Myšlenka serveru je taková, že z něj půjde streamovat hry do obýváku, takže potřebuji grafickou kartu, která zvládne dekódovat video a zároveň bude mít dostatečný výkon pro hraní indie her.

Počítač má jeden half-height PCIe slot, takže je potřeba hledat grafické karty s nízkým profilem (low-profile) a zároveň s co nejnižší spotřebou, aby se vešly do malého prostoru a byly kompatibilní s napájením počítače. Maximální spotřeba by měla být kolem 75 W, ideálně méně, abych předešel problémům s chlazením a napájením.

- [Starší grafické karty od NVIDIA](#starší-grafické-karty-od-nvidia)
  - [Quadro P400](#quadro-p400)
  - [NVIDIA Quadro P620](#nvidia-quadro-p620)
  - [NVIDIA Quadro P1000](#nvidia-quadro-p1000)
  - [Yeston GTX 1050 ti 4GDDR5](#yeston-gtx-1050-ti-4gddr5)
  - [SRhonyra GTX 1650 Low Profile 4GB Graphics](#srhonyra-gtx-1650-low-profile-4gb-graphics)
- [Moderní grafické karty od NVIDIA](#moderní-grafické-karty-od-nvidia)
  - [NVIDIA T400](#nvidia-t400)
  - [NVIDIA T600](#nvidia-t600)
  - [NVIDIA T1000](#nvidia-t1000)
  - [NVIDIA A400](#nvidia-a400)
  - [NVIDIA A1000](#nvidia-a1000)
  - [Yeston RTX 3050 6GB](#yeston-rtx-3050-6gb)
  - [X-VISION RTX 3050M 8GB Low Profile](#x-vision-rtx-3050m-8gb-low-profile)
  - [NVIDIA RTX 4060 Low Profile](#nvidia-rtx-4060-low-profile)
  - [NVIDIA RTX 5060 Low Profile](#nvidia-rtx-5060-low-profile)
- [AMD](#amd)
  - [AMD Radeon RX 6400 Low Profile](#amd-radeon-rx-6400-low-profile)
- [Intel](#intel)
  - [Intel Arc A310 Low Profile](#intel-arc-a310-low-profile)
- [Pár slov závěrem](#pár-slov-závěrem)
  - [Zdroje:](#zdroje)

# Starší grafické karty od NVIDIA

## Quadro P400

| Parametr | hodnota |
| --- | --- |
| TDP | 30 W |
| Paměť | 2 GB GDDR5 |
| PCIE | 3.0 x16 |
| Cuda | 256 |
| Architektura | Pascal |

Quadro P400 existovala striktně pouze ve 2GB verzi, což je dnes pro jakékoli hry už nepoužitelné.

## NVIDIA Quadro P620

| Parametr | hodnota |
| --- | --- |
| TDP | 40 W |
| Paměť | 2 GB GDDR5 |
| PCIE | 3.0 x16 |
| Cuda | 512 |
| Architektura | Pascal |

## NVIDIA Quadro P1000

![]({{ site.baseurl }}/assets/pc/NVIDIA Quadro P1000.jpg)
*NVIDIA Quadro P1000*

| Parametr | hodnota |
| --- | --- |
| TDP | 47 W |
| Paměť | 4 GB GDDR5 |
| PCIE | 3.0 x16 |
| Cuda | 640 |
| Architektura | Pascal |

I ty nejvyšší Low Profile modely řady P (P620 a P1000) dnes narážejí na stejný zásadní problém jako P400: starý multimediální engine (Pascal NVENC).

## Yeston GTX 1050 ti 4GDDR5

![]({{ site.baseurl }}/assets/pc/YESTON GTX 1050 ti 4GB.webp)
*Yeston GTX 1050 ti 4GB GDDR5*

| Parametr | hodnota |
| --- | --- |
| Cena | 140 USD |
| Paměť | 4 GB GDDR5 |
| PCIE | 3.0 x16 |
| Cuda | 768 |
| Architektura | Pascal |

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
| Architektura | Turing |

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
| Architektura | Turing |

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
| Architektura | Ampere |

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

Jde o mobilní čip přepájený na desktopové Low Profile PCB (čínský Frankenstein). Funguje to, ale ovladače občas vyžadují modifikaci nebo specifický přístup, což pro stabilní server nemusí být ideální.

## NVIDIA RTX 4060 Low Profile

Half-height dvou slotová grafická karta. Která by potřebovala externí napájení, takže pro můj účel není ideální, ale je to zajímavá volba pro někoho, kdo potřebuje vyšší výkon a má možnost řešit napájení a chlazení.

![]({{ site.baseurl }}/assets/pc/NVIDIA RTX 4060 Low Profile.jpg)
*NVIDIA RTX 4060 Low Profile*

| Parametr | hodnota |
| --- | --- |
| Cena | 300 USD |
| TDP | 115 W |
| Paměť | 8 GB GDDR6 |
| PCIE | 5.0 x8 |
| CUDA jader | 3072 |
| Architektura | Ada Lovelace |

## NVIDIA RTX 5060 Low Profile

Half-height dvou slotová grafická karta. Do počítače Lenovo ThinkCentre M920Q Tiny se "vejde", ale bude potřeba odstranit zadní kryt. Ještě větší spotřeba a tepelné nároky než RTX 4060.

| Parametr | hodnota |
| --- | --- |
| Cena | 300 USD |
| TDP | 145 W |
| Paměť | 8 GB GDDR7 |
| PCIE | 5.0 x8 |
| CUDA jader | 3840 |
| Architektura | Blackwell |

# AMD

## AMD Radeon RX 6400 Low Profile

Tohle je přímý konkurent pro GTX 1650 a Intel Arc A310. Je to nejlevnější moderní LP karta od AMD.

![]({{ site.baseurl }}/assets/pc/AMD Radeon RX 6400 Low Profile.webp)
*AMD Radeon RX 6400 Low Profile*

| Parametr | hodnota |
| --- | --- |
| TDP | 53 W |
| Paměť | 4 GB GDDR6 |
| PCIE | 4.0 x8 |
| Stream procesorů | 768 |
| Architektura | RDNA 2 |

Fyzicky postrádá hardwarový kodér videa (přišla o něj při ořezávání čipu).

# Intel

## Intel Arc A310 Low Profile

Grafická karta SPARKLE Intel Arc A310 ECO s 4GB operační pamětí GDDR6 nabízí špičkovou energetickou účinnost s příkonem pouhých 50 W. Model je vybaven low-profile konstrukcí a v balení naleznete i krátký bracket pro instalaci do kompaktních sestav.

![]({{ site.baseurl }}/assets/pc/Intel_arc_a310.webp)

| Parametr | hodnota |
| --- | --- |
| Cena | 3000 Kč |
| TDP | 50 W |
| Paměť | 4 GB GDDR6 |
| PCIE | 4.0 x4 |

Pro domácí server na streamování je to skrytý klenot. Má v sobě kodér QuickSync s podporou AV1, což je pro streamování videa naprosto špičková záležitost s nízkým datovým tokem. Na indie hry výkon stačí.

# Pár slov závěrem

Jako minimální množství VRAM bych považoval 4 GB, ale ideálně bych se snažil dostat na 6-8 GB, protože moderní hry a streamování mohou rychle spotřebovat dostupnou paměť.

Proč prostý počet CUDA jáder občas „lže“.

Grafiky ze seznamu:
- GTX 1650 (Turing): 896 CUDA jader,
- NVIDIA T1000 (Turing): 896 CUDA jader,
- NVIDIA A400 (Ampere): 768 CUDA jader.

Zde by člověk mohl čekat, že starší GTX 1650 nebo T1000 budou výkonnější než novější A400, protože mají o 128 CUDA jader více. Opak je ale pravdou.

A400 je postavena na novější architektuře Ampere. Každé jedno CUDA jádro v architektuře Ampere dokáže za jeden hodinový cyklus zpracovat až dvojnásobek operací (FP32) oproti jádru v architektuře Turing. Výsledkem je, že i s nižším počtem jader novější karta tu starší porazí, a navíc má k dispozici RT a Tensor jádra, která v původním počtu CUDA jader vůbec nejsou započítaná.

Pokud použiji starý stolní počítač s GTX 1070 Ti jako domácí server s virtualizovaným Bazzitem, ze kterého budu streamovat hry do obýváku, bude to pořád lepší než jakákoli z těchto low-profile karet, protože GTX 1070 Ti má 2432 CUDA jader a 8 GB VRAM.

Generace grafických karet RTX 4050 a 5060 přináší low-profile modely, které svým výkonem poráží mojí GTX 1070 Ti, ale jsou drahé a mají vyšší TDP, a jsou hlavně dvou slotové, což pro můj účel je prakticky nepoužitelné.

Až NVIDIA vydá low-profile model z řady RTX 40/50, který bude jednoslotový a s TDP kolem 50 W, tak budu uvažovat o upgradu. 

## Zdroje:
- [techpowerup](https://www.techpowerup.com/)