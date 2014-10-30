var ColorDirective=function (data) {

    //Oblique().linkFormControlWithHashParam(data.jQueryElement.find("select"),"colors");

    //data-ob-linked-control-hashparam="colors"

    this.priceRangeFormOptions=new FormOptions(data.jQueryElement.find("select"));

    var self=this;
    this.priceRangeFormOptions.change(function(event) {

        var select = $(event.target);
        var value=select.val();

        self._setParam("color", value);
    });
};

/*
ColorDirective.prototype.onHashChange=function(data) {
    this.colorFormOptions.updateValue(colorParam.value);
};
*/

ColorDirective.prototype._setParam=function (name, value) {
    var params = Oblique().getHashParams();
    params.addSingleParam(name, value);
    Oblique().setHashParams(params);
};


Oblique().registerDirective("ColorDirective", ColorDirective);