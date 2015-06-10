// Generated by CoffeeScript 1.9.3
(function() {
  var CallbackCollection;

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

}).call(this);
