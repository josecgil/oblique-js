function ObliqueError(message) {
    if (this == window) return new ObliqueError(message);
    this.message = message;
};

var Oblique = function () {
    if (this == window) return new Oblique();

    if (Oblique._singletonInstance) return Oblique._singletonInstance;
    Oblique._singletonInstance = this;

    //Default private properties
    this._intervalTimeInMs = Oblique.DEFAULT_INTERVAL_MS;
    this._lastIntervalId = undefined;
    this._directiveConstructors = [];

    this._listenToDirectivesInDOM();
};

Oblique.DEFAULT_INTERVAL_MS = 500;

Oblique.prototype._clearLastInterval = function () {
    if (this._lastIntervalId != undefined) {
        clearInterval(this._lastIntervalId);
    }
};

Oblique.prototype._applyDirectivesOnDocumentReady = function () {
    var self = this;
    $(document).ready(function () {
        self._applyDirectivesInDOM();
    });
};

Oblique.prototype._setNewInterval = function () {
    var self = this;
    this._lastIntervalId = setInterval(function () {
        self._applyDirectivesInDOM();
    }, this._intervalTimeInMs);
};

Oblique.prototype._listenToDirectivesInDOM = function () {
    this._clearLastInterval();
    this._applyDirectivesOnDocumentReady();
    this._setNewInterval();
};

Oblique.prototype._elementHasDirectiveApplied = function (DOMElement, directive) {
    return $(DOMElement).data(directive.NAME);
};

Oblique.prototype._applyDirectiveOnElement = function (directiveConstructorFn, DOMElement) {
    $(DOMElement).data(directiveConstructorFn.NAME, true);
    new directiveConstructorFn(DOMElement);
};

Oblique.prototype._findAllElementsWithAttrib = function (attribName) {
    var attribCSSSelector = "*[" + attribName + "]";
    return $(attribCSSSelector);
};

Oblique.prototype._applyDirectivesInDOM = function () {
    var self = this;
    $.each(this._directiveConstructors, function (i, directiveConstructorFn) {
        self._findAllElementsWithAttrib(directiveConstructorFn.NAME).each(function (i, DOMElement) {
            if (self._elementHasDirectiveApplied(DOMElement, directiveConstructorFn)) return true;
            self._applyDirectiveOnElement(directiveConstructorFn, DOMElement);
        });
    });
};

Oblique.prototype._addDirective = function (directiveConstructorFn) {
    this._directiveConstructors.push(directiveConstructorFn);
};

Oblique.prototype._isAFunction = function (memberToTest) {
    return typeof(memberToTest) == "function";
};

Oblique.prototype._containsDirective = function (directiveConstructorFnToCheck) {
    var containsDirective = false;
    $.each(this._directiveConstructors, function (i, directiveConstructorFn) {
        if (directiveConstructorFn.NAME == directiveConstructorFnToCheck.NAME) {
            containsDirective = true;
            return false;
        }
    });
    return containsDirective;
};

Oblique.prototype._throwErrorIfDirectiveIsNotValid = function (directiveConstructorFn) {
    if (!this._isAFunction(directiveConstructorFn)) {
        throw ObliqueError("registerDirective must be called with a Directive 'Constructor/Class'");
    }

    if (!directiveConstructorFn.NAME) {
        throw ObliqueError("directive must has an static NAME property");
    }

    if (this._containsDirective(directiveConstructorFn)) {
        throw ObliqueError("Directive '" + directiveConstructorFn.NAME + "' already registered");
    }
};

Oblique.prototype.getIntervalTimeInMs = function () {
    return this._intervalTimeInMs;
};

Oblique.prototype.setIntervalTimeInMs = function (newIntervalTimeInMs) {
    this._intervalTimeInMs = newIntervalTimeInMs;
    this._listenToDirectivesInDOM();
};

Oblique.prototype.registerDirective = function (directiveConstructorFn) {

    this._throwErrorIfDirectiveIsNotValid(directiveConstructorFn);

    this._addDirective(directiveConstructorFn);
};


