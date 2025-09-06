---
layout: post
title: "Konečně doma"
description: Konečně doma
categories: ["expedice", "Švédsko"]
---

# Konečně doma

    Co bych si příště vzal sebou:
    - náš čaj,
    - špunty do uší (nejen k mým sluchátkům)

Návleky na polštáře jsme nakonec nepoužili. Ani pláštěnkové kalhoty naštěstí nebyly potřeba, ale příště si opět raději vezmeme. 

Moje trasové body: [Skandinávie.gpx]({{ site.baseurl }}/gpx/Skandinávie.gpx)

![Trasové body]({{ site.baseurl }}/assets/fotky/Screenshot_20250830-214215.png)

Zážitky z pohledu Štefana [zde](https://wildnorthernkayakingadventures.com/2025/08/07/2025-08_nur-noch-gen-nord/).

Naše postupné projíždění Skandinávií:

<!-- Přidejte do svého .md souboru -->
<div id="gallery">
  <img id="rotating-img" src="{{ site.baseurl }}/assets/fotky/Screenshot_20250811-150530.png" width="400">
  <br>
  <div style="display: flex; justify-content: space-between; width: 400px;">
    <button onclick="prevImg()">Předchozí</button>
    <button onclick="nextImg()">Další</button>
  </div>
</div>

<script>
const path = "{{ site.baseurl }}/assets/fotky/";

const images = [
  "Screenshot_20250811-150530.png",
  "Screenshot_20250816-120758.png",
  "Screenshot_20250820-154454.png",
  "Screenshot_20250830-214215.png"
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