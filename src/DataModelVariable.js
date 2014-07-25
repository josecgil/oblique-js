// Generated by CoffeeScript 1.7.1
(function() {
  var DataModelVariable;

  this.ObliqueNS = this.ObliqueNS || {};

  DataModelVariable = (function() {
    function DataModelVariable(_expression) {
      this._expression = _expression;
      this._firstEqualPosition = this._expression.indexOf("=");
      this.name = this._getVariableName();
      this.isSet = this._isSet();
    }

    DataModelVariable.prototype._getVariableName = function() {
      var parts, variableName;
      if (this._firstEqualPosition === -1) {
        return this._expression;
      }
      parts = this._expression.split("=");
      variableName = (parts[0].replace("var ", "")).trim();
      if (variableName === "") {
        return void 0;
      }
      return variableName;
    };

    DataModelVariable.prototype._isSet = function() {
      var nextChar;
      if (this._firstEqualPosition === -1) {
        return false;
      }
      nextChar = this._expression.substr(this._firstEqualPosition + 1, 1);
      if (nextChar === "=") {
        return false;
      }
      return true;
    };

    return DataModelVariable;

  })();

  ObliqueNS.DataModelVariable = DataModelVariable;

}).call(this);
