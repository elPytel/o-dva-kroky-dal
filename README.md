# O Dva Kroky Dal

- [O Dva Kroky Dal](#o-dva-kroky-dal)
  - [Webová stránka](#webová-stránka)
  - [Testování na lokálním serveru](#testování-na-lokálním-serveru)
    - [Instalace závislostí a Jekyll](#instalace-závislostí-a-jekyll)
    - [Spuštění serveru](#spuštění-serveru)
  - [Nový blog-post](#nový-blog-post)
  - [Linky](#linky)
  - [Obrázky](#obrázky)
    - [1. Velikostní třídy (Šířka)](#1-velikostní-třídy-šířka)
    - [2. Pozicování a obtékání (Layout)](#2-pozicování-a-obtékání-layout)
    - [3. Speciální efekty](#3-speciální-efekty)
    - [Kombinace (Pro-tip)](#kombinace-pro-tip)
    - [Jak to vypadá v praxi:](#jak-to-vypadá-v-praxi)
  - [Layouts](#layouts)
    - [cookbook](#cookbook)
  - [recipe](#recipe)
  - [Skripty](#skripty)
  - [Zdroje:](#zdroje)

## Webová stránka
[https://elpytel.github.io/o-dva-kroky-dal/](https://elpytel.github.io/o-dva-kroky-dal/)

## Testování na lokálním serveru

Vytvořil jsem makefile, který zjednodušuje spuštění lokálního serveru a generování kategorií. 

### Instalace závislostí a Jekyll
Pro instalaci závislostí použijte příkaz:
```bash
make install
```

Ten nainstaluje všechny potřebná závislosti apt, python, jekyll, bundler.

### Spuštění serveru
Pro spuštění lokálního serveru použijte příkaz:
```bash
make serve
```

## Nový blog-post
Pro vytvoření nového blog-postu použijte skript `newjekyllpost.sh`:
```bash
./newjekyllpost.sh "Nokia N900 a python aplikace"
```
Tím se vytvoří nový soubor s názvem odpovídajícím datu a názvu.

- [zdroj](https://codegazerants.com/2023/01/01/create-new-jekyll-post-with-a-command/)

## Linky
It is now possible to link to pages other than posts using the link tag. link works for posts, pages, documents in a collection, and files.

```
{{ site.baseurl }}{% link _collection/name-of-document.md %}
{{ site.baseurl }}{% link _posts/2016-07-26-name-of-post.md %}
{{ site.baseurl }}{% link news/index.html %}
{{ site.baseurl }}{% link /assets/files/doc.pdf %}
```
Remember to include the file extension when using the link tag. To use it to create a link:

```
[Link to a document]({{ site.baseurl }}{% link _collection/name-of-document.md %})
[Link to a post]({{ site.baseurl }}{% link _posts/2016-07-26-name-of-post.md %})
[Link to a page]({{ site.baseurl }}{% link news/index.html %})
[Link to a file]({{ site.baseurl }}{% link /assets/files/doc.pdf %})
```

- [stackoverflow: jekyll markdown internal links](https://stackoverflow.com/questions/4629675/jekyll-markdown-internal-links)
- [jekyllrb: links](https://jekyllrb.com/docs/liquid/tags/#links)

## Obrázky

```css
/* Styly pro obrázky v článcích */
.post {
  img {
    display: block;
    margin: 1.5em auto; // Vycentrování a mezery okolo
    border-radius: 5px;
    transition: transform 0.3s ease;

    // Defaultní velikost (pokud není řečeno jinak)
    width: 100%;
    height: auto;

    // Specifické třídy pro Markdown {: .small} atd.
    &.small {
      max-width: 300px;
    }

    &.medium {
      max-width: 600px;
    }

    &.left {
      float: left;
      margin: 0 1.5em 1em 0;
      max-width: 40%;
    }

    &.right {
      float: right;
      margin: 0 0 1em 1.5em;
      max-width: 40%;
    }

    &.full {
      max-width: 100%;
      border-radius: 0; // Širokoúhlý "full-bleed" look
    }
    
    &.pixelated {
      image-rendering: pixelated; // Skvělé pro screenshoty terminálu nebo retro grafiku
    }
  }
}

// Čištění po floatech (aby text neutíkal tam, kam nemá)
.post::after {
  content: "";
  display: table;
  clear: both;
}
```

Tady je přehled všech "přepínačů", v arzenálu:

### 1. Velikostní třídy (Šířka)
Tyto třídy určují, kolik místa obrázek zabere na šířku. `max-width` zaručuje, že se na mobilu automaticky zmenší, aby nepřetekl.

* `{: .small}`: Omezí šířku na **300px**. Ideální pro detaily, loga nebo tvou ilustraci Arsenálu.
* `{: .medium}`: Omezí šířku na **600px**. Dobrý kompromis pro běžné fotky z mobilu, aby nebyly přes celou obrazovku.
* `{: .full}`: Roztáhne obrázek na **100 %** šířky kontejneru a odstraní zaoblení rohů. Skvělé pro panoramata nebo mapy.
* *(Bez třídy)*: Pokud nic nenapíšeš, obrázek se defaultně roztáhne na **100 %**, ale zůstane mu zaoblení rohů.

### 2. Pozicování a obtékání (Layout)
Tady pozor – když použiješ obtékání, text se "nalepí" na bok obrázku.

* `{: .left}`: Obrázek skočí doleva a text ho obtéká zprava. Zabere max **40 %** šířky.
* `{: .right}`: Obrázek skočí doprava a text ho obtéká zleva. Taky max **40 %**.
    * *Tip:* Tohle je super pro tvůj blog, když chceš dát k delšímu odstavci malou ilustrační fotku.

### 3. Speciální efekty
* `{: .pixelated}`: Vypne vyhlazování (anti-aliasing). To se ti bude extrémně hodit, až budeš na blog dávat **screenshoty z terminálu** nebo detailní výstupy z kódu – text v obrázku bude ostrý jako břitva i při zvětšení.


### Kombinace (Pro-tip)
Můžeš je i řetězit. Pokud chceš malý obrázek vpravo s ostrými pixely, napíšeš:
`![Popis]({{ url }}){: .small .right .pixelated}`

### Jak to vypadá v praxi:

| Zápis v Markdownu | Výsledek v prohlížeči |
| :--- | :--- |
| `![Alt](){: .small}` | Malý centrovaný obrázek (300px) |
| `![Alt](){: .full}` | Obrázek od kraje ke kraji |
| `![Alt](){: .right}` | Malá fotka vpravo, text teče vlevo |
| `![Alt](){: .small .pixelated}` | Malý, ostrý technický diagram |

## Layouts

- [Layouts](https://jekyllrb.com/docs/layouts/)

### cookbook

- [recipe.html](https://github.com/jansim/cookbook/blob/master/_layouts/recipe.html)
- [git: Amerikanische Pancakes](https://github.com/jansim/cookbook/blob/master/_recipes/Amerikanische%20Pancakes.md?plain=1)
- [blog: Amerikanische Pancakes](https://simson.io/cookbook/recipes/Amerikanische-Pancakes/)

## recipe

Nejdříve jsem se snažil použít gkeepapi. Nepoužívají však pro přihlašování app-passwords, ale master-token, takže jsem se rozhodl pro jiný postup.
- [gkeepapi](https://github.com/kiwiz/gkeepapi)
- [gkeepapi documentation](https://gkeepapi.readthedocs.io/en/latest/)

Jako nejsnazší postup se ukázalo stáhnout exportovaná data z googlu jako zip. Požijte nástroj: [takeout.google.com](https://takeout.google.com). Vyberte Google Keep a stáhněte data jako zip (odeslání odkazu na email). Následně připravit jednoduchý skript, který převede json soubory na markdown soubory s recepty.

Převod exportovaných dat z Google Keep do jednoho jsonu:
```bash
python3 keep_to_simplenote.py
```
Script očekává soubory v sectě: `./dont_include/Keep/`.

Převod velkého json soubor na markdown soubory s recepty provede script:
```bash
python3 json2recipe.py
```

- [Google Takeout](https://takeout.google.com/)
- [keep_to_simplenote.py](https://gist.github.com/echus/ce7cd43ec18edaad8105ca37349af41b#file-keep_to_simplenote-py)

## Skripty

[skripty](./scripts/scripts.md)

## Zdroje:
- [jansim/cookbook](https://github.com/jansim/cookbook/tree/master)