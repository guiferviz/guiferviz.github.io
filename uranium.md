---
layout: page
title: Uranium series
permalink: /uranium/
---

<figure id="uraniumLogo" style="text-align: center">
<img src="/assets/images/2020_04_09_uranium_logo.svg"
     width="400"
     alt="Uranium logo." />
<figcaption>
A bunch of radioactive zeros and ones that will soon destroy you.
</figcaption>
</figure>
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

