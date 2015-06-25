(function() {
    this.Namespace = this.Namespace || {};

    var AppearDirective = function(data) {
        this._element = data.jQueryElement;

        var self=this;
        this._element.appear();
        this._element.on("appear", function() {
            if (self._element.data("appear")) return;
            self._element.data("appear", true);
            self._onFirstAppearance();
        });

    };

    AppearDirective.prototype._onFirstAppearance = function () {
        alert("First Appearance!");
    };

    this.Namespace.AppearDirective = AppearDirective;
    Oblique().registerDirective("Namespace.AppearDirective", Namespace.AppearDirective);

})(this);