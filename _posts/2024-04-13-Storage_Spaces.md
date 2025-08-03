---
layout: post
title: "Storage Spaces"
description: "Jak efektivně spravovat úložné prostory v systému Windows"
categories: ["windows", "storage"]
---
# Storage Space

- [Storage Space](#storage-space)
  - [Disky](#disky)
  - [Prostory uložišť](#prostory-uložišť)
  - [Dále návod na realizaci:](#dále-návod-na-realizaci)
    - [Konfigurace softwarového RAIDu ve Windows 10](#konfigurace-softwarového-raidu-ve-windows-10)
    - [Nastavení cachovaného disku](#nastavení-cachovaného-disku)
      - [Vytvoření svazku](#vytvoření-svazku)
      - [Odstranění svazku](#odstranění-svazku)
    - [Přesun disků mezi počítači](#přesun-disků-mezi-počítači)

Máte počítač windows? Ale libí se vím představa toho, že můžete spojit více svých disků do jednoho velkého uložiště jako to jde na Linuxu třeba s použitím [MergerFS]({{ site.baseurl }}{% link _posts/2023-08-02-MergerFS.md %}). Tak nezoufejte! Microsoft má pro vás řešení (alespoň částečně)!

## Disky
Chtěl jsem říci že se mi kolem váleli tyto disky, ale je to jen poloviční pravda. M.2 SATA SSD mělo krizi osobnosti a válejíce se kolem si hrálo na velkou flashku. SATA 3.5" 3TB HDD disk jsem si dokoupil z druhé ruky v podobě externího disku. 

![SSD_128GB.png]({{ site.baseurl }}/assets/SSD_128GB.png)

![HDD_3TB.png]({{ site.baseurl }}/assets/HDD_3TB.png)

Plotnový disk stačilo vyloupnout ze svého rámečku a mohl jsem ho namontovat do stoláku. Proč by to někdo dělal? Externí disky jsou z druhé ruky levné, zpravidla je někdo používal jen málo. Tyhle 3.5" hebeda většinou nikdo nenosil v kapse, takže by měli být v poměrně dobrém stavu. Rámeček který mi zbyl jsem dal Bekovi pro jeho 1TB disk z kterého neměl jak přečíst data. 

128GB SSD jsem dříve dostal od Mikiho za to že jsem mu vyčistil notebook a nainstaloval do něj 1TB nvme SSD. Celkový zápis NAND 70 TBW? Jo fakt má tolik naběháno jako si myslíte. Miki ho používal asi 5 let s jedním volným GB na disku C. Tak si ten disk trochu ošoupal nožičky při přepisování bloků... Ale jako cache se snad ozve dříve že se mu něco nelíbí než nadobro natáhne brka. 

## Prostory uložišť

Moje Steamová knihovna má 700GB. Cože 700GB? Co tam všechno je? Aha, hry jsou dneska fákt velký.

Když systémový disk máte 250GB SATA SSD, tak tam ty hry prostě nedáte. A na plotny se to sice vejde, ale z plotnového disku se dneska už hrát prakticky nedá. Neboť například vývojáři Hogwarts Legacy věnovali veškerý čas určený pro optimalizaci načítání assetů hry pro přidání ještě více skinů šál (kdyby vám přece jenom jejich počet nestačil můžete si další zakoupit jako DLC). 

Takže mít disk který má kapacitu 3TB, zápis jako SATA SSD a opětovné načítání stejně rychlé. By byla docela výhra. 

O čem je řeč? 

Prostory uložišť: Microsoftí řešení pro softwarový RAID. 

Ty vám umožní spojovat do hromady více prázdných disků. Na výběr máte základní možnosti jako je RAID 0, 1, 5. Jak nám to pomůže? Dobře že se ptáte, protože vůbec nijak!

On totiž u$oft ve své prozřetelnosti GUI utilitu pro vytváření více úrovňových uložišť přibalil jen do edice server...

Proč? 

Odpovědí je: **microsoft :(**

Ne že by Windows 10 neuměli udělat uložiště, které má více vrstev (cachovací disk/y), oni to umí, ale vy si budete muset poradit v terminálu. 

Dále v textu je přiložené script, která umožnuje vytvořit více úrovňové uložiště z prázdných disků.

NOTE: byl trochu problém s utilizací SSD disku, musel jsem ji snížit na nějakých 93% aby měl Windows nechali disk vytvořit.

![Prostory uložišť.png]({{ site.baseurl }}/assets/Prostory uložišť.png)

Bim bada bum bum! Máme disk!

Kapacita 3TB a propustnost jako SSD (jako starý pomalý ssd)!

On ten sekvenční zápis není zas o tolik lepší. SATA 6Gbps je sama o sobě už taky dost pomalá, ale ten random access time je úplně někde jinde. Žádný plotny co se musí otočit, žádný rameno co musí chitit stopu. Jakmile jsou data v cachi, tak frčí jako ssd a 128GB cache je docela dost velká.

## Dále návod na realizaci:

### Konfigurace softwarového RAIDu ve Windows 10

1. Nainstalujte pevné disky do počítače a nechte jej nabootovat do Windows 10.  
2. Zálohujte vše, o co nechcete přijít, z vašeho systémového disku před zahájením.  
3. **Do vyhledávání Windows napište nebo vložte „Prostory Úložišť“**.  
4. **Vyberte možnost Vytvořit nový fond a prostor úložiště**. Windows zkontroluje všechny disky a v dalším okně je vybere.  
5. **Vyberte typ RAID pod Odolnost** pomocí rozbalovací nabídky. Jednoduchý fond pouze spojí disky, Dvojitá a trojitá zrcadla jsou podobná RAID 1 a Parita je podobná RAID 5.  
6. **Nastavte velikost disku pod Velikost, pokud je to nutné**. Mělo by se automaticky nastavit na správnou hodnotu.  
7. **Vyberte Vytvořit úložištní prostor**.  
8. Počkejte na dokončení procesu a poté byste měli vidět jeden disk se správnou velikostí v Průzkumníku Windows.  
9. **Do vyhledávání Windows napište nebo vložte „Spravovat Prostory Úložišť“**, abyste mohli sledovat pole.

Konfigurace RAID ve Windows 10 je nyní jednodušší než kdy dříve. Nezapomeňte však sledovat hlášení o chybách po nastavení pole pro případné problémy.

RAID 1 je zrcadlení, což znamená, že data jsou kopírována na oba disky. 
RAID 5 je rozložený (striped), což znamená, že data jsou rozprostřena mezi disky s paritními bity na každém, což umožňuje RAIDu obnovit data ze ztraceného disku.

### Nastavení cachovaného disku

![cachovaný disk](https://github.com/freemansoft/win10-storage-spaces/raw/main/images_folder/simple.png)

#### Vytvoření svazku
```powershell
# RUN AS ADMINISTRATOR
# file name: new-storage-space.ps1
# https://nils.schimmelmann.us/post/153541254987/intel-smart-response-technology-vs-windows-10
# https://github.com/freemansoft/win10-storage-spaces
#Tested with one SSD and two HDD
#
#Pool that will suck in all drives
$StoragePoolName = "My Storage Pool"
#Tiers in the storage pool
$SSDTierName = "SSDTier"
$HDDTierName = "HDDTier"
#Virtual Disk Name made up of disks in both tiers
$TieredDiskName = "My Tiered VirtualDisk"

#Simple = striped.  Mirror only works if both can mirror AFIK
#https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/dn387076(v=ws.11)
$DriveTierResiliency = "Simple"

#Change to suit - drive later and the label name
$TieredDriveLetter = "Z"
$TieredDriveLabel = "StorageDrive"

#Override the default sizing here - useful if have two different size SSDs or HDDs - set to smallest of pair
#These must be Equal or smaller than the disk size available in that tier SSD and HDD
#SSD:cache  -    HDD:data
#set to null so copy/paste to command prompt doesn't have previous run values
$SSDTierSize = $null
$HDDTierSize = $null
#Drives cannot always be fully allocated - probably broken for drives < 10GB
$UsableSpace = 0.99

#Uncomment and put your HDD type here if it shows up as unspecified with "Get-PhysicalDisk -CanPool $True
#    If your HDDs show up as Unspecified instead of HDD
$UseUnspecifiedDriveIsHDD = "Yes"

#List all disks that can be pooled and output in table format (format-table)
Get-PhysicalDisk -CanPool $True | ft FriendlyName, OperationalStatus, Size, MediaType

#Store all physical disks that can be pooled into a variable, $PhysicalDisks
#    This assumes you want all raw / unpartitioned disks to end up in your pool - 
#    Add a clause like the example with your drive name to stop that drive from being included
#    Example  " | Where FriendlyName -NE "ATA LITEONIT LCS-256"
if ($UseUnspecifiedDriveIsHDD -ne $null){
    $DisksToChange = (Get-PhysicalDisk -CanPool $True | where MediaType -eq Unspecified)
    Get-PhysicalDisk -CanPool $True | where MediaType -eq Unspecified | Set-PhysicalDisk -MediaType HDD
    # show the type changed
    Get-PhysicalDisk -CanPool $True | ft FriendlyName, OperationalStatus, Size, MediaType
}
$PhysicalDisks = (Get-PhysicalDisk -CanPool $True | Where MediaType -NE UnSpecified)
if ($PhysicalDisks -eq $null){
    throw "Abort! No physical Disks available"
}

Write-Output "Creating Storage Pool..."
#Create a new Storage Pool using the disks in variable $PhysicalDisks with a name of My Storage Pool
$SubSysName = (Get-StorageSubSystem).FriendlyName
New-StoragePool -PhysicalDisks $PhysicalDisks -StorageSubSystemFriendlyName $SubSysName -FriendlyName $StoragePoolName
#View the disks in the Storage Pool just created
Get-StoragePool -FriendlyName $StoragePoolName | Get-PhysicalDisk | Select FriendlyName, MediaType

#Set the number of columns used for each resiliency - This setting assumes you have at least 2-SSD and 2-HDD
# Get-StoragePool $StoragePoolName | Set-ResiliencySetting -Name Simple -NumberOfColumnsDefault 2
# Get-StoragePool $StoragePoolName | Set-ResiliencySetting -Name Mirror -NumberOfColumnsDefault 1

#Create two tiers in the Storage Pool created. One for SSD disks and one for HDD disks
$SSDTier = New-StorageTier -StoragePoolFriendlyName $StoragePoolName -FriendlyName $SSDTierName -MediaType SSD
$HDDTier = New-StorageTier -StoragePoolFriendlyName $StoragePoolName -FriendlyName $HDDTierName -MediaType HDD

#Calculate tier sizes within this storage pool
#Can override by setting sizes at top
if ($SSDTierSize -eq $null){
    $SSDTierSize = (Get-StorageTierSupportedSize -FriendlyName $SSDTierName -ResiliencySettingName $DriveTierResiliency).TierSizeMax
    $SSDTierSize = [int64]($SSDTierSize * $UsableSpace)
}
if ($HDDTierSize -eq $null){
    $HDDTierSize = (Get-StorageTierSupportedSize -FriendlyName $HDDTierName -ResiliencySettingName $DriveTierResiliency).TierSizeMax 
    $HDDTierSize = [int64]($HDDTierSize * $UsableSpace)
}
Write-Output "TierSizes: ( $SSDTierSize , $HDDTierSize )"

if ($SSDTierSize -eq 0 -or $HDDTierSize -eq 0){
    throw "Abort! Tier size is 0"
}

# you can end up with different number of columns in SSD - Ex: With Simple 1SSD and 2HDD could end up with SSD-1Col, HDD-2Col
Write-Output "Creating Virtual Disk..."
# New-VirtualDisk -StoragePoolFriendlyName $StoragePoolName -FriendlyName $TieredDiskName -StorageTiers @($SSDTier, $HDDTier) -StorageTierSizes @(110GB, 2700GB) -ResiliencySettingName $DriveTierResiliency -WriteCacheSize 1GB
New-VirtualDisk -StoragePoolFriendlyName $StoragePoolName -FriendlyName $TieredDiskName -StorageTiers @($SSDTier, $HDDTier) -StorageTierSizes @($SSDTierSize, $HDDTierSize) -ResiliencySettingName $DriveTierResiliency -AutoWriteCacheSize -AutoNumberOfColumns

# initialize the disk, format and mount as a single volume
Write-Output "preparing volume..."
Get-VirtualDisk $TieredDiskName | Get-Disk | Initialize-Disk -PartitionStyle GPT
# This will be Partition 2.  Storage pool metadata is in Partition 1
Get-VirtualDisk $TieredDiskName | Get-Disk | New-Partition -DriveLetter $TieredDriveLetter -UseMaximumSize
Initialize-Volume -DriveLetter $TieredDriveLetter -FileSystem NTFS -Confirm:$false -NewFileSystemLabel $TieredDriveLabel
Get-Volume -DriveLetter $TieredDriveLetter

Write-Output "Operation complete"
```

#### Odstranění svazku
```powershell
# file name: remove-storage-space.ps1
#Variables names here MUST MATCH create-storage-space.ps1
$StoragePoolName = "My Storage Pool"
$SSDTierName = "SSDTier"
$HDDTierName = "HDDTier"
$TieredDiskName = "My Tiered VirtualDisk"

# Make sure they really want to do this!
$choices  = '&Yes', '&No'
$decision = $Host.UI.PromptForChoice('Remove Storage Space', 'Are you sure you wish to remove the storage space named "' + $TieredDiskName + '"?' + [Environment]::NewLine + 'ALL DATA WILL BE PERMANENTLY LOST', $choices, 1)
if ($decision -ne 0) {
    exit
}

# In reverse order of creation
if ((Get-VirtualDisk -FriendlyName $TieredDiskName) -ne $null){
    Write-Output "Removing drive: $TieredDiskName"
    Get-VirtualDisk -FriendlyName $TieredDiskName
    Remove-virtualdisk -friendlyName $TieredDiskName -Confirm:$false
} else {
    Write-Output "Drive does not exist: $TieredDiskName"
}

# Remove Storage Tier
if ((Get-StorageTier -FriendlyName $HDDTierName) -ne $null){
    Write-Output "Removing storage tiers: $HDDTierName"
    Get-StorageTier -FriendlyName $HDDTierName | FT FriendlyName, MediaType, Size -AutoSize
    Remove-StorageTier -FriendlyName $HDDTierName -Confirm:$false
} else {
    Write-Output "Tier does not exist: $HDDTierName"
}
if ((Get-StorageTier -FriendlyName $SSDTierName) -ne $null){
    Write-Output "Removing storage tiers: $SSDTierName"
    Get-StorageTier -FriendlyName $SSDTierName | FT FriendlyName, MediaType, Size -AutoSize
    Remove-StorageTier -FriendlyName $SSDTierName -Confirm:$false
} else {
    Write-Output "Tier does not exist: $SSDTierName"
}
Get-StorageTier

# Remove the Storage Pool
if ((Get-StoragePool -FriendlyName $StoragePoolName) -ne $null){
    Write-Output "Removing storage pool: $StoragePoolName"
    Get-StoragePool -FriendlyName $StoragePoolName | Get-PhysicalDisk | FT FriendlyName, MediaType
    Remove-StoragePool -FriendlyName $StoragePoolName -Confirm:$false
} else {
    Write-Output "Storage Pool does not exist: $StoragePoolName"
}
# Show just the primoridal pool
Write-Output "Poolable drives after cleanup"
Get-StoragePool | Get-PhysicalDisk -CanPool:$True

Write-Output "Operation complete"
```

- [git: win10 storage spaces](https://github.com/freemansoft/win10-storage-spaces)
- [nils.schimmelmann.us](https://nils.schimmelmann.us/2016-11-22-intel-smart-response-technology-vs-windows-10/)

### Přesun disků mezi počítači

Přesun uložišť je možný a lze je bezpečně přesunout do nového systému, i když existují určité závislosti na verzi Windows. (Pokud je váš nový systém postaven na stejné nebo novější verzi Windows, budete v pořádku.)
Veškerá metadata o úložišti a jeho virtuálních discích a konfiguracích svazků jsou uložena na samotných discích, nikoli v operačním systému. Ujistěte se, že všechny disky jsou dostupné a připojeny v novém systému.
V některých případech může být úložiště po prvním spuštění v novém systému ve stavu offline. Pokud ano, můžete jej uvést do provozu v Správě disků.

- [reddit: moving storage spaces](https://www.reddit.com/r/Windows11/comments/10cwd7j/moving_storage_spaces/?rdt=55298)