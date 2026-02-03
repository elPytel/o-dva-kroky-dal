---
layout: post
title: "Thinkpad Thunderbolt dock a Ubuntu"
description: Návod na instalaci ovladačů pro Thinkpad Thunderbolt dock na Ubuntu
categories: ["linux", "ubuntu", "thinkpad", "dock"]
thumbnail: https://download.lenovo.com/km/media/images/ACC100348/usb-c%20111_20191220172516806.JPG
---

Když jsem úspěšně nainstaloval Ubuntu na firemní DELL Latitude 5450, tak jsem se pustil do připojování domácích monitorů přes Thinkpad Thunderbolt dock.

Momentální konfigurace je:
- HP ZDisplay Z24i 24" (1920x1200) [link](https://support.hp.com/cz-cs/drivers/hp-z-display-z24i-24-inch-ips-led-backlit-monitor/model/5367299)
- Samsung Smart Monitor 32" M7 (4K) [link](https://www.samsung.com/cz/monitors/smart/smart-monitor-m7-32-inch-smart-tv-apps-ls32dm702uuxdu/)

Oba monitory jsou přopijené na stolní počtítač do GeForce GTX 1070 a zaroveň do Thinkpad Thunderbolt docku připojeného k notebooku.

Chtěl jsem mít možnost připojit notebook ke všem monitorům a přepínat mezi nimi podle potřeby. Mám bezdrátovou klávesnici připojitelnou k více zdrojům a mohu jí tak snadně přepínat mezi stolním počítačem a notebookem. Stějně tak myš Rapture Cobra Stealth funguje na více zařízeních (jedno Bluetooth, jedno USB kabel).

Když jsem všek připojil Lenovo Dock 40A9, tak se Smasung 4K monitor připojil jen v režimu 30 Hz. Rozhodl jsem se tedy dok s tátou vyměnit za Lenovo Dock 40AF, který podporuje 4K při 60 Hz.

Připojení druhého však nebylo tak bezproblémové jak jsem čekal. Dok připojil sice ethernet a USB zařízení, ale monitory nefungovaly vůbec stejně tak ani napájení notebooku přes dok.

Musel jsem:
1. Nainstalovat obecné ovladače pro Ubuntu,
2. Nainstalovat DisplayLink software pro Ubuntu,
3. Připojit dok na výkonnější napájecí adaptér (130W místo 90W).

# Thinkpad Thunderbolt dock

Pro instalaci obecných ovladačů na Ubuntu spusťte následující příkazy v terminálu:
```Bash
sudo apt update
sudo ubuntu-drivers install
```
Restartujte počítač.

- [zdroj](https://askubuntu.com/questions/543325/how-to-download-all-required-ubuntu-drivers)

Q&A od Lenova k Thunderbolt dokovacím stanicím:
- [Podpora Linuxu na Lenovo ThinkPad dokovacích stanicích](https://pcsupport.lenovo.com/cz/cs/solutions/ht516021)

## DisplayLink software

- [legacy Ubuntu](https://support.displaylink.com/knowledgebase/articles/684649)
- [Ubuntu Driver](https://www.synaptics.com/products/displaylink-graphics/downloads/ubuntu)

### Synaptics APT Repository

Chcete-li přidat repozitář do svých APT zdrojů, nejprve si stáhněte balíček "Synaptics APT Repository" níže a poté postupujte podle těchto kroků k instalaci ovladače DisplayLink. Poznámka: před přepnutím na metodu APT odinstalujte samostatnou verzi ovladače.

```bash
sudo apt install ./Downloads/synaptics-repository-keyring.deb
```

Nezapomeňte zadat správnou cestu k umístění balíčku ve vašem souborovém systému.

Poté aktualizujte APT cache.

```bash
sudo apt update
```

Další část instalace ovladačů DisplayLink je pokračovat s vlastní instalací pomocí následujícího příkazu.

```bash
sudo apt install displaylink-driver
```

# Thinkpad Doky

## Lenovo ThinkPad USB-C Dock: Type 40A9
- [Lenovo](https://support.lenovo.com/us/en/accessories/acc100348-thinkpad-usb-c-dock-overview-and-service-parts)

![přehled](https://download.lenovo.com/km/media/images/ACC100348/usb-c%20111_20191220172516806.JPG)

![porty](https://download.lenovo.com/km/media/images/ACC100348/usb-c%20222_20191220172548931.JPG)

Dok funguje přes USB-C a Thunderbolt 3. Lze ho napájet přes Lenovo 90W hranatý napájecí adaptér.

### Video parametry
- Jeden 4K @ 30hz
- Maximální počet displejů: 2

Aby bylo dosaženo lepšího uživatelského zážitku zobrazení, doporučuje se připojit jeden nebo dva displeje na dok:
- Pouze výstup DisplayPort: 3840 x 2160 pixelů (30 Hz)
- Pouze výstup VGA: 1920 x 1200 pixelů (60 Hz)
- Současný výstup DisplayPort a VGA: 1920 x 1080 pixelů (60 Hz)
- Současný výstup DisplayPort a DisplayPort: 1920 x 1080 pixelů (60 Hz)

> [!note]
> Lze připojit 4k displej, ale s omezením na 30 Hz.

## Lenovo ThinkPad USB-C Dock: Type 40AF

- [Lenovo](https://pcsupport.lenovo.com/cz/cs/products/accessory/docks/thinkpad-hybrid-usb-c-with-usb-a-dock/40af/solutions/pd500180-thinkpad-hybrid-usb-c-with-usb-a-dock-overview-and-service-parts)

![přehled](https://download.lenovo.com/km/media/images/PD500180/usb-c%20dock%2040AF%20three_20190129200648146.JPG)

![porty](https://download.lenovo.com/km/media/images/PD500180/usb-c%20dock%2040AF%20two_2019012920073870.JPG)

### Porty, konektory, zabezpečení
- Typ připojení: USB-C kabel s USB-C na USB-A donglem
- Tři USB 3.2 gen2 (10Gbps, 1x stále zapnutý)
- Dva USB 2.0
- USB-C port (Data, 5V 3A napájení)
- 10/1000 Gigabit Ethernet
- Dva DP1.2 porty
- Dva HDMI2.0 porty
- Kombinovaný audio jack
- HDMI™
- Až dvě UHD displeje připojené přes DisplayPort™/HDMI™ porty
- Slot pro bezpečnostní zámek

### Video parametry
Rozlišení monitoru:
- Počet externích monitorů: 2
- Až dvě UHD displeje připojené přes DisplayPort™/HDMI™ porty
- Maximální podpora rozlišení/frekvence: 5120*2880@60Hz

> [!note]
> Lze připojit 4k displej a to i při 60 Hz!

> [!warning]
> Dok potřebuje napájení přes 100W aby napájel připojený notebook. Použití slabšího adaptéru umožnujě replikvat porty, ale nedodává dostatek energie pro nabíjení notebooku.