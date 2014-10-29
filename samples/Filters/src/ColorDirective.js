var ColorDirective=function (data) {
    this.albumsFormOptions=new FormOptions(data.jQueryElement.find("select"));

    var self=this;
    this.albumsFormOptions.change(function(event) {

        var select = $(event.target);
        var value=select.val();

        self._setParam("color", value);
    });
};

ColorDirective.prototype._setParam=function (name, value) {
    var params = Oblique().getHashParams();
    params.addSingleParam(name, value);
    Oblique().setHashParams(params);
};


Oblique().registerDirective("ColorDirective", ColorDirective);