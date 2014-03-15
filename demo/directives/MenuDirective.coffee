class @MenuDirective
  constructor: (DOMElement)->
    console.log DOMElement

  @CSS_EXPRESSION = "*[data-vc-menu]"

Oblique().registerDirective MenuDirective