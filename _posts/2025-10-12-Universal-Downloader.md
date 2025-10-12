---
layout: post
title: "Universal Downloader: Datoid"
description: "Přidání podpory pro Datoid do Universal Downloaderu"
categories:
  - Python
  - Universal Downloader
thumbnail: https://github.com/elPytel/Universal_downloader/raw/main/assets/app.png
---

Vrátil jsem se k vývoji Universal Downloaderu. Překvapilo mě že sdílej opět začalo fungovat. Místo přechodu na jinou platformu půjde tedy o pokus o rozšíření aplikace, tak jak jsem to původně zamýšlel.

# Datoid

Narazil jsem na [datoid.cz](https://datoid.cz/), je další služba pro sdílení souborů, která má navíc i bezplatnou verzi. 

Web vypadá jednoduše parsovatelně. 

- `https://datoid.cz/s/` - stránka pro vyhledávání
- `https://datoid.cz/f/` - url pro stahování
  - `?request=1` - parametr pro získání odkazu na stažení

Odpověď na `?request=1` je ve formátu JSON:
```json
{"download_link":"...","download_link_cdn":"...","wait":30}
```

{: .note }
> Nevýhoda je, že bezplatná verze má čekací dobu 30 sekund, po požádání o odkaz na stažení.
> Sdilej.cz má čekací dobu asi 40 sekund, ale po dokončení stahování.

# Dokumentace

Pro vygenerování dokumentace jsem použil [pdoc3](https://pdoc3.github.io/pdoc/). 

```bash
pdoc .\gui.py .\main.py .\datoid_downloader.py .\sdilej_downloader.py .\download_page_search.py -o ./docs
```

Výsledná dokumentace je dostupná na [GitHub Pages](https://elpytel.github.io/Universal_downloader/).

Budu muset dopsat dokumentační komentáře do kódu.

