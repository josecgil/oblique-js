var ColorDirective = function (element, colors) {
    var jqElement=$(element);
    var self=this;
    jqElement.click(function(event){
        event.preventDefault();
        var colorName=$(event.target).html();
        var sizes=self.findSizes(colorName, colors);
        var html=Oblique().renderHtml("/oblique-js/samples/MVD/sizes.hbs",sizes);
        $("#sizes").html(html);
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