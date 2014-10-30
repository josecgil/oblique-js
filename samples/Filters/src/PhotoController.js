var PhotoController=function (data) {
    this.photoService=new PhotoService();
    this.albumsFormOptions=new FormOptions(data.jQueryElement.find("input[type='checkbox']"));
    this.colorFormOptions=new FormOptions(data.jQueryElement.find("select"));
    this.priceRangeFormOptions=new FormOptions(data.jQueryElement.find("input[type=text]"));
};

PhotoController.prototype.onHashChange=function(data) {
    var hashParams = data.hashParams;
    Oblique().setHashParams(hashParams);

    var albumsParam = hashParams.getParam("albums");
    var colorParam= hashParams.getParam("color");
    var priceParam = hashParams.getParam("price");

    if ((albumsParam.isEmpty()) && (colorParam.isEmpty()) && (priceParam.isEmpty())) {
        this._applyNoFilter();
        return;
    };
    this._applyFilter(albumsParam, colorParam, priceParam);
};

PhotoController.prototype._applyNoFilter=function() {
    this.albumsFormOptions.reset();
    this.photoService.getAllPhotos(this._onSuccess, this._onError);
};

PhotoController.prototype._applyFilter=function(albumsParam, colorParam, priceParam) {
    this.albumsFormOptions.updateValues(albumsParam.values);
    this.colorFormOptions.updateValue(colorParam.value);
    this.priceRangeFormOptions.updateRange(priceParam.min, priceParam.max);

    this.photoService.getFilteredPhotos(albumsParam, colorParam, priceParam, this._onSuccess, this._onError);
};

PhotoController.prototype._onError=function (errorMessage) {
    $("#results").html("Error: "+errorMessage);
};

PhotoController.prototype._onSuccess=function(jsonPhotos) {
    $("#results").html("");
    for(var i=0;i<jsonPhotos.length; i++) {
        var photo=jsonPhotos[i];
        $("#results").append("<img src='"+photo.thumbnailUrl+"' title='"+photo.price+"'/>");
    }
};


Oblique().registerController("PhotoController", PhotoController)