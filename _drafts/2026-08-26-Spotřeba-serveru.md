---
layout: post
title:  "Spotřeba serveru"
author: "Jarda"
description: A description
categories: 
    - Homelab
    - Proxmox
---

- [Snižování spotřeby domácího Proxmox serveru: Jak optimalizovat 60 W v idle](#snižování-spotřeby-domácího-proxmox-serveru-jak-optimalizovat-60-w-v-idle)
  - [Chytré vypínání a zapínání pomocí Home Assistant](#chytré-vypínání-a-zapínání-pomocí-home-assistant)
    - [Integrace se Smart Things (Samsung)](#integrace-se-smart-things-samsung)
  - [Snížení idle spotřeby běžícího Proxmoxu](#snížení-idle-spotřeby-běžícího-proxmoxu)
  - [Uspávání disků a úskalí ZFS](#uspávání-disků-a-úskalí-zfs)


# Snižování spotřeby domácího Proxmox serveru: Jak optimalizovat 60 W v idle

Můj domácí server Zalman (osazený 48 GB RAM a grafikou NVIDIA GTX 1070 Ti) odebírá při běhu naprázdno zhruba 60 W. Na stroj, který běží 24/7 a zajišťuje virtualizaci pod Proxmoxem, je to očekávatelná hodnota. Nicméně pro typické domácí nasazení, kdy od půlnoci do odpoledne není server potřeba, je zbytečné pálit elektřinu. Rozhodl jsem se proto spotřebu optimalizovat, jak na úrovni běhového idle stavu, tak chytrou automatizací vypínání.

Zde je souhrn mých postupů a konfigurací.

## Chytré vypínání a zapínání pomocí Home Assistant

Vypínat server "natvrdo" časovačem je poukázka na zničený souborový systém. Využil jsem proto chytrou zásuvku Meross s měřením spotřeby napojenou na Home Assistant.

**Postup automatizace:**
1. **Softwarové vypnutí:** O půlnoci se na Proxmoxu spustí cron job (`shutdown -h now`), který bezpečně ukončí všechny kontejnery a systém. Spotřeba klesne z 60 W na jednotky wattů.
2. **Bezpečné odpojení napájení:** Home Assistant sleduje spotřebu na zásuvce. Jakmile klesne pod 5 W na dobu delší než 2 minuty, zásuvka odpojí přívod proudu. Tím se eliminuje riziko "tvrdého" vypnutí, pokud by se systém někdy vypínal déle.
3. **Automatické probuzení:** Při detekci mého příchodu domů (např. připojení na Wi-Fi nebo geolokace) Home Assistant zásuvku sepne.
4. **Automatický start (BIOS):** Aby server po příchodu proudu rovnou najel, je nutné v BIOSu základní desky nastavit volbu **Restore on AC Power Loss** (nebo obdobnou) na hodnotu **Power On**.

### Integrace se Smart Things (Samsung)

Je to nejčistší a na údržbu nejméně náročné řešení. Na tvé Galaxy S21 Ultra to navíc půjde nastavit naprosto nativně, protože SmartThings i samotné systémové rutiny jsou integrované hluboko v systému a nevyžadují běh dalších aplikací třetích stran na pozadí.

Tady je doporučený postup, jak celý řetězec poskládat pro maximální spolehlivost:

**1. Propojení Meross a SmartThings**

* V aplikaci SmartThings přidej nové zařízení a vyber možnost přidání přes partnerské značky.
* Vyhledej službu Meross, přihlas se svými údaji a chytrou zásuvku uvidíš přímo ve svém seznamu zařízení.

**2. Volba spouštěče pro rutinu**
Při vytváření samotné logiky máš na výběr ze dvou hlavních možností detekce tvého příchodu:

* **Připojení k domácí Wi-Fi:** Z technického hlediska spolehlivější, přesnější a šetrnější k baterii telefonu. Server se začne spouštět zhruba ve chvíli, kdy odemykáš dveře.
* **Geolokace (Místo):** Spustí akci, jakmile telefon vstoupí do zvoleného rádiusu kolem bydliště. Je to ideální, pokud chceš mít jistotu, že Zalman bude plně nabootovaný už ve chvíli, kdy si sundáváš boty.

**3. Konfigurace rutiny v telefonu**
Můžeš využít buď přímo aplikaci SmartThings, nebo ještě lépe nativní systémovou aplikaci **Režimy a rutiny** (Modes and Routines) v nastavení Samsungu:

* **Když (If):** Zvol "Síť Wi-Fi" a vyber svou domácí síť (podmínka "připojeno"), případně zvol "Místo" a nastav rádius.
* **Pak (Then):** Vyber "Ovládání zařízení", najdi svou Meross zásuvku a nastav akci na zapnutí.

Celé to bude fungovat zcela autonomně. O vypnutí se postará Proxmox a spotřeba samotné zásuvky, o zapnutí tvůj telefon a BIOS desky.

Máš už na desce otestovanou funkci "Restore on AC Power Loss", nebo chceš probrat, jak spolehlivě nasimulovat výpadek a ověřit, že server po sepnutí zásuvky skutečně vždy nabootuje?

## Snížení idle spotřeby běžícího Proxmoxu

Proxmox je z výroby laděn na maximální výkon. Pomocí několika úprav lze idle spotřebu srazit o dalších zhruba 10 až 20 W.

**Změna CPU Governoru**
Výchozí režim `performance` nedovolí procesoru maximálně podtaktovat. Přepnutím na `powersave` ušetříte cenné watty.
Instalace a nastavení:
```bash
apt install cpufrequtils
# Set governor to powersave
echo 'GOVERNOR="powersave"' > /etc/default/cpufrequtils
systemctl restart cpufrequtils
```

**Povolení ASPM (Active-State Power Management)**
ASPM řídí spotřebu na PCIe linkách. V Linuxu bývá často vypnuté. Zapnutí se provádí v parametrech jádra:
1. Otevřete `/etc/default/grub`.
2. Na řádek `GRUB_CMDLINE_LINUX_DEFAULT` přidejte `pcie_aspm=force`.
3. Spusťte `update-grub` a restartujte server.

**P-States grafické karty**
GTX 1070 Ti by měla v nečinnosti padat do stavu P8 (spotřeba cca 10 W). Zkontrolujte to příkazem `nvidia-smi`. Pokud karta visí ve stavu P0 i v idle, na vině může být připojený "dummy plug" nebo špatně uspaný kontejner (např. pro Sunshine/Moonlight).

**BIOS a periferie**
Vypněte vše, co server nepotřebuje: integrovanou zvukovou kartu (HD Audio), sériové porty a nepoužívané SATA řadiče. Pro hloubkovou diagnostiku sběrnic a odhalení komponent bez aktivního power managementu doporučuji utilitu `powertop`.

## Uspávání disků a úskalí ZFS

Uspávání (spindown) rotačních disků je kapitolou sama pro sebe.
* **ZFS pooly:** U mého pole (3x 3TB v RAIDZ1) je uspávání prakticky nemožné. ZFS je enterprise systém, který neustále zapisuje transakční logy a metadata.
* **MergerFS a ext4/NTFS:** Datové disky spojené přes MergerFS uspávat lze. MergerFS nestripuje data, takže probudí jen ten disk, ze kterého se reálně čte.

**Konfigurace uspání přes hdparm**
Pro dvojici 2,5" disků (s NTFS filesystémem spojených přes MergerFS), u kterých neřeším opotřebení hlaviček, nastavuji agresivní uspání po 10 minutách nečinnosti.
V souboru `/etc/hdparm.conf` použijte přesné identifikátory disků, aby konfigurace přežila restart:

```text
# Disk 1
/dev/disk/by-id/ata-ID_DISKU_1 {
    spindown_time = 120
}
# Disk 2
/dev/disk/by-id/ata-ID_DISKU_2 {
    spindown_time = 120
}
```
*(Poznámka: Hodnota 120 znamená 120 x 5 sekund = 10 minut).*

Pokud by disky příkazy z hdparmu ignorovaly, spolehlivější a agresivnější alternativou je systémový démon `hd-idle`.

Do budoucna plánuji pořídit jeden velký 8TB disk formátovaný čistě na `ext4`, na který budu posílat data přes bind mount do Docker kontejnerů. Stávající NTFS disky půjdou o dům dál, jelikož NTFS s sebou na Linuxu nese nepříjemnou režii FUSE ovladače `ntfs-3g` (formátovat je nechci, jejich nový možná bude za NTFS a filmy rád). Ten při větším čtení zatěžuje CPU a zbytečně ho budí do vyšších energetických stavů, což je přesně to, čeho se chceme u úsporného serveru vyvarovat.