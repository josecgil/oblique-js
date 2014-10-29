(function() {

    var PhotoService=function() {

    };


    PhotoService.prototype.getAllPhotos=function(onSuccess, onError) {
        var noFilterFunction = function () {
            return true;
        };
        return this._getPhotos(noFilterFunction, onSuccess, onError);
    }

    PhotoService.prototype.getFilteredPhotos=function(onSuccess, onError) {
        var filterByAlbumIdFunction=function(album) {
            var albumsHashValues = Oblique().getHashParams().getParam("albums").values;
            if (albumsHashValues.indexOf(album.albumId)==-1) {
                return false;
            }
            return true;
        };
        return this._getPhotos(filterByAlbumIdFunction, onSuccess, onError);
    }

    PhotoService.prototype._getPhotos=function(filterFunction, onSuccess, onError) {
        var params={};
        $.getJSON( "/oblique-js/samples/Filters/json/photos.json", params)
            .done(function( jsonPhotos ) {
                var filteredJSONPhotos=[];
                for(var i=0;i<jsonPhotos.length; i++) {
                    var photo=jsonPhotos[i];

                    if (filterFunction(photo)) {
                        filteredJSONPhotos.push(photo);
                    }
                }
                onSuccess(filteredJSONPhotos);
            })
            .fail(function( jqxhr, textStatus, error ) {
                onError(error);
            });
    };

    window.PhotoService=PhotoService;

}).call(this);

