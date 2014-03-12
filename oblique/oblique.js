
function ObliqueError(message) {
    if (this==window) return new ObliqueError(message);
    this.message=message;
};

var Oblique=function() {
    if (this==window) return new Oblique();

    if (Oblique._singletonInstance) return Oblique._singletonInstance;
    Oblique._singletonInstance = this;

    //Default private properties
    this._intervalTimeInMs=Oblique.DEFAULT_INTERVAL_MS;
    this._lastIntervalId=undefined;
    this._directiveConstructors=[];

    this._listenToDirectivesInDOM();
};

Oblique.DEFAULT_INTERVAL_MS = 100;

Oblique.prototype._listenToDirectivesInDOM=function() {
    var self=this;
    if (this._lastIntervalId!=undefined) {
        clearInterval(this._lastIntervalId);
    }
    this._lastIntervalId=setInterval(function () {
        self._applyDirectivesInDOM();
    }, this._intervalTimeInMs);
};

Oblique.prototype._elementHasDirectiveApplied = function (element, directive) {
    return element.data(directive.NAME);
}

Oblique.prototype._applyDirectiveOnElement = function(directive, element) {
    element.data(directive.NAME, true);
    var DOMElement=element.get(0);
    new directive(DOMElement);
};

Oblique.prototype._findAllElementWithAttrib=function(attribName) {
    var attribCSSSelector="*["+ attribName+"]";
    return $(attribCSSSelector);
};

Oblique.prototype._applyDirectivesInDOM = function() {
    var self=this;
    $.each(this._directiveConstructors, function(i, directive) {
        self._findAllElementWithAttrib(directive.NAME).each(function(i, DOMElement){
            var element=$(DOMElement);
            if (self._elementHasDirectiveApplied(element, directive)) return;
            self._applyDirectiveOnElement(directive, element);
        });
    });
};

Oblique.prototype._addDirective = function(directiveConstructorFn) {
    this._directiveConstructors.push(directiveConstructorFn);
};

Oblique.prototype._isAFunction=function(memberToTest) {
    return typeof(memberToTest) == "function";
};

Oblique.prototype.getIntervalTimeInMs=function() {
    return this._intervalTimeInMs;
};

Oblique.prototype.setIntervalTimeInMs=function(newIntervalTimeInMs) {
    this._intervalTimeInMs=newIntervalTimeInMs;
    this._listenToDirectivesInDOM();
};

Oblique.prototype._containsDirective=function(directiveConstructorFnToCheck) {
    var containsDirective=false;
    $.each(this._directiveConstructors, function(i, directiveConstructorFn){
       if (directiveConstructorFn.NAME==directiveConstructorFnToCheck.NAME) {
           containsDirective=true;
           return false;
       }
    });
    return containsDirective;
};

Oblique.prototype.registerDirective = function(directiveConstructorFn) {
    if (!this._isAFunction(directiveConstructorFn)) {
        throw ObliqueError("registerDirective must be called with a Directive 'Constructor/Class'");
    }

    if (!directiveConstructorFn.NAME) {
        throw ObliqueError("directive must has an static NAME property");
    }

    if (this._containsDirective(directiveConstructorFn)) {
        throw ObliqueError("Directive '"+directiveConstructorFn.NAME+"' already registered");
    }

    this._addDirective(directiveConstructorFn);
};
