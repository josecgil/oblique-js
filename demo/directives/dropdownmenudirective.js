var DropDownMenuDirective = function (DOMElement) {
    var element = $(DOMElement);
    var ul = element.find("ul");
    var a = element.children("a");
    ul.hide();
    a.click(function (event) {
        event.preventDefault();
        ul.toggle();
        a.html(a.html() + "!");
    });
    element.hover(function () {
        ul.show();
    }, function () {
        ul.hide();
    });
};

DropDownMenuDirective.CSS_EXPRESSION = "*[data-vc-dropdownmenu]";

Oblique().registerDirective(DropDownMenuDirective);

