// Generated by CoffeeScript 1.10.0
(function() {
  var ArrayParam, Param, ParamParser,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty,
    indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  this.ObliqueNS = this.ObliqueNS || {};

  Param = ObliqueNS.Param;

  ParamParser = ObliqueNS.ParamParser;

  ArrayParam = (function(superClass) {
    extend(ArrayParam, superClass);

    function ArrayParam(name, values) {
      var i, len, value;
      this.name = name;
      ArrayParam.__super__.constructor.call(this, this.name);
      if (!this._isArray(values)) {
        throw new ObliqueNS.Error("Param constructor must be called with second param array");
      }
      this.values = [];
      for (i = 0, len = values.length; i < len; i++) {
        value = values[i];
        this.add(value);
      }
    }

    ArrayParam.prototype._isArray = function(value) {
      if (Object.prototype.toString.call(value) === '[object Array]') {
        return true;
      }
      return false;
    };

    ArrayParam.prototype.add = function(value) {
      if (!this._isString(value)) {
        throw new ObliqueNS.Error("Array param must be an string");
      }
      return this.values.push(value);
    };

    ArrayParam.prototype.remove = function(value) {
      var index;
      index = this.values.indexOf(value);
      if (index === -1) {
        return;
      }
      this.values.splice(index, 1);
      if (this.count() === 0) {
        return this.values = void 0;
      }
    };

    ArrayParam.prototype.isEmpty = function() {
      if (this.count() === 0) {
        return true;
      }
      return false;
    };

    ArrayParam.prototype.getLocationHash = function() {
      var hash, i, len, ref, value;
      if (this.count() === 0) {
        return this.name;
      }
      hash = this.name + "=[";
      ref = this.values;
      for (i = 0, len = ref.length; i < len; i++) {
        value = ref[i];
        hash += value + ",";
      }
      hash = hash.substr(0, hash.length - 1);
      return hash += "]";
    };

    ArrayParam.prototype.count = function() {
      if (this.values === void 0) {
        return 0;
      }
      if (this.values.length === 0) {
        return 0;
      }
      return this.values.length;
    };

    ArrayParam.is = function(strHashParam) {
      var hashParam;
      hashParam = Param.parse(strHashParam);
      if (Param.isEnclosedInChars(hashParam.value, "[", "]")) {
        return true;
      }
      return false;
    };

    ArrayParam.createFrom = function(strHashParam) {
      var hashParam, i, len, trimmedValues, value, values;
      hashParam = Param.parse(strHashParam);
      value = hashParam.value.replace("[", "").replace("]", "");
      values = value.split(",");
      trimmedValues = [];
      for (i = 0, len = values.length; i < len; i++) {
        value = values[i];
        value = value.trim();
        if (value !== void 0) {
          value = unescape(value);
        }
        if (!Param.stringIsNullOrEmpty(value)) {
          trimmedValues.push(value);
        }
      }
      return new ArrayParam(hashParam.name, trimmedValues);
    };

    ArrayParam.prototype.containsValue = function(value) {
      if (this.isEmpty()) {
        return false;
      }
      if (indexOf.call(this.values, value) >= 0) {
        return true;
      }
      return false;
    };

    return ArrayParam;

  })(ObliqueNS.Param);

  ObliqueNS.ArrayParam = ArrayParam;

}).call(this);
