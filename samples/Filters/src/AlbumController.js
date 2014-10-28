var AlbumController=function () {

};

AlbumController.prototype.onLoad=function(data){
    this.onHashChange(data);
};

AlbumController.prototype.onHashChange=function(data) {
    this._checkByUrl(data);
    this._loadDataByFilter(data.hashParams);
};

AlbumController.prototype._checkByUrl=function(data){
    var checkBoxes=data.jQueryElement.find("input[type='checkbox']");
    var albumsFilter=this._getFilterFromHash(data.hashParams);
    var self=this;
    checkBoxes.each(function(i, checkbox) {
        var albumIdFromCheckBox=$(checkbox).val();
        $(checkbox).prop("checked",false);
        if (albumsFilter==null) return;
        if (self._albumIsInAlbumFilter(albumIdFromCheckBox, albumsFilter)) {
            $(checkbox).prop("checked",true);
        }
    });
};

AlbumController.prototype._albumIsInAlbumFilter=function(albumId, albumFilter) {
    if (albumFilter==null) return true;
    if (albumFilter.indexOf(albumId)==-1) {
        return false;
    }
    return true;
};

AlbumController.prototype._getFilterFromHash=function(hashParams) {
    var albumsParam=hashParams.getParam("albums");
    if (albumsParam!=null) return albumsParam.values;
    return null;
};

AlbumController.prototype._loadDataByFilter=function(hashParams) {
    var self=this;
    $.getJSON( "/oblique-js/samples/Filters/json/photos.json", function( jsonPhotos ) {
        //hashParams.removeDuplicateArrayValues();?

        var albumsFilter=self._getFilterFromHash(hashParams);

        $("#results").html("");
        for(var i=0;i<jsonPhotos.length; i++) {
            var photo=jsonPhotos[i];
            if (self._albumIsInAlbumFilter(photo.albumId, albumsFilter)) {
                $("#results").append("<img src='"+photo.thumbnailUrl+"' />");
            }
        }
    });
};

Oblique().registerController("AlbumController", AlbumController)