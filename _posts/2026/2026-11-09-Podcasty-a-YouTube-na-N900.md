---
layout: post
title:  "Podcasty a YouTube na N900"
author: "Jarda"
description: gPodder 2.20.3 s HTTPS přes curl, yt-dlp a QuickJS.
categories:
    - n900
    - Claude
tags:
    - Maemo
    - podcasty
    - gPodder
    - YouTube
thumbnail: /assets/n900/Přehrávání.png
---

- [gPodder na telefonu](#gpodder-na-telefonu)
- [Proč přestal fungovat](#proč-přestal-fungovat)
- [Zdrojáky a nový balíček](#zdrojáky-a-nový-balíček)
- [HTTPS přes curl](#https-přes-curl)
- [YouTube: yt-dlp a QuickJS](#youtube-yt-dlp-a-quickjs)
  - [Měření: 257 sekund na jedno video](#měření-257-sekund-na-jedno-video)
- [Jak dál?](#jak-dál)

Podcasty jsou na N900 dokonalá aplikace: stahují se na wifi, poslouchají se v autě nebo v kapse a telefon k tomu má dobrý přehrávač. V systému už je **gPodder** 2.20.2 (Python 2.5, PyGTK a Hildon, autor Thomas Perl) a je to program, který stojí za záchranu. Jenže dnes se v něm nic nestáhne, a pak je tu YouTube, který se do podcastů v poslední době taky hodně dostává. Tohle je příběh, co všechno jsem zkoušel a co nakonec zůstalo.

## gPodder na telefonu

Předplatné má uživatel v `~/.config/gpodder`: databáze `database.sqlite` a seznam kanálů `channels.opml`. Všechno zůstává při aktualizaci, protože balíček se těchto souborů nedotýká. Před jakoukoli instalací je přesto rozumné adresář zazálohovat.

## Proč přestal fungovat

Na vině jsou dvě věci, které již znáte z ostatních článků:

1. **HTTPS.** Python 2.5 používá OpenSSL 0.9.8 a umí jen TLS 1.0, takže stahování kanálů přes `https://` selhává stejně jako e-mail.
2. **YouTube.** Starý kód gPodderu pro YouTube (přes `get_video_info`) už dávno nefunguje. YouTube dnes vyžaduje spuštění JavaScriptu přehrávače (výzvy `n` a `sig`) a tokeny.

## Zdrojáky a nový balíček

Zdroje jsou na GitHubu (`gpodder/gpodder`). Pro Maemo 5 je značka `obsolete/maemo5` s verzí **2.20.3** (z prosince 2012), novější než ta na telefonu. Moderní gPodder 3.11 vyžaduje Python 3.7+ a GTK 3, což na N900 není, ale jeho jádro a příkaz `gpo` jsou bez grafiky. Rozhodl jsem se proto upravit ověřenou 2.20.3 a postavit balíček (`make -C apps/gpodder deb`): stáhne zdroje, složí strom jako `setup.py install` (4 Python balíčky, 23 překladů, služba D-Bus) a vyrobí `.deb` o velikosti 628 kB.

## HTTPS přes curl

Záplata `ytdlp.patch` přidává modul `gpodder/ytdlp.py`, který stahování po HTTPS **svěří programu `curl` 8** (z balíčku `curl`, TLS 1.3). Týká se to kanálů (`feedcore.py`) i stahování epizod (`download.py`, s navázáním po přerušení a průběhem pro okno). HTTP zůstává u původního `urllib`. Na telefonu jsem ověřil (v Pythonu 2.5, bez instalace balíčku) kanál YouTube v atom10 (parsuje `feedparser`), zjištění adresy a stažení videa (MP4, 629 kB).

Zajímavost: `yt-dlp` při řešení JavaScriptové výzvy zapisuje dočasné soubory a `/tmp` na telefonu je tmpfs o velikosti **1 MB** (hláška „No space left on device“). Proto jsem mu nastavil `TMPDIR=~/.gpodder/tmp`.

## YouTube: yt-dlp a QuickJS

Starým klientům pro Maemo (cuteTube, MediaBox, Minitube) se YouTube postupně vyměnil pod rukama a dnes pravděpodobně nefungují. cuteTube i jeho knihovna qyoutube mají zdroje na GitHubu, jenže oprava není jednorázová: YouTube se mění pořád a údržba staré Qt knihovny je nekonečný závod. Realistická cesta je jiná:

- extrakci dělá **yt-dlp**, který se aktualizuje několikrát týdně,
- na telefonu zůstává jen přehrávač,
- yt-dlp dnes potřebuje Python 3.10+ (máme 3.11 s `pip`, `ssl` s TLS 1.3 a `ctypes`) a pro YouTube **externí JavaScriptový běh**. Deno, Node ani Bun pro armel s glibc 2.5 neexistují, takže jsem přeložil malý **QuickJS** v C.

Ve Workshopu to fungovalo bez problémů: `yt-dlp` s `quickjs` vypsal formáty a stáhl platné MP4 (formát 18, H.264 a AAC, 240p až 360p).

### Měření: 257 sekund na jedno video

Na samotném telefonu to dopadlo jinak. N900 (256 MB RAM, ARM Cortex-A8) potřebuje na zjištění adresy **jednoho videa 257 s a 260 s** (dvě měření). QuickJS při řešení výzvy YouTube drží přes **110 MB** a telefon začne swapovat. Cache (`--cache-dir`) nepomohla: druhý běh trval stejně a žádné soubory v ní nevznikly. Zkusil jsem i klienty, které JavaScript nepotřebují, ale ty dnes nefungují (ověřeno na PC s yt-dlp 2026.10.26): `android_vr` vrací adresu, kterou YouTube odmítne s HTTP 403 (i yt-dlp samotný), `ios`, `mweb` a `web_safari` hlásí „No video formats found“ a `tv` „page needs to be reloaded“.

## Jak dál?

**YouTube na telefonu zůstane minimální.** V gPodderu 2.20.3-2maemo4:

- přehrání nestažené YouTube epizody zobrazí hlášku, že zjištění adresy na tomto zařízení trvá několik minut, a doporučí video nejdřív stáhnout. Jinak se nestane nic,
- **stahování funguje na pozadí** (vlákna gPodderu), pomalu, ale bez nutnosti dohledu. Stažené MP4 se přehraje v přehrávači médií,
- streamování přes lokální curl proxy funguje pro podcasty a jakákoli média po HTTPS, jen ne pro YouTube.

![gPodder podcasty]({{ site.baseurl }}/assets/n900/gPodder podcasty.png)
*Screenshot: seznam podcastů v gPodderu*
![gPodder epizody]({{ site.baseurl }}/assets/n900/gPodder epizody.png)
*Screenshot: seznam epizod podcastu v gPodderu*
![gPodder stáhnout]({{ site.baseurl }}/assets/n900/gPodder stáhnout.png)
*Screenshot: stahování epizody podcastu v gPodderu*
![Přehrávání podcastu]({{ site.baseurl }}/assets/n900/Přehrávání.png)
*Screenshot: přehrávání podcastu*

Další vývoj YouTube na telefonu nechávám být. Cesta vede přes server: kanály YouTube stahuje `yt-dlp` do knihovny **Jellyfin** (jak to mám postavené, je v článcích [Youtube downloader]({{ site.baseurl }}{% post_url 2026/2026-10-01-Youtube-downloader %}) a [Jellyfin a Finamp]({{ site.baseurl }}{% post_url 2026/2026-10-07-Jellyfin-a-Finamp %})) a telefon bude přehrávat z Jellyfinu. Proto je v seznamu úkolů bod „Jellyfin na N900“: nejdřív zkouška, jestli se server objeví přes DLNA v přehrávači telefonu, a když ne, vlastní klient přes REST API.

Balíčky `gpodder`, `curl` a `quickjs` jsou v apt repozitáři `n900-resurrection.github.io/n900-repository`.
