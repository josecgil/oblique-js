(function() {

    var PhotoService=function() {

    };


    PhotoService.prototype.getAllPhotos=function(onSuccess, onError) {
        var noFilterFunction = function () {
            return true;
        };
        return this._getPhotos(noFilterFunction, onSuccess, onError);
    }

    PhotoService.prototype.getFilteredPhotos=function(albumsParam, colorParam, onSuccess, onError) {
        var filterByHashValues=function(album) {

            if (!albumsParam.containsValue(album.albumId)) {
                return false;
            }

            if (!colorParam.valueIsEqualTo(album.color)) {
                return false;
            }

            return true;
        };
        return this._getPhotos(filterByHashValues, onSuccess, onError);
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

