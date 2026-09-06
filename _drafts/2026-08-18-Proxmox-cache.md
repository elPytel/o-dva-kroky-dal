---
layout: post
title:  "Proxmox cache"
author: "Jarda"
description: A description
categories: 
    - Homelab
    - Proxmox
tags: 
    - tag
---


## Cacheování dat v Proxmoxu

Write Cache (ZFS SLOG/L2ARC)

Intel 1TB disk je bleskový. Můžeš ho přidat do ZFS poolu jako "Special VDEV" nebo cache:

* V shellu po vytvoření poolu:
`zpool add data_pool log /dev/nvmeXn1` (pro SLOG - zrychlení zápisu)
`zpool add data_pool cache /dev/nvmeXn1` (pro L2ARC - zrychlení čtení)
* *Pozor:* Použití cache v ZFS vyžaduje, aby disk měl stabilní napájení a ideálně byl redundantní, pokud tam běží kritická data.

ZFS ho využije jako L2ARC (čtecí cache pro nejčastěji používaná data) a ZIL/SLOG (zápisová cache).

```text
              rychlost
                 ↑

          RAM / ARC
             ⚡⚡⚡
                │
                ↓
          NVMe / L2ARC
             ⚡⚡
                │
                ↓
          HDD / RAID-Z1
              🐌
```

### ARC
ARC = Adaptive Replacement Cache

### L2ARC

L2ARC = Level 2 ARC.

ZIL

ZIL = ZFS Intent Log.

Je určený hlavně pro synchronní zápisy.

Například aplikace řekne:

„Zapiš data a potvrď mi až ve chvíli, kdy jsou bezpečně uložená.“

To je synchronní zápis.

ZFS může použít ZIL jako log:

aplikace
   │
   │ sync write
   ↓
  ZIL
   │
   ↓
pool

A pokud máš rychlé zařízení pro ZIL, může synchronní zápis skončit rychleji.

### SLOG

A tady je další častý omyl:

SLOG není samostatná write cache v tom smyslu, že by tam ZFS dlouhodobě drželo všechna data.

SLOG = Separate Intent Log.

Je to externí zařízení, které ZFS použije pro ZIL.


### ZIL
= mechanismus/logika


SLOG
= samostatné zařízení, na kterém ten log může být

Typicky:

HDD RAID-Z1
       │
       │ synchronní zápis
       ↓
     SLOG
    NVMe/SSD
       │
       ↓
   následně pool

A proto je SLOG zajímavý třeba pro databáze, NFS, VM storage se synchronními zápisy apod.

Ale:

SLOG ti obecně nezrychlí běžné sekvenční zápisy na HDD.