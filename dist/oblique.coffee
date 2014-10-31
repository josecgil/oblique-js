@.ObliqueNS=@.ObliqueNS or {}

class Param

  constructor:(@name)->
    if not @_isString(@name)
      throw new ObliqueNS.Error("Param constructor must be called with first param string")

  _isString:(value)->
    return true if typeof(value) is 'string'
    false

  @containsChar:(fullStr, char) ->
    return false if fullStr.indexOf(char) is -1
    true

  @stringIsNullOrEmpty:(value) ->
    return true if value is undefined
    return true if value.trim().length is 0
    false

  @parse:(strHashParam)->
    hashArray=strHashParam.split("=")
    name=hashArray[0].trim()
    value=hashArray[1].trim()
    {name:name, value:value}

  getLocationHash: ->
    ""

  isEmpty:() ->
    true

  valueIsEqualTo:() ->
    true

  containsValue:() ->
    true

  isInRange:()->
    true

ObliqueNS.Param=Param
@.ObliqueNS=@.ObliqueNS or {}

Param=ObliqueNS.Param

class ArrayParam extends ObliqueNS.Param

  constructor:(@name, values)->
    super(@name)
    if not @_isArray(values)
      throw new ObliqueNS.Error("Param constructor must be called with second param array")
    @values=[]
    for value in values
      @add value

  _isArray:(value)->
    return true if Object.prototype.toString.call(value) is '[object Array]'
    false

  add:(value)->
    if (not @_isString(value))
      throw new ObliqueNS.Error("Array param must be an string")
    @values.push value

  remove:(value)->
    index=@values.indexOf value
    return if index is -1
    @values.splice index, 1
    @values=undefined if @count() is 0

  isEmpty:() ->
    return true if @count() is 0
    return false

  getLocationHash: ->
    return "" if @count() is 0
    hash = "#{@name}=["
    for value in @values
      hash += "#{value},"
    hash = hash.substr(0,hash.length-1)
    hash += "]"

  count:->
    return 0 if @values is undefined
    @values.length


  @is:(strHashParam)->
    hashParam=Param.parse(strHashParam)
    return true if Param.containsChar(hashParam.value,"[")
    false

  @createFrom:(strHashParam)->
    hashParam=Param.parse(strHashParam)
    value=hashParam.value.replace("[","").replace("]","")
    values=value.split(",")
    trimmedValues=[]
    for value in values
      value=value.trim()
      trimmedValues.push value if not Param.stringIsNullOrEmpty(value)

    new ArrayParam(hashParam.name, trimmedValues)

  containsValue:(value)->
    return false if @isEmpty()
    return true if value in @values
    return false

ObliqueNS.ArrayParam=ArrayParam
@.ObliqueNS=@.ObliqueNS or {}

class EmptyParam extends ObliqueNS.Param

  constructor:()->
    super("EmptyParam")

ObliqueNS.EmptyParam=EmptyParam
@.ObliqueNS=@.ObliqueNS or {}

ArrayParam=ObliqueNS.ArrayParam
RangeParam=ObliqueNS.RangeParam
SingleParam=ObliqueNS.SingleParam
EmptyParam=ObliqueNS.EmptyParam

class ParamCollection

  constructor:(locationHash) ->
    @removeAll()
    return if @_StringIsEmpty(locationHash)

    locationHash=locationHash.replace("#","")

    for hashParam in locationHash.split("&")
      param=undefined
      if (SingleParam.is(hashParam))
        param=SingleParam.createFrom(hashParam)
      else if (RangeParam.is(hashParam))
        param=RangeParam.createFrom(hashParam)
      else if (ArrayParam.is(hashParam))
        param=ArrayParam.createFrom(hashParam)
      else
        param=new EmptyParam()

      @add(param)

  _StringIsEmpty:(value)->
    return true if value is undefined
    return true if value.trim().length is 0
    return false

  add:(param)->
    @_params[param.name.toLowerCase()]=param
    param

  addSingleParam:(name, value)->
    @add new SingleParam(name, value)

  addRangeParam:(name, min, max)->
    @add new RangeParam(name, min, max)

  addArrayParam:(name, values)->
    @add new ArrayParam(name, values)

  remove:(paramName)->
    @_params[paramName]=undefined

  removeAll: ->
    @_params={}

  getParam:(paramName)->
    param=@_params[paramName.toLowerCase()]
    return new EmptyParam() if param is undefined
    param

  find:(paramNames)->
    lowerCaseParamNames = (param.toLowerCase() for param in paramNames)

    foundedParamCollection=new ParamCollection()
    for paramName, param of @_params
      if (not @_isEmptyParam(param)) and (paramName.toLowerCase() in lowerCaseParamNames)
        foundedParamCollection.add param
    foundedParamCollection

  isEmpty:->
    return true if @count() is 0
    false

  count: ->
    count = 0
    for paramName, param of @_params
      count++ if not @_isEmptyParam(param)
    count

  _isEmptyParam: (param)  ->
    return true if param is undefined
    return param.isEmpty()

  getLocationHash: ->
    return "" if @count() is 0

    hash = "#"
    for paramName, param of @_params
      continue if param.isEmpty()

      hash += param.getLocationHash() + "&"

    hash=hash.substr(0,hash.length-1)
    hash

ObliqueNS.ParamCollection=ParamCollection


@.ObliqueNS=@.ObliqueNS or {}

Param=ObliqueNS.Param

class RangeParam extends ObliqueNS.Param

  constructor:(@name, @min, @max)->
    super(@name)
    if (not @_isString(@min))
      throw new ObliqueNS.Error("Param constructor must be called with second param string")
    if (not @_isString(@max))
      throw new ObliqueNS.Error("Param constructor must be called with third param string")

  getLocationHash:->
     "#{@name}=(#{@min},#{@max})"

  isEmpty:() ->
    return true if (@min is undefined and @max is undefined)
    return false

  isInRange:(value) ->
    return false if value<@min
    return false if value>@max
    true

  @is:(strHashParam)->
    hashParam=Param.parse(strHashParam)
    return true if Param.containsChar(hashParam.value,"(")
    false

  @createFrom:(strHashParam)->
    hashParam=Param.parse(strHashParam)
    value=hashParam.value.replace("(","").replace(")","")
    min=(value.split(",")[0]).trim()
    max=(value.split(",")[1]).trim()
    new RangeParam(hashParam.name, min, max)

ObliqueNS.RangeParam=RangeParam
@.ObliqueNS=@.ObliqueNS or {}

Param=ObliqueNS.Param

class SingleParam extends ObliqueNS.Param

  constructor:(@name, @value)->
    super(@name)
    if (not @_isString(@value))
      throw new ObliqueNS.Error("Param constructor must be called with second param string")

  getLocationHash: ->
    "#{@name}=#{@value}"

  isEmpty:() ->
    return true if @value is undefined
    return false

  @is:(strHashParam)->
    hashParam=Param.parse(strHashParam)
    return false if Param.stringIsNullOrEmpty(hashParam.value)
    return false if Param.containsChar(hashParam.value,"(")
    return false if Param.containsChar(hashParam.value,"[")
    true

  @createFrom:(strHashParam)->
    hashParam=Param.parse(strHashParam)
    new SingleParam(hashParam.name, hashParam.value)


  valueIsEqualTo:(value)->
    return false if @isEmpty()
    return false if @value isnt value
    true

ObliqueNS.SingleParam=SingleParam
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
#Add string::trim() if not present
unless String::trim
  String::trim = ->
    @replace /^\s+|\s+$/g, ""
@.ObliqueNS=@.ObliqueNS or {}

class CallbackCollection

  constructor:()->
    @_callbacks=[]
    @_callbacksByName={}

  count:() ->
    @_callbacks.length

  _isAFunction: (memberToTest) ->
    typeof (memberToTest) is "function"

  _throwErrorIfCallbackIsNotValid: (callbackName, callbackFn) ->
    if not callbackName or typeof callbackName isnt "string"
      throw new ObliqueNS.Error("registerDirective must be called with a string directiveName")
    if not @_isAFunction(callbackFn)
      throw new ObliqueNS.Error("registerDirective must be called with a Directive 'Constructor/Class'")

  add:(callbackName, callbackFn) ->
    @_throwErrorIfCallbackIsNotValid(callbackName, callbackFn)

    @_callbacks.push callbackFn
    @_callbacksByName[callbackName]=callbackFn

  at:(index)->
    @_callbacks[index]

  getCallbackByName : (name) ->
    @_callbacksByName[name]

ObliqueNS.CallbackCollection=CallbackCollection
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

DataModelVariable=ObliqueNS.DataModelVariable

class DOMProcessor

  constructor: ->
    return new DOMProcessor() if @ is window

    return DOMProcessor._singletonInstance  if DOMProcessor._singletonInstance
    DOMProcessor._singletonInstance = @

    @_throwErrorIfJQueryIsntLoaded()

    @_directiveCollection = new ObliqueNS.CallbackCollection()

    @_directiveInstancesData=[]

    @_timedDOMObserver=@_createTimedDOMObserver(DOMProcessor.DEFAULT_INTERVAL_MS)

    @_memory=new ObliqueNS.Memory()

    jQuery(document).ready =>
      @_applyObliqueElementsInDOM()
      @_timedDOMObserver.observe()
      @_listenToHashRouteChanges()

  @DEFAULT_INTERVAL_MS = 500

  _listenToHashRouteChanges:->
    $(window).on "hashchange", =>
      for dirData in @_directiveInstancesData
        directiveData=@_createDirectiveData(dirData.domElement, dirData.jQueryElemen, dirData.model, dirData.params)
        if (dirData.instance.onHashChange)
          dirData.instance.onHashChange(directiveData)

  _ignoreHashRouteChanges:->
    $(window).off "hashchange"

  _throwErrorIfJQueryIsntLoaded: ->
    throw new Error("DOMProcessor needs jQuery to work") if not window.jQuery

  _createTimedDOMObserver: (intervalInMs)->
    observer=new ObliqueNS.TimedDOMObserver intervalInMs
    observer.onChange(=>
      @_applyObliqueElementsInDOM()
    )
    observer

  @_isApplyingObliqueElementsInDOM = false
  _applyObliqueElementsInDOM: ->
    return if @_isApplyingObliqueElementsInDOM
    @_isApplyingObliqueElementsInDOM = true
    try
      $("*[data-ob-directive]").each(
        (index, DOMElement) =>
          obElement=new ObliqueNS.Element DOMElement
          directiveAttrValue=obElement.getAttributeValue "data-ob-directive"
          @_processDirectiveElement(obElement, directiveAttrValue) if directiveAttrValue
      )
    catch e
      @_throwError("Error _applyObliqueElementsInDOM() : #{e.message}")
    finally
      @_isApplyingObliqueElementsInDOM = false

  _processDirectiveElement:(obElement, directiveAttrValue) ->
    for directiveName in directiveAttrValue.split(",")
      directiveName=directiveName.trim()
      continue if obElement.hasFlag directiveName

      directive=@_directiveCollection.getCallbackByName(directiveName)
      throw new ObliqueNS.Error("There is no #{directiveName} directive registered") if not directive
      obElement.setFlag directiveName

      domElement=obElement.getDOMElement()
      jQueryElement=obElement.getjQueryElement()
      model=@_getDirectiveModel obElement
      params=@_getParams obElement

      directiveData=@_createDirectiveData(domElement, jQueryElement, model, params)

      directiveInstanceData=
        instance: new directive(directiveData)
        domElement: domElement
        jQueryElement: jQueryElement
        model: model
        params: params

      @_directiveInstancesData.push(directiveInstanceData)

      if (directiveInstanceData.instance.onHashChange)
        directiveInstanceData.instance.onHashChange(@_createDirectiveData(domElement, jQueryElement, model, params))

  _createDirectiveData:(domElement, jQueryElement, model, params)->
    directiveData=
      domElement: domElement
      jQueryElement: jQueryElement
      model: model
      params: params
      hashParams: Oblique().getHashParams()

    directiveData

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
    @_ignoreHashRouteChanges()
    @_timedDOMObserver.destroy()
    DOMProcessor._singletonInstance=undefined

ObliqueNS.DOMProcessor=DOMProcessor
@.Oblique=DOMProcessor
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

    @domProcessor=new ObliqueNS.DOMProcessor();
    @templateFactory=new ObliqueNS.TemplateFactory()
    @_onErrorCallbacks=[]

  @DEFAULT_INTERVAL_MS = 500

  getIntervalTimeInMs: ->
    @domProcessor.getIntervalTimeInMs()

  setIntervalTimeInMs: (newIntervalTimeInMs) ->
    @domProcessor.setIntervalTimeInMs(newIntervalTimeInMs)

  registerDirective: (directiveName, directiveConstructorFn) ->
    @domProcessor.registerDirective directiveName, directiveConstructorFn

  destroy: ->
    @domProcessor.destroy()
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

  renderHTML: (url, model) ->
    if Handlebars is undefined
      throw new ObliqueNS.Error("Oblique().renderHtml(): needs handlebarsjs loaded to render templates")
    template=@templateFactory.createFromUrl url
    template.renderHTML model

  onError:(onErrorCallback)->
    @_onErrorCallbacks.push onErrorCallback

  triggerOnError:(error)->
    for callback in @_onErrorCallbacks
      callback(error)
    throw error

  getHashParams:() ->
    new ObliqueNS.ParamCollection(window.location.hash)

  setHashParams:(paramCollection) ->
    window.location.hash=paramCollection.getLocationHash()

ObliqueNS.Oblique=Oblique
@.Oblique=Oblique
@.ObliqueNS=@.ObliqueNS or {}

class ObliqueError extends Error
  constructor: (@message) ->
    return new Error(@message) if @ is window
    @name = "ObliqueNS.Error"

ObliqueNS.Error=ObliqueError
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
