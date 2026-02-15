---
layout: default
title: Kategorie
permalink: /kategorie/
---

<h1>Seznam kategorií</h1>

<ul>
  {% assign categories_sorted = site.categories | sort %}
  {% for category in categories_sorted %}
    {% assign cat = category[0] %}
    {% assign posts = category[1] %}
    {% assign slug = cat | slugify %}
    <li>
      <a href="{{ '/kategorie/' | append: slug | relative_url }}">
        {{ cat }} ({{ posts.size }})
      </a>
    </li>
  {% endfor %}
</ul>

<p>Celkem kategorií: {{ site.categories.size }}</p>
<p>Celkem článků: {{ site.posts.size }}</p>