// Generated by CoffeeScript 1.7.1
(function() {
  var ObliqueError,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.ObliqueNS = this.ObliqueNS || {};

  ObliqueError = (function(_super) {
    __extends(ObliqueError, _super);

    function ObliqueError(message) {
      this.message = message;
      if (this === window) {
        return new Error(this.message);
      }
      this.name = "ObliqueNS.ObliqueError";
    }

    return ObliqueError;

  })(Error);

  ObliqueNS.Error = ObliqueError;

}).call(this);
