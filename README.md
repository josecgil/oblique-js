# `oblique.js`

`oblique.js` is a framework that lets your structure web apps by providing:

+ **Directives** to organise & execute behaviour in page
+ **Model & model selection** to bind data in page with behaviours & DOM elements
+ **Params** to send config data to behaviours
+ **Templates**, it uses [handlebars](http://handlebarsjs.com/) to render html

## Requeriments

Currently `oblique.js` needs  [jQuery](http://jquery.com/) to work properly. If you want to use template system, you need to load also [handlebars](http://handlebarsjs.com/).

## Installation

Just download `oblique.js` or `oblique.min.js` file and load it after [jQuery](http://jquery.com/) and (optionally) [handlebars](http://handlebarsjs.com/)

## A simple example

This example will execute a console.log

```
<script type="text/javascript">
    var SimpleDirective=function(data) {
        console.log(data.domElement);
    };
    
    Oblique().registerDirective("SimpleDirective", SimpleDirective);
</script>
<p data-ob-directive="SimpleDirective">simple example<p>

```

