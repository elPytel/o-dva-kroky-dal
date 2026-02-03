---
layout: post
title: "Storage Spaces II"
description: Další pokusy se Storage Spaces na Windows 11
categories: 
  - windows
  - storage
thumbnail: /assets/pc/Safe_data.png
---

Odstranil jsem Storage Space s tiered disky. Stačilo jen spustit jako správce starý skript na odstranění Storage Space, který jsem měl od jeho vytvoření na win 10 a chvíli se modlit.

[Storage Spaces I](../2024_and_older/2024-04-13-Storage_Spaces.md)

```powershell
remove-storage-space.ps1
```

Disky bylo nejdříve potřeba vyčistit, aby je Windows mohl znovu použít. Odstranil jsem všechny oddíly a data na discích pomocí PowerShell:
```powershell
# SEZNAM disků k vyčištění
$hddFriendly = @("HUA723030ALA640","ST33000651AS","ST3000VX015-3CV10G")
Get-Disk | Where-Object { $hddFriendly -contains $_.FriendlyName } | Format-Table Number, FriendlyName, Size, PartitionStyle
Get-Disk | Where-Object { $hddFriendly -contains $_.FriendlyName } | ForEach-Object { Clear-Disk -Number $_.Number -RemoveData -Confirm:$false }
```

Dostupné disky:
```powershell
Get-PhysicalDisk | Format-Table FriendlyName, MediaType, CanPool, Size -AutoSize

FriendlyName                 MediaType CanPool          Size
------------                 --------- -------          ----
Samsung SSD 970 EVO Plus 1TB SSD         False 1000204886016
HFS128G39TND-N210A           SSD          True  128035676160
TOSHIBA MQ01ABD100           HDD         False 1000204886016
HUA723030ALA640              HDD         False 3000592982016
ST33000651AS                 HDD          True 3000592982016
NVMe INTEL MEMPEK1W032GA     SSD         False   29260513280
NVMe INTEL SSDPEKNW512G8     SSD         False  512110190592
ST3000VX015-3CV10G           HDD         False 3000592982016
TOSHIBA MQ04ABF100           HDD         False 1000204886016
```

Po restartu počítače se disky objevily jako "CanPool: True".

Můj cíl je vytvořit Storage Pool s tiered disky:
- SSD tier (NVMe 1x 512GB)
- HDD tier (RAID5 z 3x 3TB HDD)

Velká kupa ERRORů při pokusu o vytvoření Storage Poolu s tiered disky. A pár minut debugování.

```powershell
Get-PhysicalDisk | Select FriendlyName, MediaType, LogicalSectorSize, PhysicalSectorSize

FriendlyName                 MediaType LogicalSectorSize PhysicalSectorSize                                                                       
------------                 --------- ----------------- ------------------                                                                       
Samsung SSD 970 EVO Plus 1TB SSD                     512               4096
HFS128G39TND-N210A           SSD                     512               4096
TOSHIBA MQ01ABD100           HDD                     512               4096
HUA723030ALA640              HDD                     512                512
ST33000651AS                 HDD                     512                512
NVMe INTEL MEMPEK1W032GA     SSD                     512                512
NVMe INTEL SSDPEKNW512G8     SSD                     512                512
ST3000VX015-3CV10G           HDD                     512               4096
TOSHIBA MQ04ABF100           HDD                     512               4096 
```

Problém je v tom, že nesedí velikost sektorů mezi diky. Některé disky mají fyzický sektor 512B, jiné 4096B. Win Storage Spaces je neumí spojit dohromady. 

```powershell
NVMe INTEL SSDPEKNW512G8   → 512 / 512
HUA723030ALA640            → 512 / 512
ST33000651AS               → 512 / 512
ST3000VX015-3CV10G         → 512 / 4096  ❌
```

Čas na přehodnocení plánů. Proč jsem si kupoval 3 3TB disky, když teď nemůžu udělat zapojení do RAID5?

## Mirror + NVMe
Nakonec jsem se rozhodl pro jednodušší zapojení:

Mirror + NVMe (512n):
- HUA723030ALA640
- ST33000651AS
- NVMe INTEL SSDPEKNW512G8

Narazil jsem však na další problém.

Jak funguje Storage tiering na windows? 
Část dat žije na NVMe - ten neslouží jen jako cache, ale obsahuje část dat z poolu. Pokud teedy člověk chce vauží jakoukoliv rendudnaci, tak musí mít redundatní disky i v NVMe části.

Pokud bych vytvořil:
- SSD tier (NVMe)
- HDD tier (mirror)

Tak často čtená data se přesunou na NVMe, studená data zůstanou na HDD (přesun probíhá asynchronně na pozadí). NVMe není jen buffer, ale obsahuje reálná data, když by došlo k jeho selhání, tak ztratím část dat!

Pokud člověk redundanci, tak musí mít zapojení něco jako:
- SSD tier (mirror 2 NVMe)
- HDD tier (RAID5 3+ HDD)

Nemám kam do počítače zapojit druhé NVMe, takže musím jít na jednodušší zapojení bez tieringu.

## Mirror bez NVMe tieringu = SAFE_DATA

V grafickém rozhraní Windows Storage Spaces sem vytvořil Storage Pool s názvem "Mirror pool" z 2x 3TB HDD a následně z něj vytvořil virtuální disk "SAFE_DATA" v režimu Mirror (2 disky).

![mirror]({{ site.baseurl }}/assets/pc/Safe_data.png)

Má tedy redundanci a v případě selhání jednoho disku zůstávají data zachována.

Mirror má výhodu v rychlosti čtení, protože data jsou čtena ze dvou disků současně... Až na to, že rychlost čtení z disků je pořád 150MB/s (stejná jako u jednodho disku).

![mirror - performance]({{ site.baseurl }}/assets/pc/Mirror 3TB performance.png)

## 1HDD + 1nvme = GAME_FAST

Zbývá mi ještě jeden 3TB disk (ST3000VX015-3CV10G) a NVMe (NVMe INTEL SSDPEKNW512G8). Můj plán je vytvořit Storage Pool "GAME_POOL" s tiered disky:
- SSD tier (NVMe)
- HDD tier (1x 3TB HDD)

Data nebudou mít žádnou redundanci, ale pro herní data a filmy to nevadí, protože je lze vždy stáhnout znovu.

```
Get-StoragePool | Select FriendlyName, OperationalStatus, IsPrimordial
FriendlyName  OperationalStatus IsPrimordial
------------  ----------------- ------------
Mirror drive  OK                       False
Fond úložiště OK                       False
Primordial    OK                        True
```

```powershell
Get-StoragePool -FriendlyName "Fond úložiště" | Get-PhysicalDisk | ft FriendlyName, Size, Usage, CanPool -Auto
FriendlyName                      Size Usage       CanPool
------------                      ---- -----       -------
NVMe INTEL SSDPEKNW512G8  512110190592 Auto-Select   False
ST3000VX015-3CV10G       3000592982016 Auto-Select   False        
```

```powershell
$pool = Get-StoragePool -FriendlyName "GAME_POOL"

$ssdTier = New-StorageTier `
  -StoragePoolFriendlyName $pool.FriendlyName `
  -FriendlyName "SSD_TIER" `
  -MediaType SSD

$hddTier = New-StorageTier `
  -StoragePoolFriendlyName $pool.FriendlyName `
  -FriendlyName "HDD_TIER" `
  -MediaType HDD
```

```powershell
New-VirtualDisk `
  -StoragePoolFriendlyName "GAME_POOL" `
  -FriendlyName "GAME_FAST" `
  -ResiliencySettingName Simple `
  -StorageTiers $ssdTier, $hddTier `
  -StorageTierSizes 280GB, 2200GB `
  -WriteCacheSize 10GB `
  -NumberOfColumns 1
```

A nic. Pokaždé selže a je jedno v jaké konfiguraci to zkouším. Windows hlásí že prostor uložišt nemá dostatak místa pro vytvoření virtuálního disku, i když je tam volného místa dost.

Vyzkoušel jsem i kombinaci 3TB Hitachi + 128GB SSD cache, ale opět bez úspěchu.

To co šlo udělat na win10, už na win11 nejde.

O důvod více proč přejít na Linux.

Na windows se budu muset asi vydat cestou [stablebit](https://stablebit.com/DrivePool), který umožnuje vytvářet pooly z různých disků bez ohledu na velikost sektorů a další parametry, přidání i caching na SSD a další vychytávky. To bude ale program, až se vrátíme z Erasmu.