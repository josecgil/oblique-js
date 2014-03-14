var MenuDirective = function (DOMElement) {
    console.log(DOMElement);
};

MenuDirective.CSS_EXPRESSION = "*[data-vc-menu]";

Oblique().registerDirective(MenuDirective);
