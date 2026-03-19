---
layout: post
title:  "Linux SWAP"
author: "Jarda"
description: 4 GB SWAPu dneska nestačí
categories: 
    - linux
tags: 
    - ubuntu
    - swap
thumbnail: /assets/pc/linux.png
---

- [Postup pro zvětšení Swap File (přes terminál)](#postup-pro-zvětšení-swap-file-přes-terminál)
  - [Trvalé nastavení po restartu](#trvalé-nastavení-po-restartu)
  - [Sysadmin tip: Ladění "Swappiness"](#sysadmin-tip-ladění-swappiness)

Po čisté instalaci Ubuntu se mi vytvořil jen 4GB swap soubor, což je v součastnosti s 16GB RAM málo. Když se systémová pamět naplní, tak data sice začnou přetékat do SWAPu, ale chvíli na to přeteče i SWAP a systém se "zasekne" **OOM (Out Of Memory) Killer**.

V moderních distribucích (Ubuntu 22.04+) se už většinou nepoužívá swap oddíl (partition), ale **swap file**. Rozhodl jsem se ho zvětšit na 24 GB a postup je poměrěn přímočarý.

## Postup pro zvětšení Swap File (přes terminál)

Tento postup přepíše stávající swap soubor novým o velikosti 24 GB.

1. Vypneme stávající swap:
```bash
sudo swapoff -a
```

> [!note] 
> Můžete v HTOPu vidět jak swap mizí.

2. Vytvoříme nový prázdný soubor (24 GB):

```bash
sudo fallocate -l 24G /swap.img
```
*(Alokace chvíli potrvá, `fallocate` je ale bleskový)*

> [!tip] Pokud `fallocate` selže (např. na souborovém systému btrfs), lze použij starší cestu:
> `sudo dd if=/dev/zero of=/swap.img bs=1G count=24`

3. Nastavíme správná oprávnění (bezpečnost především):

```bash
sudo chmod 600 /swap.img
```

4. Naformátujeme soubor jako swap:

```bash
sudo mkswap /swap.img
```

5. Aktivujeme ho:

```bash
sudo swapon /swap.img
```

6. Zkontroluj výsledek:

```bash
free -h
# nebo
swapon --show
```

### Trvalé nastavení po restartu

Ujistíme se, že je v souboru `/etc/fstab` správný řádek. Zobrazte:
```bash
sudo cat /etc/fstab
```

Najdete řádek se swapem a zkontrolute že vypadá takto:
`/swap.img none swap sw 0 0`


### Sysadmin tip: Ladění "Swappiness"

Když už budete mít takhle velký swap na NVMe disku, můžete chtít ovlivnit, jak moc se do něj systému chce.

* Podívejte se na aktuální hodnotu: `cat /proc/sys/vm/swappiness` (výchozí bývá 60).
* Pokud chcete, aby Linux využíval swap až v krajní nouzi a šetřil RAM pro aplikace, nastav hodnotu na **10**:
`sudo sysctl vm.swappiness=10`
* Pro trvalou změnu přidejte `vm.swappiness=10` do `/etc/sysctl.conf`.

S 24 GB swapu už by se systém neměl "kousnout", jen se v extrémní zátěži trochu zpomalí, až začne odkládat data na disk.
