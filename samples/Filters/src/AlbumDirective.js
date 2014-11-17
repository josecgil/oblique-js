var AlbumDirective=function (data) {
    this.albumsCheckboxes=data.jQueryElement.find("input[type='checkbox']");

    var self=this;
    this.albumsCheckboxes.click(function(event) {

        var clickedAlbum = $(event.target);
        var value=clickedAlbum.val();
        var albumIsChecked=clickedAlbum.prop('checked');

        if (albumIsChecked) {
            self._addParam("albums", value);
        } else {
            self._removeParam("albums", value);
        }
    });
    this.onHashChange(data)
};

AlbumDirective.prototype.onHashChange=function(data) {
    var albumsParam=data.hashParams.getParam("albums");
    if (albumsParam.isEmpty()) {
        this.albumsCheckboxes.each(function(i, element) {
            $(element).prop("checked",false)
        });
        return;
    }

    this.albumsCheckboxes.each(function(i, element) {
        var checkedValue=false;
        if (albumsParam.values.containsValue($(element).val())) {
            checkedValue=true;
        }
        $(element).prop("checked",checkedValue);
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