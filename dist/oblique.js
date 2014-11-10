// Generated by CoffeeScript 1.8.0
(function() {
  var ArrayParam, CallbackCollection, DOMProcessor, DataModelVariable, Element, EmptyParam, Memory, Oblique, ObliqueError, Param, ParamCollection, RangeParam, SingleParam, Template, TemplateFactory, TimedDOMObserver,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  this.ObliqueNS = this.ObliqueNS || {};

  Param = (function() {
    function Param(name) {
      this.name = name;
      if (!this._isString(this.name)) {
        throw new ObliqueNS.Error("Param constructor must be called with first param string");
      }
    }

    Param.prototype._isString = function(value) {
      if (typeof value === 'string') {
        return true;
      }
      return false;
    };

    Param.containsChar = function(fullStr, char) {
      if (fullStr.indexOf(char) === -1) {
        return false;
      }
      return true;
    };

    Param.stringIsNullOrEmpty = function(value) {
      if (value === void 0) {
        return true;
      }
      if (value.trim().length === 0) {
        return true;
      }
      return false;
    };

    Param.parse = function(strHashParam) {
      var hashArray, name, value;
      hashArray = strHashParam.split("=");
      name = hashArray[0].trim();
      value = hashArray[1].trim();
      return {
        name: name,
        value: value
      };
    };

    Param.prototype.getLocationHash = function() {
      return "";
    };

    Param.prototype.isEmpty = function() {
      return true;
    };

    Param.prototype.valueIsEqualTo = function() {
      return true;
    };

    Param.prototype.containsValue = function() {
      return true;
    };

    Param.prototype.isInRange = function() {
      return true;
    };

    return Param;

  })();

  ObliqueNS.Param = Param;

  this.ObliqueNS = this.ObliqueNS || {};

  Param = ObliqueNS.Param;

  ArrayParam = (function(_super) {
    __extends(ArrayParam, _super);

    function ArrayParam(name, values) {
      var value, _i, _len;
      this.name = name;
      ArrayParam.__super__.constructor.call(this, this.name);
      if (!this._isArray(values)) {
        throw new ObliqueNS.Error("Param constructor must be called with second param array");
      }
      this.values = [];
      for (_i = 0, _len = values.length; _i < _len; _i++) {
        value = values[_i];
        this.add(value);
      }
    }

    ArrayParam.prototype._isArray = function(value) {
      if (Object.prototype.toString.call(value) === '[object Array]') {
        return true;
      }
      return false;
    };

    ArrayParam.prototype.add = function(value) {
      if (!this._isString(value)) {
        throw new ObliqueNS.Error("Array param must be an string");
      }
      return this.values.push(value);
    };

    ArrayParam.prototype.remove = function(value) {
      var index;
      index = this.values.indexOf(value);
      if (index === -1) {
        return;
      }
      this.values.splice(index, 1);
      if (this.count() === 0) {
        return this.values = void 0;
      }
    };

    ArrayParam.prototype.isEmpty = function() {
      if (this.count() === 0) {
        return true;
      }
      return false;
    };

    ArrayParam.prototype.getLocationHash = function() {
      var hash, value, _i, _len, _ref;
      if (this.count() === 0) {
        return "";
      }
      hash = "" + this.name + "=[";
      _ref = this.values;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        value = _ref[_i];
        hash += "" + value + ",";
      }
      hash = hash.substr(0, hash.length - 1);
      return hash += "]";
    };

    ArrayParam.prototype.count = function() {
      if (this.values === void 0) {
        return 0;
      }
      return this.values.length;
    };

    ArrayParam.is = function(strHashParam) {
      var hashParam;
      hashParam = Param.parse(strHashParam);
      if (Param.containsChar(hashParam.value, "[")) {
        return true;
      }
      return false;
    };

    ArrayParam.createFrom = function(strHashParam) {
      var hashParam, trimmedValues, value, values, _i, _len;
      hashParam = Param.parse(strHashParam);
      value = hashParam.value.replace("[", "").replace("]", "");
      values = value.split(",");
      trimmedValues = [];
      for (_i = 0, _len = values.length; _i < _len; _i++) {
        value = values[_i];
        value = value.trim();
        if (!Param.stringIsNullOrEmpty(value)) {
          trimmedValues.push(value);
        }
      }
      return new ArrayParam(hashParam.name, trimmedValues);
    };

    ArrayParam.prototype.containsValue = function(value) {
      if (this.isEmpty()) {
        return false;
      }
      if (__indexOf.call(this.values, value) >= 0) {
        return true;
      }
      return false;
    };

    return ArrayParam;

  })(ObliqueNS.Param);

  ObliqueNS.ArrayParam = ArrayParam;

  this.ObliqueNS = this.ObliqueNS || {};

  EmptyParam = (function(_super) {
    __extends(EmptyParam, _super);

    function EmptyParam() {
      EmptyParam.__super__.constructor.call(this, "EmptyParam");
    }

    return EmptyParam;

  })(ObliqueNS.Param);

  ObliqueNS.EmptyParam = EmptyParam;

  this.ObliqueNS = this.ObliqueNS || {};

  ArrayParam = ObliqueNS.ArrayParam;

  RangeParam = ObliqueNS.RangeParam;

  SingleParam = ObliqueNS.SingleParam;

  EmptyParam = ObliqueNS.EmptyParam;

  ParamCollection = (function() {
    function ParamCollection(locationHash) {
      var hashParam, param, _i, _len, _ref;
      this.removeAll();
      if (this._StringIsEmpty(locationHash)) {
        return;
      }
      locationHash = locationHash.replace("#", "");
      _ref = locationHash.split("&");
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        hashParam = _ref[_i];
        param = void 0;
        if (SingleParam.is(hashParam)) {
          param = SingleParam.createFrom(hashParam);
        } else if (RangeParam.is(hashParam)) {
          param = RangeParam.createFrom(hashParam);
        } else if (ArrayParam.is(hashParam)) {
          param = ArrayParam.createFrom(hashParam);
        } else {
          param = new EmptyParam();
        }
        this.add(param);
      }
    }

    ParamCollection.prototype._StringIsEmpty = function(value) {
      if (value === void 0) {
        return true;
      }
      if (value.trim().length === 0) {
        return true;
      }
      return false;
    };

    ParamCollection.prototype.add = function(param) {
      this._params[param.name.toLowerCase()] = param;
      return param;
    };

    ParamCollection.prototype.addSingleParam = function(name, value) {
      return this.add(new SingleParam(name, value));
    };

    ParamCollection.prototype.addRangeParam = function(name, min, max) {
      return this.add(new RangeParam(name, min, max));
    };

    ParamCollection.prototype.addArrayParam = function(name, values) {
      return this.add(new ArrayParam(name, values));
    };

    ParamCollection.prototype.remove = function(paramName) {
      return this._params[paramName] = void 0;
    };

    ParamCollection.prototype.removeAll = function() {
      return this._params = {};
    };

    ParamCollection.prototype.getParam = function(paramName) {
      var param;
      param = this._params[paramName.toLowerCase()];
      if (param === void 0) {
        return new EmptyParam();
      }
      return param;
    };

    ParamCollection.prototype.find = function(paramNames) {
      var foundedParamCollection, lowerCaseParamNames, param, paramName, _ref, _ref1;
      lowerCaseParamNames = (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = paramNames.length; _i < _len; _i++) {
          param = paramNames[_i];
          _results.push(param.toLowerCase());
        }
        return _results;
      })();
      foundedParamCollection = new ParamCollection();
      _ref = this._params;
      for (paramName in _ref) {
        param = _ref[paramName];
        if ((!this._isEmptyParam(param)) && (_ref1 = paramName.toLowerCase(), __indexOf.call(lowerCaseParamNames, _ref1) >= 0)) {
          foundedParamCollection.add(param);
        }
      }
      return foundedParamCollection;
    };

    ParamCollection.prototype.isEmpty = function() {
      if (this.count() === 0) {
        return true;
      }
      return false;
    };

    ParamCollection.prototype.count = function() {
      var count, param, paramName, _ref;
      count = 0;
      _ref = this._params;
      for (paramName in _ref) {
        param = _ref[paramName];
        if (!this._isEmptyParam(param)) {
          count++;
        }
      }
      return count;
    };

    ParamCollection.prototype._isEmptyParam = function(param) {
      if (param === void 0) {
        return true;
      }
      return param.isEmpty();
    };

    ParamCollection.prototype.getLocationHash = function() {
      var hash, param, paramName, _ref;
      if (this.count() === 0) {
        return "";
      }
      hash = "#";
      _ref = this._params;
      for (paramName in _ref) {
        param = _ref[paramName];
        if (param.isEmpty()) {
          continue;
        }
        hash += param.getLocationHash() + "&";
      }
      hash = hash.substr(0, hash.length - 1);
      return hash;
    };

    return ParamCollection;

  })();

  ObliqueNS.ParamCollection = ParamCollection;

  this.ObliqueNS = this.ObliqueNS || {};

  Param = ObliqueNS.Param;

  RangeParam = (function(_super) {
    __extends(RangeParam, _super);

    function RangeParam(name, min, max) {
      this.name = name;
      this.min = min;
      this.max = max;
      RangeParam.__super__.constructor.call(this, this.name);
      if (!this._isString(this.min)) {
        throw new ObliqueNS.Error("Param constructor must be called with second param string");
      }
      if (!this._isString(this.max)) {
        throw new ObliqueNS.Error("Param constructor must be called with third param string");
      }
    }

    RangeParam.prototype.getLocationHash = function() {
      return "" + this.name + "=(" + this.min + "," + this.max + ")";
    };

    RangeParam.prototype.isEmpty = function() {
      if (this.min === void 0 && this.max === void 0) {
        return true;
      }
      return false;
    };

    RangeParam.prototype.isInRange = function(value) {
      if (value < this.min) {
        return false;
      }
      if (value > this.max) {
        return false;
      }
      return true;
    };

    RangeParam.is = function(strHashParam) {
      var hashParam;
      hashParam = Param.parse(strHashParam);
      if (Param.containsChar(hashParam.value, "(")) {
        return true;
      }
      return false;
    };

    RangeParam.createFrom = function(strHashParam) {
      var hashParam, max, min, value;
      hashParam = Param.parse(strHashParam);
      value = hashParam.value.replace("(", "").replace(")", "");
      min = (value.split(",")[0]).trim();
      max = (value.split(",")[1]).trim();
      return new RangeParam(hashParam.name, min, max);
    };

    return RangeParam;

  })(ObliqueNS.Param);

  ObliqueNS.RangeParam = RangeParam;

  this.ObliqueNS = this.ObliqueNS || {};

  Param = ObliqueNS.Param;

  SingleParam = (function(_super) {
    __extends(SingleParam, _super);

    function SingleParam(name, value) {
      this.name = name;
      this.value = value;
      SingleParam.__super__.constructor.call(this, this.name);
      if (!this._isString(this.value)) {
        throw new ObliqueNS.Error("Param constructor must be called with second param string");
      }
    }

    SingleParam.prototype.getLocationHash = function() {
      return "" + this.name + "=" + this.value;
    };

    SingleParam.prototype.isEmpty = function() {
      if (this.value === void 0) {
        return true;
      }
      return false;
    };

    SingleParam.is = function(strHashParam) {
      var hashParam;
      hashParam = Param.parse(strHashParam);
      if (Param.stringIsNullOrEmpty(hashParam.value)) {
        return false;
      }
      if (Param.containsChar(hashParam.value, "(")) {
        return false;
      }
      if (Param.containsChar(hashParam.value, "[")) {
        return false;
      }
      return true;
    };

    SingleParam.createFrom = function(strHashParam) {
      var hashParam;
      hashParam = Param.parse(strHashParam);
      return new SingleParam(hashParam.name, hashParam.value);
    };

    SingleParam.prototype.valueIsEqualTo = function(value) {
      if (this.isEmpty()) {
        return false;
      }
      if (this.value !== value) {
        return false;
      }
      return true;
    };

    return SingleParam;

  })(ObliqueNS.Param);

  ObliqueNS.SingleParam = SingleParam;

  this.ObliqueNS = this.ObliqueNS || {};

  Template = (function() {
    function Template(templateContent) {
      this.compiledTemplate = Handlebars.compile(templateContent);
    }

    Template.prototype.renderHTML = function(model) {
      return this.compiledTemplate(model);
    };

    return Template;

  })();

  ObliqueNS.Template = Template;

  this.ObliqueNS = this.ObliqueNS || {};

  TemplateFactory = (function() {
    function TemplateFactory() {}

    Template = ObliqueNS.Template;

    TemplateFactory.prototype.createFromString = function(templateStr) {
      return new Template(templateStr);
    };

    TemplateFactory.prototype.createFromDOMElement = function(element) {
      return this.createFromString($(element).html());
    };

    TemplateFactory.prototype.createFromUrl = function(url) {
      var errorMessage, errorStatusCode, template, templateContent;
      templateContent = void 0;
      errorStatusCode = 200;
      errorMessage = void 0;
      jQuery.ajax({
        url: url,
        success: function(data) {
          return templateContent = data;
        },
        error: function(e) {
          errorStatusCode = e.status;
          return errorMessage = e.statusCode;
        },
        async: false
      });
      if (errorStatusCode === 404) {
        throw new ObliqueNS.Error("template '" + url + "' not found");
      }
      if (errorStatusCode !== 200) {
        throw new ObliqueNS.Error(errorMessage);
      }
      return template = this.createFromString(templateContent);
    };

    return TemplateFactory;

  })();

  ObliqueNS.TemplateFactory = TemplateFactory;

  if (!String.prototype.trim) {
    String.prototype.trim = function() {
      return this.replace(/^\s+|\s+$/g, "");
    };
  }

  this.ObliqueNS = this.ObliqueNS || {};

  CallbackCollection = (function() {
    function CallbackCollection() {
      this._callbacks = [];
      this._callbacksByName = {};
    }

    CallbackCollection.prototype.count = function() {
      return this._callbacks.length;
    };

    CallbackCollection.prototype._isAFunction = function(memberToTest) {
      return typeof memberToTest === "function";
    };

    CallbackCollection.prototype._throwErrorIfCallbackIsNotValid = function(callbackName, callbackFn) {
      if (!callbackName || typeof callbackName !== "string") {
        throw new ObliqueNS.Error("registerDirective must be called with a string directiveName");
      }
      if (!this._isAFunction(callbackFn)) {
        throw new ObliqueNS.Error("registerDirective must be called with a Directive 'Constructor/Class'");
      }
    };

    CallbackCollection.prototype.add = function(callbackName, callbackFn) {
      this._throwErrorIfCallbackIsNotValid(callbackName, callbackFn);
      this._callbacks.push(callbackFn);
      return this._callbacksByName[callbackName] = callbackFn;
    };

    CallbackCollection.prototype.at = function(index) {
      return this._callbacks[index];
    };

    CallbackCollection.prototype.getCallbackByName = function(name) {
      return this._callbacksByName[name];
    };

    return CallbackCollection;

  })();

  ObliqueNS.CallbackCollection = CallbackCollection;

  this.ObliqueNS = this.ObliqueNS || {};

  DataModelVariable = (function() {
    function DataModelVariable(_expression) {
      this._expression = _expression;
      this._firstEqualPosition = this._expression.indexOf("=");
      this.name = this._getVariableName();
      this.isSet = this._isSet();
    }

    DataModelVariable.prototype._getVariableName = function() {
      var parts, variableName;
      if (this._firstEqualPosition === -1) {
        return this._expression;
      }
      parts = this._expression.split("=");
      variableName = (parts[0].replace("var ", "")).trim();
      if (variableName === "") {
        return void 0;
      }
      return variableName;
    };

    DataModelVariable.prototype._isSet = function() {
      var nextChar;
      if (this._firstEqualPosition === -1) {
        return false;
      }
      nextChar = this._expression.substr(this._firstEqualPosition + 1, 1);
      if (nextChar === "=") {
        return false;
      }
      return true;
    };

    return DataModelVariable;

  })();

  ObliqueNS.DataModelVariable = DataModelVariable;

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
      this._directiveCollection = new ObliqueNS.CallbackCollection();
      this._directiveInstancesData = [];
      this._timedDOMObserver = this._createTimedDOMObserver(DOMProcessor.DEFAULT_INTERVAL_MS);
      this._memory = new ObliqueNS.Memory();
      jQuery(document).ready((function(_this) {
        return function() {
          _this._applyObliqueElementsInDOM();
          _this._timedDOMObserver.observe();
          return _this._listenToHashRouteChanges();
        };
      })(this));
    }

    DOMProcessor.DEFAULT_INTERVAL_MS = 500;

    DOMProcessor.prototype._listenToHashRouteChanges = function() {
      return $(window).on("hashchange", (function(_this) {
        return function() {
          var dirData, directiveData, _i, _len, _ref, _results;
          _ref = _this._directiveInstancesData;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            dirData = _ref[_i];
            directiveData = _this._createDirectiveData(dirData.domElement, dirData.jQueryElemen, dirData.model, dirData.params);
            if (dirData.instance.onHashChange) {
              _results.push(dirData.instance.onHashChange(directiveData));
            } else {
              _results.push(void 0);
            }
          }
          return _results;
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
          return _this._applyObliqueElementsInDOM();
        };
      })(this));
      return observer;
    };

    DOMProcessor._isApplyingObliqueElementsInDOM = false;

    DOMProcessor.prototype._applyObliqueElementsInDOM = function() {
      var e;
      if (this._isApplyingObliqueElementsInDOM) {
        return;
      }
      this._isApplyingObliqueElementsInDOM = true;
      try {
        return $("*[data-ob-directive]").each((function(_this) {
          return function(index, DOMElement) {
            var directiveAttrValue, obElement;
            obElement = new ObliqueNS.Element(DOMElement);
            directiveAttrValue = obElement.getAttributeValue("data-ob-directive");
            if (directiveAttrValue) {
              return _this._processDirectiveElement(obElement, directiveAttrValue);
            }
          };
        })(this));
      } catch (_error) {
        e = _error;
        return this._throwError("Error _applyObliqueElementsInDOM() : " + e.message);
      } finally {
        this._isApplyingObliqueElementsInDOM = false;
      }
    };

    DOMProcessor.prototype._processDirectiveElement = function(obElement, directiveAttrValue) {
      var directive, directiveData, directiveInstanceData, directiveName, domElement, jQueryElement, model, params, _i, _len, _ref, _results;
      _ref = directiveAttrValue.split(",");
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        directiveName = _ref[_i];
        directiveName = directiveName.trim();
        if (obElement.hasFlag(directiveName)) {
          continue;
        }
        directive = this._directiveCollection.getCallbackByName(directiveName);
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
        _results.push(this._directiveInstancesData.push(directiveInstanceData));
      }
      return _results;
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

    DOMProcessor.prototype._getDirectiveModel = function(___obElement) {

      /*
        WARNING: all local variable names in this method
        must be prefixed with three undercores ("___")
        in order to not be in conflict with dynamic
        local variables created by
          eval(@_memory.localVarsScript())
       */
      var Model, e, ___dataModelExpr, ___dataModelVariable, ___directiveModel, ___variableName, ___variableValue;
      Model = Oblique().getModel();
      ___dataModelExpr = ___obElement.getAttributeValue("data-ob-model");
      if (___dataModelExpr === void 0) {
        return void 0;
      }
      try {
        eval(this._memory.localVarsScript());
        ___directiveModel = eval(___dataModelExpr);
        ___dataModelVariable = new DataModelVariable(___dataModelExpr);
        if (___dataModelVariable.isSet) {
          ___variableName = ___dataModelVariable.name;
          ___variableValue = eval(___variableName);
          this._memory.setVar(___variableName, ___variableValue);
          ___directiveModel = ___variableValue;
        }
        if (!___directiveModel) {
          this._throwError("" + (___obElement.getHtml()) + ": data-ob-model expression is undefined");
        }
        return ___directiveModel;
      } catch (_error) {
        e = _error;
        return this._throwError("" + (___obElement.getHtml()) + ": data-ob-model expression error: " + e.message);
      }
    };

    DOMProcessor.prototype._throwError = function(errorMessage) {
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
      return this._directiveCollection.add(directiveName, directiveConstructorFn);
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

  this.ObliqueNS = this.ObliqueNS || {};

  Element = (function() {
    function Element(DOMElement) {
      this._jQueryElement = jQuery(DOMElement);
    }

    Element.prototype.getDOMElement = function() {
      return this._jQueryElement.get(0);
    };

    Element.prototype.getjQueryElement = function() {
      return this._jQueryElement;
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
      return Element._traverse(this.getDOMElement(), callbackOnDOMElement);
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
      return this.getDOMElement().outerHTML;
    };

    return Element;

  })();

  ObliqueNS.Element = Element;

  this.ObliqueNS = this.ObliqueNS || {};

  Memory = (function() {
    function Memory() {
      this._vars = {};
    }

    Memory.prototype.setVar = function(name, value) {
      if (name === "Model") {
        throw new ObliqueNS.Error("Can't create a variable named 'Model', is a reserved word");
      }
      return this._vars[name] = value;
    };

    Memory.prototype.getVar = function(name) {
      return this._vars[name];
    };

    Memory.prototype.localVarsScript = function() {
      var script, variableName, variableValue, _ref;
      script = "";
      _ref = this._vars;
      for (variableName in _ref) {
        if (!__hasProp.call(_ref, variableName)) continue;
        variableValue = _ref[variableName];
        script = script + ("var " + variableName + "=this._memory.getVar(\"" + variableName + "\");");
      }
      return script;
    };

    return Memory;

  })();

  ObliqueNS.Memory = Memory;

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
      this.domProcessor = new ObliqueNS.DOMProcessor();
      this.templateFactory = new ObliqueNS.TemplateFactory();
      this._onErrorCallbacks = [];
    }

    Oblique.DEFAULT_INTERVAL_MS = 500;

    Oblique.prototype.getIntervalTimeInMs = function() {
      return this.domProcessor.getIntervalTimeInMs();
    };

    Oblique.prototype.setIntervalTimeInMs = function(newIntervalTimeInMs) {
      return this.domProcessor.setIntervalTimeInMs(newIntervalTimeInMs);
    };

    Oblique.prototype.registerDirective = function(directiveName, directiveConstructorFn) {
      return this.domProcessor.registerDirective(directiveName, directiveConstructorFn);
    };

    Oblique.prototype.destroy = function() {
      var e;
      this.domProcessor.destroy();
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

    Oblique.prototype.renderHTML = function(url, model) {
      var template;
      if (Handlebars === void 0) {
        throw new ObliqueNS.Error("Oblique().renderHtml(): needs handlebarsjs loaded to render templates");
      }
      template = this.templateFactory.createFromUrl(url);
      return template.renderHTML(model);
    };

    Oblique.prototype.onError = function(onErrorCallback) {
      return this._onErrorCallbacks.push(onErrorCallback);
    };

    Oblique.prototype.triggerOnError = function(error) {
      var callback, _i, _len, _ref;
      _ref = this._onErrorCallbacks;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        callback = _ref[_i];
        callback(error);
      }
      throw error;
    };

    Oblique.prototype.getHashParams = function() {
      return new ObliqueNS.ParamCollection(window.location.hash);
    };

    Oblique.prototype.setHashParams = function(paramCollection) {
      return window.location.hash = paramCollection.getLocationHash();
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
