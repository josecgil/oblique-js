// Generated by CoffeeScript 1.8.0
(function() {
  var ArrayParam, EmptyParam, ParamCollection, RangeParam, SingleParam;

  this.ObliqueNS = this.ObliqueNS || {};

  ArrayParam = ObliqueNS.ArrayParam;

  RangeParam = ObliqueNS.RangeParam;

  SingleParam = ObliqueNS.SingleParam;

  EmptyParam = ObliqueNS.EmptyParam;

  ParamCollection = (function() {
    function ParamCollection(locationHash) {
      var hashParam, param, _i, _len, _ref;
      this.removeAll();
      if (this._StringIsEmpty(locationHash)) {
        return;
      }
      locationHash = locationHash.replace("#", "");
      _ref = locationHash.split("&");
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        hashParam = _ref[_i];
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
      this._params[param.name] = param;
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
      param = this._params[paramName];
      if (param === void 0) {
        return new EmptyParam();
      }
      return param;
    };

    ParamCollection.prototype.count = function() {
      var count, param, paramName, _ref;
      count = 0;
      _ref = this._params;
      for (paramName in _ref) {
        param = _ref[paramName];
        if (!this._isEmpty(param)) {
          count++;
        }
      }
      return count;
    };

    ParamCollection.prototype._isEmpty = function(param) {
      if (param === void 0) {
        return true;
      }
      return param.isEmpty();
    };

    ParamCollection.prototype.getLocationHash = function() {
      var hash, param, paramName, _ref;
      if (this.count() === 0) {
        return "";
      }
      hash = "#";
      _ref = this._params;
      for (paramName in _ref) {
        param = _ref[paramName];
        hash += param.getLocationHash() + "&";
      }
      hash = hash.substr(0, hash.length - 1);
      return hash;
    };

    return ParamCollection;

  })();

  ObliqueNS.ParamCollection = ParamCollection;

}).call(this);
