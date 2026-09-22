---
layout: post
title:  "Proxmox zálohování"
author: "Jarda"
description: Návod pro nastavení zálohování virtuálních strojů a kontejnerů v Proxmoxu na ZFS poolu.
categories: 
    - Homelab
    - Proxmox
tags: 
    - ZFS
    - Backup
thumbnail: /assets/Proxmox_logo.png
---

- [Jak v Proxmoxu nastavit ZFS pool pro vzdump zálohy a správně uřídit retenci](#jak-v-proxmoxu-nastavit-zfs-pool-pro-vzdump-zálohy-a-správně-uřídit-retenci)
  - [1. Příprava vyhrazeného ZFS datasetu](#1-příprava-vyhrazeného-zfs-datasetu)
  - [2. Přidání úložiště přes Proxmox GUI](#2-přidání-úložiště-přes-proxmox-gui)
  - [3. Strategie zálohování a retence](#3-strategie-zálohování-a-retence)

# Jak v Proxmoxu nastavit ZFS pool pro vzdump zálohy a správně uřídit retenci

Při ladění infrastruktury na mém Proxmox serveru (Zalman) jsem dorazil k otázce zálohování. Mám k dispozici 6TB ZFS RAIDZ1 pool a chtěl jsem jej využít pro ukládání lokálních záloh virtuálek a kontejnerů.

Háček je v tom, že Proxmox nativně chápe ZFS pouze jako blokové zařízení pro běh samotných virtuálek. Pokud do něj chcete sypat souborové zálohy z nástroje `vzdump`, musíte na to jít přes vytvoření úložiště typu **Directory** (Adresář).

## 1. Příprava vyhrazeného ZFS datasetu

V konzoli Proxmoxu vytvoříme dataset (název `data` nahraďte jménem svého poolu):

```bash
# Create dedicated dataset for backups
zfs create data/backups
```

Tento dataset se nám automaticky připojí do filesystému na cestu `/data/backups`.

## 2. Přidání úložiště přes Proxmox GUI

Nyní musíme Proxmoxu říct, že má tento adresář používat pro zálohy. Šel jsem cestou přes webové rozhraní:

1. V levém panelu vyberte na nejvyšší úrovni **Datacenter**.
2. Přejděte do **Storage** > klikněte na **Add** > vyberte **Directory**.
3. Vyplňte formulář:
* **ID:** `zfs-backups` (nebo jakékoliv vaše pojmenování)
* **Directory:** `/data/backups` (cesta k našemu ZFS datasetu)
* **Content:** Ponechte pouze **VZDump backup file**

4. **Kritický krok:** Rozbalte sekci **Advanced** a zaškrtněte **IS Mountpoint**.

Tohle je důležitý sysadmin detail. Pokud by se z nějakého důvodu ZFS pool nenačetl nebo odpojil, Proxmox uvidí, že cílová složka není mountpoint, a odmítne do ní zapisovat. Zabráníte tak tomu, aby vám noční záloha zaplnila root filesystém (systémový disk) samotného hypervizoru.

## 3. Strategie zálohování a retence

V sekci **Datacenter > Backup** jsem vytvořil novou úlohu, vybral virtuálky, nastavil cíl na naše nové úložiště `zfs-backups` a frekvenci na jednou denně.

Zásadní je ale **Retention** (politika uchovávání starých záloh). Jelikož používáme standardní `vzdump` (a ne Proxmox Backup Server), každá záloha je plná (full backup). Vzdump neumí deduplikaci. I s 6TB kapacitou a zapnutou ZFS kompresí by vám místo při denních zálohách dříve nebo později došlo.

Pro denní běh je ideální nasadit klasickou GFS (Grandfather-Father-Son) rotaci. Zde je můj osvědčený setup:

* **Keep Last: 2** (Železná rezerva. Tyto dvě nejnovější zálohy Proxmox nesmaže ani při selhání plánovače.)
* **Keep Daily: 7** (Pokrytí kompletního uplynulého týdne pro rychlou reakci na běžné problémy.)
* **Keep Weekly: 4** (Jedna záloha týdně držená po celý uplynulý měsíc.)
* **Keep Monthly: 3** (Jedna záloha měsíčně držená čtvrt roku pro případnou hlubší zpětnou analýzu.)

Systém pruningu v Proxmoxu je chytrý – pokud jedna fyzická záloha splňuje podmínky pro "Daily", "Weekly" i "Monthly" zároveň, započítá ji do všech škatulek, ale místo na disku zabírá logicky jen jednou.

Při tomto nastavení držíte přibližně 14-16 plných záloh od každého stroje. Máte tak solidní disaster recovery plán i historii, aniž byste neefektivně pálili terabyty drahocenného místa.