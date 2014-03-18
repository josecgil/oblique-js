window.ObliqueNS=window.ObliqueNS or {}

class DirectiveProcessor

  Element=ObliqueNS.Element

  constructor: ->
    return new DirectiveProcessor() if @ is window
    return DirectiveProcessor._singletonInstance  if DirectiveProcessor._singletonInstance
    DirectiveProcessor._singletonInstance = @

    @_throwErrorIfJQueryIsntLoaded()

    #Default private properties
    @_intervalTimeInMs = DirectiveProcessor.DEFAULT_INTERVAL_MS
    @_lastIntervalId = undefined
    @_directiveCollection = new ObliqueNS.DirectiveCollection()
    @_listenToDirectivesInDOM()

  @DEFAULT_INTERVAL_MS = 500

  _throwErrorIfJQueryIsntLoaded: ->
    throw new Error("DirectiveProcessor needs jQuery to work") if not window.jQuery

  _clearLastInterval: ->
    clearInterval @_lastIntervalId  unless @_lastIntervalId is undefined

  _applyDirectivesOnDocumentReady: ->
    jQuery(document).ready =>
      @_applyDirectivesInDOM()

  _setNewInterval: ->
    @_lastIntervalId = setInterval =>
      @_applyDirectivesInDOM()
    , @_intervalTimeInMs

  _listenToDirectivesInDOM: ->
    @_clearLastInterval()
    @_applyDirectivesOnDocumentReady()
    @_setNewInterval()

  @_isApplyingDirectivesInDOM = false
  _applyDirectivesInDOM: ->
    return if (@_isApplyingDirectivesInDOM)
    @_isApplyingDirectivesInDOM = true
    try
      #TODO: change this to a more human readable loop
      rootElement = document.getElementsByTagName("body")[0]
      rootObElement=new ObliqueNS.Element rootElement

      rootObElement.eachDescendant(
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
    @_intervalTimeInMs

  setIntervalTimeInMs: (newIntervalTimeInMs) ->
    throw new ObliqueNS.Error("IntervalTime must be a positive number") if newIntervalTimeInMs <= 0
    @_intervalTimeInMs = newIntervalTimeInMs
    @_listenToDirectivesInDOM()

  registerDirective: (directiveConstructorFn) ->
    @_directiveCollection.add directiveConstructorFn

  destroy: ->
    @_clearLastInterval()
    try
      delete DirectiveProcessor._singletonInstance
    catch e
      DirectiveProcessor._singletonInstance = undefined

ObliqueNS.DirectiveProcessor=DirectiveProcessor
window.Oblique=DirectiveProcessor