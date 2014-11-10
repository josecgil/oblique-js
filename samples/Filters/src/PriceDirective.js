var PriceDirective=function (data) {
    this.priceMinInput=data.jQueryElement.find("#priceMin");
    this.priceMaxInput=data.jQueryElement.find("#priceMax");

    var self=this;
    var onChangePrice=function(event) {
        self._setRangeParam("price", self.priceMinInput.val(), self.priceMaxInput.val());
    }
    this.priceMinInput.change(onChangePrice);
    this.priceMaxInput.change(onChangePrice);
    this.onHashChange(data)
};

PriceDirective.prototype._setRangeParam=function (name, min, max) {
    var params = Oblique().getHashParams();
    params.addRangeParam(name, min, max);
    Oblique().setHashParams(params);
};

PriceDirective.prototype.onHashChange=function(data) {
    var priceParam=data.hashParams.getParam("price");
    if (priceParam.isEmpty()) {
        this.priceMinInput.val(1);
        this.priceMaxInput.val(200);
        return;
    }
    this.priceMinInput.val(priceParam.min);
    this.priceMaxInput.val(priceParam.max);
};

Oblique().registerDirective("PriceDirective", PriceDirective);