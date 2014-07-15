# `oblique.js`

`oblique.js` is a framework that lets your structure web apps by providing:

+ **Directives** to organise & execute behaviours in page
+ **Model & model selection** to bind data in page with behaviours & DOM elements
+ **Params** to send config data to behaviours
+ **Templates** to render html ([handlebars](http://handlebarsjs.com/))

## Requeriments

Currently `oblique.js` needs  [jQuery](http://jquery.com/) to work properly. If you want to use template system, you need to load also [handlebars](http://handlebarsjs.com/).

## Installation

Just download `oblique.js` or `oblique.min.js` file and load it after [jQuery](http://jquery.com/) and (optionally) [handlebars](http://handlebarsjs.com/)

```
<script type="text/javascript" src="https://raw.githubusercontent.com/josecgil/oblique-js/master/dist/oblique.min.js"></script>
```

## A simple example

`oblique.js` constantly searchs the entire DOM tree for elements with `data-ob-directive`. When `oblique.js` finds the element it instantiate a new "class" with the constructor function (in this case, `new SimpleDirective(data)`). 

`data` is a params that contains several properties:

+ `domElement`: the HTMLElement that contains the `data-ob-element` attribute that triggers the execution
+ `jQueryElement`: the same as before, but the `jQuery` counterpart
+ `params`: any params that the tag has, in this case this is undefined, it works with the `data-ob-params` attribute
+ `model`: any data that you want to bind to this directive, in this case this is undefined, it works with the `data-ob-model` attribute


```
<script type="text/javascript">
    var SimpleDirective=function(data) {
        console.log(data.domElement);
    };
    
    Oblique().registerDirective("SimpleDirective", SimpleDirective);
</script>
<p data-ob-directive="SimpleDirective">simple example<p>

```

