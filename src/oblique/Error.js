// Generated by CoffeeScript 1.7.1
(function() {
  var Error;

  this.ObliqueNS = this.ObliqueNS || {};

  Error = (function() {
    function Error(message) {
      this.message = message;
      this.name = "Oblique.Error";
      if (this === window) {
        return new Error(this.message);
      }
    }

    return Error;

  })();

  ObliqueNS.Error = Error;

}).call(this);
