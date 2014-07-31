@.ObliqueNS=@.ObliqueNS or {}

class DataModelVariable

  constructor:(@_expression)->
    @_firstEqualPosition=@_expression.indexOf("=")
    @name=@_getVariableName()
    @isSet = @_isSet()

  _getVariableName: () ->
    return @_expression if @_firstEqualPosition is -1
    parts=@_expression.split("=")
    variableName=(parts[0].replace("var ", "")).trim()
    return undefined  if variableName is ""
    variableName

  _isSet:() ->
    return false if @_firstEqualPosition is -1
    nextChar=@_expression.substr(@_firstEqualPosition+1, 1)
    return false if nextChar is "="
    true

ObliqueNS.DataModelVariable=DataModelVariable
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

DataModelVariable=ObliqueNS.DataModelVariable

class DirectiveProcessor

  constructor: ->
    return new DirectiveProcessor() if @ is window

    return DirectiveProcessor._singletonInstance  if DirectiveProcessor._singletonInstance
    DirectiveProcessor._singletonInstance = @

    @_throwErrorIfJQueryIsntLoaded()

    @_directiveCollection = new ObliqueNS.DirectiveCollection()

    @_timedDOMObserver=@_createTimedDOMObserver(DirectiveProcessor.DEFAULT_INTERVAL_MS)

    @_memory=new ObliqueNS.Memory()

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

      directiveData=
        domElement: obElement.getDOMElement()
        jQueryElement: obElement.getjQueryElement()
        model: @_getDirectiveModel obElement
        params: @_getParams obElement

      new directive directiveData

  _getParams : (obElement) ->
    dataParamsExpr=obElement.getAttributeValue("data-ob-params")
    return undefined if not dataParamsExpr
    try
      jQuery.parseJSON(dataParamsExpr)
    catch e
      @_throwError("#{obElement.getHtml()}: data-ob-params parse error: #{e.message}")


  _getDirectiveModel : (___obElement) ->
    ###
      WARNING: all local variable names in this method
      must be prefixed with three undercores ("___")
      in order to not be in conflict with dynamic
      local variables created by
        eval(@_memory.localVarsScript())
    ###
    Model=Oblique().getModel()
    ___dataModelExpr=___obElement.getAttributeValue("data-ob-model")
    return undefined if ___dataModelExpr is undefined
    try
      eval(@_memory.localVarsScript())

      ___directiveModel=eval(___dataModelExpr)
      ___dataModelVariable=new DataModelVariable(___dataModelExpr)
      if (___dataModelVariable.isSet)
        ___variableName=___dataModelVariable.name
        ___variableValue=eval(___variableName)
        @_memory.setVar(___variableName, ___variableValue)
        ___directiveModel=___variableValue

      if (not ___directiveModel)
        @_throwError("#{___obElement.getHtml()}: data-ob-model expression is undefined")
      ___directiveModel
    catch e
      @_throwError("#{___obElement.getHtml()}: data-ob-model expression error: #{e.message}")

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
class Memory

  constructor:()->
    @_vars={}

  setVar:(name, value)->
    if name is "Model"
      throw new ObliqueNS.Error("Can't create a variable named 'Model', is a reserved word")
    @_vars[name]=value

  getVar:(name)->
    @_vars[name]

  localVarsScript:->
    script=""
    for own variableName, variableValue of @_vars
      script=script+"var #{variableName}=this._memory.getVar(\"#{variableName}\");"
    script

ObliqueNS.Memory=Memory
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
