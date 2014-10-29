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
    var self=this;

    this.formOptions.reset();
    this.photoService.getAllPhotos(function (jsonPhotos) {
        self._renderHtml(jsonPhotos);
    }, function (errorMessage) {
        self._renderHtmlError(errorMessage);
    });
};

AlbumController.prototype._applyFilter=function(albumsFilter) {
    var self=this;
    
    this.formOptions.updateValues(albumsFilter.values);
    this.photoService.getFilteredPhotos(function (jsonPhotos) {
        self._renderHtml(jsonPhotos);
    }, function (errorMessage) {
        self._renderHtmlError(errorMessage);
    });
};


AlbumController.prototype._renderHtml=function(jsonPhotos) {
    $("#results").html("");
    for(var i=0;i<jsonPhotos.length; i++) {
        var photo=jsonPhotos[i];
        $("#results").append("<img src='"+photo.thumbnailUrl+"' />");
    }
};

AlbumController.prototype._renderHtmlError=function(errorMessage) {
    $("#results").html("Error: "+errorMessage);
};

Oblique().registerController("AlbumController", AlbumController)