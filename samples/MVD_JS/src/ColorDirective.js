var ColorDirective = function (button, colors) {
    var jqButton=$(button);
    var self=this;
    jqButton.click(function(event){
        event.preventDefault();
        var colorName=$(event.target).html();
        var sizes=self.findSizes(colorName, colors);
        var htmlSizes=Oblique().renderHtml("templates/sizes.hbs",sizes);
        $("#sizes").html(htmlSizes);
    });
};

ColorDirective.prototype.findSizes=function(colorName, colors) {
    for(var i=0;i<colors.length;i++) {
        var color=colors[i];
        if (color.name==colorName) {
            return color.sizes;
        }
    }
};

ColorDirective.CSS_EXPRESSION = "*[data-colors]";

Oblique().registerDirective(ColorDirective);