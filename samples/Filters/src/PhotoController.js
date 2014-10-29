var PhotoController=function (data) {
    this.photoService=new PhotoService();
    this.albumsFormOptions=new FormOptions(data.jQueryElement.find("input[type='checkbox']"));
    this.colorFormOptions=new FormOptions(data.jQueryElement.find("select"));
};

PhotoController.prototype.onHashChange=function(data) {
    var hashParams = data.hashParams;
    Oblique().setHashParams(hashParams);

    var albumsParam = hashParams.getParam("albums");
    var colorParam= hashParams.getParam("color");

    if ((albumsParam.isEmpty()) && (colorParam.isEmpty())) {
        this._applyNoFilter();
        return;
    };
    this._applyFilter(albumsParam, colorParam);
};

PhotoController.prototype._applyNoFilter=function() {
    this.albumsFormOptions.reset();
    this.photoService.getAllPhotos(this._onSuccess, this._onError);
};

PhotoController.prototype._applyFilter=function(albumsParam, colorParam) {
    this.albumsFormOptions.updateValues(albumsParam.values);

    this.colorFormOptions.updateValue(colorParam.value);

    this.photoService.getFilteredPhotos(albumsParam, colorParam, this._onSuccess, this._onError);
};

PhotoController.prototype._onError=function (errorMessage) {
    $("#results").html("Error: "+errorMessage);
};

PhotoController.prototype._onSuccess=function(jsonPhotos) {
    $("#results").html("");
    for(var i=0;i<jsonPhotos.length; i++) {
        var photo=jsonPhotos[i];
        $("#results").append("<img src='"+photo.thumbnailUrl+"' title='"+photo.albumId+"'/>");
    }
};


Oblique().registerController("PhotoController", PhotoController)