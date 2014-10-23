// Generated by CoffeeScript 1.8.0
(function() {
  var Oblique;

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

}).call(this);
