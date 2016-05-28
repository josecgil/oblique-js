(function() {
    window.onpageshow = function(event) {
        if (!event.persisted) return;
        window.location.reload()
    };

})(this);