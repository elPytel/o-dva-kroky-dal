---
layout: page
title: Receptoár
use-site-title: true
---

<h2 class="text-center"> Top Recipes </h2>

{% assign recipes = site.recipes | sort: 'date' | reverse %}

{% if paginator.total_pages > 1 %}
<ul class="pager main-pager">
  {% if paginator.previous_page %}
  <li class="previous">
    <a href="{{ paginator.previous_page_path | relative_url }}">&larr; Novější</a>
  </li>
  {% endif %}
  {% if paginator.next_page %}
  <li class="next">
    <a href="{{ paginator.next_page_path | relative_url }}">Starší &rarr;</a>
  </li>
  {% endif %}
</ul>
{% endif %}