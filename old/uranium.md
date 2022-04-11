---
layout: page
title: Uranium series
description: >
    A series of post about how to build a compiler for your own programming
    language with Flex, Bison and LLVM.
permalink: /uranium/

font-awesome: true
---

<div style="text-align: center">
<a href="https://github.com/guiferviz/uranium" target="_blank">
Uranium GitHub <i class="fab fa-github"></i> repository
</a>
</div>

<figure id="uraniumLogo" style="text-align: center">
<img src="/assets/images/2020_04_09_uranium_logo.svg"
     width="250"
     alt="Uranium logo." />
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

