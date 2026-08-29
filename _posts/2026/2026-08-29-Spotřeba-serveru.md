---
layout: post
title:  "Spotřeba serveru"
author: "Jarda"
description: Snížení spotřeby domácího Proxmox serveru z 70 W v idle na minimum
categories: 
    - Homelab
    - Proxmox
thumbnail: /assets/Proxmox_logo.png
---

- [Snižování spotřeby domácího Proxmox serveru](#snižování-spotřeby-domácího-proxmox-serveru)
  - [Chytré vypínání a zapínání pomocí Home Assistant](#chytré-vypínání-a-zapínání-pomocí-home-assistant)
    - [Zápis do plánovače úloh (cron)](#zápis-do-plánovače-úloh-cron)
    - [Integrace se Smart Things (Samsung)](#integrace-se-smart-things-samsung)
  - [Snížení idle spotřeby běžícího Proxmoxu](#snížení-idle-spotřeby-běžícího-proxmoxu)
    - [Změna CPU Governoru](#změna-cpu-governoru)
    - [Povolení ASPM (Active-State Power Management)](#povolení-aspm-active-state-power-management)
    - [P-States grafické karty](#p-states-grafické-karty)
    - [BIOS a periferie](#bios-a-periferie)
  - [Uspávání disků a úskalí ZFS](#uspávání-disků-a-úskalí-zfs)
    - [Konfigurace uspání přes hdparm](#konfigurace-uspání-přes-hdparm)
  - [Závěr](#závěr)


# Snižování spotřeby domácího Proxmox serveru

Můj domácí server Zalman (osazený 48 GB RAM a grafikou NVIDIA GTX 1070 Ti) odebírá při běhu naprázdno zhruba 70 W. Na stroj, který běží 24/7 a zajišťuje virtualizaci pod Proxmoxem, je to očekávatelná hodnota. Nicméně pro typické domácí nasazení, kdy od půlnoci do odpoledne není server potřeba, je zbytečné pálit elektřinu. Rozhodl jsem se proto spotřebu optimalizovat, jak na úrovni běhového idle stavu, tak chytrou automatizací vypínání.

Pořídili jsme chytrou zásuvku Meross s měřením spotřeby, která umožnujě vypnout/zapnout na dálku přes internet.

Namřená spotřeba pří běhu na prázdno se pohybuje mezi 60-70W. Za celý den tak zásuvka naměřila spotřebu 1.433 kWh.

## Chytré vypínání a zapínání pomocí Home Assistant

Vypínat server "natvrdo" časovačem je poukázka na zničený souborový systém. 

Plán automatizace:
1. **Softwarové vypnutí:** O půlnoci se na Proxmoxu spustí cron job (`shutdown -h now`), který bezpečně ukončí všechny kontejnery a systém. Spotřeba klesne z 60 W na jednotky wattů.
2. **Bezpečné odpojení napájení:** Home Assistant sleduje spotřebu na zásuvce. Jakmile klesne pod 5 W na dobu delší než 2 minuty, zásuvka odpojí přívod proudu. Tím se eliminuje riziko "tvrdého" vypnutí, pokud by se systém někdy vypínal déle.
3. **Automatické probuzení:** Při detekci mého příchodu domů (např. připojení na Wi-Fi nebo geolokace) Home Assistant zásuvku sepne.
4. **Automatický start (BIOS):** Aby server po příchodu proudu rovnou najel, je nutné v BIOSu základní desky nastavit volbu **Restore on AC Power Loss** (nebo obdobnou) na hodnotu **Power On**.

### Zápis do plánovače úloh (cron)
Spusťil jsem v terminálu:

```bash
crontab -e
```

Na konec souboru jsem přidal následující řádek. Z důvodu spolehlivosti je v cronu vždy lepší uvádět absolutní cestu k binárce:

```bash
# Shutdown server at midnight to save power
0 0 * * * /sbin/shutdown -h now
```

### Integrace se Smart Things (Samsung)
Bohužel zásuvka není zas tak chytrá. Je možné ji propojit s SmartThings (Samsung), zde se však zásuvka objěví jen jako vypínač a lezle z ní vyčítat odběr. 

Na mém Galaxy S21 Ultra mohu nastavit zapínání nativně, protože SmartThings i samotné systémové rutiny jsou integrované hluboko v systému a nevyžadují běh dalších aplikací třetích stran na pozadí.

Pro propojení Meross a SmartThings jsem v aplikaci SmartThings přidal nové zařízení a vybral možnost přidání přes partnerské značky. Vyhledal jsem službu Meross, přihlasil jsem se svými údaji a chytrou zásuvka se připojila.

**Konfigurace rutiny v telefonu**
MOhu využít buď přímo aplikaci SmartThings, nebo ještě lépe nativní systémovou aplikaci Režimy a rutiny (Modes and Routines) v nastavení Samsungu:

* **If:** zvolím "Síť Wi-Fi" a vyberu naší domácí síť (podmínka "připojeno"), případně "Místo" a nastav rádius.
* **Then:** Vyberu "Ovládání zařízení", najdu naší Meross zásuvku a nastav akci na zapnutí.

Na desce ještě musím povolit funkci "Restore on AC Power Loss", aby se server po příchodu proudu rovnou najel. V opačném případě by se po zapnutí zásuvky server nerozběhl a musel bych ho startovat ručně.

{: .info } 
> Tento geniální plán má však jeden háček a to, že nemám způsob automativkého vypínání zásuvky. Pro zatím se spokojím jen s tím se cron server o půlnoci vypne a já ho ručně zapnu až příjdu z práce domů (nebo si jej pustí Erika).

## Snížení idle spotřeby běžícího Proxmoxu

Proxmox je z výroby laděn na maximální výkon. Pomocí několika úprav lze idle spotřebu srazit o dalších zhruba 10 až 20 W.

### Změna CPU Governoru
Výchozí režim `performance` nedovolí procesoru maximálně podtaktovat. Přepnutím na `powersave` ušetříte cenné watty.
Instalace a nastavení:
```bash
apt install linux-cpupower
cpupower frequency-set -g powersave
```

Pomocí tohoto příkazu se úsporný režim rovnou na všechna dostupná jádra procesoru.

**Trvalé nastavení po startu**

Spuštte `crontab -e` a na další řádek (hned pod pravidlo pro `shutdown`) přidejte spuštění při bootu:

```bash
@reboot /usr/bin/cpupower frequency-set -g powersave
```

Při každém dalším startu Zalmanu si tak cron automaticky sáhne na procesor a srazí ho do úsporného režimu.

Pro ověření aktuálního stavu procesoru lze použít příkaz:

```bash
cpupower frequency-info
```

### Povolení ASPM (Active-State Power Management)
ASPM řídí spotřebu na PCIe linkách. V Linuxu bývá často vypnuté. Zapnutí se provádí v parametrech jádra:
1. Otevřete `/etc/default/grub`.
2. Na řádek `GRUB_CMDLINE_LINUX_DEFAULT` přidejte `pcie_aspm=force`.
3. Spusťte `update-grub` a restartujte server.

### P-States grafické karty
GTX 1070 Ti by měla v nečinnosti padat do stavu P8 (spotřeba cca 10 W). Zkontrolujte to příkazem `nvidia-smi`. Pokud karta visí ve stavu P0 i v idle, na vině může být připojený "dummy plug" nebo špatně uspaný kontejner (např. pro Sunshine/Moonlight).

{: .info } 
> V mém případě kdy mám nakonfigurovaný passhrough grafiky do Bazzite VM, karta nelze řídit z Proxmoxu. Při spuštění kontejneru tak paradoxně dojde ke snížení spotřeby o cca 10 W, protože karta se přepne do úsporného režimu P8 (nic nehraju). Při vypnutí kontejneru se karta vrátí do stavu P0 a spotřeba se zvýší.

### BIOS a periferie
Další doporučení je vypnout vše, co server nepotřebuje: integrovanou zvukovou kartu (HD Audio), sériové porty a nepoužívané SATA řadiče. Pro hloubkovou diagnostiku sběrnic a odhalení komponent bez aktivního power managementu lze použít utilitu `powertop`.

## Uspávání disků a úskalí ZFS

Uspávání (spindown) rotačních disků je kapitolou sama pro sebe.
* **ZFS pooly:** U mého pole (3x 3TB v RAIDZ1) je uspávání prakticky nemožné. ZFS je enterprise systém, který neustále zapisuje transakční logy a metadata.
* **MergerFS a ext4/NTFS:** Datové disky spojené přes MergerFS uspávat lze. MergerFS nestripuje data, takže probudí jen ten disk, ze kterého se reálně čte.

### Konfigurace uspání přes hdparm
Pro dvojici 2,5" disků (s NTFS filesystémem spojených přes MergerFS), u kterých neřeším opotřebení hlaviček, nastavuji agresivní uspání po 5 minutách nečinnosti.

```bash
ls -l /dev/disk/by-id/ | grep ata | grep -v part
lrwxrwxrwx 1 root root  9 Aug 29 12:38 ata-HFS128G39TND-N210A_EJ7BN46861170B82R -> ../../sdb
lrwxrwxrwx 1 root root  9 Aug 29 12:38 ata-HUA723030ALA640_MK0361YHGNP0VD -> ../../sdc
lrwxrwxrwx 1 root root  9 Aug 29 12:38 ata-ST3000VX015-3CV10G_ZW61AGJ0 -> ../../sde
lrwxrwxrwx 1 root root  9 Aug 29 12:38 ata-ST33000651AS_Z290M60D -> ../../sdf
lrwxrwxrwx 1 root root  9 Aug 29 12:38 ata-TOSHIBA_MQ01ABD100_178NC5D7T -> ../../sdd
lrwxrwxrwx 1 root root  9 Aug 29 12:38 ata-TOSHIBA_MQ04ABF100_601GPGWET -> ../../sda
```

V souboru `/etc/hdparm.conf` použijte přesné identifikátory disků, aby konfigurace přežila restart:

```text
# Disky MergerFS (NTFS)
/dev/disk/by-id/ata-TOSHIBA_MQ04ABF100_601GPGWET {
    spindown_time = 60
}

/dev/disk/by-id/ata-TOSHIBA_MQ01ABD100_178NC5D7T {
    spindown_time = 60
}
```
*(Poznámka: Hodnota 60 znamená 60 x 5 sekund = 5 minut).*

Pokud by disky příkazy z hdparmu ignorovaly, spolehlivější a agresivnější alternativou je systémový démon `hd-idle`.

Okamžité vynucení stavu standby
Abys rovnou změřil dopad na celkovou spotřebu a nemusel čekat, pošli oba disky do spánku manuálně těmito příkazy:
```bash
hdparm -y /dev/disk/by-id/ata-TOSHIBA_MQ04ABF100_601GPGWET
hdparm -y /dev/disk/by-id/ata-TOSHIBA_MQ01ABD100_178NC5D7T
```

U 2.5" disků není rozdíl tak dramatický jako u velkých 3.5" ploten.
- Běžící 2.5" disk si v idle bere zhruba 1,5 až 2 W.
- Uspaný 2.5" disk klesne pod 0,5 W.

Do budoucna plánuji pořídit jeden velký 8TB disk formátovaný čistě na `ext4`, na který budu posílat data přes bind mount do Docker kontejnerů. Stávající NTFS disky půjdou o dům dál, jelikož NTFS s sebou na Linuxu nese nepříjemnou režii FUSE ovladače `ntfs-3g` (formátovat je nechci, jejich nový možná bude za NTFS a filmy rád). Ten při větším čtení zatěžuje CPU a zbytečně ho budí do vyšších energetických stavů, což je přesně to, čeho se chceme u úsporného serveru vyvarovat.

## Závěr

Spotřebu jsem tak v IDLE snížil z 70 W na 54 W. Pokud se Zalman vypne o půlnoci a zapnu jej až v 17:00, tak poběží jen 7 hodin denně místo 24.

| Provedení | Spotřeba | Spotřeba za den |
|-----------|----------------|----------------|
| Zalman IDLE (performance) | 70 W | 1.68 kWh |
| Zalman IDLE (powersave) | 68 W | 1.632 kWh |
| Bazzite IDLE (GPU P8) | 60 W | 1.433 kWh |
| Bazzite IDLE (powersave + GPU P8) | 55 W | 1.320 kWh |
| Disky uspány (MergerFS)  | 53 W | 1.272 kWh |
| Vypínání na většinu dne | 53 W | 0.370 kWh |
