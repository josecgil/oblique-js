(function() {
    this.Namespace = this.Namespace || {};

    var NearTagDirective = function(data) {
        this._element = data.jQueryElement;
        this._elementRemoved=false;
    };


    NearTagDirective.prototype._isNearOrPastViewPort=function() {
        var elementTop=this._element.position().top;
        var scrollBottom=$(window).scrollTop() + $(window).height();
        var proximity=elementTop-scrollBottom;
        return proximity<300;
    };

    NearTagDirective.prototype.onInterval=function() {
        console.log("Called!");
        if (this._elementRemoved) {
            NearTagDirective.prototype.onInterval=null;
            return;
        }
        if (this._isNearOrPastViewPort()) {
            this._elementRemoved=true;
            this._element.remove();
            console.log("Removed!");
        }
    };


    this.Namespace.NearTagDirective = NearTagDirective;
    Oblique().registerDirective("Namespace.NearTagDirective", Namespace.NearTagDirective);

})(this);