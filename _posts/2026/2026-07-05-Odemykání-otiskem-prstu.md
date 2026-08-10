---
layout: post
title:  "Čtečka otisku prstu a Ubuntu"
author: "Jarda"
description: Používání čtečky otisku prstu na Ubuntu
categories: 
    - linux
tags: 
    - Ubuntu
thumbnail: /assets/pc/ctecka_otisku_prstu_sudo.png
---

Pokud máte notebook s čtečkou otisku prstu, můžete si ji nastavit pro odemykání počítače. Stačí mít nainstalovaný balíček `fprintd` a zkontrolovat, zda je váš model podporován. Nevýhoda na kterou brzo narazíte je ta, že čtečka je podporována jen pro odemykání počítače a ale nedoekne vám klíčenku s hesly. To znamená, že při prvním přihlášení do systému po použití otisku zadáte stejně ještě heslo a tím se odemkne klíčenka. Což samo o sobě trochu postrádá komfort čtečky otisku prstu.

```bash
sudo apt install fprintd libpam-fprintd
```

Jednoduché řešení může být smazání hesla z klíčenky a používat jen otisk. To je ale bezpečnostní riziko.

Pokud se vám tedy nechce dešifrovat klíčenku, dává smysl otisk používat tam, kde klíčenka nehraje roli, tedy například při probuzení uspaného notebooku nebo v terminálu při zadávání sudo. Používání otisku pro sudo v konfiguraci s Sysadmin mindsetem vyloženě potěší.

Při zapnutí PC sice zadáte heslo (tím se odemkne klíčenka), ale po zbytek dne už na klávesnici pro autorizaci nesáhnete.

Pro povolení otisku v terminálu pro sudo stačí spustit:

```bash
sudo pam-auth-update
```

![autorizace sudo]({{ site.baseurl }}/assets/pc/ctecka_otisku_prstu_sudo.png)
*autorizace sudo*

Nyní při použití příkazu sudo vás terminal automaticky vyzve k přiložení prstu na čtečku a po úspěšném ověření se příkaz provede.