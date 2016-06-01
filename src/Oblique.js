// Generated by CoffeeScript 1.10.0
(function() {
  var Oblique;

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
      var callback, i, len, ref, results;
      ref = this._onErrorCallbacks;
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
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
      if (navigator.userAgent.match(/Android/i)) {
        return document.location = uri;
      } else {
        window.location.replace(newUrl);
        return window.history.replaceState(null, null, newUrl);
      }
    };

    return Oblique;

  })();

  ObliqueNS.Oblique = Oblique;

  this.Oblique = Oblique;

}).call(this);
