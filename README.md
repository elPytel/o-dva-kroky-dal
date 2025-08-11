# O Dva Kroky Dal

- [O Dva Kroky Dal](#o-dva-kroky-dal)
  - [Webová stránka](#webová-stránka)
  - [Testování na lokálním serveru](#testování-na-lokálním-serveru)
    - [Instalace Jekyll](#instalace-jekyll)
    - [Instalace závislostí](#instalace-závislostí)
    - [Spuštění serveru](#spuštění-serveru)
  - [Nový blog-post](#nový-blog-post)
  - [Linky](#linky)
  - [Layouts](#layouts)
    - [cookbook](#cookbook)
  - [recipe](#recipe)
  - [Zdroje:](#zdroje)

## Webová stránka
[https://elpytel.github.io/o-dva-kroky-dal/](https://elpytel.github.io/o-dva-kroky-dal/)

## Testování na lokálním serveru

[dokumentace](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/creating-a-github-pages-site-with-jekyll)

### Instalace Jekyll
Pro lokální testování je potřeba nainstalovat Jekyll a Ruby. Následující příkazy nainstalují Ruby a Jekyll na Debian/Ubuntu:

```bash
sudo apt-get install ruby-full
sudo apt install jekyll
```

### Instalace závislostí
Pro instalaci závislostí použijte bundler:
```bash
bundle install
```

### Spuštění serveru
Lokální spuštění: `jekyll serve`
```bash
bundle exec jekyll serve --baseurl="" --livereload
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

Jako najsnazší postup se ukázalo stáhnout exportovaná data z googlu jako zip. Následně upravit jednoduchý skript, který převede json soubory na markdown soubory s recepty.

Převod exportovaných dat z Google Keep do jednoho jsonu:
```bash
python keep_to_simplenote.py
```
Script je upravený a očekává soubory v sectě: `./dont_include/Keep/`.

Převod velkého json soubor na markdown soubory s recepty provede script:
```bash
python json2recipe.py
```

- [Google Takeout](https://takeout.google.com/)
- [keep_to_simplenote.py](https://gist.github.com/echus/ce7cd43ec18edaad8105ca37349af41b#file-keep_to_simplenote-py)

## Zdroje:
- [jansim/cookbook](https://github.com/jansim/cookbook/tree/master)