# `oblique.js`

`oblique.js` is a framework that lets your structure web apps by providing:

+ **Directives** to organise & execute code in page
+ **Model & model selection** to bind data in page with code & DOM elements
+ **Params** to send config data to code
+ **Templates** to do big DOM manipulations (it uses [handlebars](http://handlebarsjs.com/))

## Requeriments

Currently `oblique.js` needs  [jQuery](http://jquery.com/) to work properly. If you want to use the template system, you need to load also [handlebars](http://handlebarsjs.com/).

## Installation

Just download `oblique.js` or `oblique.min.js` file and load it after [jQuery](http://jquery.com/) and (optionally) [handlebars](http://handlebarsjs.com/)

```<script type="text/javascript" src="https://raw.githubusercontent.com/josecgil/oblique-js/master/dist/oblique.min.js"></script>```

## An overview

`oblique.js` constantly searchs the entire DOM tree for elements with the `data-ob-directive` attribute. When an element is found, it process it and marks the element as 'processed' so the next time does'nt find it.

At the core of `oblique.js` the are a two elements: 
+ a DOM Element thats declares code to execute and data to be sent to the code.
+ a javascript constructor function (or more than one) that will be called when oblique.js finds the element

The most simple DOM element look like this:

```<p data-ob-directive="HelloDirective">simple example</p>```

It has an important attribute `data-ob-directive`, that declares the name of the constructor function that `oblique.js` must call when it finds this element. When the element is found it instantiates a new object with the constructor function (in this case, `new HelloDirective()`).

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

These functions are called `Directives` in `oblique.js` jargon. Hence the name of the function `HelloDirective`. Directives are like an orchestra conductor, they are the core of the execution process.

Directives are registered through the `Oblique().registerDirective()` function, as you can see `Oblique()` is the function through which you can access all the functionality of `oblique.js`.

## Execution lifecycle

In `oblique.js` it goes like this:

+ When `oblique.js` is loaded and the DOM is ready it sets a timer to search the DOM every 400ms
+ on every execution
   + it searchs for elements with the `data-ob-directive` attribute not already processed
   + it extracts all the directives names declared in element
   + it parse the attributes beginning with data-ob and builds a 'data' object
   + it instantiate a new object with the constructor function named like the directive and it sends a [data](#the-data-param) object as the first param

## The data param

All `Directives` receive a `data` param with info related to the context of the DOM element that triggers its excution and more data from the page (controlled by the `data-ob-model` & `data-ob-params` attributes). 

`data` is a params that contains several properties:

+ `domElement`: the HTMLElement that contains the `data-ob-element` attribute that triggers its execution
+ `jQueryElement`: the same as before, but the `jQuery` counterpart
+ `params`: any params that the DOM element has, in this case this is undefined, it works with the `data-ob-params` attribute
+ `model`: any data that you want to bind to this directive, in this case this is undefined, it works with the `data-ob-model` attribute

## The data-ob-params attribute

The `data-ob-params` is a form to send config params to a directive. The format of the params is JSON.

```
<p data-ob-directive="PopupDirective" data-ob-params="{\"width\":\"200px\", \"height\":\"100px\"}">Popup content</p>
```

In this example, the `PopupDirective` will receive a JSON object in the `data.params` property:

```
<script type="text/javascript">
    var PopupDirective=function(data) {
        var params=data.params;
        //Popup code
    };
    
    Oblique().registerDirective("PopupDirective", PopupDirective);
</script>
```

`data-params` value would be 
```
{
    width:"200px",
    height:"100px"
}
```

##The Model

In oblique.js the Model is the data needed by the page. There are three related items that works with the model.

+ The `Oblique.setModel()` function, that sets all the data for the page (as an object)
+ The `data-ob-model` attribute that selectes what data goes to the directive
+ The `Model` reserved word (used inside `data-ob-model` attribute)

Let's start with the `Oblique().setModel()` function. It inform `oblique.js` that all directives in the page has the possibility to work with some kind of data.

`data-ob-model` then selects what part of the Model is send to a directive in a concrete case.

###A simple example

Let's say you have a data in you page refered to the current logged user:

```
<script type="text/javascript">
    var loggedUser={ name: "josecgil", isPremium: true };
</script>
```

And an image in the html that you what to show only when the logger user is a premium user.

```
<img src="/images/premium_user.jpg" />
```

To code the behaviour of showing the image or not you need to write javascript. The place to do this in `oblique.js` is to create and register a `Directive`:

```
<script type="text/javascript">
    var PremiumBadgeDirective=function() {
        //code to show or hide premium image
    };
    
    Oblique().registerDirective("PremiumBadgeDirective", PremiumBadgeDirective);
</script>
```

To bind this `Directive` to the tag you need to set an attribute `data-ob-directive` with the name of the registered directive:

```
<img src="/images/premium_user.jpg" data-ob-directive="PremiumBadgeDirective" />
```

But, to show or hide the image you need the data of the current logged user. ¿How to send the needed data to the `PremiumBadgeDirective`?

A. Set the model in `oblique.js`

```
<script type="text/javascript">
    var loggedUser={ name: "josecgil", isPremium: true };
    Oblique().setModel(loggedUser);
</script>
```

B. Select the part of the model you want to pass in `data-ob-model` attribute. If you use the reserved word `Model` it means all the data set previously in `Oblique.setModel()` will be sent to the directive.

```
<img src="/images/premium_user.jpg" data-ob-directive="PremiumBadgeDirective" data-ob-model="Model"/>
```

This tag declares the execution of a registered "PremiumBadgeDirective" function and sends all the Model data to it (that what the reserved word `Model` means). 

The final javascript code looks like this:

```
<script type="text/javascript">
    var PremiumBadgeDirective=function(data) {
        isPremiumUser=data.Model.isPremium;
        premiumImage=data.jQueryElement;
        if (isPremiumUser) {
            premiumImage.show();
        } else {
            premiumImage.hide();
        }
    };
    
    Oblique().registerDirective("PremiumBadgeDirective", PremiumBadgeDirective);

    var loggedUser={ name: "josecgil", isPremium: true };
    Oblique().setModel(loggedUser);
</script>
```

### What can you do with the data-ob-model attribute

A. Select a part of a model

Lets say you have a complex model:

```
<script type="text/javascript">
    var cart=
    {
        user:
        {
            name: "Carlos",
            surname: "Gil",
            address:
            {
                street: "Gran Via",
                number: 32,
                city: "Barcelona"
            }
        },
        products:
            [
                { title:"Dune", price: 32, currency: "Euro"},
                { title:"1984", price: 23, currency: "Euro"},
                { title:"At the mountains of madness", price: 13, currency: "Euro"}
            ],
        promotionCode: "DUCKDAY"
    };

    Oblique().setModel(cart);
</script>
```

With `data-ob-model="Model"` you send all this data to the directive.

With `data-ob-model="Model.user"` you send the user object (name, surname, address...).

With `data-ob-model="Model.user.address.city"` you send "Barcelona" to the directive.

With `data-ob-model="Model.products[0]"` you send the first product data to the directive.

B. Execute a javascript expression 

The result of the executed expression will be assigned to de model property in the data param received by the directive.

With `data-ob-model="new Cart()"` you send an instance of Cart to the directive.

With `data-ob-model="format(new Date())"` you send the result of the global function format.

With `data-ob-model="new Address(Model.address)"` you send an instance of Address that receives the address part of the model.

C. Assign a variable and use it later

if you execute code that creates a local variable, like this:

`data-ob-model="var anAddress=new Address(Model.address)"`

In this case, `oblique.js` does two things:

a. it assign the variable as the model of the directive when it finds it
b. it remembers the name and value of the variable so other `data-ob-model` attributes can use it as an expression.

The next html is valid in `oblique.js`:

```
<div data-ob-model="var anAddress=new Address(Model.address)">
    <!--some html-->
</div>

    <p data-ob-model="anAddress">
        <!--some html-->
    </p>
   
```

The second expression `data-ob-model="anAddress"` retrieves the `anAdress` variable from an especial oblique storage so `anAddress` is the same instance of the same object that the previous one `data-ob-model` attribute.

##Templates

`oblique.js` uses [handlebars](http://handlebarsjs.com/) as his template system, it exposes the `Oblique().renderHtml(pathToTemplate, object)` method to use `handlebars`. 

The next example uses a simple object (name, surname) to render an html like this:

```
<div id="hellouser">
    <p>Hello <strong>Edgar</strong>Allan</p>
</div>
```
The javascript part will look like this:

```
<script type="text/javascript">
    //this is the object 
    var user=
    {
        name: "Edgar",
        surName: "Allan"
    }
    
    //builds an string from the template and the data from the model
    var helloUserHtml=Oblique().renderHtml("/templates/hellouser.hbs", user);
    //changes a DOM element with the html from the previous step
    $("#hellouser").html(helloUserHtml);
</script>
```

The template part (`/templates/hellouser.hbs` file) will be:

```
<p>Hello <strong>{{name}}</strong>{{surname}}</p>
```

**Note**: `handlebars` must be loaded before the use of the `Oblique().renderHtml()` method.

For a complete reference of the template language check [handlebars website](http://handlebarsjs.com/)

##Error handling

`oblique.js` has an `onError` event where you can register a function to be called when an error is throw. Here is an example:

```
Oblique().onError(function(error) {
    //Code to handle the error

    //error.name is the name of the error
    //error.message is the description of the error
});
```

`error` is the Error object, it has `name` and a `message` property.

##A note on inserting new 'data-ob-directives' via DOM manipulation

##Interval to check for directives

##More samples

To learn more and see more complex examples check the [samples directory](http://github.com/josecgil/oblique-js/tree/master/samples)
