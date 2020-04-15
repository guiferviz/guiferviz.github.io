---
layout: page
title: Tags
permalink: /tags/

comments: true
font-awesome: true
---

{% comment %}
Thanks to codinfox for almost all the code related to tags in Jekyll.
https://codinfox.github.io/dev/2015/03/06/use-tags-and-categories-in-your-jekyll-based-github-pages/
{% endcomment%}

{% comment %}
The following part extracts all the tags from your posts and sort tags, so that you do not need to manually collect your tags to a place.
{% endcomment %}
{% assign rawtags = "" %}
{% for post in site.posts %}
    {% assign ttags = post.tags | join:'|' | append:'|' %}
    {% assign rawtags = rawtags | append:ttags %}
{% endfor %}
{% assign rawtags = rawtags | split:'|' | sort %}

{% comment %}
The following part removes dulpicated tags and invalid tags like blank tag.
{% endcomment %}
{% assign tags = "" %}
{% for tag in rawtags %}
    {% if tag != "" %}
        {% if tags == "" %}
            {% assign tags = tag | split:'|' %}
        {% endif %}
        {% unless tags contains tag %}
            {% assign tags = tags | join:'|' | append:'|' | append:tag | split:'|' %}
        {% endunless %}
    {% endif %}
{% endfor %}

{% comment %}
List all the tags of your site.
{% endcomment %}
<div>
{% for tag in tags %}
    <a class="tag" href="#{{ tag | slugify }}">{{ tag }}</a>
{% endfor %}
</div>

<div style="min-height: 100px"></div>

{% comment %}
=======================
The purpose of this snippet is to list all your posts posted with a certain tag.
=======================
{% endcomment %}
<div>
{% for tag in tags %}
    <h2 id="{{ tag | slugify }}">{{ tag }}</h2>
    <ul>
    {% assign sorted_posts = site.posts | sort: "url" %}
    {% for post in sorted_posts %}
        {% if post.tags contains tag %}
            <li>
                {% if site.difficulties %}{{ post.difficulty_icon }} {% endif %}<a href="{{ post.url }}">{{ post.title }}</a> {% for tag in post.tags %}<a class="tag" href="/tags/#{{ tag | slugify }}">{{ tag }}</a>{% unless forloop.last %}, {% endunless %}{% endfor %}
        {% comment %}
            {% get_post "post.id" link %}
            <small>{{ post.date | date_to_string }}</small>
            <small>
            {% for tag in post.tags %}
                <a class="tag" href="/tag/#{{ tag | slugify }}">{{ tag }}</a>
            {% endfor %}
            </small>
        {% endcomment %}
            </li>
        {% endif %}
    {% endfor %}
    </ul>
{% endfor %}
</div>

<div style="min-height: 100px"></div>
