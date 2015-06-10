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
    value=""
    value=hashArray[1].trim() if hashArray.length>1
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
    return @name if @count() is 0
    hash = "#{@name}=["
    for value in @values
      hash += "#{value},"
    hash = hash.substr(0,hash.length-1)
    hash += "]"

  count:->
    return 0 if @values is undefined
    return 0 if @values.length is 0
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
      value=unescape(value) if (value isnt undefined)
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
    #return "" if @count() is 0

    hash = "#"
    for paramName, param of @_params
      #continue if param.isEmpty()

      continue if param is undefined
      hash += param.getLocationHash() + "&"

    hash=hash.substr(0,hash.length-1)
    hash="" if hash is "#"
    hash

ObliqueNS.ParamCollection=ParamCollection


@.ObliqueNS=@.ObliqueNS or {}

Param=ObliqueNS.Param

class RangeParam extends ObliqueNS.Param

  constructor:(@name, @min, @max)->
    super(@name)
    if (not @_isValidValue(@min))
      throw new ObliqueNS.Error("Param constructor must be called with second param string")
    if (not @_isValidValue(@max))
      throw new ObliqueNS.Error("Param constructor must be called with third param string")
    @min=unescape(@min) if (@min isnt undefined)
    @max=unescape(@max) if (@max isnt undefined)


  _isValidValue:(value) ->
    return true if value is undefined
    return @_isString(value)

  getLocationHash:->
    return "#{@name}=(#{@min},#{@max})" if not @isEmpty()
    @name

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
    min=undefined
    max=undefined
    if (not Param.stringIsNullOrEmpty(hashParam.value))
      value=hashParam.value.replace("(","").replace(")","")
      if (value.trim().length>0)
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
    @value=unescape(@value) if (@value isnt undefined)

  getLocationHash: ->
    return "#{@name}=#{@value}" if not @isEmpty()
    @name

  isEmpty:() ->
    return true if @value is undefined
    return true if @value.trim().length is 0
    return false

  @is:(strHashParam)->
    hashParam=Param.parse(strHashParam)
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
      @_doACycle()
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
        @_doACycle()
    )
    observer

  @_isDoingACycle = false
  _doACycle: ->
    try
      return if @_isDoingACycle
      @_isDoingACycle = true

      @_applyObliqueElementsInDOM()
      @_callOnIntervalOnCurrentDirectives()
    catch e
      @_throwError(e, "Error doing a cycle in Oblique.js: #{e.message}")
      throw e
    finally
      @_isDoingACycle = false

  _callOnIntervalOnCurrentDirectives: ->
    for directiveInstanceData in @_directiveInstancesData
      directive=directiveInstanceData.instance
      directive.onInterval() if directive.onInterval

  _applyObliqueElementsInDOM: ->
      $("*[data-ob-var]").each(
        (index, DOMElement) =>
          obElement=new ObliqueNS.Element DOMElement
          scriptAttrValue=obElement.getAttributeValue "data-ob-var"
          @_processScriptElement(obElement, scriptAttrValue) if scriptAttrValue
      )
      $("*[data-ob-directive]").each(
        (index, DOMElement) =>
          obElement=new ObliqueNS.Element DOMElement
          directiveAttrValue=obElement.getAttributeValue "data-ob-directive"
          @_processDirectiveElement(obElement, directiveAttrValue) if directiveAttrValue
      )

  _execJS : (___JSScriptBlock) ->
    Model = Oblique().getModel()
    eval(@_memory.localVarsScript())

    ___directiveModel = eval(___JSScriptBlock)
    ___dataModelVariable = new DataModelVariable(___JSScriptBlock)
    if (___dataModelVariable.isSet)
      ___variableName = ___dataModelVariable.name
      ___variableValue = eval(___variableName)
      @_memory.setVar(___variableName, ___variableValue)
      ___directiveModel = ___variableValue

    ___directiveModel

  _processScriptElement:(obElement, varAttrValue) ->
    return if obElement.hasFlag "data-ob-var"
    obElement.setFlag "data-ob-var"
    @_execJS varAttrValue

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
      @_throwError(e, "#{obElement.getHtml()}: data-ob-params parse error: #{e.message}")

  _getDirectiveModel : (___obElement) ->
    ###
      WARNING: all local variable names in this method
      must be prefixed with three undercores ("___")
      in order to not be in conflict with dynamic
      local variables created by
        eval(@_memory.localVarsScript())
    ###
    ___dataModelExpr=___obElement.getAttributeValue("data-ob-model")
    return undefined if ___dataModelExpr is undefined
    try
      ___directiveModel = @_execJS(___dataModelExpr)
      if (not ___directiveModel)
        errorMsg = "#{___obElement.getHtml()}: data-ob-model expression is undefined"
        error=new ObliqueError(errorMsg)
        @_throwError(error, errorMsg)
        throw error
      ___directiveModel
    catch e
      @_throwError(e, "#{___obElement.getHtml()}: data-ob-model expression error: #{e.message}")
      throw e

  _throwError: (e, errorMessage) ->
    console.log "--- Init Oblique Error ---"
    console.log errorMessage
    console.log e.stack
    console.log "--- End  Oblique Error ---"
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
    #throw error

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
