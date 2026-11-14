---
layout: post
title:  "Bluetooth klávesnice na N900: den zápasu s Shiftem"
author: "Jarda"
description: "Jak se N900 naučila psát na externí Bluetooth klávesnici: vypnutý HID plugin, párování s vlastním agentem, Shift, který nikdy nedorazil, a mapa kláves, kterou jsem omylem rozbil i na vestavěné klávesnici."
categories:
    - n900
    - Claude
tags:
    - Maemo
    - Bluetooth
    - X11
    - klávesnice
    - experiment
thumbnail: /assets/Bluetooth_logo.png
---

- [Co jsem chtěl](#co-jsem-chtěl)
- [Párování, které nikam nevedlo](#párování-které-nikam-nevedlo)
- [PIN, který nikdo nezadal](#pin-který-nikdo-nezadal)
- [Připojeno, ale Shift nefunguje](#připojeno-ale-shift-nefunguje)
- [Kombinované zařízení](#kombinované-zařízení)
- [Moje chyba: sdílená mapa kláves](#moje-chyba-sdílená-mapa-kláves)
- [České rozložení v uživatelském prostoru](#české-rozložení-v-uživatelském-prostoru)
- [Jak to funguje teď](#jak-to-funguje-teď)

{: .warning}
> **Tohle je experiment.** Na telefonu se mění systémový soubor (`/etc/bluetooth/main.conf`), načítají se moduly jádra a běží vlastní proces, který bere vstup klávesnice. Všechno jde vrátit zpět (tabulka dole), ale zkoušel jsem to jen na jednom telefonu a jedné klávesnici.

## Co jsem chtěl

Psát na N900 na normální klávesnici. Vestavěná je skvělá na SMS, ale ssh, terminál nebo úprava souborů s ní bolí. Mám Bluetooth klávesnici od Thinkpadu (česká s TrackPointem) a N900 má Bluetooth. Co by na tom mohlo být?

Spoiler: spárování zabere pět minut, **normální psaní** několik hodin. Níž je celý příběh včetně toho, kde jsem udělal chybu, a na konci skripty, které to celé zopakují jedním příkazem.

## Párování, které nikam nevedlo

Telefon klávesnici našel a začal párovat, pak se nestalo nic. Vypadalo to, že klávesnice je „spárovaná“, ale nepřipojená a nic nepsala.

Dvě věci, které je dobré vědět:

- V `/etc/bluetooth/main.conf` je na N900 `DisablePlugins = network,input,hal`. Plugin `input` je právě HID, tedy klávesnice a myši. Telefon se spáruje, ale HID kanál nikdy neotevře.
- Moduly jádra `hid` a `hidp` v systému existují, jen se nenačítají.

Oprava je krátká: `modprobe hid hidp`, z `DisablePlugins` odebrat `input` (originál si zálohuju) a `bluetoothd` restartovat. Na tomhle upstartu není příkaz `restart`, takže `initctl stop` a pak `initctl start`.

## PIN, který nikdo nezadal

Po téhle opravě se na displeji objevilo okno „Zadejte PIN“, ale ať jsem zadal cokoliv, klávesnice se nepřipojila. Důvod: **starý klávesnicový PIN se zadává dvakrát**. Telefon dostane PIN do pole a stejné číslo musí někdo napsat na klávesnici a potvrdit Enterem, a to během pár sekund. Systémový dialog na to není stavěný.

Napsal jsem proto vlastní „agenta“ pro BlueZ, malý skript v Pythonu 2.5 (to je systémový Python telefonu, který má `dbus`). Zahodí starý nefunkční záznam o klávesnici, odpoví na žádost o PIN pevným `0000`, a ve chvíli, kdy ho telefon pošle, napíšu `0000` + Enter na klávesnici. Pak klávesnici označí za důvěryhodnou a zavolá `Input.Connect`. V seznamu vstupních zařízení se objevila **ThinkPad Keyboard**.

## Připojeno, ale Shift nefunguje

Teď přišly na řadu detaily. Co jsem při prvním psaní viděl:

- fungují písmena a šipky,
- **nejdou velká písmena** (Shift nic nedělá),
- bez diakritiky (AltGr nic nedělá),
- Z a Y jsou prohozené (česká klávesnice, americká mapa),
- nejde držet Backspace pro mazání,
- Tab a Enter jsou nespolehlivé.

Nejdřív jsem zkusil to, co se zdálo logické: napsat českou mapu kláves a nahrát ji jen pro tuhle klávesnici. Písmena se opravila, háčky a čárky přišly. **Shift ne.** Další hodina šla do měření.

Naměřil jsem, že X server klávesu Shift doručí (`Shift_L`, správný keycode), ale **modifikátor se nenastaví**: stav Shiftu je nula, i když ho držím. Pomohlo zeptat se serveru přímo (`XkbGetState`) na stav jednotlivých zařízení: u klávesnice Shift svítil, u hlavního „Virtual core keyboard“, ze kterého čtou aplikace, nikdy.

## Kombinované zařízení

U vestavěné klávesnice telefonu se stav hlavní klávesnice mění správně. U Thinkpadu ne. Rozdíl: ThinkPad je **kombinované zařízení**, klávesnice a TrackPoint v jednom. X server 1.6.99, který je na N900, takové zařízení zjevně špatně propisuje.

Řešení je trochu neobvyklé: zařízení **rozdělit**. Napsal jsem malý démon (`btkbd-split.py`), který klávesnici převezme (`EVIOCGRAB`) a události přeposílá do dvou nových zařízení přes `uinput`: jedno je čistá klávesnice, druhé čistá myš. A najednou funguje Shift, Ctrl i opakování kláves.

Jeden detail, který mě stál půl hodiny: `uinput` v jádře 2.6.28 přijímá **přesně jednu událost na jedno `write()`**. Všechno ostatní vrací `EINVAL` a démon po pár vteřinách spadne bez jakékoli užitečné hlášky.

## Moje chyba: sdílená mapa kláves

Mezitím jsem udělal chybu, která stojí za zmínku. České rozložení jsem nahrál příkazem `xkbcomp -i <zařízení>`, v domnění, že mění mapu jen pro tu jednu klávesnici. **Neměnil.** Mapa kláves je v tomhle X serveru **jedna pro všechny klávesnice**. Rozbil jsem tím i vestavěnou klávesnici: Enter přestal fungovat bez Ctrl a změnil se Ctrl.

Poznal jsem to, až když jsem zjistil, že **Enter na vestavěné klávesnici funguje taky jenom s Ctrl**. Výpis map všech zařízení pak ukázal, že jsou všechna tři stejná, a všechna moje. Původní mapu jsem vrátil příkazem `setxkbmap` s původními komponentami (zapsal jsem si je na začátku z `setxkbmap -print`) a Enter byl zpátky.

Poučení: **do sdílené mapy nikdy nepsat „jen pro jednu klávesnici“**. Šlo to jen přidáním nových, nepoužívaných kódů kláves.

## České rozložení v uživatelském prostoru

Když rozložení nejde dát do mapy, dá se **přeložit dřív**: rozdělovač je už mezi klávesnicí a X, takže překládá kódy kláves:

- Z a Y se prohodí,
- česká horní řada (`ě š č ř ž ý á í é`, s Shiftem číslice), `ú ů § ¨`, čárka, tečka, pomlčka a AltGr znaky (`\ | € # & @ { }`) se pošlou jako **volné kódy kláves** (od Linuxového kódu 183, tedy F13 a dál), kterým do X mapy **přidám** symboly. Vestavěná klávesnice žádný z nich nepoužívá, takže se jí to nijak nedotkne,
- pravý Shift a pravý Ctrl se změní na levé,
- **Caps Lock řeší rozdělovač sám**, protože písmena v mapě telefonu zámek z X ignorují.

Na ověření, co aplikace opravdu dostává, jsem napsal testovací okno (Python 3 přes moje `hildonlite`), které po každé klávese ukáže její název, `state` a keycode. Díky němu jsem viděl, že klávesy do aplikace opravdu dorazí (Enter jako `Return`), a ukázalo se, kde se ztrácely. Taky jsem si na něm ověřil, že špatný `state` (`0x2` je zapnutý Caps Lock) jsem nejdřív považoval za příčinu potíží s Enterem, ale nebyla to ona. Nakonec za to mohla ta sdílená mapa výše.

## Jak to funguje teď

Funguje psaní včetně Shiftu, Caps Locku, AltGr a Ctrl, české znaky, opakování kláves, šipky, Delete a Tab. Nefunguje PgUp a PgDn v terminálu (`osso-xterm`): X je doručuje správně, jen je terminál nepoužije.

Celý postup je ve skriptu, který běží z počítače přes ssh:

```bash
scripts/bt-keyboard/bt-keyboard.sh setup          # moduly, plugin input, nástroje
scripts/bt-keyboard/bt-keyboard.sh pair ADRESA    # jen pro novou klávesnici
scripts/bt-keyboard/bt-keyboard.sh start          # rozdělení, české rozložení, opakování
```

Po restartu telefonu stačí `setup` a `start`. Co zůstalo změněné:

| změna | kde | návrat |
|---|---|---|
| plugin `input` povolen | `/etc/bluetooth/main.conf` | záloha `main.conf.orig` |
| moduly `hid` a `hidp` | jádro, do restartu | `rmmod hidp hid` |
| spárování klávesnice | `/var/lib/bluetooth` | Nastavení › Bluetooth |
| rozdělovač a nové klávesy | proces, paměť X serveru | `bt-keyboard.sh stop` |

Zatím **není trvalé**: načítání modulů při startu a automatické spuštění rozdělovače po připojení klávesnice. Rád bych je udělal jako upstart job, ale zasahuje to do systému, tak s tím ještě počkám.

Všechno je v repozitáři projektu ([github.com/elPytel/N900](https://github.com/elPytel/N900)) ve složce `scripts/bt-keyboard/` a podrobný popis příčin a diagnostiky v `DOC/bluetooth-keyboard.md`.

