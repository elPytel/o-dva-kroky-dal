---
layout: post
title:  "Signal v nativních Konverzacích na N900"
author: "Jarda"
description: "Experiment: Signal jako běžný účet v systémových Konverzacích Nokie N900. Rust démon nad knihovnou presage a plugin pro libpurple."
categories:
    - n900
    - Claude
tags:
    - Maemo
    - Signal
    - Rust
    - experiment
---

- [Co jsem chtěl](#co-jsem-chtěl)
- [Jak N900 zachází s chatovacími účty](#jak-n900-zachází-s-chatovacími-účty)
- [Krok 0: zkouška s echo protokolem](#krok-0-zkouška-s-echo-protokolem)
- [Krok 1: signal-bridge](#krok-1-signal-bridge)
- [Krok 2: plugin libsignal-purple](#krok-2-plugin-libsignal-purple)
- [První test v Konverzacích](#první-test-v-konverzacích)
- [Co neumí a co je pro mě riziko](#co-neumí-a-co-je-pro-mě-riziko)

{: .warning}
> **Tohle je experiment.** Signal oficiálně nemá klient pro N900 a to, co tu popisuju, je neoficiální a vyzkoušené jen na jednom telefonu a jednom účtu. Používám to opatrně a nic z toho nedoporučuju jako náhradu oficiální aplikace.

## Co jsem chtěl

Terminálový klient pro Signal už na N900 běží (`gurk`, o něm níž), ale mě lákalo víc: **sjednotit chat na jedno místo**. N900 má systémové Konverzace (to, co vidíte po klepnutí na zprávy), kde se mísí SMS, Jabber nebo *RIP: Skype* . Chtěl jsem, aby tam byl i Signal jako další účet, který se přidá v Nastavení, a kontakty a vlákna vypadaly stejně jako ostatní.

## Jak N900 zachází s chatovacími účty

Maemo 5 používá **Telepathy**: Mission Control spravuje účty a Konverzace s nimi mluví přes „spojovací manažery“. Důležité pro mě je `telepathy-haze` 0.3.2, což je most, který z libovolného pluginu pro **libpurple** (knihovna z Pidginu) udělá protokol Telepathy. V systému je libpurple i Pidgin 2.7.7. Takže pokud napíšu plugin pro libpurple, Konverzace ho uvidí.

Nový protokol potřebuje čtyři věci:

1. soubor pluginu `.so` v `/usr/lib/purple-2/`,
2. blok `[Protocol x]` v `/usr/share/telepathy/managers/haze.manager`,
3. profil účtu v `/usr/share/osso-rtcom/x.profile` (kopie existujícího, třeba ICQ, kde je `Manager=haze`),
4. ikonu v `/usr/share/icons/hicolor/48x48/hildon/`.

Mission Control čte manažery při startu, takže po instalaci je potřeba restart telefonu.

## Krok 0: zkouška s echo protokolem

Než psát celý Signal, chtěl jsem ověřit, že tenhle mechanismus vůbec funguje. Nechal jsem Claude napsat nejjednodušší možný protokol: **echo**. Účet „Echo (test)“ má jediný kontakt `echo-bot` a každou zprávu vrátí s předponou `Echo:`. Balíček `purple-echo` nainstaluje ty čtyři věci. Po restartu telefonu se účet objevil v Nastavení a chat s botem v Konverzacích fungoval. To byl důkaz, že cesta existuje a zbytek je „jen“ kotel další práce pro Claude.

![echo bot]({{ site.baseurl }}/assets/n900/echo bot.png)
*echo bot*

## Krok 1: signal-bridge

Claude:

Signal má složitý protokol a nechci ho psát v C do pluginu. Proto je plugin tenký a nemluví se Signalem sám. Mluví přes **unixový socket** s mým démonem `signal-bridge`, který je napsaný v **Rustu** nad knihovnou **presage** (stejná, na které stojí klient gurk). Démon se připojuje jako propojené zařízení k účtu, který už jsem do gurku přihlásil, takže nový QR kód nepotřebuju.

- Úložiště účtu (kontakty, klíče, zprávy) je šifrovaná databáze **sqlcipher**. Otevření na telefonu trvá asi **13 sekund** na každé spojení.
- Signal dovolí **jedno spojení na propojené zařízení**: gurk a bridge nesmí běžet zároveň.
- Komunikace je jednoduchý řádkový protokol (pole oddělená tabulátory): příkazy `SEND`, `CONTACTS`, `HISTORY`, `PING` a odpovědi `READY`, `CONTACT`, `MSG`, `SENT`, `OK`, `ERR`. Socket je v adresáři s právy 700 a má práva 600.
- **Bezpečnostní pojistka `--allow`:** protože je to můj osobní účet, bridge odešle zprávu jen kontaktům v seznamu povolených. Pro zkoušky jsem povolil jen kontakt **„Poznámka sobě“ (Note to Self)**. Test odeslání i příjmu jsem dělal jen tam.

Překlad je statická binárka pro musl (stejným postupem jako ripgrep) a má asi 6,5 MB. O tom jsem psal v článku o Rustu a Go.

## Krok 2: plugin libsignal-purple

Plugin je malý program v C (asi 18 kB). Funguje takhle:

- Při přihlášení se připojí k socketu. Pokud tam démon neběží, **spustí ho** sám (`signal-bridge-start`) a čeká.
- Kontakty se stanou „buddy“: jméno je UUID, ale zobrazí se přezdívka. Moje vlastní vlákno je „(Note to Self)“.
- Příchozí zprávy se předají Konverzacím (`serv_got_im`). Zprávy, které napíšu na hlavním telefonu, se ukážou jako odeslané.
- Po přihlášení si plugin vyžádá zprávy, které bridge přijal, když nebyl připojený žádný klient. Bridge je ukládá do databáze, takže se neztratí.
- Když se spojení nezdaří do dvou minut, ohlásí chybu místo věčného „Connecting“.

Zabalil jsem ho do balíčku `libsignal-purple`, který přidá potřebné čtyři věci (včetně bubliny jako ikony), a závisí na `signal-bridge`. Pro libpurple 2.7.7 jsem musel zkontrolovat všech 28 použitých symbolů proti knihovně na telefonu, protože plugin se s libpurple nelinkuje, symboly se řeší až při načtení.

## První test v Konverzacích

Po instalaci a restartu telefonu se Signal objevil mezi účty v Konverzacích, ale **při přihlášení se zasekl**. Zkusil jsem to proto v Pidginu: ten napoprvé spadl, a když jsem v něm účet Signal přidal, po chvíli čekání se objevil kontakt **„Note to Self“**. První zpráva neodešla, protože telefon neměl wifi. Po připojení jsem poslal novou zprávu a **dorazila**, takže bridge i plugin spolu fungují.

Zaseknutí v Konverzacích se vysvětluje tím, že plugin hlásil „připojeno“ až poté, co démon otevřel šifrovanou databázi a spojil se se Signalem (kolem minuty), a bez sítě se to nedokončilo vůbec. Plugin pak zůstal ve stavu „Connecting“ bez chyby. To jsem opravil časovým limitem 120 s, po kterém ohlásí chybu. Opravu zatím nemám otestovanou v samotných Konverzacích, protože k tomu je potřeba restart telefonu. Pád Pidginu při prvním spuštění jsem nevysvětlil.

**Historie starých zpráv se nezobrazuje.** Kontakty se synchronizují, ale Signal propojenému zařízení starou historii neposílá. Bridge ukládá jen to, co přijal, když běžel, a plugin po prvním přihlášení ukáže jen zprávy novější než první přihlášení. Historie se tedy bude plnit od teď. V gurku mám sice starší data, ale jsou v jiné šifrované databázi a import jsem zatím neudělal.

## Co neumí a co je pro mě riziko

- Chybí **skupiny** (jejich zprávy bridge zahazuje, protože nezná sender key), **přílohy**, psaní a potvrzení o přečtení a **nové kontakty podle čísla**.
- První připojení trvá kolem minuty, protože se otevírá šifrovaná databáze.
- Je to neoficiální klient na osobním účtu. Používám ho jen pro testování a nikomu nedoporučuju spoléhat se na něj.
- Před každou instalací počítám s restartem telefonu (Mission Control čte soubory při startu). Odinstalace `dpkg -r libsignal-purple` změnu v `haze.manager` zase vrátí.

Zdroje: [signal-bridge](https://github.com/n900-resurrection/signal-bridge), [libsignal-purple](https://github.com/n900-resurrection/libsignal-purple). Plán a poznámky jsou v dokumentaci projektu (`DOC/signal-native.md`).
