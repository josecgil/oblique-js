// Generated by CoffeeScript 1.7.1
(function() {
  var DirectiveCollection;

  this.ObliqueNS = this.ObliqueNS || {};

  DirectiveCollection = (function() {
    function DirectiveCollection() {
      this.directives = [];
      this._cssExpressions = [];
    }

    DirectiveCollection.prototype.count = function() {
      return this.directives.length;
    };

    DirectiveCollection.prototype._isAFunction = function(memberToTest) {
      return typeof memberToTest === "function";
    };

    DirectiveCollection.NOT_A_FUNCTION_CLASS_ERROR_MESSAGE = "registerDirective must be called with a Directive 'Constructor/Class'";

    DirectiveCollection.DOESNT_HAVE_PROPERTY_CSS_EXPR_MESSAGE = "directive must has an static CSS_EXPRESSION property";

    DirectiveCollection.prototype._throwErrorIfDirectiveIsNotValid = function(directive) {
      if (!this._isAFunction(directive)) {
        throw new ObliqueNS.Error(ObliqueNS.DirectiveCollection.NOT_A_FUNCTION_CLASS_ERROR_MESSAGE);
      }
      if (!directive.CSS_EXPRESSION) {
        throw new ObliqueNS.Error(ObliqueNS.DirectiveCollection.DOESNT_HAVE_PROPERTY_CSS_EXPR_MESSAGE);
      }
    };

    DirectiveCollection.prototype._hashCode = function(str) {
      var chr, hash, i, len;
      hash = 0;
      i = void 0;
      chr = void 0;
      len = void 0;
      if (str.length === 0) {
        return hash;
      }
      i = 0;
      len = str.length;
      while (i < len) {
        chr = str.charCodeAt(i);
        hash = ((hash << 5) - hash) + chr;
        hash |= 0;
        i++;
      }
      return hash;
    };

    DirectiveCollection.prototype.add = function(directive) {
      this._throwErrorIfDirectiveIsNotValid(directive);
      directive.hashCode = this._hashCode(directive.toString() + directive.CSS_EXPRESSION);
      this.directives.push(directive);
      return this._buildCSSExpressions();
    };

    DirectiveCollection.prototype.at = function(index) {
      return this.directives[index];
    };

    DirectiveCollection.prototype._containsCssExpr = function(exprToSearch, exprArray) {
      var expr, _i, _len;
      for (_i = 0, _len = exprArray.length; _i < _len; _i++) {
        expr = exprArray[_i];
        if (exprToSearch === expr) {
          return true;
        }
      }
      return false;
    };

    DirectiveCollection.prototype._buildCSSExpressions = function() {
      var cssExpr, directive, _i, _len, _ref, _results;
      this._cssExpressions = [];
      _ref = this.directives;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        directive = _ref[_i];
        cssExpr = directive.CSS_EXPRESSION;
        if (this._containsCssExpr(cssExpr, this._cssExpressions)) {
          continue;
        }
        _results.push(this._cssExpressions.push(cssExpr));
      }
      return _results;
    };

    DirectiveCollection.prototype.getCSSExpressions = function() {
      return this._cssExpressions;
    };

    DirectiveCollection.prototype.getDirectivesByCSSExpression = function(cssExpression) {
      var cssExpr, directive, directivesWithCSSExpr, _i, _len, _ref;
      directivesWithCSSExpr = [];
      _ref = this.directives;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        directive = _ref[_i];
        cssExpr = directive.CSS_EXPRESSION;
        if (cssExpr !== cssExpression) {
          continue;
        }
        directivesWithCSSExpr.push(directive);
      }
      return directivesWithCSSExpr;
    };

    return DirectiveCollection;

  })();

  ObliqueNS.DirectiveCollection = DirectiveCollection;

}).call(this);

//# sourceMappingURL=DirectiveCollection.map
