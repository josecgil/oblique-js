// Generated by CoffeeScript 1.10.0
(function() {
  var ArrayParam, DOMProcessor, DataModelVariable, Directive, DirectiveCollection, Element, EmptyParam, Memory, Oblique, ObliqueError, Param, ParamCollection, ParamParser, RangeParam, SingleParam, Template, TemplateFactory, TimedDOMObserver,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty,
    indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  this.ObliqueNS = this.ObliqueNS || {};

  Directive = (function() {
    function Directive(name1, callback1, isGlobal) {
      this.name = name1;
      this.callback = callback1;
      this.isGlobal = isGlobal != null ? isGlobal : false;
      this._throwErrorIfParamsAreNotValid(this.name, this.callback);
    }

    Directive.prototype._isAFunction = function(memberToTest) {
      return typeof memberToTest === "function";
    };

    Directive.prototype._throwErrorIfParamsAreNotValid = function(name, callback) {
      if (!name || typeof name !== "string") {
        throw new ObliqueNS.Error("Directive name must be an string");
      }
      if (!this._isAFunction(callback)) {
        throw new ObliqueNS.Error("Directive must be called with a 'Constructor Function/Class' param");
      }
    };

    return Directive;

  })();

  ObliqueNS.Directive = Directive;

  this.ObliqueNS = this.ObliqueNS || {};

  DirectiveCollection = (function() {
    function DirectiveCollection() {
      this._directives = {};
    }

    DirectiveCollection.prototype.add = function(directive) {
      return this._directives[directive.name] = directive;
    };

    DirectiveCollection.prototype.count = function() {
      var len;
      len = 0;
      this.each(function() {
        return len++;
      });
      return len;
    };

    DirectiveCollection.prototype.findByName = function(name) {
      return this._directives[name];
    };

    DirectiveCollection.prototype.each = function(callback) {
      var index, key, ref, results, value;
      index = 0;
      ref = this._directives;
      results = [];
      for (key in ref) {
        value = ref[key];
        callback(value, index);
        results.push(index++);
      }
      return results;
    };

    return DirectiveCollection;

  })();

  ObliqueNS.DirectiveCollection = DirectiveCollection;

  this.ObliqueNS = this.ObliqueNS || {};

  ParamParser = (function() {
    function ParamParser(params, separator) {
      var ch, currentParam, i, isInsideValue, len1;
      if (separator == null) {
        separator = "&";
      }
      params = params.replace("#", "") + separator;
      this.hashParams = [];
      currentParam = "";
      isInsideValue = false;
      for (i = 0, len1 = params.length; i < len1; i++) {
        ch = params[i];
        if (ch === ']' || ch === ')') {
          isInsideValue = false;
        }
        if (ch === '[' || ch === '(') {
          isInsideValue = true;
        }
        if (ch === separator && !isInsideValue) {
          this.hashParams.push(currentParam);
          currentParam = "";
          continue;
        }
        currentParam = currentParam + ch;
      }
    }

    return ParamParser;

  })();

  ObliqueNS.ParamParser = ParamParser;

  this.ObliqueNS = this.ObliqueNS || {};

  ParamParser = ObliqueNS.ParamParser;

  Param = (function() {
    function Param(name1) {
      this.name = name1;
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

    Param.isEnclosedInChars = function(fullStr, charStart, charEnd) {
      if (fullStr[0] === charStart) {
        return true;
      }
      if (fullStr[fullStr.length - 1] === charEnd) {
        return true;
      }
      return false;
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
      hashArray = new ParamParser(strHashParam, "=").hashParams;
      name = hashArray[0].trim();
      value = "";
      if (hashArray.length > 1) {
        value = hashArray[1].trim();
      }
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

  ParamParser = ObliqueNS.ParamParser;

  ArrayParam = (function(superClass) {
    extend(ArrayParam, superClass);

    function ArrayParam(name1, values) {
      var i, len1, value;
      this.name = name1;
      ArrayParam.__super__.constructor.call(this, this.name);
      if (!this._isArray(values)) {
        throw new ObliqueNS.Error("Param constructor must be called with second param array");
      }
      this.values = [];
      for (i = 0, len1 = values.length; i < len1; i++) {
        value = values[i];
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
      var hash, i, len1, ref, value;
      if (this.count() === 0) {
        return this.name;
      }
      hash = this.name + "=[";
      ref = this.values;
      for (i = 0, len1 = ref.length; i < len1; i++) {
        value = ref[i];
        hash += value + ",";
      }
      hash = hash.substr(0, hash.length - 1);
      return hash += "]";
    };

    ArrayParam.prototype.count = function() {
      if (this.values === void 0) {
        return 0;
      }
      if (this.values.length === 0) {
        return 0;
      }
      return this.values.length;
    };

    ArrayParam.is = function(strHashParam) {
      var hashParam;
      hashParam = Param.parse(strHashParam);
      if (Param.isEnclosedInChars(hashParam.value, "[", "]")) {
        return true;
      }
      return false;
    };

    ArrayParam.createFrom = function(strHashParam) {
      var hashParam, i, len1, trimmedValues, value, values;
      hashParam = Param.parse(strHashParam);
      value = hashParam.value.replace("[", "").replace("]", "");
      values = value.split(",");
      trimmedValues = [];
      for (i = 0, len1 = values.length; i < len1; i++) {
        value = values[i];
        value = value.trim();
        if (value !== void 0) {
          value = unescape(value);
        }
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
      if (indexOf.call(this.values, value) >= 0) {
        return true;
      }
      return false;
    };

    return ArrayParam;

  })(ObliqueNS.Param);

  ObliqueNS.ArrayParam = ArrayParam;

  this.ObliqueNS = this.ObliqueNS || {};

  EmptyParam = (function(superClass) {
    extend(EmptyParam, superClass);

    function EmptyParam() {
      EmptyParam.__super__.constructor.call(this, "EmptyParam");
    }

    return EmptyParam;

  })(ObliqueNS.Param);

  ObliqueNS.EmptyParam = EmptyParam;

  this.ObliqueNS = this.ObliqueNS || {};

  ParamParser = ObliqueNS.ParamParser;

  ArrayParam = ObliqueNS.ArrayParam;

  RangeParam = ObliqueNS.RangeParam;

  SingleParam = ObliqueNS.SingleParam;

  EmptyParam = ObliqueNS.EmptyParam;

  ParamCollection = (function() {
    function ParamCollection(locationHash) {
      var hashParam, i, len1, param, paramParser, ref;
      this.removeAll();
      if (this._StringIsEmpty(locationHash)) {
        return;
      }
      paramParser = new ParamParser(locationHash);
      ref = paramParser.hashParams;
      for (i = 0, len1 = ref.length; i < len1; i++) {
        hashParam = ref[i];
        hashParam = decodeURIComponent(hashParam);
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
      var foundedParamCollection, lowerCaseParamNames, param, paramName, ref, ref1;
      lowerCaseParamNames = (function() {
        var i, len1, results;
        results = [];
        for (i = 0, len1 = paramNames.length; i < len1; i++) {
          param = paramNames[i];
          results.push(param.toLowerCase());
        }
        return results;
      })();
      foundedParamCollection = new ParamCollection();
      ref = this._params;
      for (paramName in ref) {
        param = ref[paramName];
        if ((!this._isEmptyParam(param)) && (ref1 = paramName.toLowerCase(), indexOf.call(lowerCaseParamNames, ref1) >= 0)) {
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
      var count, param, paramName, ref;
      count = 0;
      ref = this._params;
      for (paramName in ref) {
        param = ref[paramName];
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
      var hash, param, paramName, ref;
      hash = "#";
      ref = this._params;
      for (paramName in ref) {
        param = ref[paramName];
        if (param === void 0) {
          continue;
        }
        hash += param.getLocationHash() + "&";
      }
      if (hash.length !== 1) {
        hash = hash.substr(0, hash.length - 1);
      }
      if (hash === "#") {
        hash = "#_";
      }
      return hash;
    };

    return ParamCollection;

  })();

  ObliqueNS.ParamCollection = ParamCollection;

  this.ObliqueNS = this.ObliqueNS || {};

  Param = ObliqueNS.Param;

  ParamParser = ObliqueNS.ParamParser;

  RangeParam = (function(superClass) {
    extend(RangeParam, superClass);

    function RangeParam(name1, min1, max1) {
      this.name = name1;
      this.min = min1;
      this.max = max1;
      RangeParam.__super__.constructor.call(this, this.name);
      if (!this._isValidValue(this.min)) {
        throw new ObliqueNS.Error("Param constructor must be called with second param string");
      }
      if (!this._isValidValue(this.max)) {
        throw new ObliqueNS.Error("Param constructor must be called with third param string");
      }
      if (this.min !== void 0) {
        this.min = unescape(this.min);
      }
      if (this.max !== void 0) {
        this.max = unescape(this.max);
      }
    }

    RangeParam.prototype._isValidValue = function(value) {
      if (value === void 0) {
        return true;
      }
      return this._isString(value);
    };

    RangeParam.prototype.getLocationHash = function() {
      if (!this.isEmpty()) {
        return this.name + "=(" + this.min + "," + this.max + ")";
      }
      return this.name;
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
      if (Param.isEnclosedInChars(hashParam.value, "(", ")")) {
        return true;
      }
      return false;
    };

    RangeParam.createFrom = function(strHashParam) {
      var hashParam, max, min, value;
      hashParam = Param.parse(strHashParam);
      min = void 0;
      max = void 0;
      if (!Param.stringIsNullOrEmpty(hashParam.value)) {
        value = hashParam.value.replace("(", "").replace(")", "");
        if (value.trim().length > 0) {
          min = (value.split(",")[0]).trim();
          max = (value.split(",")[1]).trim();
        }
      }
      return new RangeParam(hashParam.name, min, max);
    };

    return RangeParam;

  })(ObliqueNS.Param);

  ObliqueNS.RangeParam = RangeParam;

  this.ObliqueNS = this.ObliqueNS || {};

  ParamParser = ObliqueNS.ParamParser;

  Param = ObliqueNS.Param;

  SingleParam = (function(superClass) {
    extend(SingleParam, superClass);

    function SingleParam(name1, value1) {
      this.name = name1;
      this.value = value1;
      SingleParam.__super__.constructor.call(this, this.name);
      if (!this._isString(this.value)) {
        throw new ObliqueNS.Error("Param constructor must be called with second param string");
      }
      if (this.value !== void 0) {
        this.value = unescape(this.value);
      }
    }

    SingleParam.prototype.getLocationHash = function() {
      if (!this.isEmpty()) {
        return this.name + "=" + this.value;
      }
      return this.name;
    };

    SingleParam.prototype.isEmpty = function() {
      if (this.value === void 0) {
        return true;
      }
      if (this.value.trim().length === 0) {
        return true;
      }
      return false;
    };

    SingleParam.is = function(strHashParam) {
      var hashParam, value;
      hashParam = Param.parse(strHashParam);
      value = hashParam.value;
      if (Param.isEnclosedInChars(value, "(", ")")) {
        return false;
      }
      if (Param.isEnclosedInChars(value, "[", "]")) {
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
          var dirData, directiveData, i, len1, ref, results;
          if (!_this._hashChangeEventEnabled) {
            return;
          }
          ref = _this._directiveInstancesData;
          results = [];
          for (i = 0, len1 = ref.length; i < len1; i++) {
            dirData = ref[i];
            directiveData = _this._createDirectiveData(dirData.domElement, dirData.jQueryElemen, dirData.model, dirData.params);
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
      var directive, directiveInstanceData, i, len1, ref, results;
      ref = this._directiveInstancesData;
      results = [];
      for (i = 0, len1 = ref.length; i < len1; i++) {
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
      return $("*[data-ob-var]").each((function(_this) {
        return function(index, DOMElement) {
          var obElement, scriptAttrValue;
          obElement = new ObliqueNS.Element(DOMElement);
          scriptAttrValue = obElement.getAttributeValue("data-ob-var");
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
      var directive, directiveData, directiveInstanceData, directiveName, domElement, i, jQueryElement, len1, model, params, ref, results;
      ref = directiveAttrValue.split(",");
      results = [];
      for (i = 0, len1 = ref.length; i < len1; i++) {
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
      var child, currentElement, elementsToTraverse, results;
      elementsToTraverse = [];
      if (Element._isTag(parentElement)) {
        elementsToTraverse.push(parentElement);
      }
      callbackOnDOMElement(parentElement);
      results = [];
      while (elementsToTraverse.length > 0) {
        currentElement = elementsToTraverse.pop();
        results.push((function() {
          var i, len1, ref, results1;
          ref = currentElement.children;
          results1 = [];
          for (i = 0, len1 = ref.length; i < len1; i++) {
            child = ref[i];
            if (Element._isTag(child)) {
              elementsToTraverse.push(child);
              results1.push(callbackOnDOMElement(child));
            } else {
              results1.push(void 0);
            }
          }
          return results1;
        })());
      }
      return results;
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
      var ref, script, variableName, variableValue;
      script = "";
      ref = this._vars;
      for (variableName in ref) {
        if (!hasProp.call(ref, variableName)) continue;
        variableValue = ref[variableName];
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
      var error;
      if (window.jQuery === void 0) {
        error = new ObliqueNS.Error("ObliqueJS needs jQuery to be loaded");
        Oblique.logError(error);
        throw error;
      }
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

    Oblique.logError = function(error) {
      console.log("--- Init Oblique Error ---");
      console.log(error.message);
      console.log(error.stack);
      return console.log("--- End  Oblique Error ---");
    };

    Oblique.prototype.getIntervalTimeInMs = function() {
      return this.domProcessor.getIntervalTimeInMs();
    };

    Oblique.prototype.setIntervalTimeInMs = function(newIntervalTimeInMs) {
      return this.domProcessor.setIntervalTimeInMs(newIntervalTimeInMs);
    };

    Oblique.prototype.registerDirective = function(directiveName, directiveConstructorFn) {
      return this.domProcessor.registerDirective(directiveName, directiveConstructorFn);
    };

    Oblique.prototype.registerDirectiveAsGlobal = function(directiveName, directiveConstructorFn) {
      return this.domProcessor.registerDirectiveAsGlobal(directiveName, directiveConstructorFn);
    };

    Oblique.prototype.enableHashChangeEvent = function() {
      return this.domProcessor.enableHashChangeEvent();
    };

    Oblique.prototype.disableHashChangeEvent = function() {
      return this.domProcessor.disableHashChangeEvent();
    };

    Oblique.prototype.destroy = function() {
      var e, error1;
      this.domProcessor.destroy();
      try {
        return delete Oblique._singletonInstance;
      } catch (error1) {
        e = error1;
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
      var callback, i, len1, ref, results;
      ref = this._onErrorCallbacks;
      results = [];
      for (i = 0, len1 = ref.length; i < len1; i++) {
        callback = ref[i];
        results.push(callback(error));
      }
      return results;
    };

    Oblique.prototype.getHashParams = function() {
      return new ObliqueNS.ParamCollection(window.location.hash);
    };

    Oblique.prototype.setHashParams = function(paramCollection) {
      var hash, location, newUrl, urlWithoutHash;
      hash = paramCollection.getLocationHash();
      location = window.location;
      urlWithoutHash = location.protocol + "//" + location.host + location.pathname + location.search;
      newUrl = urlWithoutHash + hash;
      window.location.replace(newUrl);
      return window.history.replaceState(null, null, newUrl);
    };

    return Oblique;

  })();

  ObliqueNS.Oblique = Oblique;

  this.Oblique = Oblique;

  this.ObliqueNS = this.ObliqueNS || {};

  ObliqueError = (function(superClass) {
    extend(ObliqueError, superClass);

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
    function TimedDOMObserver(intervalInMs1) {
      this.intervalInMs = intervalInMs1;
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
