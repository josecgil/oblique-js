var AlbumDirective=function (data) {
    this.formOptions=new FormOptions(data.jQueryElement.find("input[type='checkbox']"));

    var self=this;
    this.formOptions.click(function(event) {

        var clickedAlbum = $(event.target);
        var value=clickedAlbum.val();
        var albumIsChecked=clickedAlbum.prop('checked');

        if (albumIsChecked) {
            self._addParam("albums", value);
        } else {
            self._removeParam("albums", value);
        }
    });
};

AlbumDirective.prototype._addParam=function (name, value) {
    var params = Oblique().getHashParams();
    var albumsParam=params.getParam(name);
    if (albumsParam.isEmpty()) {
        params.addArrayParam(name, [value]);
    } else {
        albumsParam.add(value);
    }
    Oblique().setHashParams(params);
};

AlbumDirective.prototype._removeParam=function(name, value) {
    var params = Oblique().getHashParams();
    var albumsParam=params.getParam(name);
    albumsParam.remove(value);
    Oblique().setHashParams(params);
};


Oblique().registerDirective("AlbumDirective", AlbumDirective);