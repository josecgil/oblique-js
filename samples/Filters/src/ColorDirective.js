var ColorDirective=function (data) {
    this.colorSelect=data.jQueryElement.find("select");

    var self=this;
    this.colorSelect.change(function(event) {

        var select = $(event.target);
        var value=select.val();

        self._setParam("color", value);
    });
};


ColorDirective.prototype.onHashChange=function(data) {
    var colorParam=data.hashParams.getParam("color");
    if (colorParam.isEmpty()) {
        this.colorSelect.val("");
        return;
    }
    this.colorSelect.val(colorParam.value);
};


ColorDirective.prototype._setParam=function (name, value) {
    var params = Oblique().getHashParams();
    params.addSingleParam(name, value);
    Oblique().setHashParams(params);
};


Oblique().registerDirective("ColorDirective", ColorDirective);