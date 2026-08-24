---
layout: post
title:  "Domácí server"
author: "Jarda"
description: Zbohem Windows, hurá do Proxmoxu!
categories:
    - Homelab
    - Windows
    - Proxmox
thumbnail: /assets/Proxmox_logo.png
---

- [Příprava na opuštění Windows](#příprava-na-opuštění-windows)
  - [Zrušení Fast Boot](#zrušení-fast-boot)
  - [Uvolnění disků](#uvolnění-disků)
- [Proxmox](#proxmox)
  - [Rozdělení disků](#rozdělení-disků)
  - [Instalace Proxmoxu](#instalace-proxmoxu)
    - [Vytváření nového instalačního media](#vytváření-nového-instalačního-media)
  - [Konfigurace Proxmoxu](#konfigurace-proxmoxu)
    - [Zkrocení repozitářů (Odchod z Enterprise)](#zkrocení-repozitářů-odchod-z-enterprise)
    - [První velká aktualizace](#první-velká-aktualizace)
    - [Konfigurace disků do poolu](#konfigurace-disků-do-poolu)
    - [Optane 32GB jako SWAP](#optane-32gb-jako-swap)
  - [SMB](#smb)

# Příprava na opuštění Windows

## Zrušení Fast Boot

{: .info }
> Aby bylo možné po instalaci Proxmoxu připojit disky je nutné zrušit Fast Boot, jinak se disky budou zobrazovat jako "dirty" a nebude možné na ně zapisovat.

```powershell
powercfg /h off

powercfg /a
```

## Uvolnění disků

```powershell
Get-PhysicalDisk | Format-Table FriendlyName, MediaType, CanPool, Size -AutoSize

FriendlyName                 MediaType CanPool          Size
------------                 --------- -------          ----
Samsung SSD 970 EVO Plus 1TB SSD         False 1000204886016
TOSHIBA MQ01ABD100           HDD         False 1000204886016
NVMe INTEL SSDPEKNW010T8     SSD         False 1024209543168
HUA723030ALA640              HDD         False 3000592982016
ST33000651AS                 HDD         False 3000592982016
NVMe INTEL MEMPEK1W032GA     SSD         False   29260513280
ST3000VX015-3CV10G           HDD         False 3000592982016
HFS128G39TND-N210A           SSD         False  128035676160
TOSHIBA MQ04ABF100           HDD         False 1000204886016
```

Veškerá data z disků, která jsem si chtěl zachovat jsem zálohoval na externí disk. Následně jsem všechny 3TB disky vymazal.

1TB disky s filmama jsem nechal naformátované jak NTFS. V Proxmoxu je připojím přes MergeFS, takže se mi budou chovat jako jeden velký adresář o velikosti 2TB. Rozdílné řízení prvá Linux vs Windows vyřeším později.

# Proxmox

## Rozdělení disků

{: .tip } 
> Výběr plotnových disků:
> - Chtějte CMR (Conventional Magnetic Recording)
> - Vyhnete se SMR (Shingled Magnetic Recording)

Do budoucna plánuji dokoputit 8TB disk na Filmy.

| **Úložiště** | **Fyzické disky** | **Kapacita** | **Účel**                                     |
| ------------ | ----------------- | ------------ | -------------------------------------------- |
| Optane       | NVMe              | 32GB         | SWAP                                         |
| POOL_SYSTEM  | NVMe              | ~1TB         | OS Proxmox, kontejnery, swap, VM pro agenty. |
| POOL_DATA    | 3x 3TB (RAID-Z1)  | ~5.5 TB      | Fotky, osobní archivy (redundance 1 disku).  |
| POOL_MEDIA   | 1x 8TB (Single)   | 8 TB         | Streamování  (filmy, seriály).               |

Samsung (dříve disk C:) poslouží jako čistý systémový disk Proxmoxu. 
A co redundace? Tady se vydám cestou zálohování. Zásadní je nepřijít o nastavení virtuálek a kontejnerů. Zálohy (tzv. Proxmox backupy) si budou automaticky vytvářet na hlavní redundantní úložiště (3x 3TB disky v režimu RAID-Z1).

Intel 1TB nechám jako samostatné, bleskově rychlé úložiště bez redundance. Poběží na něm Bazzite (SteamOS), herní servery a kontejnery. Proxmox nastavím tak, aby každý den ve 3 ráno udělal snapshot celého Intel disku a bezpečně ho zazálohoval na velké 6TB HDD pole.

## Instalace Proxmoxu

Zrušil jsem secure boot v BIOSu.

Ventoy selhal. Když se mi konečně podařilo nabootovat z flashky (zrušení secure bootu), tak jsem narazil na problém že při bootu instalačního disku Proxmoxu se USB Disk odpojí od systému a Instalátor ztratí kontakt s obrazem disku k instalaci.

### Vytváření nového instalačního media

Vypíšeme bloková zařízení (disky)
```bash
lsblk
sudo umount /dev/sda*
```

Nyní pošleme ISO obraz přímo na disk. Upravil jsem parametr `if=` tak, aby přesně odpovídal názvu staženého souboru `proxmox-ve_9.2-1.iso`.

Cílový disk je natvrdo `/dev/sda` bez čísla na konci, protože přepisujeme kompletně celou tabulku oddílů!

```bash
sudo dd if=proxmox-ve_9.2-1.iso of=/dev/sda bs=4M status=progress

sync
```

Jakmile sync doběhne (může to pár vteřin trvat) je hotovo.

## Konfigurace Proxmoxu

Tentokrát instalace proběhla v pořádku, jdeme konfigurovat.


### Zkrocení repozitářů (Odchod z Enterprise)

Proxmox je open-source a zdarma, ale ve výchozím stavu se snaží stahovat aktualizace z placeného "Enterprise" repozitáře. Pokud bys teď zkusil systém aktualizovat, vyhodil by ti chybu o chybějící subskripci.

* Klikněte v levém panelu na svůj uzel **zalman**.
* V prostředním sloupci vyberte **Updates** a pod ním **Repositories**.
* Nahoře klikněte na tlačítko **Add**, z roletky vyber **No-Subscription** a potvrď.
* Následně v seznamu označte řádek, kde je napsáno `pve-enterprise`, a nahoře klikněte na tlačítko **Disable**.

### První velká aktualizace

* V prostředním sloupci klikněte na samotné **Updates**.
* Nahoře klikněte na **Refresh** (stáhne se seznam novinek, až to doběhne na `TASK OK`, okno zavři).
* Následně klikněte na tlačítko **Upgrade**. Vyskakovací okno ti otevře linuxovou konzoli, kde jen napíšeš `Y` a potvrdíte Enterem.

### Konfigurace disků do poolu

V Proxmoxu v sekci **Disks** jsem vybral všechny 3TB disky. A kliknutím na **Wipe Disk** u všech 3TB disků jsem odstranil zbytky Windows Storage Spaces.

ZFS je v Proxmoxu standard. Pro 3x 3TB disky je RAID-Z1 ideální volbou.

V kontextu Proxmoxu a linuxových disků se pojmy **RAIDZ** a **RAID-Z1** často zaměňují, ale technicky vzato jde o jedno a totéž.

Co znamená RAID-Z?

* **RAID-Z1** je konkrétní úroveň pole v souborovém systému ZFS (obdoba klasického RAID 5). Číslo "1" na konci znamená paritu pro selhání **jednoho** disku. Znamená to, že může bezpečně umřít libovolný jeden disk z pole, aniž bys přišel o data.
* **RAIDZ** (nebo také `raidz`) je obecné označení pro celou rodinu ZFS RAIDů s paritou, kam spadá **RAID-Z1** (1 paritní disk), **RAID-Z2** (2 paritní disky, obdoba RAID 6) a **RAID-Z3** (3 paritní disky).

Konfigurace ZFS poolu:
* **Datacenter -> [název uzlu] -> ZFS -> Create: ZFS**.
* **Name:** `data_pool` (nebo dle libosti).
* **RAID Level:** **raidz1**.
* **Add Storage:** Zaškrtnul jsem všechny tři 3TB disky.

LZ4 proč data komprimovat?

1. **Rychlost:** Algoritmus `lz4` je extrémně nenáročný na procesor (bývá rychlejší než samotný zápis na mechanický disk).
2. **Více místa:** Filmy a běžná data se díky kompresi zmenší (často o jednotky až desítky procent).
3. **Vyšší výkon:** Protože je soubor menší, disk fyzicky přečte/zápíše menší množství dat, což paradoxně může celkovou rychlost čtení a zápisu zvýšit.

### Optane 32GB jako SWAP

Optane pro zrychlení systému Proxmoxu:

```
mkswap /dev/nvme_optane_disk
swapon /dev/nvme_optane_disk
```

A přidal jsem ho do `/etc/fstab`, aby se připojoval po restartu.


## SMB

Na Zalmanovi jsem vytvořil `/data_pool/share` a `smbuser`, kterému patří.

Pro připojení ve Windows zadejte do Průzkumníka:

```txt
\\192.168.1.100\Data
```

Pod Linuxem:
```txt
smb://192.168.1.100/Data
```

Přihlašovací údaje:
- uživatel: smbuser
- heslo:    heslo pro smbpasswd
