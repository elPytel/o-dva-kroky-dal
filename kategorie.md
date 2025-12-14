---
layout: default
title: Kategorie
permalink: /kategorie/
---

<h1>Seznam kategorií</h1>

<ul>
  {% for category in site.categories %}
    {% assign slug = category[0] | slugify %}
    <li>
      <a href="{{ '/kategorie/' | append: slug | relative_url }}">
        {{ category[0] }} ({{ category[1].size }})
      </a>
    </li>
  {% endfor %}
</ul>

<p>Celkem kategorií: {{ site.categories.size }}</p>
<p>Celkem článků: {{ site.posts.size }}</p>