@.ObliqueNS=@.ObliqueNS or {}

DataModelVariable=ObliqueNS.DataModelVariable

class DOMProcessor

  constructor: ->
    return new DOMProcessor() if @ is window

    return DOMProcessor._singletonInstance  if DOMProcessor._singletonInstance
    DOMProcessor._singletonInstance = @

    @_throwErrorIfJQueryIsntLoaded()

    @_directiveCollection = new ObliqueNS.CallbackCollection()
    @_controllerCollection = new ObliqueNS.CallbackCollection()

    @_directiveInstancesData=[]
    @_controllerInstancesData=[]

    @_timedDOMObserver=@_createTimedDOMObserver(DOMProcessor.DEFAULT_INTERVAL_MS)

    @_memory=new ObliqueNS.Memory()

    jQuery(document).ready =>
      @_applyObliqueElementsInDOM()
      @_timedDOMObserver.observe()
      @_listenToHashRouteChanges()

  @DEFAULT_INTERVAL_MS = 500

  _listenToHashRouteChanges:->
    $(window).on "hashchange", =>
      for controllerInstanceData in @_controllerInstancesData
        controllerData=@_createControllerData(controllerInstanceData.domElement, controllerInstanceData.jQueryElement)
        controllerInstanceData.instance.onHashChange(controllerData)

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
      $("*[data-ob-controller]").each(
        (index, DOMElement) =>
          obElement=new ObliqueNS.Element DOMElement
          controllerAttrValue=obElement.getAttributeValue "data-ob-controller"
          @_processControllerElement(obElement, controllerAttrValue) if controllerAttrValue
      )

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

      callbackHashChange = directiveInstanceData.instance.onHashChange
      callbackHashChange @_createDirectiveData(domElement, jQueryElement, model, params) if callbackHashChange

  _processControllerElement:(obElement, controllerAttrValue) ->
    for controllerName in controllerAttrValue.split(",")
      controllerName=controllerName.trim()
      continue if obElement.hasFlag controllerName

      controllerConstructorFn=@_controllerCollection.getCallbackByName(controllerName)
      throw new ObliqueNS.Error("There is no #{controllerName} controller registered") if not controllerConstructorFn
      obElement.setFlag controllerName

      domElement=obElement.getDOMElement()
      jQueryElement=obElement.getjQueryElement()

      controllerData=@_createControllerData(domElement, jQueryElement)

      controllerInstanceData=
        instance: new controllerConstructorFn(controllerData)
        domElement: domElement
        jQueryElement: jQueryElement

      @_controllerInstancesData.push(controllerInstanceData)

      callbackHashChange = controllerInstanceData.instance.onHashChange
      callbackHashChange @_createControllerData(domElement, jQueryElement) if callbackHashChange

  _createControllerData:(domElement, jQueryElement)->
    controllerData=
      domElement: domElement
      jQueryElement: jQueryElement
      hashParams: Oblique().getHashParams()

    controllerData


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

  registerController: (controllerName, controllerConstructorFn) ->
    @_controllerCollection.add controllerName, controllerConstructorFn

  destroy: ->
    @_ignoreHashRouteChanges()
    @_timedDOMObserver.destroy()
    DOMProcessor._singletonInstance=undefined

ObliqueNS.DOMProcessor=DOMProcessor
@.Oblique=DOMProcessor