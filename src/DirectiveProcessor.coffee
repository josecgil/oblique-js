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
      #TODO: change this to a more human readable loop
      rootDOMElement = document.getElementsByTagName("body")[0]
      rootElement=new ObliqueNS.Element rootDOMElement

      rootElement.eachDescendant(
        (DOMElement) =>
          obElement=new ObliqueNS.Element(DOMElement)
          for cssExpr in @_directiveCollection.getCSSExpressions()
            continue if not obElement.matchCSSExpression cssExpr
            for directive in @_directiveCollection.getDirectivesByCSSExpression cssExpr
              directiveHashCode = directive.hashCode
              continue if obElement.hasFlag directiveHashCode
              obElement.setFlag directiveHashCode
              model=@_getModel obElement
              new directive DOMElement, model
      )
    finally
      @_isApplyingDirectivesInDOM = false

  _getModel : (obElement) ->
    return undefined if not obElement.hasAttribute("data-model")
    model=Oblique().getModel()
    return undefined if not model
    dataModelExpr=obElement.getAttributeValue("data-model")
    return model if dataModelExpr is "this"
    results=jsonPath(model, dataModelExpr)

    @_throwError(obElement.getHtml() + ": data-model doesn't match any data in model") if not results
    @_throwError(obElement.getHtml() + ": data-model match many data in model") if results.length > 1
    results[0]

  _throwError: (errorMessage) ->
    Oblique().triggerOnError(new ObliqueNS.Error(errorMessage))

  getIntervalTimeInMs: ->
    @_timedDOMObserver.getIntervalInMs()

  setIntervalTimeInMs: (newIntervalTimeInMs) ->
    throw new ObliqueNS.Error("IntervalTime must be a positive number") if newIntervalTimeInMs <= 0
    @_timedDOMObserver.destroy()
    @_timedDOMObserver=@_createTimedDOMObserver(newIntervalTimeInMs)
    @_timedDOMObserver.observe()

  registerDirective: (directiveConstructorFn) ->
    @_directiveCollection.add directiveConstructorFn

  destroy: ->
    @_timedDOMObserver.destroy()
    try
      delete DirectiveProcessor._singletonInstance
    catch e
      DirectiveProcessor._singletonInstance = undefined


ObliqueNS.DirectiveProcessor=DirectiveProcessor
@.Oblique=DirectiveProcessor