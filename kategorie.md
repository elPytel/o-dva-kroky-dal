---
layout: default
title: Kategorie
permalink: /kategorie/
---

## Statistika

{% capture wc %}{% include_relative generated/word_count.txt %}{% endcapture %}
{% assign pages_count = wc | split: ':' | last | strip %}

| Celkem | Hodnota |
|---|---:|
| Kategorií | {{ site.categories.size }} |
| Tagů | {{ site.tags.size }} |
| Článků | {{ site.posts.size }} |
| Přibližný počet stránek (250 slov/stránka) | {{ pages_count }} |

## Seznam kategorií

<ul>
  {% assign categories_sorted = site.categories | sort %}
  {% for category in categories_sorted %}
    {% assign cat = category[0] %}
    {% assign posts = category[1] %}
    {% capture cat_str %}{{ cat }}{% endcapture %}
    {% assign slug = cat_str | slugify: 'latin' %}
    <li>
      <a href="{{ '/kategorie/' | append: slug | relative_url }}">
        {{ cat }} ({{ posts.size }})
      </a>
    </li>
  {% endfor %}
</ul>

## Seznam tagů

<ul>
  {% assign tags_sorted = site.tags | sort %}
  {% for tagpair in tags_sorted %}
    {% assign tag_name = tagpair[0] %}
    {% assign posts = tagpair[1] %}
    {% capture tag_str %}{{ tag_name }}{% endcapture %}
    {% if tag_str and tag_str != "" %}
      {% assign slug = tag_str | slugify: 'latin' %}
      <li>
        <a href="{{ '/kategorie/' | append: slug | relative_url }}">
          {{ tag_str }} ({{ posts.size }})
        </a>
      </li>
    {% endif %}
  {% endfor %}
</ul>