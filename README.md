# `oblique.js`

`oblique.js` is a framework that lets your structure web apps by providing:

+ **Directives** to organise & execute behaviour in page
+ **Model & model selection** to bind data in page with behaviours & DOM elements
+ **Params** to send config data to behaviours
+ **Templates**, it uses [handlebars](http://handlebarsjs.com/) to render html

## A simple example

```
var SimpleDirective=function(data) {
    console.log(data.domElement);
};

Oblique().registerDirective("SimpleDirective", SimpleDirective);

```

