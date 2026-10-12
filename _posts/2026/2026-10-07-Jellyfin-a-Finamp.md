---
layout: post
title:  "Jellyfin a Finamp"
author: "Jarda"
description: Self hosted alternativa Spotify.
categories: 
    - Homelab
tags: 
    - Jellyfin
    - Finamp
thumbnail: /assets/Jellyfin_logo.webp
---

- [Serverová část (Backend)](#serverová-část-backend)
- [Čím to přehrávat (Klienti)](#čím-to-přehrávat-klienti)
- [Kámen úrazu: Metadata a získávání hudby](#kámen-úrazu-metadata-a-získávání-hudby)

Chtěl jsem ještě mediální knihovnu rozšířit o hudbu. Vzhledem k tomu, že jsem chtěl mít vše self-hosted a open-source, padla volba na Jellyfin (protože jej již používám). Jellyfin je mediální server, který zvládá filmy, seriály i hudbu. Pro hudbu je k dispozici dedikovaná mobilní aplikace **Finamp**, která poskytuje čistě hudební rozhraní podobné Spotify.

## Serverová část (Backend)

* **Navidrome (Zlatý standard pro hudbu):** Napsaný v Go, extrémně nenáročný na zdroje (běží v desítkách MB RAM) a bleskový i u obřích knihoven. Má přehledné webové rozhraní, podporuje více uživatelů s oddělenými playlisty, on-the-fly transkódování (např. z domácích FLACů do úsporného Opusu při poslechu přes mobilní data) a plně implementuje Subsonic API.
* **Jellyfin (Univerzální mediální server):** Pokud už řešíte i filmy a seriály v jednom ekosystému, Jellyfin zvládne hudbu velmi dobře. Ve spojení s dedikovanou mobilní aplikací **Finamp** dostanete čistě hudební rozhraní, které vypadá a funguje téměř identicky jako Spotify.
* **Plex + Plexamp (Nejblíže chytrým algoritmům):** Není to čistý open-source, ale kombinace Plexu a dedikované aplikace **Plexamp** má bezkonkurenčně nejlepší „chytré“ funkce. Server dělá lokální zvukovou analýzu skladeb, takže umí automatické plynulé přechody (sweet fades), generování nekonečných rádií podle nálady podobně jako Spotify Radio a špičkový offline režim.
* **Koel (Důraz na webové rozhraní):** Pokud chcete primárně poslouchat v prohlížeči na PC a vyžadujete, aby samotný web vypadal od prvního spuštění jako moderní klon Spotify bez nutnosti instalovat další programy, Koel je designově nejblíž.

## Čím to přehrávat (Klienti)

Poslouchat hudbu přes mobilní prohlížeč je za trest, takže o reálném „Spotify zážitku“ rozhoduje nativní aplikace napojená na váš server:

* **Android:** Jednoznačným králem je **Symfonium** (jednorázově placená aplikace, naprostá špička v rychlosti, podpoře Android Auto, chytrých filtrech a automatické offline synchronizaci; umí se připojit na Navidrome, Jellyfin i Plex). Z čistě open-source (FOSS) alternativ skvěle poslouží **Tempo** nebo **Ultrasonic** (pro Navidrome) a zmíněný **Finamp** (pro Jellyfin).
* **Desktop (Linux / Windows):** Místo webového prohlížeče se vyplatí nasadit **Feishin** nebo **Supersonic**. Jsou to moderní desktopové aplikace napojené na Subsonic/Jellyfin API s podporou mediálních kláves, systémové lišty a gapless playbacku.

## Kámen úrazu: Metadata a získávání hudby

Na rozdíl od běžných knihoven se soubory (kde často stačí rozumná adresářová struktura) jsou hudební servery jako Navidrome striktně závislé na **ID3 tazích** přímo v souborech (Interpret, Album Artist, Album, Rok, Číslo stopy). Pokud v tazích chybí pořádek, server jedno album rozbije na pět různých položek.

Před nasazením knihovny se proto vyplatí prohnat složky přes **MusicBrainz Picard** (GUI) nebo **Beets** (extrémně silný CLI nástroj v Pythonu), který hudbu automaticky identifikuje podle akustického otisku, opraví tagy, stáhne přebaly alb a srovná soubory na disku podle definované šablony. Pro samotnou automatizaci stahování a sledování nových alb pak slouží **Lidarr** nebo self-hosted webový klient **slskd** (Soulseek).

```bash
sudo apt update
sudo apt install picard
```

Jak ovládat picard se snadno dozvíte třeba na youtube.

{: .tip }
> Před upravou tagů se vyplatí udělat zálohu původních souborů, protože pokud se něco pokazí, je lepší mít možnost se vrátit k původnímu stavu.