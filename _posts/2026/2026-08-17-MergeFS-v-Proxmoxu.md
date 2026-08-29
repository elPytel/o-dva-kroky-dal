---
layout: post
title:  "MergeFS v Proxmoxu"
author: "Jarda"
description: Připojení dvou NTFS disků do jednoho sjednoceného poolu pomocí MergeFS
categories: 
    - Homelab
    - Proxmox
    - storage
tags: 
    - MergerFS
thumbnail: /assets/pc/MergerFS_logo.png
---

- [Spojování dvou NTFS disků pomocí MergeFS](#spojování-dvou-ntfs-disků-pomocí-mergefs)
  - [MergerFS](#mergerfs)
  - [Aktivace a ověření](#aktivace-a-ověření)
  - [Přidání úložiště do Proxmox GUI](#přidání-úložiště-do-proxmox-gui)
  - [Samba a sdílení sjednoceného poolu](#samba-a-sdílení-sjednoceného-poolu)

# Spojování dvou NTFS disků pomocí MergeFS

## MergerFS
Proxmox potřebuje balíčky pro práci s NTFS (`ntfs-3g`) a samotný `mergerfs`.

```bash
apt update
apt install ntfs-3g mergerfs
```

Zjistíš UUID oddílů obou NTFS disků, aby se připojení nerozbilo po restartu při změně označení `/dev/sdX`:

```bash
blkid
```

Poznamenej si `UUID` pro oba disky (např. `UUID="XXXX-XXXX"`).

Vytvoř adresáře pro jednotlivé disky i pro výsledný sjednocený pool:

```bash
mkdir -p /mnt/Toshiba_1 /mnt/Toshiba_2 /mnt/pool_movies
```

Otevři soubor `/etc/fstab` (`nano /etc/fstab`) a přidej řádky pro připojení obou disků a poolu mergerfs.

```fstab
# Fyzicke NTFS disky
UUID=5458F6B258F691CA /mnt/Toshiba_1 ntfs-3g defaults,nofail,uid=1000,gid=1000,dmask=022,fmask=133 0 0
UUID=76983C84983C4541 /mnt/Toshiba_2 ntfs-3g defaults,nofail,uid=1000,gid=1000,dmask=022,fmask=133 0 0

# Mergerfs sjednoceny pool
/mnt/Toshiba_1:/mnt/Toshiba_2 /mnt/pool_movies fuse.mergerfs defaults,allow_other,use_ino,category.create=mfs,minfreespace=10G,fsname=pool_movies 0 0
```

Význam důležitých voleb mergerfs:
* `allow_other`: Umožní přístup k souborům i ostatním uživatelům/procesům (např. Samba, Plex/Jellyfin, LXC).
* `use_ino`: Zachovává konzistentní inode čísla, nutné pro správnou funkci Samby a médií.
* `category.create=mfs`: Nové soubory se zapisují na disk s největším volným místem (*most free space*).
* `minfreespace=10G`: Přesměruje zápis na druhý disk, pokud na prvním zbývá méně než 10 GB.

## Aktivace a ověření

Připoj všechny disky podle `fstab` a ověř velikost:

```bash
mount -a
df -h /mnt/pool_movies
```

Příkaz `df -h /mnt/pool_movies` by měl ukázat souhrnnou kapacitu asi 2 TB.

## Přidání úložiště do Proxmox GUI

Pokud chceš `/mnt/pool_movies` zpřístupnit přímo v rozhraní Proxmoxu (např. pro ukládání ISO obrazů, záloh nebo pro bind-mount do LXC kontejnerů):

1. V Proxmox GUI přejdeš na **Datacenter** -> **Storage** -> **Add** -> **Directory**.
2. Nastavíš:
   * **ID:** `Mergerfs-Pool` (nebo libovolný název)
   * **Directory:** `/mnt/pool_movies`
   * **Content:** Vyber typy obsahu (např. *VZDump backup file*, *ISO image* apod.).

Po uložení stačí připojit disky a zkontrolovat:

```bash
mount -a
df -h /mnt/Toshiba_1 /mnt/Toshiba_2 /mnt/pool_movies
ls -la /mnt/pool_movies
```

```Bash
systemctl daemon-reload
```

## Samba a sdílení sjednoceného poolu
Pro přidání sjednoceného poolu do stávající Samby stačí vložit novou sekci do konfiguračního souboru `/etc/samba/smb.conf`.

Otevři konfiguraci Samby:

```bash
vim /etc/samba/smb.conf
```

Definice nového sdílení přidaná na konec souboru:

```ini
[Movies]
   path = /mnt/pool_movies
   browseable = yes
   read only = no
   guest ok = no
   valid users = smbuser
   create mask = 0775
   directory mask = 0775
   force user = smbuser
   force group = smbuser
```

{: .note }
> Pokud pro přístup používáte jiného uživatele než `smbuser`, uprav položky `valid users`, `force user` a `force group` podle potřeby.

Zkontroluj syntaxi a restartuj službu:

```bash
# Ověření platnosti konfigurace
testparm -s

# Restart démona Samba
systemctl restart smbd
```

Nyní se v síti objeví nové sdílení **Movies** se sloučeným obsahem z obou disků.

Připojení z klienta:

Linux (Nautilus / Thunar / Dolphin):
`smb://<IP_nebo_hostname_zalman>/Movies`

Windows (Průzkumník souborů):
`\\<IP_nebo_hostname_zalman>\Movies`