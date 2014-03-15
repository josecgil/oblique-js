var CalendarDirective = function (DOMElement) {
    console.log(DOMElement);
};

CalendarDirective.CSS_EXPRESSION = "*[data-vc-calendar]";

Oblique().registerDirective(CalendarDirective);
