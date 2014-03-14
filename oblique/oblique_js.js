function ObliqueJSError(message) {
    if (this == window) return new ObliqueJSError(message);
    this.message = message;
};

var ObliqueJS = function () {
    if (this == window) return new ObliqueJS();

    if (ObliqueJS._singletonInstance) return ObliqueJS._singletonInstance;
    ObliqueJS._singletonInstance = this;

    //Default private properties
    this._intervalTimeInMs = ObliqueJS.DEFAULT_INTERVAL_MS;
    this._lastIntervalId = undefined;
    this._directiveConstructors = [];

    this._listenToDirectivesInDOM();
};

ObliqueJS.DEFAULT_INTERVAL_MS = 500;

ObliqueJS.prototype._clearLastInterval = function () {
    if (this._lastIntervalId != undefined) {
        clearInterval(this._lastIntervalId);
    }
};

ObliqueJS.prototype._applyDirectivesOnDocumentReady = function () {
    var self = this;
    $(document).ready(function () {
        self._applyDirectivesInDOM();
    });
};

ObliqueJS.prototype._setNewInterval = function () {
    var self = this;
    this._lastIntervalId = setInterval(function () {
        self._applyDirectivesInDOM();
    }, this._intervalTimeInMs);
};

ObliqueJS.prototype._listenToDirectivesInDOM = function () {
    //this._clearLastInterval();
    this._applyDirectivesOnDocumentReady();
    //this._setNewInterval();
};

ObliqueJS.prototype._elementHasDirectiveApplied = function (DOMElement, directive) {
    return $(DOMElement).data(directive.CSS_EXPRESSION);
};

ObliqueJS.prototype._applyDirectiveOnElement = function (directiveConstructorFn, DOMElement) {
    $(DOMElement).data(directiveConstructorFn.CSS_EXPRESSION, true);
    new directiveConstructorFn(DOMElement);
};

ObliqueJS.prototype._applyDirectivesInDOM = function () {
    var self = this;

    var rootElement = document.getElementsByTagName("body")[0];
    bqDOMDocument.traverse(rootElement, function (DOMElement) {
        if (DOMElement.nodeType != bqDOMDocument.NODE_TYPE_ELEMENT) return true;

        for (var i = 0; i < self._directiveConstructors.length; i++) {
            var directiveConstructorFn = self._directiveConstructors[i];
            if ($(DOMElement).is(directiveConstructorFn.CSS_EXPRESSION)) {
                if (self._elementHasDirectiveApplied(DOMElement, directiveConstructorFn)) return true;
                self._applyDirectiveOnElement(directiveConstructorFn, DOMElement);
            }
        }
    });
};

ObliqueJS.prototype._addDirective = function (directiveConstructorFn) {
    this._directiveConstructors.push(directiveConstructorFn);
};

ObliqueJS.prototype._isAFunction = function (memberToTest) {
    return typeof(memberToTest) == "function";
};

ObliqueJS.prototype._containsDirective = function (directiveConstructorFnToCheck) {
    var containsDirective = false;
    $.each(this._directiveConstructors, function (i, directiveConstructorFn) {
        if (directiveConstructorFn.CSS_EXPRESSION == directiveConstructorFnToCheck.CSS_EXPRESSION) {
            containsDirective = true;
            return false;
        }
    });
    return containsDirective;
};

ObliqueJS.prototype._throwErrorIfDirectiveIsNotValid = function (directiveConstructorFn) {
    if (!this._isAFunction(directiveConstructorFn)) {
        throw ObliqueJSError("registerDirective must be called with a Directive 'Constructor/Class'");
    }

    if (!directiveConstructorFn.CSS_EXPRESSION) {
        throw ObliqueJSError("directive must has an static CSS_EXPRESSION property");
    }

    if (this._containsDirective(directiveConstructorFn)) {
        throw ObliqueJSError("Directive '" + directiveConstructorFn.CSS_EXPRESSION + "' already registered");
    }
};

ObliqueJS.prototype.getIntervalTimeInMs = function () {
    return this._intervalTimeInMs;
};

ObliqueJS.prototype.setIntervalTimeInMs = function (newIntervalTimeInMs) {
    this._intervalTimeInMs = newIntervalTimeInMs;
    this._listenToDirectivesInDOM();
};

ObliqueJS.prototype.registerDirective = function (directiveConstructorFn) {

    this._throwErrorIfDirectiveIsNotValid(directiveConstructorFn);

    this._addDirective(directiveConstructorFn);
};


