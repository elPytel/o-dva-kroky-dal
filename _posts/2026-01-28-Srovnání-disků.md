---
layout: post
title: "Srovnání disků"
description: Srovnání výkonu různých disků
categories: 
  - pc
  - windows
thumbnail: /assets/pc/hitachi-hdd-3tb-3.5-sata.jpeg
---

## 28.1.
Dorazil třetí 3TB disk a nainstaloval jsem ho do šasi.

![hitachi]({{ site.baseurl }}/assets/pc/hitachi-hdd-3tb-3.5-sata.jpeg)

Hitachi HDD 3TB:

| Parametr | Hodnota |
| -------- | ------- |
|Formát (form factor) |	3,5 palců |
|Kapacita pevného disku | 3TB |
|Rozhraní | Serial ATA III |
|Rychlost přenosu dat z ploten | 157 MB/s |
|Rychlost otáček (RPM) | 7200 ot./min |
|Vyrovnávací paměť (cache) | 64 MB |
|Výška | 25,4 mm (standardní výška) |

![hitachi]({{ site.baseurl }}/assets/pc/Hitachi 3TB.png)

### Srovnání výkonu disků

| Srovnání jednotlivých disků | Rychlost čtení (MB/s) |
| -------------------------- | --------------------- |
| Hitachi 3TB  | 155 |
| Seagate 3TB  | 206 |
| StorageDrive 3TB + 128GB sata cache | 561 |
| Intel 1TB nvme | 1,620 |
| Samsung 1TB nvme | 3,444 |

<div id="gallery">
  <img id="rotating-img" src="{{ site.baseurl }}/assets/pc/Hitachi 3TB performance.png" width="700" height="500">
  <br>
  <div style="display: flex; justify-content: space-between; width: 700px;">
    <button onclick="prevImg()">Předchozí</button>
    <button onclick="nextImg()">Další</button>
  </div>
</div>

<script>
const path = "{{ site.baseurl }}/assets/pc/";

const images = [
  "Hitachi 3TB performance.png", 
  "Seagate 3TB performance.png",
  "StorageDrive 3TB + SSD cache performance.png",
  "Intel 1TB nvme performance.png", 
  "Samsung 1TB nvme performance.png"
];

let idx = 0;

function showImg() {
    document.getElementById('rotating-img').src = path + images[idx];
}

function prevImg() {
    idx -= 1;
    if (idx < 0) idx = 0;
    showImg();
}

function nextImg() {
    idx = idx + 1;
    if (idx >= images.length) idx = images.length - 1;
    showImg();
}
</script>