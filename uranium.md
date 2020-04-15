---
layout: page
title: Uranium series
permalink: /uranium/
---

<style>
ol {
    list-style-type: decimal-leading-zero;
}
</style>
{% assign uranium_posts = site.posts | where_exp: "p", "p.url contains '/uranium/'" %}
{% assign uranium_posts = uranium_posts | sort: "url" %}
<ol start="0">
  {% for post in uranium_posts %}
    {% if post.url %}
        <li>
          {% assign title = post.title | split: " - " %}
          <a href="{{ post.url }}">{{ title[1] }}</a>.
          <br />
          {{ post.excerpt }}
        </li>
    {% endif %}
  {% endfor %}
</ol>

