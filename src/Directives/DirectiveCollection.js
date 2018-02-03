// Generated by CoffeeScript 1.10.0
(function() {
  var DirectiveCollection;

  this.ObliqueNS = this.ObliqueNS || {};

  DirectiveCollection = (function() {
    function DirectiveCollection() {
      this._directives = {};
    }

    DirectiveCollection.prototype._toKeyName = function(str) {
      if (!str) {
        return null;
      }
      return str.trim().toLowerCase();
    };

    DirectiveCollection.prototype.add = function(directive) {
      return this._directives[this._toKeyName(directive.name)] = directive;
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
      return this._directives[this._toKeyName(name)];
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

}).call(this);
