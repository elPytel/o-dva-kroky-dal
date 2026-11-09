---
layout: post
title:  "Apt repozitář pro N900 na GitHub Pages"
author: "Jarda"
description: Vlastní apt repozitář s nově přeloženými programy pro Maemo 5, jak ho přidat do telefonu a proč je potřeba balíček apt-transport-curl.
categories:
    - n900
    - Claude
tags:
    - Maemo
    - apt
    - GitHub Pages
thumbnail: /assets/n900/n900 apt tui.png
---

- [Proč vlastní repozitář](#proč-vlastní-repozitář)
- [Jak repozitář vypadá](#jak-repozitář-vypadá)
- [Přidání do telefonu](#přidání-do-telefonu)
- [HTTPS a apt-transport-curl](#https-a-apt-transport-curl)
- [Co zatím nefunguje](#co-zatím-nefunguje)
- [apt-n900: přívětivější příkaz apt](#apt-n900-přívětivější-příkaz-apt)
- [Co z toho plyne](#co-z-toho-plyne)

Nokia N900 používá klasický `apt` z Debianu, takže programy se na ni instalují stejně jako na každý Linux. Jenže servery Nokie zmizely a komunitní repozitáře (Extras) jsou dávno zamrzlé. Aby programy, které pro N900 překládám (`htop 3`, `tmux`, `ripgrep`, `mutt`, `Signal` a další), nemusel nikdo stahovat ručně, postavil jsem si vlastní apt repozitář. Běží na GitHub Pages, takže mě nestojí nic a kdokoli si ho může forknout.

## Proč vlastní repozitář

- Aktualizace se dají nainstalovat jedním příkazem (`apt-get upgrade`), ne ručním stahováním `.deb`.
- Verze jsou dohledatelné: v repozitáři zůstávají i starší verze každého balíčku, takže se jde vrátit (`apt-get install nazev=verze`).
- Zdrojové skripty jsou v gitu, takže je vidět, odkud balíček pochází a jak se postavil.

## Jak repozitář vypadá

Je to obyčejný adresář s tímto rozložením:

```
n900-repository/
├── pool/main/<balíček>/<balíček>_<verze>_armel.deb
└── dists/fremantle/
    ├── Release                          (součty MD5, SHA1 a SHA256)
    └── main/binary-armel/Packages.gz
```

Generuje ho skript `scripts/mkrepo.sh`, který spouští `make repo`. Pro každý balíček je jedna složka, kde jsou všechny jeho verze. Adresář `pool/` se mezi sestaveními **zachovává**: nový `.deb` se jen přidá a znovu se vytvoří `dists/` (příkaz `dpkg-scanpackages -m` vypíše všechny verze a `apt` nainstaluje nejvyšší). Starý `apt` na telefonu čte jen `Packages.gz` (ne `xz`) a zná jen MD5 a SHA1, proto `Release` obsahuje všechny tři součty.

Verze balíčku odpovídá upstreamu plus příponě (například `3.5.3-1maemo1`). Když chci, aby aktualizaci uživatelé viděli, zvýším `REV`.

## Přidání do telefonu

Do souboru `/etc/apt/sources.list.d/n900.list` stačí jeden řádek:

```
deb https://n900-resurrection.github.io/n900-repository fremantle main
```

a potom, v terminálu:

```bash
sudo apt-get update
sudo apt-get install htop3
```

![apt-get]({{ site.baseurl }}/assets/n900/n900 apt-get.png)
*apt-get*

Jenže jednoduché to není, protože odkaz začíná na `https`.

## HTTPS a apt-transport-curl

Apt na N900 (verze 0.7.20) stahuje přes `https://` vlastní metodou, která používá starou knihovnu libcurl s OpenSSL 0.9.8. Ta umí jen **TLS 1.0**, a GitHub (včetně Pages) ho už nepřijímá. Výsledek je hláška `tlsv1 alert protocol version`.

Řešení jsem našel v tom, že apt si metody stahování spouští jako externí programy. Napsal jsem balíček `apt-transport-curl`, který místo původní metody `/usr/lib/apt/methods/https` nainstaluje krátký skript v bashi. Ten zavolá `curl` 8 (s TLS 1.2 a 1.3) a výsledek předá aptu. Původní metodu přesune `dpkg-divert` do souboru `https.distrib`, a když balíček odstraním, vrátí se zpátky. Apt ani Application Manager se vůbec nemusí měnit.

Skript komunikuje s aptem přes stdin a stdout (`100 Capabilities`, `600 URI Acquire`, `201 URI Done` a další). Při ladění jsem narazil na dvě zvláštnosti starého aptu:

- když metoda odpoví okamžitě, apt první zprávu nikdy nepřečte a zasekne se. Skript proto počká 0,2 s před úvodní zprávou,
- každá zpráva musí přijít jedním zápisem.

Certifikáty se vždy ověřují (výchozí je svazek certifikátů z balíčku `curl`). Volbu `Verify-Peer` záměrně ignoruju, protože telefon má v `/etc/apt/apt.conf.d` nastavené `Verify-Peer "false"` a certifikáty by se tak potichu přestaly kontrolovat. Pro ladění slouží `APT_CURL_DEBUG=/tmp/log apt-get update`.

**První instalace (bootstrap)** se dělá ručně: `apt-transport-curl` potřebuje `curl` a systémový balíček `apt-transport-https`. Oba `.deb` (curl a apt-transport-curl) si stáhnu na PC z adresáře `pool/main/…` v repozitáři, zkopíruju je na telefon (`scp`) a nainstaluji `dpkg -i`. Pak už funguje i HTTPS repozitář. Alternativa je dočasně použít adresu přes HTTP.

## Co zatím nefunguje

- **Application Manager se na mém telefonu zasekává** při obnovování seznamů i při přípravě instalace („Preparing installation, please wait“, `apt-worker` nečinný, zámek dpkg držený, nic se nenainstaluje). Instalace proto dělám přes `apt-get` v terminálu. `apt-get update && apt-get upgrade` funguje spolehlivě. Příčinu zatím hledám.
- **Repozitář není podepsaný.** `Release.gpg` chybí, takže apt vypíše `Ign … Release.gpg` a k instalaci chce `--force-yes`. Podpis je na seznamu úkolů.
- **Pozor na součty v indexu.** Všechny soubory jsou ověřitelné podle součtů v `Packages`, ale bez podpisu `Release` je toho zabezpečení méně, než by mělo být. Kdo chce být opatrný, ať instaluje jen to, co si pročetl.

Katalog se dá přidat i do Application Manageru souborem `n900-repository.install` (sekce `[install]` s `catalogues` a `package`), ale protože Application Manager zatím visí, nedoporučuju na něj spoléhat.

## apt-n900: přívětivější příkaz apt

Starý `apt-get` je funkční, ale nepohodlný. Proto jsem napsal malý skript `apt-n900` (je to POSIX shell nad `apt-get`, `apt-cache` a `dpkg-query`, nic ze systému nenahrazuje) a dal mu jméno `apt`:

```bash
apt update
apt list --upgradable        # balíčky s novější verzí
apt list --installed [slovo]
apt upgrade                  # a apt full-upgrade pro dist-upgrade
apt install|remove|purge|autoremove|clean ...
apt search|show|policy ...
apt files BALÍČEK            # soubory nainstalovaného balíčku
apt owns SOUBOR              # kterému balíčku patří soubor
apt tui                      # textové menu
```

Příkazy, které mění systém, používají `sudo`, když nejsem root. Doporučuju vyzkoušet `apt tui`: je to menu postavené na `dialog` (**Upgrade** jako seznam zaškrtávacích políček, **hledání a instalace**, **nainstalované balíčky** a **aktualizace seznamů**). Každá změna se nejdřív ukáže jako simulace (`apt-get -s`) a čeká na potvrzení a výstup aptu je vidět rovnou. Okna se přizpůsobí velikosti terminálu (80×24 s vysunutou klávesnicí).

![apt-get]({{ site.baseurl }}/assets/n900/n900 apt tui.png)
*apt tui*

Aby se dalo vůbec poznat, co se vyplatí překládat znovu, mám v projektu příkaz `make updates`. Projde všechny aplikace, zjistí jejich upstream (GitHub, GitLab, crates.io, PyPI a další), porovná použitou verzi s nejnovější a vypíše přehlednou tabulku. Slouží jako „to-do“ pro nové verze.

## Co z toho plyne

Apt repozitář na GitHub Pages je nejlevnější způsob, jak programy pro starý telefon udržovat. Limit je zhruba 1 GB (velikost Pages), a ten bude jednou potřeba hlídat. Zdrojové skripty jsou v samostatných repozitářích pod [n900-resurrection](https://github.com/n900-resurrection) a repozitář běží na `https://n900-resurrection.github.io/n900-repository`.

Žádný z repozitářů Nokie už neběží a komunitní zrcadla jsou jen kopie z roku 2017. Jak to řešit do budoucna, je námět na samostatný článek.
