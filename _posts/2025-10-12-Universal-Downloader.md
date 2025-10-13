---
layout: post
title: "Universal Downloader: Datoid"
description: "Přidání podpory pro Datoid do Universal Downloaderu"
categories:
  - Python
  - Universal Downloader
thumbnail: https://github.com/elPytel/Universal_downloader/raw/main/assets/multi_source.png
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

## Přepracoval jsem `link_to_file.py`

Tak aby se získávál odkaz na stažení souboru až při samotném stahování. Kód je nyní obecnější pro jednotlivé třídy downloaderů, ale musí do něj předávat i samotná třída, která objekt vytvořila.

```python
class Link_to_file:
    def __init__(self, title, detail_url, size, source_class: Download_page_search = None):
        self.title = title
        self.detail_url = detail_url
        self.size = size
        self.Source_class = source_class
```

Vytvořila se tak kruhová závislost mezi třídami `Link_to_file` a `Download_page_search`, a zabralo mi chvíli než jsem přišel na to jak rozbít ji a ne můj kód.

# Dokumentace

Pro vygenerování dokumentace jsem použil [pdoc3](https://pdoc3.github.io/pdoc/). 

```bash
pdoc .\gui.py .\main.py .\datoid_downloader.py .\sdilej_downloader.py .\download_page_search.py -o ./docs
```

Výsledná dokumentace je dostupná na [GitHub Pages](https://elpytel.github.io/Universal_downloader/).

Budu muset dopsat dokumentační komentáře do kódu.

# GUI volba zdrojů

![GUI volba zdrojů](https://github.com/elPytel/Universal_downloader/raw/main/assets/multi_source.png)

Nyní při spuštění GUI aplikace je možné zvolit více zdrojů pro vyhledávání a stahování souborů.

Při vyhledávání se vyhledává paralelně přes každý zdroj zvlášť a výsledky se pak sloučí do jednoho seznamu, který se aktualizuje průběžně jak přicházejí výsledky z jednotlivých zdrojů.