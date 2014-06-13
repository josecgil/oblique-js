// Generated by CoffeeScript 1.7.1
(function() {
  var Element;

  this.ObliqueNS = this.ObliqueNS || {};

  Element = (function() {
    function Element(DOMElement) {
      this._DOMElement = DOMElement;
      this._jQueryElement = jQuery(DOMElement);
    }

    Element.prototype.isTag = function() {
      return Element._isTag(this._DOMElement);
    };

    Element.prototype.matchCSSExpression = function(cssExpression) {
      return this._jQueryElement.is(cssExpression);
    };

    Element.prototype.setFlag = function(flagName) {
      return this._jQueryElement.data(flagName, true);
    };

    Element.prototype.unsetFlag = function(flagName) {
      return this._jQueryElement.removeData(flagName);
    };

    Element.prototype.hasFlag = function(flagName) {
      return this._jQueryElement.data(flagName);
    };

    Element.prototype.hasAttribute = function(attributeName) {
      var attrValue;
      attrValue = this.getAttributeValue(attributeName);
      if (attrValue === void 0) {
        return false;
      }
      return true;
    };

    Element.prototype.getAttributeValue = function(attributeName) {
      return this._jQueryElement.attr(attributeName);
    };

    Element.prototype.eachDescendant = function(callbackOnDOMElement) {
      return Element._traverse(this._DOMElement, callbackOnDOMElement);
    };

    Element._isTag = function(DOMElement) {
      return DOMElement.nodeType === 1;
    };

    Element._traverse = function(parentElement, callbackOnDOMElement) {
      var child, currentElement, elementsToTraverse, _results;
      elementsToTraverse = [];
      if (Element._isTag(parentElement)) {
        elementsToTraverse.push(parentElement);
      }
      callbackOnDOMElement(parentElement);
      _results = [];
      while (elementsToTraverse.length > 0) {
        currentElement = elementsToTraverse.pop();
        _results.push((function() {
          var _i, _len, _ref, _results1;
          _ref = currentElement.children;
          _results1 = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            child = _ref[_i];
            if (Element._isTag(child)) {
              elementsToTraverse.push(child);
              _results1.push(callbackOnDOMElement(child));
            } else {
              _results1.push(void 0);
            }
          }
          return _results1;
        })());
      }
      return _results;
    };

    return Element;

  })();

  ObliqueNS.Element = Element;

}).call(this);

//# sourceMappingURL=Element.map
