---
section: "scripts"
chapter: "domain"
title: "AI"
order: 1
---

{% assign pages = site.collections | where: "label" , "archived_pages" | first %}
{% assign scripts = pages.docs | where: "section" , "scripts" %}
{% assign scripts = scripts | sort %}

{% assign pagePath = page.path | split: "/" %}
{% assign pageName = pagePath[1] | remove: ".md" %}

## {{ page.title }}

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

<table class="table table-bordered bg-breadcrumb">
<thead>
    <tr>
        <td scope="col"><strong>Name</strong></td>
        <td scope="col"><strong>Author</strong></td>
        <td scope="col"><strong>Date</strong></td>
    </tr>
</thead>
<tbody>
{% for script in scripts %}
    {% if script.categories contains pageName %}
    
    {% assign scriptTitle = script.title | split: ' ' %}
    {% capture scriptTitleWithCase %}{% for word in scriptTitle %}{{ word | capitalize }} {% endfor %}{% endcapture %}
    
    <tr>
        <td><a href="{{ script.url }}.html">{{ scriptTitleWithCase }}</a></td>
        <td>{{ script.author }}</td>
        <td>{{ script.uploaded }}</td>
    </tr>
    {% endif %}
{% endfor %}
</tbody>
</table>