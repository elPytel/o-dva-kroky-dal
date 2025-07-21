# O Dva Kroky Dal

## Webová stránka
[https://elpytel.github.io/o-dva-kroky-dal/](https://elpytel.github.io/o-dva-kroky-dal/)

## Testování na lokálním serveru
Lokální spuštění: `jekyll serve`
```
bundle exec jekyll serve --baseurl="" --livereload
```

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