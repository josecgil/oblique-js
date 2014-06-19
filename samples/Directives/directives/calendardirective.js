var CalendarDirective = function (DOMElement) {
    console.log(DOMElement);
    directiveTag=new DirectiveTag(DOMElement, "data-vc-calendar");
    console.log("Initial Date:"+ directiveTag.param("initial-date"));
};

CalendarDirective.CSS_EXPRESSION = "*[data-vc-calendar]";

Oblique().registerDirective(CalendarDirective);
