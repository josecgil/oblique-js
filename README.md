# `oblique.js`

`oblique.js` is a framework that lets your structure web apps by providing:

+ **Directives** to organise & execute behaviours in page
+ **Model & model selection** to bind data in page with behaviours & DOM elements
+ **Params** to send config data to behaviours
+ **Templates**, it uses [handlebars](http://handlebarsjs.com/) to render html

## Requeriments

Currently `oblique.js` needs  [jQuery](http://jquery.com/) to work properly. If you want to use template system, you need to load also [handlebars](http://handlebarsjs.com/).

## Installation

Just download `oblique.js` or `oblique.min.js` file and load it after [jQuery](http://jquery.com/) and (optionally) [handlebars](http://handlebarsjs.com/)

## A simple example

This example will instantiate a new SimpleDirective when `oblique.js` find the element with data-ob-directive passing data to its constructor with:

+ domElement: the HTMLElement that contains the data-ob-element attribute that triggers the execution
+ jQueryElement: the same as before, but the jQuery counterpart
+ params: any params that the tag has, in this case this is undefined, it works with the data-ob-params attribute
+ model: any data that you want to bind to this directive, in this case this is undefined, it works with the data-ob-model attribute


```
<script type="text/javascript">
    var SimpleDirective=function(data) {
        console.log(data.domElement);
    };
    
    Oblique().registerDirective("SimpleDirective", SimpleDirective);
</script>
<p data-ob-directive="SimpleDirective">simple example<p>

```

