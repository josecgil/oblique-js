// Generated by CoffeeScript 1.10.0
(function() {
  var DOMProcessor, DataModelVariable;

  this.ObliqueNS = this.ObliqueNS || {};

  DataModelVariable = ObliqueNS.DataModelVariable;

  DOMProcessor = (function() {
    function DOMProcessor() {
      if (this === window) {
        return new DOMProcessor();
      }
      if (DOMProcessor._singletonInstance) {
        return DOMProcessor._singletonInstance;
      }
      DOMProcessor._singletonInstance = this;
      this._throwErrorIfJQueryIsntLoaded();
      this._directiveCollection = new ObliqueNS.DirectiveCollection();
      this._directiveInstancesData = [];
      this._timedDOMObserver = this._createTimedDOMObserver(DOMProcessor.DEFAULT_INTERVAL_MS);
      this._memory = new ObliqueNS.Memory();
      this._hashChangeEventEnabled = true;
      jQuery(document).ready((function(_this) {
        return function() {
          _this._doACycle();
          _this._timedDOMObserver.observe();
          return _this._listenToHashRouteChanges();
        };
      })(this));
    }

    DOMProcessor.DEFAULT_INTERVAL_MS = 500;

    DOMProcessor.prototype.enableHashChangeEvent = function() {
      return this._hashChangeEventEnabled = true;
    };

    DOMProcessor.prototype.disableHashChangeEvent = function() {
      return this._hashChangeEventEnabled = false;
    };

    DOMProcessor.prototype._listenToHashRouteChanges = function() {
      return $(window).on("hashchange", (function(_this) {
        return function() {
          var dirData, directiveData, i, len, ref, results;
          if (!_this._hashChangeEventEnabled) {
            return;
          }
          ref = _this._directiveInstancesData;
          results = [];
          for (i = 0, len = ref.length; i < len; i++) {
            dirData = ref[i];
            directiveData = _this._createDirectiveData(dirData.domElement, dirData.jQueryElement, dirData.model, dirData.params);
            if (dirData.instance.onHashChange) {
              results.push(dirData.instance.onHashChange(directiveData));
            } else {
              results.push(void 0);
            }
          }
          return results;
        };
      })(this));
    };

    DOMProcessor.prototype._ignoreHashRouteChanges = function() {
      return $(window).off("hashchange");
    };

    DOMProcessor.prototype._throwErrorIfJQueryIsntLoaded = function() {
      if (!window.jQuery) {
        throw new Error("DOMProcessor needs jQuery to work");
      }
    };

    DOMProcessor.prototype._createTimedDOMObserver = function(intervalInMs) {
      var observer;
      observer = new ObliqueNS.TimedDOMObserver(intervalInMs);
      observer.onChange((function(_this) {
        return function() {
          return _this._doACycle();
        };
      })(this));
      return observer;
    };

    DOMProcessor._isDoingACycle = false;

    DOMProcessor.prototype._doACycle = function() {
      var e, error1;
      try {
        if (this._isDoingACycle) {
          return;
        }
        this._isDoingACycle = true;
        this._applyGlobalDirectives();
        this._applyVariablesInDOM();
        this._applyDirectivesInDOM();
        return this._callOnIntervalOnCurrentDirectives();
      } catch (error1) {
        e = error1;
        this._throwError(e, "Error doing a cycle in Oblique.js: " + e.message);
        throw e;
      } finally {
        this._isDoingACycle = false;
      }
    };

    DOMProcessor.prototype._callOnIntervalOnCurrentDirectives = function() {
      var directive, directiveInstanceData, i, len, ref, results;
      ref = this._directiveInstancesData;
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        directiveInstanceData = ref[i];
        directive = directiveInstanceData.instance;
        if (directive.onInterval) {
          results.push(directive.onInterval());
        } else {
          results.push(void 0);
        }
      }
      return results;
    };

    DOMProcessor.prototype._applyVariablesInDOM = function() {
      return $("*[data-ob-var], *[ob-var]").each((function(_this) {
        return function(index, DOMElement) {
          var obElement, scriptAttrValue;
          obElement = new ObliqueNS.Element(DOMElement);
          scriptAttrValue = obElement.getAttributeValue("data-ob-var");
          if (!scriptAttrValue) {
            scriptAttrValue = obElement.getAttributeValue("ob-var");
          }
          if (scriptAttrValue) {
            return _this._processScriptElement(obElement, scriptAttrValue);
          }
        };
      })(this));
    };

    DOMProcessor.prototype._applyGlobalDirectives = function() {
      var rootElement;
      rootElement = new ObliqueNS.Element(document.documentElement);
      return this._directiveCollection.each((function(_this) {
        return function(directive) {
          if (!directive.isGlobal) {
            return;
          }
          return _this._processDirectiveElement(rootElement, directive.name);
        };
      })(this));
    };

    DOMProcessor.prototype._applyDirectivesInDOM = function() {
      return $("*[data-ob-directive], *[ob-directive]").each((function(_this) {
        return function(index, DOMElement) {
          var directiveAttrValue, obElement;
          obElement = new ObliqueNS.Element(DOMElement);
          directiveAttrValue = obElement.getAttributeValue("data-ob-directive");
          if (!directiveAttrValue) {
            directiveAttrValue = obElement.getAttributeValue("ob-directive");
          }
          if (directiveAttrValue) {
            return _this._processDirectiveElement(obElement, directiveAttrValue);
          }
        };
      })(this));
    };

    DOMProcessor.prototype._execJS = function(___JSScriptBlock) {
      var Model, ___dataModelVariable, ___directiveModel, ___variableName, ___variableValue;
      Model = Oblique().getModel();
      eval(this._memory.localVarsScript());
      ___directiveModel = eval(___JSScriptBlock);
      ___dataModelVariable = new DataModelVariable(___JSScriptBlock);
      if (___dataModelVariable.isSet) {
        ___variableName = ___dataModelVariable.name;
        ___variableValue = eval(___variableName);
        this._memory.setVar(___variableName, ___variableValue);
        ___directiveModel = ___variableValue;
      }
      return ___directiveModel;
    };

    DOMProcessor.prototype._processScriptElement = function(obElement, varAttrValue) {
      if (obElement.hasFlag("data-ob-var")) {
        return;
      }
      obElement.setFlag("data-ob-var");
      return this._execJS(varAttrValue);
    };

    DOMProcessor.prototype._processDirectiveElement = function(obElement, directiveAttrValue) {
      var directive, directiveData, directiveInstanceData, directiveName, domElement, i, jQueryElement, len, model, params, ref, results;
      ref = directiveAttrValue.split(",");
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        directiveName = ref[i];
        directiveName = directiveName.trim();
        if (obElement.hasFlag(directiveName)) {
          continue;
        }
        directive = this._directiveCollection.findByName(directiveName).callback;
        if (!directive) {
          throw new ObliqueNS.Error("There is no " + directiveName + " directive registered");
        }
        obElement.setFlag(directiveName);
        domElement = obElement.getDOMElement();
        jQueryElement = obElement.getjQueryElement();
        model = this._getDirectiveModel(obElement);
        params = this._getParams(obElement);
        directiveData = this._createDirectiveData(domElement, jQueryElement, model, params);
        directiveInstanceData = {
          instance: new directive(directiveData),
          domElement: domElement,
          jQueryElement: jQueryElement,
          model: model,
          params: params
        };
        results.push(this._directiveInstancesData.push(directiveInstanceData));
      }
      return results;
    };

    DOMProcessor.prototype._createDirectiveData = function(domElement, jQueryElement, model, params) {
      var directiveData;
      directiveData = {
        domElement: domElement,
        jQueryElement: jQueryElement,
        model: model,
        params: params,
        hashParams: Oblique().getHashParams()
      };
      return directiveData;
    };

    DOMProcessor.prototype._getParams = function(obElement) {
      var dataParamsExpr, e, error1;
      dataParamsExpr = obElement.getAttributeValue("data-ob-params");
      if (!dataParamsExpr) {
        dataParamsExpr = obElement.getAttributeValue("ob-params");
      }
      if (!dataParamsExpr) {
        return void 0;
      }
      try {
        return jQuery.parseJSON(dataParamsExpr);
      } catch (error1) {
        e = error1;
        return this._throwError(e, (obElement.getHtml()) + ": data-ob-params parse error: " + e.message);
      }
    };

    DOMProcessor.prototype._getDirectiveModel = function(___obElement) {

      /*
        WARNING: all local variable names in this method
        must be prefixed with three undercores ("___")
        in order to not be in conflict with dynamic
        local variables created by
          eval(@_memory.localVarsScript())
       */
      var ___dataModelExpr, ___directiveModel, e, error, error1, errorMsg;
      ___dataModelExpr = ___obElement.getAttributeValue("data-ob-model");
      if (!___dataModelExpr) {
        ___dataModelExpr = ___obElement.getAttributeValue("ob-model");
      }
      if (___dataModelExpr === void 0) {
        return void 0;
      }
      try {
        ___directiveModel = this._execJS(___dataModelExpr);
        if (!___directiveModel) {
          errorMsg = (___obElement.getHtml()) + ": data-ob-model expression is undefined";
          error = new ObliqueError(errorMsg);
          this._throwError(error, errorMsg);
          throw error;
        }
        return ___directiveModel;
      } catch (error1) {
        e = error1;
        this._throwError(e, (___obElement.getHtml()) + ": data-ob-model expression error: " + e.message);
        throw e;
      }
    };

    DOMProcessor.prototype._throwError = function(e, errorMessage) {
      Oblique.logError(e);
      return Oblique().triggerOnError(new ObliqueNS.Error(errorMessage));
    };

    DOMProcessor.prototype.getIntervalTimeInMs = function() {
      return this._timedDOMObserver.getIntervalInMs();
    };

    DOMProcessor.prototype.setIntervalTimeInMs = function(newIntervalTimeInMs) {
      if (newIntervalTimeInMs <= 0) {
        throw new ObliqueNS.Error("IntervalTime must be a positive number");
      }
      this._timedDOMObserver.destroy();
      this._timedDOMObserver = this._createTimedDOMObserver(newIntervalTimeInMs);
      return this._timedDOMObserver.observe();
    };

    DOMProcessor.prototype.registerDirective = function(directiveName, directiveConstructorFn) {
      return this._directiveCollection.add(new ObliqueNS.Directive(directiveName, directiveConstructorFn));
    };

    DOMProcessor.prototype.registerDirectiveAsGlobal = function(directiveName, directiveConstructorFn) {
      return this._directiveCollection.add(new ObliqueNS.Directive(directiveName, directiveConstructorFn, true));
    };

    DOMProcessor.prototype.destroy = function() {
      this._ignoreHashRouteChanges();
      this._timedDOMObserver.destroy();
      return DOMProcessor._singletonInstance = void 0;
    };

    return DOMProcessor;

  })();

  ObliqueNS.DOMProcessor = DOMProcessor;

  this.Oblique = DOMProcessor;

}).call(this);
