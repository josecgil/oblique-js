// Generated by CoffeeScript 1.7.1
(function() {
  var ClassDSL, DataModelDSL, DirectiveCollection, DirectiveProcessor, Element, Error, ModelDSL, ModelDSLPart, Oblique, ObliqueError, Template, TemplateFactory, TimedDOMObserver,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.ObliqueNS = this.ObliqueNS || {};

  ModelDSLPart = (function() {
    function ModelDSLPart(part) {
      var firstBracePosition, indexStr, lastBracePosition;
      this.name = part;
      this.hasIndex = false;
      this.index = void 0;
      firstBracePosition = part.indexOf("[");
      if (firstBracePosition !== -1) {
        this.hasIndex = true;
        this.name = part.substr(0, firstBracePosition);
        lastBracePosition = part.indexOf("]");
        indexStr = part.slice(firstBracePosition + 1, lastBracePosition);
        this.index = parseInt(indexStr, 10);
      }
    }

    return ModelDSLPart;

  })();

  ModelDSL = (function() {
    function ModelDSL(_expression) {
      var part, _i, _len, _ref;
      this._expression = _expression;
      this.hasFullModel = false;
      this._partsByDot = this._expression.split(".");
      this._checkSyntax();
      this._partsByDot.shift();
      if (this._partsByDot.length === 0) {
        this.hasFullModel = true;
        this.properties = void 0;
        return;
      }
      this.properties = [];
      _ref = this._partsByDot;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        part = _ref[_i];
        this.properties.push(new ModelDSLPart(part));
      }
    }

    ModelDSL.prototype._checkSyntax = function() {
      var lastIndex;
      if (this._partsByDot[0] !== "Model") {
        throw new ObliqueNS.Error("data-model must begins with 'Model or new'");
      }
      lastIndex = this._partsByDot.length - 1;
      if (this._partsByDot[lastIndex] === "") {
        throw new ObliqueNS.Error("data-model needs property after dot");
      }
    };

    return ModelDSL;

  })();

  ClassDSL = (function() {
    function ClassDSL(_expression) {
      var classNameAndBrackets, closeBracket, openBracket;
      this._expression = _expression;
      classNameAndBrackets = this._expression.split(" ")[1];
      openBracket = classNameAndBrackets.indexOf("(");
      if (openBracket === -1) {
        throw new ObliqueNS.Error("data-model needs open bracket after className");
      }
      closeBracket = classNameAndBrackets.indexOf(")", openBracket);
      if (closeBracket === -1) {
        throw new ObliqueNS.Error("data-model needs close bracket after className");
      }
      this.name = classNameAndBrackets.slice(0, openBracket);
    }

    return ClassDSL;

  })();

  DataModelDSL = (function() {
    function DataModelDSL(_expression) {
      var modelDSL, modelExpression;
      this._expression = _expression;
      this._checkIsNullOrEmpty();
      this._expression = this._removeExtraSpaces(this._expression);
      this.hasFullModel = false;
      this.modelProperties = void 0;
      this.className = void 0;
      this._hasClass = this._expression.split(" ")[0] === "new";
      if (this._hasClass) {
        this.className = (new ClassDSL(this._expression)).name;
      }
      modelExpression = this._extractModelExpression();
      if (modelExpression !== "") {
        modelDSL = new ModelDSL(modelExpression);
        this.modelProperties = modelDSL.properties;
        this.hasFullModel = modelDSL.hasFullModel;
      }
    }

    DataModelDSL.prototype._removeExtraSpaces = function(str) {
      while (str.indexOf("  ") !== -1) {
        str = str.replace("  ", " ");
      }
      str = str.trim();
      str = str.replace(" (", "(");
      str = str.replace(" )", ")");
      str = str.replace("( ", "(");
      str = str.replace(") ", ")");
      return str;
    };

    DataModelDSL.prototype._extractModelExpression = function() {
      var modelFirstPosition, modelLastPosition;
      if (!this._hasClass) {
        return this._expression;
      }
      modelFirstPosition = this._expression.indexOf("(Model");
      if (modelFirstPosition === -1) {
        return "";
      }
      modelLastPosition = this._expression.indexOf(")");
      return this._expression.slice(modelFirstPosition + 1, modelLastPosition);
    };

    DataModelDSL.prototype._checkIsNullOrEmpty = function() {
      if (this._isNullOrEmpty()) {
        throw new ObliqueNS.Error("data-model can't be null or empty");
      }
    };

    DataModelDSL.prototype._isNullOrEmpty = function() {
      if (this._expression === void 0) {
        return true;
      }
      if (this._expression === null) {
        return true;
      }
      if (this._expression === "") {
        return true;
      }
      return false;
    };

    return DataModelDSL;

  })();

  ObliqueNS.DataModelDSL = DataModelDSL;

  this.ObliqueNS = this.ObliqueNS || {};

  DirectiveCollection = (function() {
    function DirectiveCollection() {
      this.directives = [];
      this._directivesByName = {};
    }

    DirectiveCollection.prototype.count = function() {
      return this.directives.length;
    };

    DirectiveCollection.prototype._isAFunction = function(memberToTest) {
      return typeof memberToTest === "function";
    };

    DirectiveCollection.NOT_A_FUNCTION_CLASS_ERROR_MESSAGE = "registerDirective must be called with a Directive 'Constructor/Class'";

    DirectiveCollection.prototype._throwErrorIfDirectiveIsNotValid = function(directiveName, directive) {
      if (!directiveName || typeof directiveName !== "string") {
        throw new ObliqueNS.Error("registerDirective must be called with a string directiveName");
      }
      if (!this._isAFunction(directive)) {
        throw new ObliqueNS.Error(ObliqueNS.DirectiveCollection.NOT_A_FUNCTION_CLASS_ERROR_MESSAGE);
      }
    };

    DirectiveCollection.prototype.add = function(directiveName, directiveFn) {
      this._throwErrorIfDirectiveIsNotValid(directiveName, directiveFn);
      this.directives.push(directiveFn);
      return this._directivesByName[directiveName] = directiveFn;
    };

    DirectiveCollection.prototype.at = function(index) {
      return this.directives[index];
    };

    DirectiveCollection.prototype.getDirectiveByName = function(directiveName) {
      return this._directivesByName[directiveName];
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
      var directive, directiveData, directiveName, model, params, _i, _len, _ref, _results;
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
        model = this._getModel(obElement);
        params = this._getParams(obElement);
        directiveData = {
          domElement: obElement.getDOMElement(),
          jQueryElement: obElement.getjQueryElement(),
          model: model,
          params: params
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

    DirectiveProcessor.prototype._getModel = function(obElement) {
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
      this.templateFactory = new ObliqueNS.TemplateFactory();
      this._onErrorCallbacks = [];
    }

    Oblique.DEFAULT_INTERVAL_MS = 500;

    Oblique.prototype.getIntervalTimeInMs = function() {
      return this.directiveProcessor.getIntervalTimeInMs();
    };

    Oblique.prototype.setIntervalTimeInMs = function(newIntervalTimeInMs) {
      return this.directiveProcessor.setIntervalTimeInMs(newIntervalTimeInMs);
    };

    Oblique.prototype.registerDirective = function(directiveName, directiveConstructorFn) {
      return this.directiveProcessor.registerDirective(directiveName, directiveConstructorFn);
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

    Oblique.prototype.renderHtml = function(url, model) {
      var template;
      if (Handlebars === void 0) {
        throw new ObliqueNS.Error("Oblique().renderHtml() needs handlebarsjs loaded to work");
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
