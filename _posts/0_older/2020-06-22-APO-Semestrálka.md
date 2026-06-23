---
layout: post
title:  "APO Semestrálka"
author: "Jarda"
description: Semestrální práce z předmětu APO
categories: 
    - FEL
    - Github
tags: 
    - KYR
    - APO
thumbnail: https://github.com/elPytel/Die-Kurve/raw/main/assets/dieKurve.png
---

# APO - Architektura počítačů

Pro hru jsem vytvořil repo na GitHubu: [Die Kurve](https://github.com/elPytel/Die-Kurve) a také jednoduchý Makefile, který umožňuje kompilaci a spuštění hry na PC.

- [APO - Architektura počítačů](#apo---architektura-počítačů)
  - [Achtung die Kurve!](#achtung-die-kurve)
  - [22.6. 2026](#226-2026)

## Achtung die Kurve!
Jde o implementaci hry Achtung die Kurve! v jazyce C pro školní vývojovou desku. Součástí implementace je emulace na PC, kde je možné hru ovládat klávesnicí.

![](https://github.com/elPytel/Die-Kurve/raw/main/assets/dieKurve.png){: .small .left }
*Logo hry Achtung die Kurve!*

Obrázek jsem nakreslil s pomocí stylusu na ThinkPad X220t. 

Aby bylo možné hrutestovat bez vývojové desky, ke které jsem se v té době nemohl dostat (byl covid a já se přestěhoval z Prahy zpátky do Liberce), vytvořil jsem jednoduchou emulaci, která umožňuje spustit hru na PC.

Pomocí kláves DF a JK se ovládají otočné knoflíky, na které je hra původně navržena.

A tak stačí na počítači zadat příkaz a hra se spustí:

```bash
make run
```

## 22.6. 2026

Upravil jsem strukturu repozitáře.

Přidal jsem generování dokumentace pomocí Doxygenu, která se přes Github Actions automaticky generuje a je dostupná na adrese: [Die-Kurve](https://elPytel.github.io/Die-Kurve/).

TODO:
- [ ] Přidat dokumentaci k jednotlivým funkcím
- [ ] Opravit emulator, aby se správně spouštěl na Linuxu a nezamrznul
- [ ] Přidat škálování okna, aby se hra dala hrát i na větších obrazovkách
- [ ] alternativní ovládání pro PC (např. WSAD)