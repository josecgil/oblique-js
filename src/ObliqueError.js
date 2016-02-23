// Generated by CoffeeScript 1.10.0
(function() {
  var ObliqueError,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

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

}).call(this);
