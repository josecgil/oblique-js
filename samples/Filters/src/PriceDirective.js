var PriceDirective=function (data) {
    this.priceRangeFormOptions=new FormOptions(data.jQueryElement.find("input[type=text]"));

    var self=this;
    this.priceRangeFormOptions.change(function(event) {

        var min= $("#priceMin").val();
        var max= $("#priceMax").val();

        self._setRangeParam("price", min, max);
    });
};

PriceDirective.prototype._setRangeParam=function (name, min, max) {
    var params = Oblique().getHashParams();
    params.addRangeParam(name, min, max);
    Oblique().setHashParams(params);
};


Oblique().registerDirective("PriceDirective", PriceDirective);