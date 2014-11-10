var PhotoResultsDirective=function (data) {
    this.photoService=new PhotoService();
    this.onHashChange(data)
};

PhotoResultsDirective.prototype.onHashChange=function(data) {
    var hashParams = data.hashParams;
    Oblique().setHashParams(hashParams);

    var params=hashParams.find(["albums","color","price"])
    if (params.isEmpty()) {
        this._applyNoFilter();
        return;
    }

    this._applyFilter(params);
};

PhotoResultsDirective.prototype._applyNoFilter=function() {
    this.photoService.getAllPhotos(this._onSuccess, this._onError);
};

PhotoResultsDirective.prototype._applyFilter=function(params) {
    this.photoService.getFilteredPhotos(params, this._onSuccess, this._onError);
};

PhotoResultsDirective.prototype._onError=function (errorMessage) {
    $("#results").html("Error: "+errorMessage);
};

PhotoResultsDirective.prototype._onSuccess=function(jsonPhotos) {
    $("#results").html("");
    for(var i=0;i<jsonPhotos.length; i++) {
        var photo=jsonPhotos[i];
        $("#results").append("<img src='"+photo.thumbnailUrl+"' title='"+photo.price+"'/>");
    }
};

Oblique().registerDirective("PhotoResultsDirective", PhotoResultsDirective)