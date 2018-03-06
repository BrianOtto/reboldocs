---
section: "scripts"
title: "Sorted By Domain"
order: 2
---

{% assign allcaps = 'ai,cgi,ftp,gui,html,http,ldc,sdk,sql,tcp,ui,vid,xml' | split: ',' %}
{% assign categories = '' | split: ',' %}
{% assign categoriesUnique = '' | split: ',' %}

{% assign pages = site.collections | where: "label" , "archived_pages" | first %}
{% assign categoriesMixedCase = pages.docs | where: "section" , "scripts" | map: 'categories' | join: ',' | join: ',' | split: ',' %}

{% for category in categoriesMixedCase %}
    {% assign categoryClean = category | capitalize %}
    {% assign categories = categories | push: categoryClean %}
{% endfor %}

{% assign categories = categories | sort %}

{% for category in categories %}
    {% if category == 'All' %}{% continue %}{% endif %}
    
    {% assign categoryClean = category %}
    
    {% unless categoryClean == previous %}
        {% for word in allcaps %}
            {% assign wordClean = word | capitalize %}
            {% if wordClean == categoryClean %}
                {% assign categoryClean = categoryClean | upcase %}
            {% endif %}
        {% endfor %}
        
        {% assign categoriesUnique = categoriesUnique | push: categoryClean %}
    {% endunless %}
    
    {% assign previous = category %}
{% endfor %}

{% assign categoriesUnique = categoriesUnique | sort_natural %}

{% assign scripts = pages.docs | where: "section" , "scripts" %}
{% assign scripts = scripts | sort %}

## Sorted By Domain

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

<div class="row">
{% for category in categoriesUnique %}
<div class="col-12">
    <div class="card">
        <div class="card-header">
        {{ category }}
        </div>
        
        {% assign categoryClean = category | downcase %}
        
        <div class="card-block p-4">
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
                {% if script.categories contains categoryClean %}
                
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
        </div>
    </div>
    
    <br>
</div>
{% endfor %}
</div>