var FastImageDirective = function (DOMElement) {
    var img = $(DOMElement);
    var src = img.attr("src");
    if (src == undefined) return;
    src = src.replace("www", "cdn" + this._random(2, 3));
    img.attr("src", src);

};

FastImageDirective.prototype._random = function (min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
};

FastImageDirective.CSS_EXPRESSION = "img";

Oblique().registerDirective(FastImageDirective);
