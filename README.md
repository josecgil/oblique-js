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

## An overview

`oblique.js` constantly searchs the entire DOM tree for elements with the `data-ob-directive` attribute. When an element is found, it process it and marks the element as 'processed' so the next time does'nt find it.

At the core of `oblique.js` the are a two elements: 
+ a DOM Element thats declares behaviours and data.
+ a javascript constructor function (or more than one) that will be called when oblique.js finds the element

The most simple DOM element look like this:

```
    <p data-ob-directive="HelloDirective">simple example</p>

```
It has an important attribute `data-ob-directive`, that declares the name of the constructor function that `oblique.js` must call when it finds this element. When it finds the element it instantiate a new object with the constructor function (in this case, `new HelloDirective()`).

Previously, `HelloDirective` must be registered as a function in `oblique.js`

```
<script type="text/javascript">
    var HelloDirective=function() {
        console.log("Hello world!");
    };
    
    Oblique().registerDirective("HelloDirective", HelloDirective);
</script>
```

The same example in a more concise way:

```
<script type="text/javascript">    
    Oblique().registerDirective("HelloDirective", function() {
        console.log("Hello world!");
    });
</script>

```

These functions are called `Directives` in `oblique.js` jargon. Hence the name of the function `HelloDirective`. Directives are like an orchestra conductor. They are the core of the execution process.

Directives are registered through the Oblique() function, that is the function through which you can access all the functionality of `oblique.js`.

## Directives

Execution lifecicle in `oblique.js` goes like this

+ `oblique.js` sets a timer to search the DOM every 400ms
+ on every execution
   + it searchs for elements with the `data-ob-directive` attribute
   + it extracts all the directives names declared in tag
   + it parse the especial tag attributes (attributes beginning with data-ob) and builds a 'data' object
   + it instantiate a new object with the constructor function named like the directive sending the 'data' object as the first param

### data constructor param

`data` is a params that contains several properties:

+ `domElement`: the HTMLElement that contains the `data-ob-element` attribute that triggers the execution
+ `jQueryElement`: the same as before, but the `jQuery` counterpart
+ `params`: any params that the tag has, in this case this is undefined, it works with the `data-ob-params` attribute
+ `model`: any data that you want to bind to this directive, in this case this is undefined, it works with the `data-ob-model` attribute

