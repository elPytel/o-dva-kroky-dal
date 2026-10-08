---
layout: post
title:  "Jellyfin a HW akcelerace"
author: "Jarda"
description: Pokud se vám při přehrávání filmů v Jellyfinu CPU vytíží na 100%, je čas zprovoznit hardwarovou akceleraci přes iGPU a Quick Sync Video (QSV).
categories:
    - Homelab
    - Proxmox
tags: 
    - Jellyfin
thumbnail: /assets/Jellyfin_logo.webp
---

- [Jak zprovoznit iGPU pro Jellyfin](#jak-zprovoznit-igpu-pro-jellyfin)
  - [Povolení iGPU v BIOSu základní desky](#povolení-igpu-v-biosu-základní-desky)
  - [Předání iGPU do virtuálního stroje (Proxmox)](#předání-igpu-do-virtuálního-stroje-proxmox)
  - [Konfigurace uvnitř Debian VM](#konfigurace-uvnitř-debian-vm)
  - [Nastavení v Jellyfin GUI](#nastavení-v-jellyfin-gui)
- [Závěrem](#závěrem)
- [BONUS: Kontrola formátů v knihovně](#bonus-kontrola-formátů-v-knihovně)
  - [Rychlý audit knihovny](#rychlý-audit-knihovny)
  - [Možný převod z AV1](#možný-převod-z-av1)

Nasadil jsem Jellyfin na Docker runner a při stremování filmů je procesor vytížený alespoň na 1,5 jádra pokud dochází k nějakému překódování. To je pro i5-7600K sice stále v pohodě, ale pokud by se přehrávalo více streamů současně, tak by to už mohlo být problém. Proto jsem se rozhodl zprovoznit hardwarovou akceleraci přes integrované grafické jádro procesoru (iGPU) a jeho Quick Sync Video (QSV).

`debian-docker-runner` (VM 101) aktuálně nemá v hardwarové konfiguraci přiřazeno žádné PCIe zařízení. Protože je GTX 1070 Ti exkluzivně dedikovaná pro Bazzite pomocí IOMMU/PCIe passthrough, nelze ji současně sdílet do tohoto Debian VM. Veškeré transkódování v Jellyfinu tak nyní padá na softwarový výpočet přes 4 jádra procesoru, což systém při náročnějších formátech okamžitě zahltí.

{: .info }
> Pojmenování VM je trochu neštěstné, kdybch začal číslovat od 101, tak bych mohl nastavit aby ID VM odpovídalo IP adrese. 192.168.1.XXX by pak sedělo s VM XXX. Ale protože jsem začal od 100, tak je to trochu matoucí.

Řešení je přitom přímo v procesoru. Architektura Kaby Lake (i5-7600K) obsahuje integrované grafické jádro **Intel HD Graphics 630** s technologií **Quick Sync Video (QSV)**. Kaby Lake QSV plně podporuje hardwarové dekódování i kódování H.264 a především HEVC (H.265) včetně 10-bitových barev. Pro Jellyfin je to ideální a extrémně úsporný HW akcelerátor.

## Jak zprovoznit iGPU pro Jellyfin

Nastavení BIOSu:
- iGPU: enabled,
- Primary Monitor: CPU graphics.

### Povolení iGPU v BIOSu základní desky
Když je v PCIe slotu osazena dedikovaná grafika (1070 Ti), základní desky často integrované grafické jádro automaticky deaktivují. Je nutné jít do BIOSu hostitele a vynutit zapnutí iGPU (volba typu `IGD Multi-Monitor` = Enabled nebo `Primary Display` = PEG, ale `iGPU` = Enabled).

Restartoval jsem počítač, zapnul jsem BIOS a našel jsem sekci týkající se grafiky. Tam jsem vyhledal volbu `iGPU Multi-Monitor` a přepnul ji na `Enabled`. Volbu pro primární monitor jsem nastavil na **CPU graphics**. Uložil jsem nastavení a nabootoval Proxmox.

Zhruba nyní vybouchl Bazzite, protože iommu se pomýchaly skupiny a při startu Bazzite se Proxmox odřízne od některých PCIe zařízení. Je nutné upravit GRUB a restartovat Proxmox:

```bash
vim /etc/default/grub
```

Upravte řádek `GRUB_CMDLINE_LINUX_DEFAULT` takto:
```conf
GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on iommu=pt acpi_enforce_resources=lax initcall_blacklist=sysfb_init video=efifb:off pcie_aspm=force pcie_acs_override=downstream,multifunction"
```

```bash
update-grub
reboot
```

Po restartu Proxmoxu ověřte, Proxmox správně detekuje iGPU:

```bash
root@zalman:~# lspci
...
00:02.0 Display controller: Intel Corporation HD Graphics 630 (rev 04)
01:00.0 VGA compatible controller: NVIDIA Corporation GP104 [GeForce GTX 1070 Ti] (rev a1)
```

### Předání iGPU do virtuálního stroje (Proxmox)

V nastavení VM 101 jsem přidal nové zařízení: `Add -> PCI Device`. Vybral jsem integrovanou grafiku Intel.

{: .info }
> Tip pro Sysadminy: Pokud v budoucnu budete potřebovat iGPU sdílet mezi více virtuálními stroji (např. jeden pro Docker, druhý pro něco jiného), lze u Kaby Lake využít technologii **GVT-g** (vGPU), která iGPU virtuálně rozdělí. Pokud iGPU potřebujte pouze pro Debian s Dockerem, stačí standardní PCIe passthrough.

### Konfigurace uvnitř Debian VM
Aby Debian iGPU rozpoznal a dokázal akcelerovat video, potřebuje nesvobodné ovladače.

Přidal jsem ansible playbook, který nainstaloval balíčky `intel-media-va-driver-non-free` a `vainfo`. Po instalaci jsem ověřil, že se zařízení správně připojilo a vytvořilo zařízení:

```bash
ls -l /dev/dri
```

Zpřístupnění do Docker kontejneru. V `docker-compose.yml` Jellyfinu je potřeba zařízení namapovat, aby na něj kontejner viděl.

Do konfigurace služby Jellyfin jsem přidal sekci `devices`:
```yaml
    devices:
      # Direct access to QuickSync transcoding device
      - /dev/dri/renderD128:/dev/dri/renderD128

```

### Nastavení v Jellyfin GUI
Ve webovém rozhraní Jellyfinu a jděte do nastavení serveru.
V sekci **Řídící panel** -> **Přehrávání** -> **Transkódování** přepněte Hardwarovou akceleraci z *None* na *Intel QuickSync (QSV)*.
Zaškrtněte podporované formáty pro dekódování, primárně **H264** a **HEVC**.

Tím je procesorový bottleneck zcela vyřešen. Všechno překódování si nyní vezme na starost efektivní QuickSync čip.

## Závěrem
Pro běžné domácí použití a homelab nemá nákup dedikované karty čistě na transkódování do Zalmana prakticky žádný smysl.

Integrované grafické jádro Intel HD 630 v procesoru i5-7600K je na tuto úlohu hardwarově perfektně vybavené:

* **Dostatečná kapacita pro domácnost:** Quick Sync Video (QSV) v Kaby Lake bez problémů zvládne několik souběžných 1080p streamů nebo 1 až 2 paralelní transkódy 4K HEVC videa v reálném čase. Pro pokrytí potřeb jedné domácnosti a pár vzdálených klientů je to naprosto dostačující rezerva.
* **Nulová spotřeba a žádné teplo navíc:** Integrovaná grafika si v klidu nebere téměř nic a v zátěži přidá jednotky wattů. Přídavná dedikovaná grafika by v serveru trvale zvedla spotřebu v idle o 5 až 15 W a zabrala prostor pro chlazení.
* **Šetření PCIe slotů a linek:** Procesor i5-7600K disponuje pouze 16 PCIe linkami. Pokud už v hlavním slotu běží GTX 1070 Ti pro Bazzite, další PCIe karta by buď dělila linky na 8x/8x, nebo by musela komunikovat přes čipset základní desky (DMI sběrnici), kde už soupeří se ZFS/NVMe úložištěm a síťovým provozem.

Jediným reálným limitem i5-7600K je **chybějící hardwarové dekódování formátu AV1**, které Intel přidal až u 11. generace procesorů. Drtivá většina filmů a seriálů je však dnes stále uložena v H.264 nebo HEVC (H.265), se kterými si HD 630 poradí na jedničku.


## BONUS: Kontrola formátů v knihovně

**Jellyfin a Direct Play:** Pokud váš koncový přehrávač (telefon, novější televize, počítač) AV1 nativně podporuje, Jellyfin na serveru video vůbec netranskóduje. Pošle ho přímo přes Direct Play nebo Direct Stream. V takovém případě procesor ani iGPU na serveru nedělají prakticky nic bez ohledu na kodek. Transkódování nastává pouze tehdy, když klient kodek neumí nebo když omezíš datový tok.

**Generační ztráta kvality a čas:** i5-7600K nemá pro AV1 hardwarový dekodér, takže by musel každý snímek dekódovat softwarově přes CPU. Následná rekomprese do jiného ztrátového formátu zabere dost času a zbytečně sníží obrazovou kvalitu. Pokud při auditu narazíte na 2–3 AV1 kousky, které dělají klientům problémy, je řádově rychlejší a čistší je prostě stáhnout znovu v nativním HEVC/H.264.

### Rychlý audit knihovny

Jednoduchý Bash one-liner přes `ffprobe` (nebo `mediainfo`). Projde rekurzivně složku s filmy a vypíše pouze soubory v AV1:

```bash
find /cesta/k/filmum -type f \( -name "*.mkv" -o -name "*.mp4" \) -print0 | while IFS= read -r -d '' file; do
    codec=$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$file" 2>/dev/null)
    if [ "$codec" = "av1" ]; then
        echo "Nalezeno AV1: $file"
    fi
done

```

Mě nenalez žádný soubor v AV1.

### Možný převod z AV1

Software dekóduje AV1 přes rychlou knihovnu `dav1d` a o enkódování do HEVC se postará přímo Quick Sync na iGPU (`hevc_qsv`):

```bash
ffmpeg -c:v av1 -i "vstup.mkv" -c:v hevc_qsv -preset medium -global_quality 23 -c:a copy "vystup.mkv"
```

