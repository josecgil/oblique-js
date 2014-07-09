@.ObliqueNS=@.ObliqueNS or {}

class TemplateFactory

  Template=ObliqueNS.Template

  createFromString:(templateStr)->
    new Template templateStr

  createFromDOMElement:(element) ->
    @createFromString $(element).html()

  createFromUrl:(url) ->
    templateContent=undefined
    errorStatusCode=200
    errorMessage=undefined
    jQuery.ajax(
      url: url
      success: (data) =>
        templateContent=data
      error: (e) ->
        errorStatusCode=e.status
        errorMessage=e.statusCode
      async: false
    )
    switch errorStatusCode
      when 404 then throw new ObliqueNS.Error("template '#{url}' not found")
      when not 200 then throw new ObliqueNS.Error(errorMessage)
    template=@createFromString(templateContent)

ObliqueNS.TemplateFactory=TemplateFactory



