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
      success: (data) ->
        templateContent=data
      error: (e) ->
        errorStatusCode=e.status
        errorMessage=e.statusCode
      async: false
    )

    throw new ObliqueNS.Error("template '#{url}' not found") if errorStatusCode is 404
    throw new ObliqueNS.Error(errorMessage) if errorStatusCode isnt 200
    template=@createFromString(templateContent)



ObliqueNS.TemplateFactory=TemplateFactory



