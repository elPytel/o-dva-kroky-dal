---
layout: post
title:  "HTTPS a prohlížeč MicroB na N900"
author: "Jarda"
description: Jak jsem do původního prohlížeče MicroB dostal TLS 1.2 a aktuální certifikáty. Archiv zdrojáků, výměna NSS za novější a co z toho zbylo.
categories:
    - n900
    - Claude
tags:
    - Maemo
    - TLS
    - MicroB
    - prohlížeč
thumbnail: /assets/n900/IDOS v MicroBu.png
---

- [Problém: TLS 1.0 a staré certifikáty](#problém-tls-10-a-staré-certifikáty)
  - [HTTPS všude jinde](#https-všude-jinde)
- [Krok 1: aktuální kořenové certifikáty](#krok-1-aktuální-kořenové-certifikáty)
- [Krok 2: zdrojáky MicroBu](#krok-2-zdrojáky-microbu)
- [Krok 3: výměna NSS](#krok-3-výměna-nss)
- [Šifry: PSM všechno vypne](#šifry-psm-všechno-vypne)
- [Test bez prohlížeče](#test-bez-prohlížeče)
- [Instalace a první pád](#instalace-a-první-pád)
- [Výsledek](#výsledek)
  - [Co se nepodařilo](#co-se-nepodařilo)

Původní prohlížeč Nokie N900 se jmenuje **MicroB** a je to jádro Gecko 1.9.2 z doby Firefoxu 3.6. Stránky se v něm dnes otevírají jen občas. Když se zeptáte na Google, Facebook nebo Seznam, dostanete „SSL error“ nebo „upgrade to TLS 1.2“. Problém není jen v samotném prohlížeči: **celý systém N900 mluví TLS 1.0** a servery tenhle protokol před lety vypnuly. V tomhle článku shrnuju, co jsem s HTTPS na N900 udělal, a hlavně popisuju zákulisí oprav MicroBu.

## Problém: TLS 1.0 a staré certifikáty

MicroB používá knihovnu **NSS 3.12.6** a na ní stojí celé HTTPS. Má dva nedostatky:

1. **Protokol.** NSS 3.12.6 umí nejvýš TLS 1.0. Servery s TLS 1.2 a novějším ho odmítnou.
2. **Certifikáty.** Úložiště kořenových certifikátů je z roku 2010. Chybí asi 117 současných (ISRG Root X1 od Let's Encrypt, DigiCert G2 a G3, GlobalSign R3, USERTrust a další). Systémová doména `common-ca` je jen pro čtení.

### HTTPS všude jinde

Nejdřív jsem opravil všechno ostatní, protože na prohlížeči závisí jen webové stránky:

- **curl** 8 s TLS 1.3 (balíček `curl`) a **git** s HTTPS,
- **apt** přes HTTPS: balíček `apt-transport-curl` nahradí metodu `https` skriptem, který volá curl. Díky tomu funguje GitHub Pages (viz článek o apt repozitáři),
- **Python 3.11** s OpenSSL 3.5, **Go** a **Rust** (každý s vlastním TLS, viz článek o Rustu a Go),
- textový prohlížeč **links 2.30** přes statické OpenSSL 3 (TLS 1.3, certifikáty jsou přibalené).

To všechno běží vedle starých knihoven. Systémové programy a MicroB se nezměnily.

## Krok 1: aktuální kořenové certifikáty

MicroB bere certifikáty přes `libnssckbi.so`, což je ve skutečnosti odkaz na **`libmaemosec_certman`** (správce certifikátů od Nokie). Certifikáty se spravují přes nástroj `cmcli`. Systémová doména `common-ca` (asi 300 certifikátů z roku 2010) je jen pro čtení, ale uživatel má vlastní soukromé domény v `~/.maemosec-certs`, například `ssl-ca`. Balíček **`ca-certs-n900`** tam doplní 118 aktuálních kořenových certifikátů z Mozilly (stejný svazek jako u curl). Systém se nemění a `ca-certs-n900 remove` odstraní přesně ty, které přidal.

Ověřil jsem to nejdřív na vlastní testovací certifikační autoritě: na PC jsem spustil `openssl s_server -tls1` s certifikátem podepsaným vlastní CA, na telefonu `cmcli -v` bez přidané CA hlásí „unable to get local issuer certificate“ a po přidání „Verified OK“. Pak jsem v MicroBu otevřel stránku a **načetla se bez varování o certifikátu**. Skutečný web ověřil `https://tls-v1-0.badssl.com:1010/` (TLS 1.0 s certifikátem od Let's Encrypt): načetla se bez varování.

![MicroB s TLS 1.0 a badssl.com]({{ site.baseurl }}/assets/n900/microb-tls10-badssl.png)
*Screenshot: tls-v1-0.badssl.com v MicroBu*

To pomáhá jen u webů, které ještě povolují TLS 1.0. Pro zbytek bylo potřeba sáhnout hlouběji.

## Krok 2: zdrojáky MicroBu

Servery Nokie už neexistují, ale **Internet Archive** má snímek adresáře `repository.maemo.org/pool/…/microb-engine/` z roku 2020. Našel jsem tam **přesně verzi, kterou má telefon** (`microb-engine 20100401-1.9.2-5.2+0m5`): `.dsc`, `.diff.gz` s Debian patchi a 58 MB `orig.tar.gz` s celým stromem Mozilly 1.9.2. MD5 sedí. Aby se to nemuselo hledat znovu, uložil jsem je do samostatného repozitáře [microb-engine](https://github.com/n900-resurrection/microb-engine) (asi 400 MB rozbaleno).

Rebuild moderního Gecka nedává smysl: potřeboval by novější GTK, glib, kompilátor a víc RAM, než telefon má. Zajímavější je to, co jsem se dozvěděl ze zdrojáků: engine s NSS pracuje přes **veřejné API** a protokoly zapíná jen starými voláními `SSL_OptionSetDefault(SSL_ENABLE_SSL3/TLS, …)`, bez rozsahů verzí.

## Krok 3: výměna NSS

V NSS 3.28.6 je výchozí rozsah protokolů **TLS 1.0 až TLS 1.2** a volba `SSL_ENABLE_TLS` ho jen rozšiřuje, nikdy nesnižuje maximum. Gecko by tedy mohlo vyjednávat TLS 1.2, aniž bych ho měnil. Stačí **vyměnit knihovny NSS a NSPR**. Ověřil jsem to na datech:

- engine importuje ze starých NSS a NSPR **871 symbolů** a nová knihovna je exportuje **všechny**, včetně datových šablon,
- všech **29 verzí symbolů** (`NSS_3.2` až `NSS_3.12.6`, `NSSUTIL_3.12.x`), které engine vyžaduje, je definováno.

Zkontroloval jsem to jak ze souborů `.def`, tak i na přeložených knihovnách (skript `scripts/microb-nss-abi-check.sh`). Pak jsem NSPR 4.16 a NSS 3.28.6 přeložil pro armel s třemi malými záplatami.

## Šifry: PSM všechno vypne

Tady jsem narazil na past, kterou by nikdo neuhodl. Vrstva PSM v Geckovi při startu **vypne všechny šifrovací sady** knihovny a pak zapne jen svůj starý seznam (CBC se SHA-1). TLS 1.2 by se sice vyjednalo, ale **moderní sady (AES-GCM, ChaCha20) by zůstaly vypnuté** a servery, které staré sady zrušily, by dál selhávaly. Záplata proto zařídí, aby volání „vypnout“ pro moderní sady nic nedělalo. Druhá záplata vypíná **SSL 3.0** (POODLE) a třetí přejmenuje SQLite z NSS na `libnsssqlite3.so`, protože MicroB má vlastní `libsqlite3.so` ve stejném adresáři.

## Test bez prohlížeče

Abych nemusel pokaždé restartovat prohlížeč, napsal jsem malý program **`psm-sim`**, který nastaví NSS stejně jako PSM (SSL 3 a TLS zapnuté, všechny sady vypnuté, pak staré CBC zapnuté) a vypíše, co se vyjednalo. Pod qemu-user proti skutečným serverům: tls-v1-2.badssl.com **TLS 1.2**, Google, Facebook a example.org **TLS 1.2 s AES-GCM**, Seznam **TLS 1.2**. To dokazuje, že záplata funguje, protože PSM sám GCM sady nezapíná. Na telefonu trvá takový handshake do 1 sekundy.

## Instalace a první pád

Nové knihovny se dostávají do systému tak, že balíček `microb-nss` vloží odkazy do `/usr/lib/microb-engine` a původní soubory přesune pomocí `dpkg-divert`, takže po `dpkg -r` se vrátí. **První verze balíčku se nenainstalovala čistě.** Starý `dpkg-divert` na N900 nezná `--listpackage` a `rename` nejde přes hranici souborových systémů (`/opt` je jinde než `/usr`), takže balíček zůstal ve stavu „half-configured“. Zálohy proto teď jdou do `/usr/lib/microb-engine-orig` a balíček zahodí diversion zapsanou bez přesunu souboru.

Po instalaci je potřeba restartovat démona prohlížeče (`/etc/init.d/tablet-browser-daemon.init restart`). A tady je poslední past: **starý zastavený proces enginu `browserd -s … -n browserui` restart přežije**, má staré knihovny a okno prohlížeče na něj čeká donekonečna. Je nutné ho ukončit, okno se pak samo vytvoří znovu s novým enginem.

## Výsledek

Po restartu se **původní MicroB** otevřel na `https://www.seznam.cz/` s ověřeným certifikátem. Před tím: „SSL error“.

![MicroB s TLS 1.2 a Seznam.cz]({{ site.baseurl }}/assets/n900/Seznam v MicroBu.png)
*Screenshot: seznam.cz v MicroBu*

A také na **IDOS** (`https://idos.cz/`): stylovaná stránka s formulářem a barvami, jen načítání trvá asi **20 sekund**.

![IDOS v MicroBu]({{ site.baseurl }}/assets/n900/IDOS v MicroBu.png)
*Screenshot: idos.cz v MicroBu*

Příčinu pomalého načítání zatím neznám. Handshake je rychlý, takže podezřívám správce certifikátů (kořenů je teď kolem 420), neoptimalizovanou kryptografii v C na 600 MHz nebo samotný Gecko 1.9.2 s moderním JavaScriptem. Změřím to někdy v budoucnu.

### Co se nepodařilo

- **Google** hlásí „váš prohlížeč není podporován“ a **Facebook** chce novější prohlížeč. To není TLS, ale kontrola User-Agentu. Zkusím přepsat `general.useragent.override` a základní HTML Googlu (`gbv=1`).
- Moderní stránky se zobrazí po svém: engine z roku 2010 nezná dnešní CSS a JavaScript, takže vzhled je jen přibližný.
- Servery jen s **TLS 1.3** a **HTTP/2** zůstávají mimo dosah. Tohle řešení je záplata, ne nový prohlížeč.

Celé je to experimentální a ověřené na jednom telefonu. Kdo to chce vyzkoušet, má jistotu: `dpkg -r microb-nss` vrátí původní knihovny. Balíčky `ca-certs-n900` a `microb-nss` jsou v apt repozitáři `n900-resurrection.github.io/n900-repository`, zdroje v organizaci [n900-resurrection](https://github.com/n900-resurrection).
