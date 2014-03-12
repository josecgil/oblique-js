var Oblique=function() {
    if (this==window) return new Oblique();

    if (Oblique._singletonInstance) return Oblique._singletonInstance;
    Oblique._singletonInstance = this;

    //Default private properties
    this._intervalTimeInMs=this.DEFAULT_INTERVAL_MS;
    this._lastIntervalId=undefined;
    this._directiveConstructors=[];

    this._listenToDirectivesInDOM();
};

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
    for(var i=0;i<this._directiveConstructors.length;i++) {
        var directive=this._directiveConstructors[i];
        var self=this;
        this._findAllElementWithAttrib(directive.NAME).each(function(i, DOMElement){
            var element=$(DOMElement);
            if (self._elementHasDirectiveApplied(element, directive)) return;
            self._applyDirectiveOnElement(directive, element);
        });
    }
};

Oblique.prototype.getIntervalTimeInMs=function() {
    return this._intervalTimeInMs;
};

Oblique.prototype.setIntervalTimeInMs=function(newIntervalTimeInMs) {
    this._intervalTimeInMs=newIntervalTimeInMs;
    this._listenToDirectivesInDOM();
};


Oblique.prototype.DEFAULT_INTERVAL_MS = 100;

Oblique.prototype._observe = function(directiveConstructorFn) {
    this._directiveConstructors.push(directiveConstructorFn);
};

Oblique.prototype._isAFunction=function(memberToTest) {
    return typeof(memberToTest) == "function";
};

Oblique.prototype.registerDirective = function(directiveConstructorFn) {
    if (!this._isAFunction(directiveConstructorFn)) {
        throw new Error("registerDirective must be called with a Directive 'Constructor/Class'");
    }

    if (!directiveConstructorFn.NAME) {
        throw new Error("directive must has an NAME property");
    }

    this._observe(directiveConstructorFn);
};
