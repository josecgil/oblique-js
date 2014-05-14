(function () {

    this.DirectiveTag = function (domElement, directiveName) {
        this.jQueryElement = $(domElement);
        this._params = this._buildParams(directiveName);
    };

    DirectiveTag.prototype.attr = function (attribName) {
        return this.jQueryElement.attr(attribName);
    };

    DirectiveTag.prototype.intAttr = function (attribName) {
        var value = this.attr(attribName);
        if (!value) return undefined;
        return parseInt(value, 10);
    };

    DirectiveTag.prototype.param = function (paramName) {
        for (var i = 0; i < this._params.length; i++) {
            var param = this._params[i];
            if (param.isSameName(paramName)) return this._removeQuotes(param.value);
        }
        return undefined;
    };

    DirectiveTag.prototype.intParam = function (paramName) {
        var value = this.param(paramName);
        if (!value) return undefined;
        return parseInt(value, 10);
    };

    DirectiveTag.prototype._hasQuotes = function (paramValue, quoteChar) {
        var startsWithQuote = (paramValue[0] == quoteChar);
        var endsWithQuote = (paramValue[paramValue.length - 1] == quoteChar);

        if (!startsWithQuote) return false;
        if (!endsWithQuote) return false;
        return true;
    };

    DirectiveTag.prototype._isBetweenQuotes = function (paramValue) {
        if (this._hasQuotes(paramValue, "'")) return true;
        if (this._hasQuotes(paramValue, "\"")) return true;
        return false;
    };

    DirectiveTag.prototype._removeQuotes = function (paramValue) {
        if (paramValue.length < 2) return paramValue;
        if (!this._isBetweenQuotes(paramValue)) return paramValue;
        return paramValue.substr(1, paramValue.length - 2);
    };

    DirectiveTag.prototype._buildParams = function (directiveName) {
        var paramsArray = [];
        var paramValue = this.attr(directiveName);
        if (!paramValue) return paramsArray;

        var params = paramValue.split(";");
        for (var i = 0; i < params.length; i++) {
            paramsArray.push(new DirectiveParameter(directiveName, params[i]));
        }
        return paramsArray;
    }

    var DirectiveParameter = function (directiveName, parameter) {
        var directiveName = directiveName;
        var parameter = parameter;
        var param = parameter.split(":");
        var originalName = param[0];
        var originalValue = param[1];

        if (parameter.indexOf(":") == -1) throw new DirectiveTagError("invalid param '" + directiveName + " -> " + parameter + "\'");
        if (originalName.length == 0) throw new DirectiveTagError("invalid param '" + directiveName + " -> " + parameter + " hasn\'t key\'");
        if (originalValue.length == 0) throw new DirectiveTagError("invalid param '" + directiveName + " -> " + originalName + " hasn\'t value\'");

        this.name = originalName.trim();
        this.value = originalValue.trim();

        this.isSameName = function (otherName) {
            if (this.name.toUpperCase() === otherName.trim().toUpperCase()) return true;
            return false;
        };
    };

}).call(this);



