Oblique().registerDirective(
    "ColorDirective",
    function (data) {
        var colors=data.model;
        data.jQueryElement.click(function(event){
            event.preventDefault();
            var colorName=$(event.target).html();
            var sizes=colors.findSizes(colorName);
            var htmlSizes=Oblique().renderHTML("Templates/sizes.hbs",sizes);
            $("#sizes").html(htmlSizes);
        });
    }
);