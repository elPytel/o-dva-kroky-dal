---
layout: post
title: "Nápady k rozšíření webových nástrojů"
description: Sbírka nápadů na nové webové nástroje
categories: ["javascript", "web"]
thumbnail: https://raw.githubusercontent.com/elPytel/web-tools/refs/heads/main/src/assets/WebTools_v2.png
---
# Nápady k rozšíření webových nástrojů 💡

> [!tip] "Crypto & Code Playground"
> *Interaktivní webové ukázky šifer, kódování a algoritmů (HTML+JS, žádný server).*

- [Nápady k rozšíření webových nástrojů 💡](#nápady-k-rozšíření-webových-nástrojů-)
  - [🔢 Datové typy](#-datové-typy)
  - [⏱️ Práce s časem](#️-práce-s-časem)
  - [🧮 Kódování a převody](#-kódování-a-převody)
    - [📦 Bezdrátová komprese:](#-bezdrátová-komprese)
    - [🛠️ Opravné kódy:](#️-opravné-kódy)
    - [🎨 Kódování barev a obrazových dat](#-kódování-barev-a-obrazových-dat)
    - [📐 Vektorové oprace](#-vektorové-oprace)
  - [🔐 Kryptografie a šifry](#-kryptografie-a-šifry)
    - [🪶 Kód Navajo](#-kód-navajo)
    - [🔁 Substituční šifry](#-substituční-šifry)
      - [👑 Caesarova šifra](#-caesarova-šifra)
      - [🪞 Atbash](#-atbash)
      - [📐 Affine cipher](#-affine-cipher)
    - [🔀 Transpoziční šifra](#-transpoziční-šifra)
    - [🔑 Vigenèrova šifra](#-vigenèrova-šifra)
    - [🔒 Výpočet složitosti hesla](#-výpočet-složitosti-hesla)
    - [🌈 Rainbow tables](#-rainbow-tables)
    - [🔐 RSA mini demo](#-rsa-mini-demo)
    - [🔏 Předávání zakodovaných zpráv](#-předávání-zakodovaných-zpráv)
    - [✒️ Podepisování zpráv pomocí digitálního podpisu](#️-podepisování-zpráv-pomocí-digitálního-podpisu)
    - [🎣 Phishing](#-phishing)
    - [🎯 Spear phishing](#-spear-phishing)
    - [📶 Wifi](#-wifi)
  - [📡 Signály](#-signály)
    - [🔊 Audio:](#-audio)
      - [🎹 MIDI přehrávač:](#-midi-přehrávač)
      - [🎼 MIDI úprava notového zápisu:](#-midi-úprava-notového-zápisu)
    - [🎧 Základní audio efekty:](#-základní-audio-efekty)
    - [📡 Modulace signálu](#-modulace-signálu)
  - [🧪 Chemie](#-chemie)
  - [🎮 Hry](#-hry)
  - [Zdroje](#zdroje)

## 🔢 Datové typy
Datové typy:
- Int
- Float

Reprezentace, výpočet, binární podoba.
Možnost ukládání v paměti (grafy) int.

## ⏱️ Práce s časem
Práce s časem:
- Aktuální čas 
- Stopky
- Odpočet, Ala pomodoro
- Délka práce (kalkulačka)

## 🧮 Kódování a převody

Zaměřené na znaky, čísla a datové formáty.

| Název                          | Popis                                                              | Obtížnost |
| ------------------------------ | ------------------------------------------------------------------ | --------- |
| 🧾 HEXdump                        | zobrazí hex hodnoty souboru nebo textu                             | 🟢        |
| Checksum / Hash ukázka         | spočítá SHA-1 / SHA-256 hash a ukáže rozdíl po změně znaku         | 🟡        |
| Generátor a ověřovač kontrolních součtů (např. rodné číslo, IBAN) | reálné využití mod 11 a jiných pravidel         | 🟡        |
| QR Encoder                     | z textu vygeneruje QR kód (pomocí JS knihovny `qrcode.js`)         | 🟡        |

Kódování úlohy co jsme dělali s Chaloupkou pro komprimaci.
VCard do qr code pro generování vizitek.

### 📦 Bezdrátová komprese:
- RLE
- LZW
- Huffmanovo kódování

### 🛠️ Opravné kódy:
Parita
RAID 0,1,5 ukázka

🗄️RAID:
- Demonstrace stripování dat v RAID
- Text -> ascii -> bin, ukládání na "discích"
- Použití parity pro výpočet chybějící informace na jednom disku (nahrání do hot spare)

### 🎨 Kódování barev a obrazových dat

Obraz a barvy:
- Paleta barev
- RGB složka obrazu
- YUV složka obrazu
- Ukládání dat do bmp

### 📐 Vektorové oprace

Matice:
- škálování
- rotace
- translace

Udělej si hodiny. Skládání transformací.

## 🔐 Kryptografie a šifry

| Název                | Popis                                                                                | Obtížnost |
| -------------------- | ------------------------------------------------------------------------------------ | --------- |
| Caesarova šifra      | jednoduché posunutí písmen o pevný počet míst                                        | 🟢        |
| Atbash               | jednoduché zrcadlení abecedy (A↔Z, B↔Y…)                                             | 🟢        |
| ROT13 / ROT47          | jednoduchá obměna Caesarovy šifry pro ASCII        | 🟢        |
| Pig Latin / švachština | jazyková transformace textu                        | 🟢        |
| Textový analyzátor     | spočítá počet slov, znaků, frekvence písmen        | 🟡        |
| Vigenèrova šifra     | zadáš klíčové slovo, provádí posuny jako Caesar, ale podle klíče. Generování kroků.  | 🟡        |
| Transpoziční šifra   | ukazuje, jak se písmena přesouvají v textu podle klíče                               | 🟡        |
| Modulo aritmetika vizualizátor     | ukáže výsledek (a mod n) jako kruh nebo tabulku | 🟡        |
| Affine Cipher        | ukazuje, jak se písmena mapují lineárně `E(x) = (a*x + b) mod 26`                    | 🟡        |
| One-Time Pad         | vysvětlí princip náhodného klíče a XOR operace                                       | 🟡        |
| Braillovo písmo      | převod textu na Braillovo                                                            | 🟡        |
| RSA mini demo        | ukázka generování malých prvočísel, výpočtu `n, e, d`, a šifrování/dešifrování čísla | 🔴        |

- [rumkin: Ciphers and Codes](https://rumkin.com/tools/cipher/)
- [rumkin: analyze](https://rumkin.com/tools/cipher/analyze/)

### 🪶 Kód Navajo
- [wiki: kód Navajo](https://cs.wikipedia.org/wiki/Kód_Navajo)

### 🔁 Substituční šifry
#### 👑 Caesarova šifra
- jednoduché posunutí písmen o pevný počet míst

#### 🪞 Atbash
- jednoduché zrcadlení abecedy (A↔Z, B↔Y…)

- [rumkin: atbash](https://rumkin.com/tools/cipher/atbash/)

#### 📐 Affine cipher
- Ukazuje, jak se písmena mapují lineárně `E(x) = (a*x + b) mod 26`
- Výběr `a` a `b` s kontrolou, že `a` je nesoudělné s 26.
- Ukázka dešifrování pomocí inverzní funkce.
- Grafické znázornění mapování písmen na kruhu.
- Možnost zadat vlastní text a vidět šifrování/dešifrování v reálném čase.

Jak nastavit `a` a `b`, aby se šifra chovala jako:
- Caesarova šifra: `a = 1`, `b = posun`
- Atbash: `a = 25`, `b = 25` (protože `E(x) = (25*x + 25) mod 26`)

- [rumkin: affine cipher](https://rumkin.com/tools/cipher/affine/)
- [eitca: afinní šifra](https://cs.eitca.org/cybersecurity/eitc-is-ccf-classical-cryptography-fundamentals/history-of-cryptography/modular-arithmetic-and-historical-ciphers/what-is-the-key-space-of-an-affine-cipher/)
### 🔀 Transpoziční šifra

Kombinace s jinými šiframi

Transpozice se často používá **v kombinaci** se substitucí:

1. hrubě text „zamícháme“ transpozicí,
2. výsledný text zašifrujeme např. Caesarovou nebo Vigenèrovou šifrou.

V demo můžeš ukázat volbu:

* `Nejprve Caesar, potom Transpozice`
* `Nejprve Transpozice, potom Caesar`

> [!question]
> Ukažte rozdíl v tom, jak vypadá frekvenční analýza pro:
>
> * samotný Caesar
> * samotnou Transpozici
> * kombinaci Caesar + Transpozice

### 🔑 Vigenèrova šifra
- Zadáš klíčové slovo, provádí posuny jako Caesar, ale podle klíče.
- Generování kroků.
- Ukázka lámání pomocí frekvenční analýzy.

### 🔒 Výpočet složitosti hesla
Generování háhodného bezpečného hesla
- peněženky a autentifikátory

Používej správce hesel (unikátní, náhodná, dlouhá).

Preferuj passphrase (např. 4–5 náhodných slov) → vysoká entropie, dobrá zapamatovatelnost.

Zapni MFA (ideálně TOTP/hardware klíč).

Pravidelně kontroluj úniky (Have I Been Pwned).

### 🌈 Rainbow tables

Lámání hesel
Rainbow slovník
Hledání hesla k hashi.
Možnost přidání soli.

Při datovém úniku z korporátního serveru byla zasažena i databáze s loginy uživatelů. 
Unikly přístupová pravá všech zákazníků v podobě:
email; zahešované heslo; datum registrace

Lze zvolit n řádků z databáze které se mají vygenerovat.

Při generování si člověk může vybrat jaký heshovací algoritmus byl požit při tvorbě hesel (výchozí je MD5).

Při generování náhodných hesel lze zvolit délka a použitá znaková sada.

Aby jste se jako hackeři mohli dostat heslům jednotlivých uživatelů, tak nejdříve musíte prolomit zahešovaná hesla. 

Lámání hesel. Nastavení algoritmu:
- posolený,
- verze hashe,
- tabulka nejčastějších hesel / od nuly

Láme se n hesel najednou. 

"konzole" vypisuje průběh lámání hesel.

Když se podaří heslo najít, tak se podbarví zeleně řádek s uživatelem a vypíše se jeho heslo do systému. 

### 🔐 RSA mini demo

Ukázka generování malých prvočísel, výpočtu `n, e, d`, a šifrování/dešifrování čísla.

🛡️ RSA:
- ukázka generování klíčů a šifrování/dešifrování zprávy pomocí RSA
- demonstrace výpočtu `n, e, d` a jejich použití při šifrování a dešifrování

### 🔏 Předávání zakodovaných zpráv

Předávání zakodovaných zpráv mezi dvěma uživateli pomocí:
- symetrické šifry (AES)
- asymetrické šifry (RSA)

### ✒️ Podepisování zpráv pomocí digitálního podpisu 

Ukázka podepisování zpráv pomocí digitálního podpisu.
- Generování páru klíčů (soukromý a veřejný klíč),
- Generování hashe zprávy,
- Šifrování hashe soukromým klíčem (digitální podpis),
- Ověřování podpisu pomocí veřejného klíče,

### 🎣 Phishing
- ukázka jak funguje phishingový útok
- phishingový email
- phishingová stránka

Kontrola příchozího emailu na podezřelé znaky. Url redirecty. Http hlavičky. Podpisy stránky.

### 🎯 Spear phishing
Sběr informací na na sociálních sítích. Telefonáty, nahrávka hlasu. Syntéza hlasu. Cílený útok na konkrétní osobu.
- deepfake videa.

### 📶 Wifi

Hackování wifi.
Vše (názvy a hesla) se generují procedurálně s časovým seedem.
Zobrazí se n obrázků wifi routerů s různými názvy od "různých výrobců".
Kliknutím si vybereme koho chceme odposlouchávat.
Tlačítko zahájit útok / opakovaný útok.
V textové konzoli vidíme probíhající komunikaci. 
Pokoušíme se rozbít wpa handshake a uhodnout heslo.
Když známe heslo. Tak ho zadáme na připojování k wifi a rozsvítí se kontrolka zeleně.
Přiložené datasheety k AP s výchozími hesly pro Admin.
Po připojení:
Okno "prohlížeče" pod terminálem s komunikací.
Zadáme ip adresu AP. Otevře se nám přihlašovací stránka. Zadáme admina, výchozí heslo. 
Dostaneme přístup do konfigurace AP. -> úspěšný hackarský útok.

Do konzole se vypisuje ASCII art logo aircracku a průběh útoku.

> [!warning]
Toto je **simulovaný** výukový nástroj. Používání obdobných nástrojů na cizí sítě v obdobných "penetračních" je nelegální!


## 📡 Signály

| Název         | Popis                             | Obtížnost |
| ------------- | --------------------------------- | --------- |
| Generátor signálu | generování základních průběhů (sinus, čtverec, pilový), vizualizace: amplituda/fft, vyžší harmonické "hudebních" nástrojů | 🟡        |


Signály:
- Generátor funkcí a audio výstup 
- Grafické znázornění 
- 50Hz - 20kHz
- Nastavení hlasitosti 
- Usměrněná sinusovka.
- Jak se syntetizují hudební nástroje?

### 🔊 Audio:
- mp3 přehrávač

#### 🎹 MIDI přehrávač:

Vzorové soubory midi.
Přehrání midi souboru přes Web Audio API.
Možnost nahrávní vlastního midi souboru.

#### 🎼 MIDI úprava notového zápisu:
- Midi přehrávač a úprava notového zápisu.

Nahrání midi souboru, zobrazení notového zápisu.
Přehrání midi souboru přes Web Audio API.
Možnost úpravy not (výška, délka, přidání/odstranění not).

převod noty → frekvence

- [wiki: MIDI](https://cs.wikipedia.org/wiki/Standard_MIDI_File)
- [bitmidi: files](https://bitmidi.com)
- [midiworld: files](https://www.midiworld.com/files/)

### 🎧 Základní audio efekty:
- Ozvěna
- Konvoluce s impulzní odezvou.

### 📡 Modulace signálu 
- PWM
  - Rotující kolečko, podle nastavení střídy.
- AM
- PSK
- QAM

## 🧪 Chemie
- Kalkulačka na chemii
- Molekulární množství 
- Roztok

## 🎮 Hry
- Sudoku
- Piškvorky

## Zdroje

- [gov: jmena](https://mv.gov.cz/clanek/seznam-rodove-neutralnich-jmen.aspx)