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
          directiveAttrValue=obElement.getAttributeValue "data-directive"
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
    dataParamsExpr=obElement.getAttributeValue("data-params")
    return undefined if not dataParamsExpr
    try
      jQuery.parseJSON(dataParamsExpr)
    catch e
      @_throwError("#{obElement.getHtml()}: data-params parse error: #{e.message}")

  _getModel : (obElement) ->
    model=Oblique().getModel()
    dataModelExpr=obElement.getAttributeValue("data-model")
    return undefined if dataModelExpr is undefined

    dataModelDSL=new ObliqueNS.DataModelDSL dataModelExpr
    if not dataModelDSL.hasFullModel
      if dataModelDSL.modelProperties
        for property in dataModelDSL.modelProperties
          if (not model.hasOwnProperty(property.name))
            @_throwError("#{obElement.getHtml()}: data-model doesn't match any data in model")
          model=model[property.name]
          model=model[property.index] if property.hasIndex

    className = dataModelDSL.className
    if className
      if (not window.hasOwnProperty(className))
        @_throwError("#{obElement.getHtml()}: '#{className}' isn't an existing class in data-model")

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
