![alt tag](https://raw.githubusercontent.com/josecgil/oblique-js/master/logo/ObliqueLogo.jpg)

`oblique.js` is a framework that lets your create web apps providing:

+ **Directives** to organise & execute code in page
+ **Params** to send config data to code
+ **Model & model selection** to bind data in page with code & DOM elements
+ **Templates** to do big DOM manipulations (it uses [handlebars](http://handlebarsjs.com/))
+ **Hash routing** to handle changes & manipulate hash url params
+ **Timed events** to do recurring tasks

##Table of contents

1. [Requeriments](#requeriments)
2. [Installation](#installation)
3. [An overview](#an-overview)
4. [Directives](#directives)
5. [The `data-ob-directive` attribute](#the-data-ob-directive-attribute)
6. [Execution lifecycle](#execution-lifecycle)
7. [The `data param` attribute](#the-data-param)
8. [The `data-ob-params` attribute](#the-data-ob-params-attribute)
9. [The Model](#the-model)
10. [The `data-ob-model` attribute](#the-data-ob-model-attribute)
11. [The `data-ob-var` attribute](#the-data-ob-var-attribute) 
12. [Templates](#templates)
13. [Hash routing](#hash-routing)
14. [Timed events](#timed-events) 
15. [Error handling](#error-handling)
16. [Global Directives](#global-directives)
17. [Notes](#notes)
18. [Learn more](#learn-more)

## Requeriments

Currently `oblique.js` needs  [jQuery](http://jquery.com/) to work properly. If you want to use the template system, you need to load also [handlebars](http://handlebarsjs.com/).

## Installation

Just download `oblique.js` or `oblique.min.js` file and load it after [jQuery](http://jquery.com/) and (optionally) [handlebars](http://handlebarsjs.com/)

```<script type="text/javascript" src="https://raw.githubusercontent.com/josecgil/oblique-js/master/dist/oblique.min.js"></script>```

## An overview

`oblique.js` constantly searchs the entire DOM tree for elements with the `data-ob-directive` attribute (an exception to this are [Global Directives](#global-directives)). When an element is found, it process it and marks the element as 'processed' so the next time does'nt find it.

At the core of `oblique.js` the are a two elements: 
+ a DOM Element thats declares code to execute and data to be sent to the code.
+ a javascript constructor function (or more than one) that will be called when `oblique.js` finds the element. Those functions are called `Directives`

## Directives

The most simple DOM element that uses `oblique.js`look like this:

```<p data-ob-directive="HelloDirective">simple example</p>```

It has an important attribute `data-ob-directive`, that declares the name of the directive that `oblique.js` must call when it finds this element. When the element is found it instantiates a new object with the constructor function that is passed in the `Oblique().registerDirective` method (in this case, `new HelloDirective()`, see the next example).

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

## The data-ob-directive attribute

The `data-ob-directive` attribute can declare multiple directives separated by commas:

```<p data-ob-directive="HelloDirective, GoodbyeDirective">simple example</p>```

## Execution lifecycle

In `oblique.js` it goes like this:

+ When `oblique.js` is loaded and the DOM is ready it sets a timer to search the DOM every 400ms
+ on every execution
   + it searchs for elements with the `data-ob-var` attribute not already processed and creates the variables declared
   + it searchs for elements with the `data-ob-directive` attribute not already processed
   + it extracts all the directives names declared in element
   + it parse the attributes beginning with data-ob and builds a 'data' object
   + it instantiate a new object with the constructor function named like the directive and it sends a [data](#the-data-param) object as the first param

## The data param

All `Directives` receive a `data` param with info related to the context of the DOM element that triggers its execution and more data from the page (controlled by the `data-ob-model` & `data-ob-params` attributes). 

`data` is a params that contains several properties:

+ `domElement`: the HTMLElement that contains the `data-ob-element` attribute that triggers its execution
+ `jQueryElement`: the same as before, but the `jQuery` counterpart
+ `params`: any params that the DOM element has, it works in conjuntion with the `data-ob-params` attribute
+ `model`: any data that you want to bind to this directive, it works in conjuntion with the `data-ob-model` attribute

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

In `oblique.js` the Model is the data needed by the page. There are three related items that works with the model.

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
        isPremiumUser=data.model.isPremium;
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

### The data-ob-model attribute

What can you do with the `data-ob-model` attribute?

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

C. Assign a variable and use it later in the page

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

<p ... data-ob-model="anAddress">
    <!--some html-->
</p>
   
```

The second expression `data-ob-model="anAddress"` retrieves the `anAdress` variable from an especial oblique storage so `anAddress` is the same instance of the same object that the previous one `data-ob-model` attribute.

##The data-ob-var attribute

You can create variables in `oblique.js` and use it in `data-ob-model`  or `data-ob-var` expressions with the `data-ob-var` attribute. This attribute can be declared without a `data-ob-directive` attribute in the same tag.

Here is an usage example:
```
<div data-ob-var="var anAddress=new Address(Model.address)">
    <!--some html-->
</div>

<p ... data-ob-model="anAddress">
    <!--some html-->
</p>
   
```
And here is another usage example:

```
<div data-ob-var="var number=2"></div>
<div data-ob-var="var otherNumber=number+2"></div>

<p ... data-ob-model="otherNumber">
    <!--some html-->
</p>
   
```

Note: variables are always executed before any directive execution.

##Templates

`oblique.js` uses [handlebars](http://handlebarsjs.com/) as his template system, it exposes the `Oblique().renderHtml(pathToTemplate, object)` method to use `handlebars`. 

The next example uses a simple object (name, surname) to render an html like this:

```
<div id="hellouser">
    <p>Hello <strong>Edgar</strong>Allan Poe</p>
</div>
```
The javascript part will look like this:

```
<script type="text/javascript">
    //this is the object 
    var user=
    {
        name: "Edgar",
        surName: "Allan Poe"
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

##Hash routing

Hash routing refers to the hability to check & change document.location.hash values. `oblique.js` provides an easy way to get, add, modify & remove hash params from url & to notify you when params are changed.

###Check hash route params
Calling `Oblique().getHashParams()` you get a `ParamCollection` object that allows you to check, add, modify and delete current hash params.

It has the following methods to check route values:

+ `getParam(nameOfParam)`: returns a `Param` object that allows to check and modify any individual param.
+ `isEmpty()`: returns true if there is no hash params in the collection, otherwise return false.

You can get a `Param` object with the method `getParam(nameOfParam)` of a 
`ParamCollection` object.
Depending of the param you can get 4 types of `Param` object:
+ ArrayParam: representing a param with multiples values. It has a `values` property where you can check or change his values.
+ RangeParam: representing a param with a min and a max value. It has a `min` and `max` property where you can check or change his values.  
+ SingleParam: representing a param with a single value. It has a `value` property where you can check or change his values. 
+ EmptyParam: representing an empty or non-existent param. It doesn't have values properties.

Any of there param objects has a method `isEmpty()` that returns true if param has no value. 

Example:

```
//Let's supose I have an url with this hash params:
//#sizes=[S, M, L]&price=(9,26)&color=red
var params=Oblique()..getHashParams();
var sizesParam=params.getParam("sizes"); //ArrayParam
var priceParam=params.getParam("price"); //RangeParam
var colorParam=params.getParam("color"); //SingleParam
var noneParam=params.getParam("foobar"); //EmptyParam

var noneIsEmpty=noneParam.isEmpty() //true
var sizesIsEmpty=sizesParam.IsEmpty() //false

var sizes=sizesParam.values; //["S" , "M", "L"]
var priceMIn=priceParam.min; //"9"
var priceMax=priceParam.max; //"26"
var color=colorParam.value; //"red"
```

###Add hash route params

You add hash params 
+ getting `ParamCollection` object via `Oblique().getHashParams()`
+ calling methods of this object to mofify its values 
+ and then setting the modified `ParamCollection` object via `Oblique().setHashParams(params)`.

`ParamCollection` object has the following methods to add route values:
+ `addArrayParam(nameOfParam, arrayValuesOfParam)`: adds a param of type array. 
+ `addRangeParam(nameOfParam, minValue, maxValue)`: adds a param of type range (composed of a min and a max value)
+ `addSingleParam(nameOfParam, value)`: adds a param of type single.

Examples:
```
//Let's supose i have an url with this hash params:
//#source=1

var params=Oblique().getHashParams();
params.addArrayParam("sizes",["S","M","L"]);
params.addRangeParam("price", 25 , 50);
params.addSingleParam("color","green");

Oblique().setHashParams(params);

//sets the url to 
//#source=1&sizes=[S,M,L]&price=(25,50)&color=green
```

###Modify hash route params

To modify a param you:  

+ get the `ParamCollection` object via `Oblique().getHashParams()`
+ get the `Param` object you want via `getParam(nameOfParam)`
+ modify the `Param` values (see examples below)
+ set the modified `ParamCollection` object via `Oblique().setHashParams(paramCollection)`

Examples:
```
//Let's supose i have an url with this hash params:
//#sizes=[S, M, L]&price=(9,26)&color=red
var params=Oblique().getHashParams();
var sizesParam=params.getParam("sizes"); //ArrayParam
var priceParam=params.getParam("price"); //RangeParam
var colorParam=params.getParam("color"); //SingleParam

sizesParam.values=["XL", "XXL"];
priceParam.min=1;
priceParam.max=100;
colorParam.value="blue";

Oblique().setHashParams(params);
//New hash is:
//#sizes=[XL, XXL]&price=(1,100)&color=blue
```

###Remove hash route params
To remove a hash params you
+ get a `ParamCollection` object via `Oblique().getHashParams()`
+ call `remove(nameOfParam)` or `removeAll()`  
+ set the modified `ParamCollection` object via `Oblique().setHashParams(params)`.

Example:
```
//Let's supose I have an url with this hash params:
//#sizes=[S, M, L]&price=(9,26)&color=red

var params=Oblique().getHashParams();
params.remove("sizes") 
Oblique().setHashParams(params); //this last line is when the change really occurs.
//New hash is:
//#price=(1,100)&color=blue
```

###Listen to changes in hash route params

`oblique.js` provides a convenient mechanism to listen to changes in hash params. You can add a function `onHashChange` to every `directive`. `oblique.js` will call this function on every hash change passing an object with a `ParamCollection` object.   


This is an example we listen to changes in hash for a `price` param:

```
var PriceDirective=function (data) {

};

PriceDirective.prototype.onHashChange=function(data) {
   var priceParam=data.hashParams.getParam("price");
   if (priceParam.isEmpty()) {
       //do whatever when is empty
       return;
   }
   //do whatever when is not empty
};

Oblique().registerDirective("PriceDirective", PriceDirective);
```


###samples

In  [samples/Filters directory](http://github.com/josecgil/oblique-js/tree/master/samples/Filters) there is a complete & functional sample thats uses all the hash routing functionality.

##Timed events

Every directive you create in `oblique.js` has the possibility to listen to an `onInterval` event. This event is fired every 400ms (this default can be changed via `Oblique().setIntervalTimeInMs()`). Let's see an example:

```
var TimedExampleDirective=function () {

};

TimedExampleDirective.prototype.onInterval=function() {
	//This event is fired every 400ms by default
	console.log("It's time to do some work!");
};
```

In  [samples/Timer directory](https://github.com/josecgil/oblique-js/tree/master/samples/Timer) there is a complete & functional sample thats uses the timed events functionality.

##Global Directives

Sometimes you want to execute some code that isn't related to an especific part of the DOM. There are two ways to do this:

1) Attach the directive to the body or html tag. Example:

```
<html>
	<head>
		<title>Document title</title>
	</head>
	<body data-ob-directive="GlobalDirective">
	...
	</body>
</html>
```
An then create a normal directive:

```
var GlobalDirective=function () {
	//Some code not related to the body tag
};

Oblique().registerDirective("GlobalDirective", GlobalDirective);
```

2) Register the directive as Global using `Oblique().registerDirectiveAsGlobal` method. This will execute the directive when the DOM is ready and will tie the directive to the root element of the document:

```
var GlobalDirective=function () {
	//Some code not related to the body tag
};

Oblique().registerDirectiveAsGlobal("GlobalDirective", GlobalDirective);
```
This is the prefered way.

##Error handling

`oblique.js` has an `onError` event where you can register a function to be called when an error is throw. Here is an example:

```
<script type="text/javascript">
    Oblique().onError(function(error) {
        //Code to handle the error
    
        //error.name is the name of the error
        //error.message is the description of the error
    });
</script>
```

`error` is the Error object, it has `name` and a `message` property.

##Notes

###On inserting new 'data-ob-directives' via DOM manipulation

`oblique.js` checks the DOM on the moment the DOM is loaded, and then every 400ms (by default) to check for directives loaded dinamically (via DOM manipulation). So, if you use AJAX, your app is a Single Page Application (SPA) or do intensive DOM manipulation there is no problem to use `oblique.js`, it will find and execute dinamically loaded directives.

###Interval to check for directives

By default, `oblique.js` checks the DOM every 400ms, but you can change this via the `Oblique().setIntervalTimeInMs()`. This algo changes the frequency of the `onInterval()` event.

For example, if you want that `oblique.js` checks the DOM every second, you can do:

```
<script type="text/javascript">
    Oblique().setIntervalTimeInMs(1000);
</script>
```

##Learn more
To learn more and see more complex examples check the [samples directory](http://github.com/josecgil/oblique-js/tree/master/samples)

You can learn more about every object of the system checking usage cases in the [spec directory](https://github.com/josecgil/oblique-js/tree/master/spec)
