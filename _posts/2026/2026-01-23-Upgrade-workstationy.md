---
layout: post
title: "Upgrade workstationy"
description: Upgrade stolního počítače disky a paměti RAM
categories: 
  - pc
  - windows
thumbnail: /assets/pc/Disky.png
---

## 20.1.
Upgrade stolního [počítače](../2024_and_older/2024-08-02-desktop.md) s [GTX 1070ti](../2025/2025-12-14-GTX-1070-Ti.md).

Pořídil jsem 2x8GB DDR4 paměti značky Samsung.
Takže mám nyní 48GB celkem. Na dlouhou dobu to teď bude asi poslední rozšíření operační paměti vzhledem k situaci na trhu s pamětí RAM.

Rozšíření RAM:
+16GB RAM
-> 48GB

Pořídil jsem také 3TB HDD. Mám v plánu sehnat ještě jeden a zapojit je s tím stávajícím do RAID 5, tedy o užitečné kapacitě 6TB v součtu. 

Rozšíření úložiště:
- 2x1TB HDD (2.5" SATA),
- 3x3TB HDD (3.2" SATA) + 500GB nvme "Cache"

Vyndal jsem 16GB optane místo něho jsem přidal Intel nvme 500GB SSD. 

| Kapacita | Výrobce | Formát  | Otáčky | 
| -------- | ------- | ------- | ------ |
| 1TB  | Toshiba | 2.5" SATA | 5400 RPM |
| 1TB  | Toshiba | 2.5" SATA | 5400 RPM |
| 3TB  | Seagate | 3.2" SATA | 5400 RPM |
| 3TB  | Seagate | 3.2" SATA | 7200 RPM |

| Kapacita | Výrobce | Formát   |
| -------- | ------- | -------- |
| 1TB      | Samsung | M.2 NVMe |
| 500GB    | Intel   | M.2 NVMe |

![disky]({{ site.baseurl }}/assets/pc/Disky.png)

Mám v plánu nastavit [Storage Spaces](../2024/2024-04-13-Storage_Spaces.md) s tiered disky:
- 500GB nvme SSD jako "rychlá vrstva" (cache),
- 3x3TB HDD jako "pomalá vrstva" (data) - celkem 6TB užitné kapacity v RAID 5.

Budu muset:
1. přenést data ze stávajících disků na zálohovací disk (externí 3TB HDD),
2. rozpustit stávající Storage Space (3TB+128GB),
3. upravit script na generování Storage Space s tiered disky,
4. vytvořit nový Storage Space s tiered disky,
5. přenést data zpět.

Tento upgrade by měl počítač připravit na to, že z něj výhledově bude domácí server.

Na virtualizovaný Steam OS a několik kontejnerů + SMB server by to mělo bohatě stačit.

![pc]({{ site.baseurl }}/assets/pc/Zalman_drives.jpg)

Objednal jsem i třetí 3TB HDD a čekám kdy dorazí.


## 3D tisk
Pro instalaci disků se v tomto šasi používají platové kolejničky. V počítači jsem měl jen jednu sadu, tak jsem našel na internet 3D modely pro tisk náhradních kolejnic.

Poslal jem Bekovi odkazy na stl soubory na 3D tisk držáků pro HDD do Zalman šasi.
- [Zalman Z3 Plus HDD rails](https://www.thingiverse.com/thing:5337904)
- [Zalman HDD rails](https://www.printables.com/model/1126937-zalman-hdd-rails?lang=cs)

Výměnou za ně dostal vybité elektronky, ze kterých vezme baterie.

Ukázka jak by to mělo vypadat po instalaci:

![s disky](https://media.printables.com/media/prints/1126937/images/8504592_81411079-bc7a-437b-be98-7189f14d0ca1_624dbaa0-f915-44b9-8903-aa2ae44095b0/thumbs/inside/1600x1200/jpg/img_20241230_140655.webp)
