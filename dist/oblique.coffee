@.ObliqueNS=@.ObliqueNS or {}

class ModelDSLPart
  constructor:(part)->
    @name=part
    @hasIndex=false
    @index=undefined
    firstBracePosition = part.indexOf "["
    if firstBracePosition isnt -1
      @hasIndex= true
      @name=part.substr 0, firstBracePosition
      lastBracePosition = part.indexOf "]"
      indexStr=part.slice firstBracePosition+1, lastBracePosition
      @index=parseInt(indexStr, 10)

class ModelDSL
  constructor:(@_expression) ->
    @hasFullModel=false
    @_partsByDot = @_expression.split(".")
    @_checkSyntax()
    @_partsByDot.shift()

    if @_partsByDot.length is 0
      @hasFullModel=true
      @properties=undefined
      return

    @properties=[]
    for part in @_partsByDot
      @properties.push new ModelDSLPart(part)

  _checkSyntax:() ->
    throw new ObliqueNS.Error("data-model must begins with 'Model or new'") if @_partsByDot[0] isnt "Model"
    lastIndex = @_partsByDot.length - 1
    throw new ObliqueNS.Error("data-model needs property after dot") if @_partsByDot[lastIndex] is ""

class ClassDSL
  constructor:(@_expression)->
    classNameAndBrackets = @_expression.split(" ")[1]
    openBracket = classNameAndBrackets.indexOf("(")
    throw new ObliqueNS.Error("data-model needs open bracket after className") if openBracket is -1

    closeBracket=classNameAndBrackets.indexOf(")", openBracket)
    throw new ObliqueNS.Error("data-model needs close bracket after className") if closeBracket is -1
    @name = classNameAndBrackets.slice(0, openBracket)


class DataModelDSL
  constructor:(@_expression) ->
    @_checkIsNullOrEmpty()
    @_expression=@_removeExtraSpaces @_expression

    @hasFullModel = false
    @modelProperties=undefined
    @className=undefined

    @_hasClass = @_expression.split(" ")[0] is "new"
    if (@_hasClass)
      @className=(new ClassDSL @_expression).name

    modelExpression=@_extractModelExpression()
    if (modelExpression isnt "")
      modelDSL = new ModelDSL modelExpression
      @modelProperties=modelDSL.properties
      @hasFullModel=modelDSL.hasFullModel

  _removeExtraSpaces:(str)->
    while str.indexOf("  ") isnt -1
      str=str.replace("  ", " ")
    str=str.trim()
    str=str.replace " (", "("
    str=str.replace " )", ")"
    str=str.replace "( ", "("
    str=str.replace ") ", ")"
    str

  _extractModelExpression:()->
    return @_expression if not @_hasClass
    modelFirstPosition=@_expression.indexOf("(Model")
    return "" if (modelFirstPosition is -1)
    modelLastPosition=@_expression.indexOf(")")
    return @_expression.slice(modelFirstPosition+1, modelLastPosition)

  _checkIsNullOrEmpty:() ->
    throw new ObliqueNS.Error("data-model can't be null or empty") if @_isNullOrEmpty()

  _isNullOrEmpty:() ->
    return true if @_expression is undefined
    return true if @_expression is null
    return true if @_expression is ""
    false

ObliqueNS.DataModelDSL=DataModelDSL


@.ObliqueNS=@.ObliqueNS or {}

class DirectiveCollection

  constructor:()->
    @directives=[]
    @_directivesByName={}

  count:() ->
    @directives.length

  _isAFunction: (memberToTest) ->
    typeof (memberToTest) is "function"

  @NOT_A_FUNCTION_CLASS_ERROR_MESSAGE = "registerDirective must be called with a Directive 'Constructor/Class'"

  _throwErrorIfDirectiveIsNotValid: (directiveName, directive) ->
    if not directiveName or typeof directiveName isnt "string"
      throw new ObliqueNS.Error("registerDirective must be called with a string directiveName")
    if not @_isAFunction(directive)
      throw new ObliqueNS.Error(ObliqueNS.DirectiveCollection.NOT_A_FUNCTION_CLASS_ERROR_MESSAGE)

  add:(directiveName, directiveFn) ->
    @_throwErrorIfDirectiveIsNotValid(directiveName, directiveFn)

    @directives.push directiveFn
    @_directivesByName[directiveName]=directiveFn

  at:(index)->
    @directives[index]

  getDirectiveByName : (directiveName) ->
    @_directivesByName[directiveName]

ObliqueNS.DirectiveCollection=DirectiveCollection

@.ObliqueNS=@.ObliqueNS or {}

class DirectiveProcessor

  constructor: ->
    return new DirectiveProcessor() if @ is window

    return DirectiveProcessor._singletonInstance  if DirectiveProcessor._singletonInstance
    DirectiveProcessor._singletonInstance = @

    @_throwErrorIfJQueryIsntLoaded()

    @_directiveCollection = new ObliqueNS.DirectiveCollection()

    @_timedDOMObserver=@_createTimedDOMObserver(DirectiveProcessor.DEFAULT_INTERVAL_MS)
    jQuery(document).ready =>
      @_applyDirectivesInDOM()
      @_timedDOMObserver.observe()

  @DEFAULT_INTERVAL_MS = 500

  _throwErrorIfJQueryIsntLoaded: ->
    throw new Error("DirectiveProcessor needs jQuery to work") if not window.jQuery

  _createTimedDOMObserver: (intervalInMs)->
    observer=new ObliqueNS.TimedDOMObserver intervalInMs
    observer.onChange(=>
      @_applyDirectivesInDOM()
    )
    observer

  @_isApplyingDirectivesInDOM = false
  _applyDirectivesInDOM: ->
    return if @_isApplyingDirectivesInDOM
    @_isApplyingDirectivesInDOM = true
    try
      ###
      $("*[data-directive]").each(
        (index, DOMElement) =>
          obElement=new ObliqueNS.Element DOMElement
          @_processDirectiveElement obElement
      )
      ###

      body=document.getElementsByTagName("body")[0]
      rootObElement=new ObliqueNS.Element body
      rootObElement.eachDescendant(
        (DOMElement)=>
          obElement=new ObliqueNS.Element DOMElement
          directiveAttrValue=obElement.getAttributeValue "data-ob-directive"
          @_processDirectiveElement(obElement, directiveAttrValue) if directiveAttrValue
      )

    finally
      @_isApplyingDirectivesInDOM = false

  _processDirectiveElement:(obElement, directiveAttrValue) ->
    for directiveName in directiveAttrValue.split(",")
      directiveName=directiveName.trim()
      continue if obElement.hasFlag directiveName

      directive=@_directiveCollection.getDirectiveByName(directiveName)
      throw new ObliqueNS.Error("There is no #{directiveName} directive registered") if not directive
      obElement.setFlag directiveName
      model=@_getModel obElement
      params=@_getParams obElement

      directiveData=
        domElement: obElement.getDOMElement()
        jQueryElement: obElement.getjQueryElement()
        model: model
        params: params

      new directive directiveData

  _getParams : (obElement) ->
    dataParamsExpr=obElement.getAttributeValue("data-ob-params")
    return undefined if not dataParamsExpr
    try
      jQuery.parseJSON(dataParamsExpr)
    catch e
      @_throwError("#{obElement.getHtml()}: data-ob-params parse error: #{e.message}")

  _getModel : (obElement) ->
    model=Oblique().getModel()
    dataModelExpr=obElement.getAttributeValue("data-ob-model")
    return undefined if dataModelExpr is undefined

    dataModelDSL=new ObliqueNS.DataModelDSL dataModelExpr
    if not dataModelDSL.hasFullModel
      if dataModelDSL.modelProperties
        for property in dataModelDSL.modelProperties
          if (not model.hasOwnProperty(property.name))
            @_throwError("#{obElement.getHtml()}: data-ob-model doesn't match any data in model")
          model=model[property.name]
          model=model[property.index] if property.hasIndex

    className = dataModelDSL.className
    if className
      if (not window.hasOwnProperty(className))
        @_throwError("#{obElement.getHtml()}: '#{className}' isn't an existing class in data-ob-model")

      constructorFn=window[className]
      model=new constructorFn(model)

    model

  _throwError: (errorMessage) ->
    Oblique().triggerOnError(new ObliqueNS.Error(errorMessage))

  getIntervalTimeInMs: ->
    @_timedDOMObserver.getIntervalInMs()

  setIntervalTimeInMs: (newIntervalTimeInMs) ->
    throw new ObliqueNS.Error("IntervalTime must be a positive number") if newIntervalTimeInMs <= 0
    @_timedDOMObserver.destroy()
    @_timedDOMObserver=@_createTimedDOMObserver(newIntervalTimeInMs)
    @_timedDOMObserver.observe()

  registerDirective: (directiveName, directiveConstructorFn) ->
    @_directiveCollection.add directiveName, directiveConstructorFn

  destroy: ->
    @_timedDOMObserver.destroy()
    DirectiveProcessor._singletonInstance=undefined

ObliqueNS.DirectiveProcessor=DirectiveProcessor
@.Oblique=DirectiveProcessor
@.ObliqueNS=@.ObliqueNS or {}

class Element

  constructor:(DOMElement)->
    @_jQueryElement=jQuery(DOMElement)

  getDOMElement:->
    @_jQueryElement.get 0

  getjQueryElement:->
    @_jQueryElement

  isTag: ->
    Element._isTag(@_DOMElement)

  matchCSSExpression: (cssExpression) ->
    @_jQueryElement.is(cssExpression)

  setFlag: (flagName) ->
    @_jQueryElement.data(flagName, true)

  unsetFlag: (flagName) ->
    @_jQueryElement.removeData(flagName)

  hasFlag: (flagName) ->
    @_jQueryElement.data(flagName)

  hasAttribute: (attributeName) ->
    attrValue=@getAttributeValue attributeName
    return false if attrValue is undefined
    true

  getAttributeValue: (attributeName) ->
    @_jQueryElement.attr attributeName

  eachDescendant: (callbackOnDOMElement) ->
    Element._traverse(@getDOMElement(), callbackOnDOMElement)

  @_isTag: (DOMElement) ->
    DOMElement.nodeType is 1

  @_traverse: (parentElement, callbackOnDOMElement) ->
    elementsToTraverse = []
    if Element._isTag parentElement
      elementsToTraverse.push parentElement

    callbackOnDOMElement parentElement
    while elementsToTraverse.length > 0
      currentElement = elementsToTraverse.pop()
      for child in currentElement.children
        if Element._isTag child
          elementsToTraverse.push child
          callbackOnDOMElement child

  getHtml:->
    @getDOMElement().outerHTML

ObliqueNS.Element=Element
@.ObliqueNS=@.ObliqueNS or {}

class Error
  constructor: (@message) ->
    return new Error(@message) if @ is window
    @name = "Oblique.Error"

ObliqueNS.Error=Error


@.ObliqueNS=@.ObliqueNS or {}

class Oblique

  constructor: ->
    return new Oblique() if @ is window

    return Oblique._singletonInstance  if Oblique._singletonInstance
    Oblique._singletonInstance = @

    @directiveProcessor=new ObliqueNS.DirectiveProcessor();
    @templateFactory=new ObliqueNS.TemplateFactory()
    @_onErrorCallbacks=[]

  @DEFAULT_INTERVAL_MS = 500

  getIntervalTimeInMs: ->
    @directiveProcessor.getIntervalTimeInMs()

  setIntervalTimeInMs: (newIntervalTimeInMs) ->
    @directiveProcessor.setIntervalTimeInMs(newIntervalTimeInMs)

  registerDirective: (directiveName, directiveConstructorFn) ->
    @directiveProcessor.registerDirective directiveName, directiveConstructorFn

  destroy: ->
    @directiveProcessor.destroy()
    try
      delete Oblique._singletonInstance
    catch e
      Oblique._singletonInstance = undefined

  setModel: (@_model) ->

  getModel: ->
    @_model

  hasModel: ->
    return true if @_model
    false

  renderHtml: (url, model) ->
    if Handlebars is undefined
      throw new ObliqueNS.Error("Oblique().renderHtml() needs handlebarsjs loaded to work")
    template=@templateFactory.createFromUrl url
    template.renderHTML model

  onError:(onErrorCallback)->
    @_onErrorCallbacks.push onErrorCallback

  triggerOnError:(error)->
    for callback in @_onErrorCallbacks
      callback(error)
    throw error

ObliqueNS.Oblique=Oblique
@.Oblique=Oblique


@.ObliqueNS=@.ObliqueNS or {}

class ObliqueError extends Error
  constructor: (@message) ->
    return new Error(@message) if @ is window
    @name = "ObliqueNS.Error"

ObliqueNS.Error=ObliqueError
@.ObliqueNS=@.ObliqueNS or {}

class Template

  constructor:(templateContent)->
    @compiledTemplate = Handlebars.compile(templateContent)

  renderHTML:(model) ->
    @compiledTemplate(model)

ObliqueNS.Template=Template


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



@.ObliqueNS=@.ObliqueNS or {}

class TimedDOMObserver

  constructor:(@intervalInMs)->
    @_intervalId=undefined
    @_callback=->

  onChange:(callback)->
    @_callback=callback

  getIntervalInMs: ->
    @intervalInMs

  observe:->
    @_intervalId=setInterval(=>
      @_callback()
    , @intervalInMs)

  destroy: ->
    clearInterval @_intervalId if @_intervalId
    @_intervalId=undefined

ObliqueNS.TimedDOMObserver=TimedDOMObserver
