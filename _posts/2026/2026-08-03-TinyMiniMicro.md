---
layout: post
title:  "TinyMiniMicro"
author: "Jarda"
description: Nákup nového počítače Lenovo ThinkCentre P330 Tiny a jeho konfigurace
categories: 
    - TiniMiniMicro
    - Lenovo
tags: 
    - P330
thumbnail: /assets/pc/p330/P330.avif
---

# Výběr nového počítače

- [Výběr nového počítače](#výběr-nového-počítače)
  - [M720q Tiny](#m720q-tiny)
  - [M920q Tiny](#m920q-tiny)
  - [P330 Tiny](#p330-tiny)
  - [Nákup](#nákup)
    - [Jak jsem nakonfiguroval P330 po nákupu?](#jak-jsem-nakonfiguroval-p330-po-nákupu)
  - [Možnost rozšíření TiniMiniMicro (TMM) o grafickou kartu](#možnost-rozšíření-tiniminimicro-tmm-o-grafickou-kartu)
  - [Reference:](#reference)

![p330]({{ site.baseurl }}/assets/pc/p330/P330.avif)

Rozhodl jsem se pořídit si nový "stolní" počítač, který nahradí Zalman. Ze Zalmana udělam domácí server, který bude sloužit pro streamování her do obýváku, jako datové uložiště a docker kontejnery.

Chtěl jsem si pořídit malý stroj, který nebude zabírat moc místa a v budoucnu půjde snadno použít jako malý domací server.

Nabízely se tři značky a jejich řady:
- Lenovo ThinkCentre **Tiny**,
- HP EliteDesk **Mini**,
- Dell OptiPlex **Micro**.

Dlouhodobě se mi osvědčila značka Lenovo, takže jsem se rozhodl pro **Lenovo ThinkCentre Tiny**. Mám doma několik dokin a máhradních nabíječek, které mají stejnou koncovku jako počítače řady Tiny.

Uvažoval jsem nad různými modely. Řada ThinkCentre Tiny má několik generací a modelů. 

![p330]({{ site.baseurl }}/assets/pc/p330/Lenovo-ThinkStation-P330-Tiny_1.jpg)

M9x0 se liší tím, jaké generace procesorů podporují:

| Model | Procesor | Čipset | Poznámka |
| --- | --- | --- | --- |
| **Mx10** (M710q / M910q) | Intel Core 6. a 7. gen | Intel Q270/B250 | Oficiálně max i7-7700T. Neoficiálně lze upravit BIOS (CoffeeTime mod) na 8./9. gen. |
| **Mx20 / Tiny5** (M720q / M920q / M920x) | Intel Core 8. a 9. gen | Intel B360/Q370 | Nativní podpora až 6jádrových a 8jádrových CPU (např. i5-8500T, i7-8700T). Fyzicky vždy přítomný PCIe konektor na desce. |
| **P330 Tiny** | Intel Core 8. a 9. gen / Xeon E | Intel Q370 | Pracovní stanice (vychází z M920x). Má nativně **2× M.2 NVMe** slot. |

Písmenka M a P označují, zda se jedná o **Mini PC** (M) nebo **Workstation** (P).
Označení na konci (q / x) označuje, zda se jedná o **Tiny** (q) nebo **TinyX** (x). TinyX má silnější napájecí zdroj a lepší chlazení, takže zvládne i výkonnější grafické karty.

## M720q Tiny
M720q spadá do generace Tiny5 a využívá čipset Intel B360. Nativně podporuje 8. a 9. generaci procesorů Intel Core (např. 6jádrový i5-8500T), což přináší oproti starším 4jádrovým generacím výrazný skok v multitaskingu. 

- **Výhody:** Na základní desce má vždy osazený proprietární konektor pro PCIe riser, takže do něj lze snadno přidat dedikovanou grafiku, HBA kartu nebo 10GbE síťovku. Na bazarech se dá sehnat za velmi výhodné peníze.
- **Úložiště:** 1× M.2 NVMe slot + 1× 2.5" SATA pozice.
- **Omezení:** Chybí mu funkce vzdálené správy Intel vPro.

## M920q Tiny
Vyšší model generace Tiny5 s čipsetem Intel Q370. Získal si velkou oblibu v komunitě homelabů především díky pokročilé výbavě.

- **Intel vPro (Hardware KVM / IPMI):** Pokud je osazen procesorem i5 nebo i7, podporuje vzdálenou správu vPro. Můžete se k počítači připojit přes síť, vidět obrazovku už od bootování, konfigurovat BIOS nebo přeinstalovat OS bez nutnosti připojovat monitor.
- **Konektivita:** V základu nabízí USB-C port na předním panelu a oficiální podporu pro rozšiřující Thunderbolt 3 kartu (01AJ968) do PCIe slotu.
- **Úložiště:** 1× M.2 NVMe slot + 1× 2.5" SATA pozice.

## P330 Tiny
Lenovo ThinkStation P330 Tiny je kompaktní pracovní stanice (Workstation), která konstrukčně vychází z prémiového modelu M920x. Je to ultimátní volba pro náročnější homelab i pracovní stůl.

- **2× Nativní M.2 NVMe slot:** Na rozdíl od M720q/M920q má na spodní straně desky osazené **dva plnohodnotné M.2 NVMe sloty**. To umožňuje vytvořit superrychlé ZFS zrcadlení (RAID 1) přímo v těle počítače pro systém Proxmox nebo kritická data.
- **Výbava v základu:** Často se prodává již s osazenou low-profile grafikou (např. NVIDIA Quadro P620 / P1000), z výroby nainstalovaným PCIe riserem, silnějším 135W napájecím adaptérem a vylepšeným chladením.

## Nákup

Našel jsem nabídku na Aukro:

| Model | Cena |
| --- | --- |
| M720q Tiny | 2 500 Kč |
| M920q Tiny | 3 500 Kč |
| P330 Tiny | 4 300 Kč |

Vzhledem k nejlepší výbavě u P330 a ne o tolik vyšší ceně jsem se rozhodl pro **P330 Tiny**.

### Jak jsem nakonfiguroval P330 po nákupu?

| Parametr | Hodnota |
| --- | --- |
| Procesor | Intel Core i5-8500T 6c/6t 2.1GHz (4.1GHz Turbo) |
| RAM | 24 GB DDR4 2666MHz (8+16GB) |
| 1. M.2 NVMe | 1 TB Intel 660P |
| 2. M.2 NVMe | Optane 16 GB |

Jako operační systém jsem zvolil Ubuntu 26.04 LTS. Na Optane bude klasicky SWAP. 

## Možnost rozšíření TiniMiniMicro (TMM) o grafickou kartu
Pro zapojení GPU budu potřebovat vnitřní pravoúhlou PCIe Riser kartu, konkrétní FRU číslo (označení dílu):

👉 01AJ940

*Lenovo Tiny5 PCIE16 Riser Card 01AJ940*

Srovnání GPU pro TiniMiniMicro (TMM) [Výběr grafické karty](./2026-06-04-Výběr-grafické-karty.md).

![p330]({{ site.baseurl }}/assets/pc/p330/Lenovo-ThinkStation-P330-Tiny.jpg)

Možný upgrade a přidání GPU:

<iframe width="720" height="430" src="https://www.youtube.com/embed/NGZqKFg4spw" title="Lenovo Tiny P330 + Nvidia T1000 upgrade, can it game?" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## Reference:
- [servethehome: Lenovo ThinkCentre M920x Tiny Review and Guide](https://www.servethehome.com/lenovo-thinkcentre-m920x-tiny-review-and-guide/)
- [servethehome: Introducing Project TinyMiniMicro - Home Lab Revolution](https://www.servethehome.com/introducing-project-tinyminimicro-home-lab-revolution/)
- [printables: TinyMiniMicro](https://www.printables.com/tag/tinyminimicro)