// Generated by CoffeeScript 1.7.1
(function() {
  var DirectiveCollection, DirectiveProcessor, Element, Error, JSON, NamedParams, Oblique, ObliqueError, Param, TimedDOMObserver,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.ObliqueNS = this.ObliqueNS || {};

  DirectiveCollection = (function() {
    function DirectiveCollection() {
      this.directives = [];
      this._cssExpressions = [];
    }

    DirectiveCollection.prototype.count = function() {
      return this.directives.length;
    };

    DirectiveCollection.prototype._isAFunction = function(memberToTest) {
      return typeof memberToTest === "function";
    };

    DirectiveCollection.NOT_A_FUNCTION_CLASS_ERROR_MESSAGE = "registerDirective must be called with a Directive 'Constructor/Class'";

    DirectiveCollection.DOESNT_HAVE_PROPERTY_CSS_EXPR_MESSAGE = "directive must has an static CSS_EXPRESSION property";

    DirectiveCollection.prototype._throwErrorIfDirectiveIsNotValid = function(directive) {
      if (!this._isAFunction(directive)) {
        throw new ObliqueNS.Error(ObliqueNS.DirectiveCollection.NOT_A_FUNCTION_CLASS_ERROR_MESSAGE);
      }
      if (!directive.CSS_EXPRESSION) {
        throw new ObliqueNS.Error(ObliqueNS.DirectiveCollection.DOESNT_HAVE_PROPERTY_CSS_EXPR_MESSAGE);
      }
    };

    DirectiveCollection.prototype._hashCode = function(str) {
      var chr, hash, i, len;
      hash = 0;
      i = void 0;
      chr = void 0;
      len = void 0;
      if (str.length === 0) {
        return hash;
      }
      i = 0;
      len = str.length;
      while (i < len) {
        chr = str.charCodeAt(i);
        hash = ((hash << 5) - hash) + chr;
        hash |= 0;
        i++;
      }
      return hash;
    };

    DirectiveCollection.prototype.add = function(directive) {
      this._throwErrorIfDirectiveIsNotValid(directive);
      directive.hashCode = this._hashCode(directive.toString() + directive.CSS_EXPRESSION).toString();
      this.directives.push(directive);
      return this._buildCSSExpressions();
    };

    DirectiveCollection.prototype.at = function(index) {
      return this.directives[index];
    };

    DirectiveCollection.prototype._containsCssExpr = function(exprToSearch, exprArray) {
      var expr, _i, _len;
      for (_i = 0, _len = exprArray.length; _i < _len; _i++) {
        expr = exprArray[_i];
        if (exprToSearch === expr) {
          return true;
        }
      }
      return false;
    };

    DirectiveCollection.prototype._buildCSSExpressions = function() {
      var cssExpr, directive, _i, _len, _ref, _results;
      this._cssExpressions = [];
      _ref = this.directives;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        directive = _ref[_i];
        cssExpr = directive.CSS_EXPRESSION;
        if (this._containsCssExpr(cssExpr, this._cssExpressions)) {
          continue;
        }
        _results.push(this._cssExpressions.push(cssExpr));
      }
      return _results;
    };

    DirectiveCollection.prototype.getCSSExpressions = function() {
      return this._cssExpressions;
    };

    DirectiveCollection.prototype.getDirectivesByCSSExpression = function(cssExpression) {
      var cssExpr, directive, directivesWithCSSExpr, _i, _len, _ref;
      directivesWithCSSExpr = [];
      _ref = this.directives;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        directive = _ref[_i];
        cssExpr = directive.CSS_EXPRESSION;
        if (cssExpr !== cssExpression) {
          continue;
        }
        directivesWithCSSExpr.push(directive);
      }
      return directivesWithCSSExpr;
    };

    return DirectiveCollection;

  })();

  ObliqueNS.DirectiveCollection = DirectiveCollection;

  this.ObliqueNS = this.ObliqueNS || {};

  DirectiveProcessor = (function() {
    function DirectiveProcessor() {
      if (this === window) {
        return new DirectiveProcessor();
      }
      if (DirectiveProcessor._singletonInstance) {
        return DirectiveProcessor._singletonInstance;
      }
      DirectiveProcessor._singletonInstance = this;
      this._throwErrorIfJQueryIsntLoaded();
      this._directiveCollection = new ObliqueNS.DirectiveCollection();
      this._timedDOMObserver = this._createTimedDOMObserver(DirectiveProcessor.DEFAULT_INTERVAL_MS);
      jQuery(document).ready((function(_this) {
        return function() {
          _this._applyDirectivesInDOM();
          return _this._timedDOMObserver.observe();
        };
      })(this));
    }

    DirectiveProcessor.DEFAULT_INTERVAL_MS = 500;

    DirectiveProcessor.prototype._throwErrorIfJQueryIsntLoaded = function() {
      if (!window.jQuery) {
        throw new Error("DirectiveProcessor needs jQuery to work");
      }
    };

    DirectiveProcessor.prototype._createTimedDOMObserver = function(intervalInMs) {
      var observer;
      observer = new ObliqueNS.TimedDOMObserver(intervalInMs);
      observer.onChange((function(_this) {
        return function() {
          return _this._applyDirectivesInDOM();
        };
      })(this));
      return observer;
    };

    DirectiveProcessor._isApplyingDirectivesInDOM = false;

    DirectiveProcessor.prototype._applyDirectivesInDOM = function() {
      var rootDOMElement, rootElement;
      if (this._isApplyingDirectivesInDOM) {
        return;
      }
      this._isApplyingDirectivesInDOM = true;
      try {
        rootDOMElement = document.getElementsByTagName("body")[0];
        rootElement = new ObliqueNS.Element(rootDOMElement);
        return rootElement.eachDescendant((function(_this) {
          return function(DOMElement) {
            var cssExpr, directive, directiveHashCode, model, obElement, _i, _len, _ref, _results;
            obElement = new ObliqueNS.Element(DOMElement);
            _ref = _this._directiveCollection.getCSSExpressions();
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              cssExpr = _ref[_i];
              if (!obElement.matchCSSExpression(cssExpr)) {
                continue;
              }
              _results.push((function() {
                var _j, _len1, _ref1, _results1;
                _ref1 = this._directiveCollection.getDirectivesByCSSExpression(cssExpr);
                _results1 = [];
                for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
                  directive = _ref1[_j];
                  directiveHashCode = directive.hashCode;
                  if (obElement.hasFlag(directiveHashCode)) {
                    continue;
                  }
                  obElement.setFlag(directiveHashCode);
                  model = this._getModel(obElement);
                  _results1.push(new directive(DOMElement, model));
                }
                return _results1;
              }).call(_this));
            }
            return _results;
          };
        })(this));
      } finally {
        this._isApplyingDirectivesInDOM = false;
      }
    };

    DirectiveProcessor.prototype._getModel = function(obElement) {
      var dataModelExpr, model;
      if (!obElement.hasAttribute("data-model")) {
        return void 0;
      }
      model = Oblique().getModel();
      if (!model) {
        return void 0;
      }
      dataModelExpr = obElement.getAttributeValue("data-model");
      if (dataModelExpr === "this") {
        return model;
      }
      try {
        return new ObliqueNS.JSON(model).getPathValue(dataModelExpr);
      } catch (_error) {
        return this._throwError(obElement.getHtml() + ": data-model doesn't match any data in model");
      }

      /*
      results=jsonPath(model, dataModelExpr)
      @_throwError(obElement.getHtml() + ": data-model doesn't match any data in model") if not results
      @_throwError(obElement.getHtml() + ": data-model match many data in model") if results.length > 1
      results[0]
       */
    };

    DirectiveProcessor.prototype._throwError = function(errorMessage) {
      return Oblique().triggerOnError(new ObliqueNS.Error(errorMessage));
    };

    DirectiveProcessor.prototype.getIntervalTimeInMs = function() {
      return this._timedDOMObserver.getIntervalInMs();
    };

    DirectiveProcessor.prototype.setIntervalTimeInMs = function(newIntervalTimeInMs) {
      if (newIntervalTimeInMs <= 0) {
        throw new ObliqueNS.Error("IntervalTime must be a positive number");
      }
      this._timedDOMObserver.destroy();
      this._timedDOMObserver = this._createTimedDOMObserver(newIntervalTimeInMs);
      return this._timedDOMObserver.observe();
    };

    DirectiveProcessor.prototype.registerDirective = function(directiveConstructorFn) {
      return this._directiveCollection.add(directiveConstructorFn);
    };

    DirectiveProcessor.prototype.destroy = function() {
      var e;
      this._timedDOMObserver.destroy();
      try {
        return delete DirectiveProcessor._singletonInstance;
      } catch (_error) {
        e = _error;
        return DirectiveProcessor._singletonInstance = void 0;
      }
    };

    return DirectiveProcessor;

  })();

  ObliqueNS.DirectiveProcessor = DirectiveProcessor;

  this.Oblique = DirectiveProcessor;

  this.ObliqueNS = this.ObliqueNS || {};

  Element = (function() {
    function Element(DOMElement) {
      this._jQueryElement = jQuery(DOMElement);
    }

    Element.prototype._getDOMElement = function() {
      return this._jQueryElement.get(0);
    };

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
      return Element._traverse(this._getDOMElement(), callbackOnDOMElement);
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

    Element.prototype.getHtml = function() {
      return this._getDOMElement().outerHTML;
    };

    return Element;

  })();

  ObliqueNS.Element = Element;

  this.ObliqueNS = this.ObliqueNS || {};

  Error = (function() {
    function Error(message) {
      this.message = message;
      if (this === window) {
        return new Error(this.message);
      }
      this.name = "Oblique.Error";
    }

    return Error;

  })();

  ObliqueNS.Error = Error;

  this.ObliqueNS = this.ObliqueNS || {};

  JSON = (function() {
    function JSON(value) {
      this.value = value;
    }

    JSON.prototype.getPathValue = function(path) {
      var part, parts, value, _i, _len;
      parts = path.split(".");
      value = this.value;
      for (_i = 0, _len = parts.length; _i < _len; _i++) {
        part = parts[_i];
        if (!value.hasOwnProperty(part)) {
          throw new ObliqueNS.Error("'" + path + "' not found in JSON Object");
        }
        value = value[part];
      }
      return value;
    };

    return JSON;

  })();

  ObliqueNS.JSON = JSON;

  this.ObliqueNS = this.ObliqueNS || {};

  Param = ObliqueNS.Param;

  NamedParams = (function() {
    function NamedParams(params, paramSeparator, valueSeparator) {
      var param, _i, _len, _ref;
      if (paramSeparator == null) {
        paramSeparator = ";";
      }
      if (valueSeparator == null) {
        valueSeparator = ":";
      }
      this.params = [];
      _ref = params.split(paramSeparator);
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        param = _ref[_i];
        this.params.push(new Param(param, valueSeparator));
      }
    }

    NamedParams.prototype.getParam = function(paramName) {
      var param, _i, _len, _ref;
      _ref = this.params;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        param = _ref[_i];
        if (param.name === paramName) {
          return param;
        }
      }
      return null;
    };

    return NamedParams;

  })();

  ObliqueNS.NamedParams = NamedParams;

  this.ObliqueNS = this.ObliqueNS || {};

  Oblique = (function() {
    function Oblique() {
      if (this === window) {
        return new Oblique();
      }
      if (Oblique._singletonInstance) {
        return Oblique._singletonInstance;
      }
      Oblique._singletonInstance = this;
      this.directiveProcessor = new ObliqueNS.DirectiveProcessor();
      this._onErrorCallback = function() {};
    }

    Oblique.DEFAULT_INTERVAL_MS = 500;

    Oblique.prototype.getIntervalTimeInMs = function() {
      return this.directiveProcessor.getIntervalTimeInMs();
    };

    Oblique.prototype.setIntervalTimeInMs = function(newIntervalTimeInMs) {
      return this.directiveProcessor.setIntervalTimeInMs(newIntervalTimeInMs);
    };

    Oblique.prototype.registerDirective = function(directiveConstructorFn) {
      return this.directiveProcessor.registerDirective(directiveConstructorFn);
    };

    Oblique.prototype.destroy = function() {
      var e;
      this.directiveProcessor.destroy();
      try {
        return delete Oblique._singletonInstance;
      } catch (_error) {
        e = _error;
        return Oblique._singletonInstance = void 0;
      }
    };

    Oblique.prototype.setModel = function(_model) {
      this._model = _model;
    };

    Oblique.prototype.getModel = function() {
      return this._model;
    };

    Oblique.prototype.hasModel = function() {
      if (this._model) {
        return true;
      }
      return false;
    };

    Oblique.prototype.onError = function(_onErrorCallback) {
      this._onErrorCallback = _onErrorCallback;
    };

    Oblique.prototype.triggerOnError = function(error) {
      this._onErrorCallback(error);
      throw error;
    };

    return Oblique;

  })();

  ObliqueNS.Oblique = Oblique;

  this.Oblique = Oblique;

  this.ObliqueNS = this.ObliqueNS || {};

  ObliqueError = (function(_super) {
    __extends(ObliqueError, _super);

    function ObliqueError(message) {
      this.message = message;
      if (this === window) {
        return new Error(this.message);
      }
      this.name = "ObliqueNS.Error";
    }

    return ObliqueError;

  })(Error);

  ObliqueNS.Error = ObliqueError;

  this.ObliqueNS = this.ObliqueNS || {};

  Param = (function() {
    function Param(param, valueSeparator) {
      var paramAndValue;
      if (valueSeparator == null) {
        valueSeparator = ":";
      }
      paramAndValue = param.split(valueSeparator);
      this.name = paramAndValue[0].trim();
      this.value = paramAndValue[1].trim();
    }

    Param.prototype.valueAsInt = function() {
      return parseInt(this.value, 10);
    };

    return Param;

  })();

  ObliqueNS.Param = Param;

  this.ObliqueNS = this.ObliqueNS || {};

  TimedDOMObserver = (function() {
    function TimedDOMObserver(intervalInMs) {
      this.intervalInMs = intervalInMs;
      this._intervalId = void 0;
      this._callback = function() {};
    }

    TimedDOMObserver.prototype.onChange = function(callback) {
      return this._callback = callback;
    };

    TimedDOMObserver.prototype.getIntervalInMs = function() {
      return this.intervalInMs;
    };

    TimedDOMObserver.prototype.observe = function() {
      return this._intervalId = setInterval((function(_this) {
        return function() {
          return _this._callback();
        };
      })(this), this.intervalInMs);
    };

    TimedDOMObserver.prototype.destroy = function() {
      if (this._intervalId) {
        clearInterval(this._intervalId);
      }
      return this._intervalId = void 0;
    };

    return TimedDOMObserver;

  })();

  ObliqueNS.TimedDOMObserver = TimedDOMObserver;

}).call(this);
