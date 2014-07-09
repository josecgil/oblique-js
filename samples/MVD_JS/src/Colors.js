var Colors=function(colors) {
  this.colors=colors;
};

Colors.prototype.findSizes=function(colorName) {
    for(var i=0;i<this.colors.length;i++) {
        var color=this.colors[i];
        if (color.name==colorName) {
            return color.sizes;
        }
    }
};