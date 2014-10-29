(function() {

    var PhotoService=function() {

    };


    PhotoService.prototype.getAllPhotos=function(callbackOk, callbackError) {
        var noFilterFunction = function () {
            return true;
        };
        return this._getPhotos(noFilterFunction, callbackOk, callbackError);
    }

    PhotoService.prototype.getFilteredPhotos=function(callbackOk, callbackError) {
        var albumsHashValues = Oblique().getHashParams().getParam("albums").values;
        var filterByAlbumIdFunction=function(album) {
            if (albumsHashValues.indexOf(album.albumId)==-1) {
                return false;
            }
            return true;
        };
        return this._getPhotos(filterByAlbumIdFunction, callbackOk, callbackError);
    }

    PhotoService.prototype._getPhotos=function(filterFunction, callbackOk, callbackError) {
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
                callbackOk(filteredJSONPhotos);
            })
            .fail(function( jqxhr, textStatus, error ) {
                callbackError(error);
            });
    };




    window.PhotoService=PhotoService;

}).call(this);

