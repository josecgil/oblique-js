var PhotoController=function (data) {
    this.photoService=new PhotoService();
    this.albumsFormOptions=new FormOptions(data.jQueryElement.find("input[type='checkbox']"));
    this.colorFormOptions=new FormOptions(data.jQueryElement.find("select"));
};

PhotoController.prototype.onHashChange=function(data) {
    var hashParams = data.hashParams;
    Oblique().setHashParams(hashParams);

    var albumsFilter = hashParams.getParam("albums");
    var colorFilter= hashParams.getParam("color");

    if ((albumsFilter.isEmpty()) && (colorFilter.isEmpty())) {
        this._applyNoFilter();
        return;
    };
    this._applyFilter(albumsFilter, colorFilter);
};

PhotoController.prototype._applyNoFilter=function() {
    this.albumsFormOptions.reset();
    this.photoService.getAllPhotos(this._onSuccess, this._onError);
};

PhotoController.prototype._applyFilter=function(albumsFilter, colorFilter) {
    this.albumsFormOptions.updateValues(albumsFilter.values);

    this.colorFormOptions.updateValue(colorFilter.value);

    this.photoService.getFilteredPhotos(this._onSuccess, this._onError);
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