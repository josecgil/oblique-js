// Generated by CoffeeScript 1.7.1
(function() {
  var DirectiveProcessor;

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
      var dataModelExpr, model, results;
      if (!Oblique().hasModel()) {
        return void 0;
      }
      model = Oblique().getModel();
      if (!obElement.hasAttribute("data-model")) {
        return model;
      }
      dataModelExpr = obElement.getAttributeValue("data-model");
      results = jsonPath(model, dataModelExpr);
      if (results.length === 1) {
        return results[0];
      }
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

}).call(this);

//# sourceMappingURL=DirectiveProcessor.map
