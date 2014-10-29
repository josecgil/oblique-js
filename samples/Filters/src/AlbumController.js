var AlbumController=function (data) {
    this.photoService=new PhotoService();
    this.formOptions=new FormOptions(data.jQueryElement.find("input[type='checkbox']"));
};

AlbumController.prototype.onHashChange=function(data) {
    var hashParams = data.hashParams;
    Oblique().setHashParams(hashParams);

    var albumsFilter = hashParams.getParam("albums");

    if (albumsFilter.isEmpty()) {
        this._applyNoFilter();
        return;
    };
    this._applyFilter(albumsFilter);
};

AlbumController.prototype._applyNoFilter=function() {
    this.formOptions.reset();
    this.photoService.getAllPhotos(this._onSuccess, this._onError);
};

AlbumController.prototype._applyFilter=function(albumsFilter) {
    this.formOptions.updateValues(albumsFilter.values);
    this.photoService.getFilteredPhotos(this._onSuccess, this._onError);
};

AlbumController.prototype._onError=function (errorMessage) {
    $("#results").html("Error: "+errorMessage);
};

AlbumController.prototype._onSuccess=function(jsonPhotos) {
    $("#results").html("");
    for(var i=0;i<jsonPhotos.length; i++) {
        var photo=jsonPhotos[i];
        $("#results").append("<img src='"+photo.thumbnailUrl+"' />");
    }
};


Oblique().registerController("AlbumController", AlbumController)