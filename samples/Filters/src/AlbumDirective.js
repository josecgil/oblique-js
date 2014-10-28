var AlbumDirective=function (data) {

    $("input[type=checkbox]").click(function(event) {
        var isChecked=$(event.target).prop('checked');
        var value=$(event.target).prop('value');
        var params=Oblique().getHashParams();
        var albumsParam=params.getParam("albums");
        if (isChecked) {
            if (albumsParam!=null) {
                albumsParam.add(value);
            } else {
                params.addArrayParam("albums",[value]);
            }
        } else {
            albumsParam.remove(value);
        }
        Oblique().setHashParams(params);
    });

};

Oblique().registerDirective("AlbumDirective", AlbumDirective);