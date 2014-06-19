class ColorDirective
  constructor:(button, colors) ->
    jqButton=$(button)
    jqButton.click( (event) =>
      event.preventDefault()
      colorName=$(event.target).html()
      sizes=@findSizes colorName, colors
      htmlSizes=Oblique().renderHtml "templates/sizes.hbs", sizes
      $("#sizes").html htmlSizes
    )

  findSizes:(colorName, colors) ->
    for color in colors
      return color.sizes if color.name is colorName
    undefined

  @CSS_EXPRESSION= "*[data-colors]"

Oblique().registerDirective ColorDirective
