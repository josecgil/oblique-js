Possible design decisions
--------------------------

* Framework design should be guided by the principle of least astonishment
* Faster change detection in modern browsers that support DOM event change detection.
Fallback to timeout if not.
* Modular & testable. Framework & app code should be easily testable.

* The framework shouldn't inject his ideas in the app code that uses it
(initially could be opinionated)

* It should use and collaborate (if possible) with other common JS libraries (jQuery,
 jQueryLite, mootools, yui, underscore...) If this libraries are not present,
 or choosed bu user, it should use it's own mechanisms
* It must not slow down or add unacceptable memory footprint to the app


Possible next steps
----------------------

* Change licence to MIT or BSD, to allow propietary software to use this
* Change project name?
* ¿Refactor tests & code: better naming, SOLID... or full scale rewrite?
* Add jasmine specRunner (karma?)
* Generate & use source maps
* Reduce / isolate dependency from jQuery
* Possibility to create adapters for other js libraries (jquery, jquerylite, mootols, prototype...) and our own Default implementation. Current needs:
    * match an element to a CSSExpression
    * save/retrieve data on DOMElement,
    * detect DOM.ready
    * detect DOM changes ...

* Add tests coverage tool
* Rework samples to more beautiful presentation (bootstrap?)
* Extract real directives from current CMS

* Add http://benchmarkjs.com/ test to ensure changes does'nt degrade performance
below a certain threshold

* Multibrowser / OS testing

* Change timeout style detection to DOMSubTreeChanged/MutationObserver when available
    http://stackoverflow.com/questions/2844565/is-there-a-jquery-dom-change-listener
    http://help.dottoro.com/ljrmcldi.php
    TimedDOMObserver
    DOMChangeObserver
    MutationObserver
    (previous refactor, extract timeout related code to TimedDOMObserver)

* Change detection currently only know that DOM changes, but not what elements
Improve to know what elements changed from previous state and only process those.
    ¿Use md5 to know what content change?
    http://stackoverflow.com/questions/1655769/fastest-md5-implementation-in-javascript

* ¿Expose current internal APIs as public? ¿Do as jQuery an only expose one large facade object?

* Possibility to create POO style or Functional style directives.
The Framework must not impose programming style/paradigm

* Add destroy (optional) method to directives to call when DOMElements are removed (to clearTimeouts, cancel current operations, free resources...)

* Change CSSExpression to mustApply(). A method/function is more flexible

* Document with doku + github pages (jasmine docs style)

* ¿Add common needs?
    * http module: sync, async, html, json, url parsing...
    * html templating
    * instrumentation
    * logging
    * common extensions to base objects, String.trim(), Array.Contains(),
    Array.sort(), Object.shallowClone(), Object.DeepClone(), ...
    * methods / properties to be compatible on multiple browsers / versions
    of ECMAScript...
    * cookies