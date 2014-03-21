@.ObliqueNS=@.ObliqueNS or {}

class DirectiveProcessor

  constructor: ->
    return new DirectiveProcessor() if @ is window

    return DirectiveProcessor._singletonInstance  if DirectiveProcessor._singletonInstance
    DirectiveProcessor._singletonInstance = @

    @_throwErrorIfJQueryIsntLoaded()

    @_directiveCollection = new ObliqueNS.DirectiveCollection()

    @_timedDOMObserver=new ObliqueNS.TimedDOMObserver()
    @_timedDOMObserver.setIntervalInMs DirectiveProcessor.DEFAULT_INTERVAL_MS
    @_timedDOMObserver.onChange(=>
      @_applyDirectivesInDOM()
    )
    @_listenToDOMReady()

  @DEFAULT_INTERVAL_MS = 500

  _throwErrorIfJQueryIsntLoaded: ->
    throw new Error("DirectiveProcessor needs jQuery to work") if not window.jQuery

  _setupTimedDOMObserver:->
    @_timedDOMObserver=new ObliqueNS.TimedDOMObserver()
    @_timedDOMObserver.setIntervalInMs DirectiveProcessor.DEFAULT_INTERVAL_MS
    @_timedDOMObserver.onChange(=>
      @_applyDirectivesInDOM()
    )

  _listenToDOMReady: ->
    jQuery(document).ready =>
      @_applyDirectivesInDOM()
      @_timedDOMObserver.observe()

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
              directiveName = directive.name
              continue if obElement.hasFlag directiveName
              obElement.setFlag directiveName
              new directive DOMElement
      )
    finally
      @_isApplyingDirectivesInDOM = false

  getIntervalTimeInMs: ->
    @_timedDOMObserver.getIntervalInMs()

  setIntervalTimeInMs: (newIntervalTimeInMs) ->
    throw new ObliqueNS.Error("IntervalTime must be a positive number") if newIntervalTimeInMs <= 0
    @_timedDOMObserver.setIntervalInMs newIntervalTimeInMs

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