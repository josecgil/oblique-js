@.ObliqueNS=@.ObliqueNS or {}

DataModelVariable=ObliqueNS.DataModelVariable

class DOMProcessor

  constructor: ->
    return new DOMProcessor() if @ is window

    return DOMProcessor._singletonInstance  if DOMProcessor._singletonInstance
    DOMProcessor._singletonInstance = @

    @_throwErrorIfJQueryIsntLoaded()

    @_directiveCollection = new ObliqueNS.DirectiveCollection()

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

      @_applyGlobalDirectives()
      @_applyVariablesInDOM()
      @_applyDirectivesInDOM()

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

  _applyVariablesInDOM: ->
      $("*[data-ob-var]").each(
        (index, DOMElement) =>
          obElement=new ObliqueNS.Element DOMElement
          scriptAttrValue=obElement.getAttributeValue "data-ob-var"
          @_processScriptElement(obElement, scriptAttrValue) if scriptAttrValue
      )

  _applyGlobalDirectives: ->
      rootElement=new ObliqueNS.Element document.documentElement
      @_directiveCollection.each(
        (directive) =>
          return if not directive.isGlobal
          @_processDirectiveElement(rootElement, directive.name)
      )

  _applyDirectivesInDOM: ->
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

      directive=@_directiveCollection.findByName(directiveName).callback
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
    Oblique.logError e
    Oblique().triggerOnError(new ObliqueNS.Error(errorMessage))

  getIntervalTimeInMs: ->
    @_timedDOMObserver.getIntervalInMs()

  setIntervalTimeInMs: (newIntervalTimeInMs) ->
    throw new ObliqueNS.Error("IntervalTime must be a positive number") if newIntervalTimeInMs <= 0
    @_timedDOMObserver.destroy()
    @_timedDOMObserver=@_createTimedDOMObserver(newIntervalTimeInMs)
    @_timedDOMObserver.observe()

  registerDirective: (directiveName, directiveConstructorFn) ->
    @_directiveCollection.add new ObliqueNS.Directive(directiveName, directiveConstructorFn)

  registerDirectiveAsGlobal: (directiveName, directiveConstructorFn) ->
    @_directiveCollection.add new ObliqueNS.Directive(directiveName, directiveConstructorFn, true)

  destroy: ->
    @_ignoreHashRouteChanges()
    @_timedDOMObserver.destroy()
    DOMProcessor._singletonInstance=undefined

ObliqueNS.DOMProcessor=DOMProcessor
@.Oblique=DOMProcessor