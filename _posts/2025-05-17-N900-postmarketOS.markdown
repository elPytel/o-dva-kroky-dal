---
layout: post
title:  "Nokia N900 a postmarketOS"
date:   2025-05-17 15:11:11 +0200
categories: n900 postmarketOS
thumbnail: https://i.redd.it/6aki9gtqtb1f1.png
---

# Hrátky s Nokií

Operační systém na Nokii je Maemo 5. Je to vlastně Linuxové jádro, trocha střev z Debianu a nad tím grafické prostředí GTK+. To všechno je krásné, jen je to z roku 2009 a většina toho softwaru je dávno za datem prodlouřené podpory.

Pro mojí aplikaci bych potraboval Python3, Maemo má Python 2. Mohl bych zkusit zkompilovat nový python a všechny jeho závislosti na staré Maemo. 

To se vedlo asi takhle [github: Python 3.11 on N900](https://github.com/elPytel/Python_3.11_on_N900) (Což je také odpověď na otázku co dělá mladý IŤák, když je u moře a má týden rýmu).

Druhá možnost je přeinstalovat operační systém na něco moderního...
Postmarket OS!

# N900 a postmarketOS

Instalace by byla docela přímočará, kdyby fungovaly servery Meamo (komunity) s repozitářema a šlo instalovat aplikace tou běžnou cestou. Bohužel to však nebyl můj případ. Musel jsem shánět aplikace na strákách internet archivu. Naštěstí web maemo zde svůj archiv měl a všechny `*.deb` soubory sde jsou k dispozici. 

Nainstalovat jsem:
- **gainroot**,
- **ssh**,
- **u-boot**. 

Když jsem povolil starší protokol, tak přístup na N900 byl přes SSH jinak bezproblémový.

S funkčním u-bootem je instalce postmarketOS vlastně jen rozbalení obrazu disku na SD-kartu a její vložení do mobilu. Něco co zvládne každý vlastník RPi.

Je potřeba u-bootu přidat záznam pro bootování z SD karty.

Všechno je dobře popsáno v oficiální dokumentaci postmarketOS: [Nokia N900](https://wiki.postmarketos.org/wiki/Nokia_N900_(nokia-n900))

Mé poznámky a postupy jsou zde:
[Postmarket OS na N900](https://github.com/elPytel/nokia-n900-notes/blob/main/pmOS_files/Postmarket%20OS.md)

Obraz disku jsem si vybral s grafikcým prostředím i3wm. Otestoval jsem i verzi s pouze příkazovou řádku, která poskytuje menší obraz a také xfce, ale to bylo nesnesitelně pomalé (za to pravděpodobně může chybějící grafická akcelerace).

![pmOS terminál](https://i.redd.it/6aki9gtqtb1f1.png)

Post na Redditu: [r/n900: n900 back in the game](https://www.reddit.com/r/n900/comments/1koqmgo/n900_back_in_the_game/)

## i3wm

Pokud se poprvé setkáváte se správcem oken i3, tak je dobré se podívat alespoň na tyto klávesové zkratky, které vám pomohou začít:

### Zkratky:

**výchozí režim:**
- shift + space: přepnout na "příkazový režim"

**příkazový režim:**
- t: otevřít terminál
- k: zabít aktuální program
- w: režim pracovního prostoru
- r: restartovat i3wm (použijte po úpravě konfigurace)
- q: vrátit se do "výchozího režimu"

**režim pracovního prostoru:**
- a/s/d/f/g: přepnout na pracovní prostor 1/2/3/4/5
- q: vrátit se do "příkazového režimu"

Pro úpravu konfigurace správce oken i3 budete primárně pracovat s souborem `~/.config/i3/config` (nebo `~/.i3/config`).
