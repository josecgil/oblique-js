// Generated by CoffeeScript 1.7.1
(function() {
  this.MenuDirective = (function() {
    function MenuDirective(DOMElement) {
      console.log(DOMElement);
    }

    MenuDirective.CSS_EXPRESSION = "*[data-vc-menu]";

    return MenuDirective;

  })();

  Oblique().registerDirective(MenuDirective);

}).call(this);
