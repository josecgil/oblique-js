Oblique().registerDirective(
    "ColorDirective",
    function (button, colors) {
        var jqButton=$(button);
        jqButton.click(function(event){
            event.preventDefault();
            var colorName=$(event.target).html();
            var sizes=colors.findSizes(colorName);
            var htmlSizes=Oblique().renderHtml("templates/sizes.hbs",sizes);
            $("#sizes").html(htmlSizes);
        });
    }
);