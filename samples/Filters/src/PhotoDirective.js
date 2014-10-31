var PhotoDirective=function () {
    this.photoService=new PhotoService();
};

PhotoDirective.prototype.onHashChange=function(data) {
    var hashParams = data.hashParams;
    Oblique().setHashParams(hashParams);

    var albumsParam = hashParams.getParam("albums");
    var colorParam= hashParams.getParam("color");
    var priceParam = hashParams.getParam("price");

    if ((albumsParam.isEmpty()) && (colorParam.isEmpty()) && (priceParam.isEmpty())) {
        this._applyNoFilter();
        return;
    }
    this._applyFilter(albumsParam, colorParam, priceParam);
};

PhotoDirective.prototype._applyNoFilter=function() {
    this.photoService.getAllPhotos(this._onSuccess, this._onError);
};

PhotoDirective.prototype._applyFilter=function(albumsParam, colorParam, priceParam) {
    this.photoService.getFilteredPhotos(albumsParam, colorParam, priceParam, this._onSuccess, this._onError);
};

PhotoDirective.prototype._onError=function (errorMessage) {
    $("#results").html("Error: "+errorMessage);
};

PhotoDirective.prototype._onSuccess=function(jsonPhotos) {
    $("#results").html("");
    for(var i=0;i<jsonPhotos.length; i++) {
        var photo=jsonPhotos[i];
        $("#results").append("<img src='"+photo.thumbnailUrl+"' title='"+photo.price+"'/>");
    }
};

Oblique().registerDirective("PhotoDirective", PhotoDirective)