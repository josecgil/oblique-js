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
      var body, rootObElement;
      if (this._isApplyingDirectivesInDOM) {
        return;
      }
      this._isApplyingDirectivesInDOM = true;
      try {

        /*
        $("*[data-directive]").each(
          (index, DOMElement) =>
            obElement=new ObliqueNS.Element DOMElement
            @_processDirectiveElement obElement
        )
         */
        body = document.getElementsByTagName("body")[0];
        rootObElement = new ObliqueNS.Element(body);
        return rootObElement.eachDescendant((function(_this) {
          return function(DOMElement) {
            var directiveAttrValue, obElement;
            obElement = new ObliqueNS.Element(DOMElement);
            directiveAttrValue = obElement.getAttributeValue("data-ob-directive");
            if (directiveAttrValue) {
              return _this._processDirectiveElement(obElement, directiveAttrValue);
            }
          };
        })(this));
      } finally {
        this._isApplyingDirectivesInDOM = false;
      }
    };

    DirectiveProcessor.prototype._processDirectiveElement = function(obElement, directiveAttrValue) {
      var directive, directiveData, directiveName, _i, _len, _ref, _results;
      _ref = directiveAttrValue.split(",");
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        directiveName = _ref[_i];
        directiveName = directiveName.trim();
        if (obElement.hasFlag(directiveName)) {
          continue;
        }
        directive = this._directiveCollection.getDirectiveByName(directiveName);
        if (!directive) {
          throw new ObliqueNS.Error("There is no " + directiveName + " directive registered");
        }
        obElement.setFlag(directiveName);
        directiveData = {
          domElement: obElement.getDOMElement(),
          jQueryElement: obElement.getjQueryElement(),
          model: this._getDirectiveModel(obElement),
          params: this._getParams(obElement)
        };
        _results.push(new directive(directiveData));
      }
      return _results;
    };

    DirectiveProcessor.prototype._getParams = function(obElement) {
      var dataParamsExpr, e;
      dataParamsExpr = obElement.getAttributeValue("data-ob-params");
      if (!dataParamsExpr) {
        return void 0;
      }
      try {
        return jQuery.parseJSON(dataParamsExpr);
      } catch (_error) {
        e = _error;
        return this._throwError("" + (obElement.getHtml()) + ": data-ob-params parse error: " + e.message);
      }
    };

    DirectiveProcessor.prototype._extractVarFrom = function(dataModelExpression) {
      var parts, variableName;
      if (dataModelExpression.indexOf("=") === -1) {
        return void 0;
      }
      parts = dataModelExpression.split("=");
      variableName = (parts[0].replace("var ", "")).trim();
      if (variableName === "") {
        return void 0;
      }
      return variableName;
    };

    DirectiveProcessor.prototype._getDirectiveModel = function(obElement) {
      var Model, dataModelExpr, directiveModel, e, variableName;
      Model = Oblique().getModel();
      dataModelExpr = obElement.getAttributeValue("data-ob-model");
      if (dataModelExpr === void 0) {
        return void 0;
      }
      try {
        directiveModel = eval(dataModelExpr);
        variableName = this._extractVarFrom(dataModelExpr);
        if (variableName) {
          directiveModel = eval(variableName);
        }
        if (!directiveModel) {
          this._throwError("" + (obElement.getHtml()) + ": data-ob-model expression is undefined");
        }
        return directiveModel;
      } catch (_error) {
        e = _error;
        return this._throwError("" + (obElement.getHtml()) + ": data-ob-model expression error: " + e.message);
      }
    };

    DirectiveProcessor.prototype._getDirectiveModel2 = function(obElement) {
      var className, constructorFn, dataModelDSL, dataModelExpr, model, property, _i, _len, _ref;
      model = Oblique().getModel();
      dataModelExpr = obElement.getAttributeValue("data-ob-model");
      if (dataModelExpr === void 0) {
        return void 0;
      }
      dataModelDSL = new ObliqueNS.DataModelDSL(dataModelExpr);
      if (!dataModelDSL.hasFullModel) {
        if (dataModelDSL.modelProperties) {
          _ref = dataModelDSL.modelProperties;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            property = _ref[_i];
            if (!model.hasOwnProperty(property.name)) {
              this._throwError("" + (obElement.getHtml()) + ": data-ob-model doesn't match any data in model");
            }
            model = model[property.name];
            if (property.hasIndex) {
              model = model[property.index];
            }
          }
        }
      }
      className = dataModelDSL.className;
      if (className) {
        if (!window.hasOwnProperty(className)) {
          this._throwError("" + (obElement.getHtml()) + ": '" + className + "' isn't an existing class in data-ob-model");
        }
        constructorFn = window[className];
        model = new constructorFn(model);
      }
      return model;
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

    DirectiveProcessor.prototype.registerDirective = function(directiveName, directiveConstructorFn) {
      return this._directiveCollection.add(directiveName, directiveConstructorFn);
    };

    DirectiveProcessor.prototype.destroy = function() {
      this._timedDOMObserver.destroy();
      return DirectiveProcessor._singletonInstance = void 0;
    };

    return DirectiveProcessor;

  })();

  ObliqueNS.DirectiveProcessor = DirectiveProcessor;

  this.Oblique = DirectiveProcessor;

}).call(this);
