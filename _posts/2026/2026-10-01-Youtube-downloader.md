---
layout: post
title:  "Youtube downloader"
author: "Jarda"
description: Požití yt-dlp pro stahování videí z Youtube
categories: 
    - Youtube
tags: 
    - Audiobookshelf
thumbnail: /assets/yt-dlp.png
---

Rozhodl jsem se stáhnout pro Eriku "podcast" z youtube, aby si ho mohla poslechnout v Audiobookshelf. Použil jsem k tomu nástroj [yt-dlp](https://github.com/yt-dlp/yt-dlp).

```bash
sudo apt update
sudo apt install nodejs ffmpeg
```

Narazil jsem s `apt` instalací na problém, že balíček `yt-dlp` je v repozitáři zastaralý a nefunguje patrně s ověřováním na youtube. Proto jsem použil instalaci z GitHubu.

```bash
sudo wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O /usr/local/bin/yt-dlp
sudo chmod a+rx /usr/local/bin/yt-dlp
```

```bash
# Extract best audio and keep it in m4a format for Audiobookshelf
# Embed metadata and thumbnails into the audio files automatically
# Name files with playlist index to keep the correct episode order
yt-dlp \
  --js-runtimes node \
  --extract-audio \
  --audio-format m4a \
  --embed-metadata \
  --embed-thumbnail \
  --output "%(playlist_index)02d - %(title)s.%(ext)s" \
  <url>
```

Příkaz stáhne všechny epizody z playlistu a uloží je do aktuálního adresáře. Soubory jsou pojmenovány podle pořadí v playlistu a názvu epizody. Metadata a náhledy jsou vloženy do audio souborů, což je vhodné pro přehrávání v Audiobookshelf.
