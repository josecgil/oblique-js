// Generated by CoffeeScript 1.10.0
(function() {
  var Param, SingleParam,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  this.ObliqueNS = this.ObliqueNS || {};

  Param = ObliqueNS.Param;

  SingleParam = (function(superClass) {
    extend(SingleParam, superClass);

    function SingleParam(name, value1) {
      this.name = name;
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
      var hashParam;
      hashParam = Param.parse(strHashParam);
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

}).call(this);
