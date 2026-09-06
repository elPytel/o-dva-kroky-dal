---
layout: post
title:  "Proxmox zálohování"
author: "Jarda"
description: Zálohování v Proxmoxu
categories: 
    - Homelab
    - Proxmox
tags: 
    - tag
---


## Zálohování

V tom případě bych to držel jednoduché. Je dobré rozlišit **RAIDZ1, ZFS snapshot a skutečnou zálohu**, protože každé řeší něco jiného.

### 1. RAIDZ1 ≠ záloha

Tvůj `data_pool`:

```text
3 × 3 TB
   ↓
RAIDZ1
   ↓
~5,3 TB použitelných
```

RAIDZ1 dovolí přežít **selhání jednoho disku**.

Například:

```text
Disk 1  ✓
Disk 2  ✗
Disk 3  ✓
       ↓
data stále dostupná
```

Ale když například omylem smažeš `/Fotky/2025`, RAIDZ1 ti nepomůže. ZFS změnu normálně zapíše.

### 2. ZFS snapshot

Snapshot je v podstatě **okamžitý bod v čase**.

Například:

```text
17:00  snapshot
17:30  smažeš soubor
18:00  zjistíš, že tam neměl být
```

Snapshot z 17:00 pořád obsahuje původní stav.

Výhoda ZFS je, že snapshot **nekopíruje všechna data**. Na začátku zabere prakticky nic a postupně zabírá místo pouze za změněná data.

Můžeš tedy mít třeba:

```text
data_pool/share
├── snapshot@daily-2026-08-15
├── snapshot@daily-2026-08-16
└── aktuální data
```

Snapshot ale **není záloha** v případě, že odejde celý server/pool. Snapshoty jsou stále na těch stejných discích.

---

### 3. Tvůj externí 3TB disk = skutečná záloha

Tohle je z hlediska důležitých dat mnohem důležitější.

Máš tedy:

```text
                    ┌── Disk 1
                    ├── Disk 2       RAIDZ1
data_pool ──────────┤
                    └── Disk 3
                         │
                         │ manuální backup
                         ▼
                   externí 3TB disk
```

Pokud například:

* odejde jeden disk → **RAIDZ1**
* omylem smažeš soubor → **snapshot**
* odejde celý Proxmox/server → **externí disk**
* ransomware zašifruje data → **externí disk, pokud není právě připojený**
* smažeš data a následně uděláš backup → tady už může být problém

Proto je velmi dobré **externí disk po zálohování odpojit**.

---

### U tebe bych to udělal takto

Na ZFS bych nastavil automatické snapshoty třeba:

```text
posledních 24 hodin → hodinové
posledních 7 dní     → denní
poslední měsíc       → týdenní
```

Nemusíš se o ně prakticky starat.

A důležitá data bych jednou za čas ručně kopíroval na externí 3TB disk.

Například:

```text
/data_pool/share
        │
        ├── běžná data
        │
        ├── snapshoty
        │
        └──────→ externí HDD
                  │
                  └── odpojit
```

### Jedna věc je ale trochu nepříjemná

Tvůj pool má **5,32 TB**, zatímco externí disk má jen **3 TB**.

Takže na externí disk se nevejde kompletní kopie `data_pool/share`.

To ale vůbec nemusí být problém, pokud na něm chceš mít **jen opravdu důležitá data**:

```text
5,3 TB na NASu
│
├── filmy       → nezálohovat
├── ISO         → nezálohovat
├── hry         → nezálohovat
├── downloads   → nezálohovat
│
├── fotky       → BACKUP
├── dokumenty   → BACKUP
├── projekty    → BACKUP
└── důležitá data → BACKUP
```

To je podle mě pro tvoje použití velmi rozumný kompromis.

A pokud budeš chtít, můžeme pak udělat **jednoduchý příkaz/script**, kterým jedním příkazem synchronizuješ třeba `/data_pool/share/Dulezite` na ten 3TB disk a zároveň budeš mít přehled, co se změnilo.

