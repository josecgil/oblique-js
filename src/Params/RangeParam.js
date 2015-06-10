// Generated by CoffeeScript 1.9.3
(function() {
  var Param, RangeParam,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  this.ObliqueNS = this.ObliqueNS || {};

  Param = ObliqueNS.Param;

  RangeParam = (function(superClass) {
    extend(RangeParam, superClass);

    function RangeParam(name, min1, max1) {
      this.name = name;
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
      if (Param.containsChar(hashParam.value, "(")) {
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

}).call(this);
