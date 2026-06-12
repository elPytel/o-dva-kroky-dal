---
layout: post
title:  "TUL knihovna opac book downloader"
author: "Jarda"
description: Nástroj na stahování knih ze školní knihovny
categories: 
    - TUL
    - Github
tags: 
    - programming
    - Python
---

Odkaz na repozitář [zde](https://github.com/TUL-IT-2020/TUL_knihovna-opac_book_downloader)

Naprogramoval jsem jednoduchý skript, který stahuje knihy z OPACu TUL knihovny. Skript je napsaný v Pythonu a je určen pro Linux, ale měl by fungovat i na Windows.

## Použití:
1. Připojte se do sítě TUL pomocí VPN.
2. Otevřete si v prohlížeči školní knihovnu.
   - `https://knihovna-opac.tul.cz`
3. Přihlaste se do svého účtu v knihovně.
4. Vyhledejte si knihu, kterou chcete stáhnout.
5. Rozklikněte si dokumenty ke stažení a zkopírujte zkrácený odkaz na první stránku.
   - Například v podobě: `https://knihovna-opac.tul.cz/media-viewer?rootDirectory=207986`
6. Spusťte na počítači skript:
```bash
python3 book_downloader.py
```