---
layout: default
title: Kategorie
permalink: /kategorie/
---

<h1>Seznam kategorií</h1>

<ul>
  {% for category in site.categories %}
    <li>
      <a href="{{ '/kategorie/' | append: category[0] | relative_url }}">
        {{ category[0] }} ({{ category[1].size }})
      </a>
    </li>
  {% endfor %}
</ul>

<p>Celkem kategorií: {{ site.categories.size }}</p>
<p>Celkem článků: {{ site.posts.size }}</p>