---
layout: page
title: Recepty
permalink: /recepty/
---

# Recepty

<ul>
  {% for recipe in site.recipes %}
    <li>
      <a href="{{ recipe.url | relative_url }}">{{ recipe.title }}</a>
    </li>
  {% endfor %}
</ul>