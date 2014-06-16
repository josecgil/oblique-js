@.ObliqueNS=@.ObliqueNS or {}

class Template

  constructor:()->

  setContent:(@templateContent) ->
    @compiledTemplate = Handlebars.compile(@templateContent)

  parse:(model) ->
    @compiledTemplate(model)

ObliqueNS.Template=Template