// Generated by CoffeeScript 1.10.0
(function() {
  var ArrayParam, EmptyParam, ParamCollection, RangeParam, SingleParam,
    indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  this.ObliqueNS = this.ObliqueNS || {};

  ArrayParam = ObliqueNS.ArrayParam;

  RangeParam = ObliqueNS.RangeParam;

  SingleParam = ObliqueNS.SingleParam;

  EmptyParam = ObliqueNS.EmptyParam;

  ParamCollection = (function() {
    function ParamCollection(locationHash) {
      var hashParam, i, len, param, ref;
      this.removeAll();
      if (this._StringIsEmpty(locationHash)) {
        return;
      }
      locationHash = locationHash.replace("#", "");
      ref = locationHash.split("&");
      for (i = 0, len = ref.length; i < len; i++) {
        hashParam = ref[i];
        hashParam = decodeURIComponent(hashParam);
        param = void 0;
        if (SingleParam.is(hashParam)) {
          param = SingleParam.createFrom(hashParam);
        } else if (RangeParam.is(hashParam)) {
          param = RangeParam.createFrom(hashParam);
        } else if (ArrayParam.is(hashParam)) {
          param = ArrayParam.createFrom(hashParam);
        } else {
          param = new EmptyParam();
        }
        this.add(param);
      }
    }

    ParamCollection.prototype._StringIsEmpty = function(value) {
      if (value === void 0) {
        return true;
      }
      if (value.trim().length === 0) {
        return true;
      }
      return false;
    };

    ParamCollection.prototype.add = function(param) {
      this._params[param.name.toLowerCase()] = param;
      return param;
    };

    ParamCollection.prototype.addSingleParam = function(name, value) {
      return this.add(new SingleParam(name, value));
    };

    ParamCollection.prototype.addRangeParam = function(name, min, max) {
      return this.add(new RangeParam(name, min, max));
    };

    ParamCollection.prototype.addArrayParam = function(name, values) {
      return this.add(new ArrayParam(name, values));
    };

    ParamCollection.prototype.remove = function(paramName) {
      return this._params[paramName] = void 0;
    };

    ParamCollection.prototype.removeAll = function() {
      return this._params = {};
    };

    ParamCollection.prototype.getParam = function(paramName) {
      var param;
      param = this._params[paramName.toLowerCase()];
      if (param === void 0) {
        return new EmptyParam();
      }
      return param;
    };

    ParamCollection.prototype.find = function(paramNames) {
      var foundedParamCollection, lowerCaseParamNames, param, paramName, ref, ref1;
      lowerCaseParamNames = (function() {
        var i, len, results;
        results = [];
        for (i = 0, len = paramNames.length; i < len; i++) {
          param = paramNames[i];
          results.push(param.toLowerCase());
        }
        return results;
      })();
      foundedParamCollection = new ParamCollection();
      ref = this._params;
      for (paramName in ref) {
        param = ref[paramName];
        if ((!this._isEmptyParam(param)) && (ref1 = paramName.toLowerCase(), indexOf.call(lowerCaseParamNames, ref1) >= 0)) {
          foundedParamCollection.add(param);
        }
      }
      return foundedParamCollection;
    };

    ParamCollection.prototype.isEmpty = function() {
      if (this.count() === 0) {
        return true;
      }
      return false;
    };

    ParamCollection.prototype.count = function() {
      var count, param, paramName, ref;
      count = 0;
      ref = this._params;
      for (paramName in ref) {
        param = ref[paramName];
        if (!this._isEmptyParam(param)) {
          count++;
        }
      }
      return count;
    };

    ParamCollection.prototype._isEmptyParam = function(param) {
      if (param === void 0) {
        return true;
      }
      return param.isEmpty();
    };

    ParamCollection.prototype.getLocationHash = function() {
      var hash, param, paramName, ref;
      hash = "#";
      ref = this._params;
      for (paramName in ref) {
        param = ref[paramName];
        if (param === void 0) {
          continue;
        }
        hash += param.getLocationHash() + "&";
      }
      hash = hash.substr(0, hash.length - 1);
      if (hash === "#") {
        hash = "";
      }
      return hash;
    };

    return ParamCollection;

  })();

  ObliqueNS.ParamCollection = ParamCollection;

}).call(this);
