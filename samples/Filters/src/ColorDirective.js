var ColorDirective=function (data) {
    this.colorFormOptions=new FormOptions(data.jQueryElement.find("select"));

    var self=this;
    this.colorFormOptions.change(function(event) {

        var select = $(event.target);
        var value=select.val();

        self._setParam("color", value);
    });
};


ColorDirective.prototype.onHashChange=function(data) {
    var colorParam=data.hashParams.getParam("color");
    if (colorParam.isEmpty()) {
        this.colorFormOptions.updateValue("");
        return;
    }
    this.colorFormOptions.updateValue(colorParam.value);
};


ColorDirective.prototype._setParam=function (name, value) {
    var params = Oblique().getHashParams();
    params.addSingleParam(name, value);
    Oblique().setHashParams(params);
};


Oblique().registerDirective("ColorDirective", ColorDirective);