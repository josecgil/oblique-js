// Generated by CoffeeScript 1.7.1
(function() {
  var DirectiveCollection;

  window.ObliqueNS = window.ObliqueNS || {};

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

    DirectiveCollection.prototype.add = function(directive) {
      this._throwErrorIfDirectiveIsNotValid(directive);
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

}).call(this);
// Generated by CoffeeScript 1.7.1
(function() {
  var DirectiveProcessor;

  window.ObliqueNS = window.ObliqueNS || {};

  DirectiveProcessor = (function() {
    var Element;

    Element = ObliqueNS.Element;

    function DirectiveProcessor() {
      if (this === window) {
        return new DirectiveProcessor();
      }
      if (DirectiveProcessor._singletonInstance) {
        return DirectiveProcessor._singletonInstance;
      }
      DirectiveProcessor._singletonInstance = this;
      this._throwErrorIfJQueryIsntLoaded();
      this._intervalTimeInMs = DirectiveProcessor.DEFAULT_INTERVAL_MS;
      this._lastIntervalId = void 0;
      this._directiveCollection = new ObliqueNS.DirectiveCollection();
      this._listenToDirectivesInDOM();
    }

    DirectiveProcessor.DEFAULT_INTERVAL_MS = 500;

    DirectiveProcessor.prototype._throwErrorIfJQueryIsntLoaded = function() {
      if (!window.jQuery) {
        throw new Error("DirectiveProcessor needs jQuery to work");
      }
    };

    DirectiveProcessor.prototype._clearLastInterval = function() {
      if (this._lastIntervalId !== void 0) {
        return clearInterval(this._lastIntervalId);
      }
    };

    DirectiveProcessor.prototype._applyDirectivesOnDocumentReady = function() {
      return jQuery(document).ready((function(_this) {
        return function() {
          return _this._applyDirectivesInDOM();
        };
      })(this));
    };

    DirectiveProcessor.prototype._setNewInterval = function() {
      return this._lastIntervalId = setInterval((function(_this) {
        return function() {
          return _this._applyDirectivesInDOM();
        };
      })(this), this._intervalTimeInMs);
    };

    DirectiveProcessor.prototype._listenToDirectivesInDOM = function() {
      this._clearLastInterval();
      this._applyDirectivesOnDocumentReady();
      return this._setNewInterval();
    };

    DirectiveProcessor._isApplyingDirectivesInDOM = false;

    DirectiveProcessor.prototype._applyDirectivesInDOM = function() {
      var rootElement, rootObElement;
      if (this._isApplyingDirectivesInDOM) {
        return;
      }
      this._isApplyingDirectivesInDOM = true;
      try {
        rootElement = document.getElementsByTagName("body")[0];
        rootObElement = new ObliqueNS.Element(rootElement);
        return rootObElement.eachDescendant((function(_this) {
          return function(DOMElement) {
            var cssExpr, directive, directiveName, obElement, _i, _len, _ref, _results;
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
                  directiveName = directive.name;
                  if (obElement.hasFlag(directiveName)) {
                    continue;
                  }
                  obElement.setFlag(directiveName);
                  _results1.push(new directive(DOMElement));
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

    DirectiveProcessor.prototype.getIntervalTimeInMs = function() {
      return this._intervalTimeInMs;
    };

    DirectiveProcessor.prototype.setIntervalTimeInMs = function(newIntervalTimeInMs) {
      if (newIntervalTimeInMs <= 0) {
        throw new ObliqueNS.Error("IntervalTime must be a positive number");
      }
      this._intervalTimeInMs = newIntervalTimeInMs;
      return this._listenToDirectivesInDOM();
    };

    DirectiveProcessor.prototype.registerDirective = function(directiveConstructorFn) {
      return this._directiveCollection.add(directiveConstructorFn);
    };

    DirectiveProcessor.prototype.destroy = function() {
      var e;
      this._clearLastInterval();
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

  window.Oblique = DirectiveProcessor;

}).call(this);
// Generated by CoffeeScript 1.7.1
(function() {
  var Element;

  window.ObliqueNS = window.ObliqueNS || {};

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
// Generated by CoffeeScript 1.7.1
(function() {
  var Error;

  window.ObliqueNS = window.ObliqueNS || {};

  Error = (function() {
    function Error(message) {
      this.message = message;
      this.name = "Oblique.Error";
      if (this === window) {
        return new Error(this.message);
      }
    }

    return Error;

  })();

  ObliqueNS.Error = Error;

}).call(this);
// Generated by CoffeeScript 1.7.1
(function() {
  var TimedDOMObserver;

  window.ObliqueNS = window.ObliqueNS || {};

  TimedDOMObserver = (function() {
    function TimedDOMObserver() {
      this._reset();
      this._callback = void 0;
      this._intervalInMs = 500;
    }

    TimedDOMObserver.prototype.onChange = function(callback) {
      return this._callback = callback;
    };

    TimedDOMObserver.prototype.setIntervalInMs = function(newIntervalInMs) {
      return this._intervalInMs = newIntervalInMs;
    };

    TimedDOMObserver.prototype.observe = function() {
      this.destroy();
      if (!this._callback) {
        return;
      }
      return this._intervalId = setInterval((function(_this) {
        return function() {
          return _this._callback();
        };
      })(this), this._intervalInMs);
    };

    TimedDOMObserver.prototype._reset = function() {
      return this._intervalId = void 0;
    };

    TimedDOMObserver.prototype.destroy = function() {
      if (this._intervalId) {
        clearInterval(this._intervalId);
        return this._reset();
      }
    };

    return TimedDOMObserver;

  })();

  ObliqueNS.TimedDOMObserver = TimedDOMObserver;

}).call(this);
