class @Oblique

  constructor: ->
    return new Oblique() if @ is window
    return Oblique._singletonInstance  if Oblique._singletonInstance
    Oblique._singletonInstance = @

    @_throwErrorIfJQueryIsntLoaded()

    #Default private properties
    @_intervalTimeInMs = Oblique.DEFAULT_INTERVAL_MS
    @_lastIntervalId = undefined
    @_directiveCollection = new DirectiveCollection()
    @_listenToDirectivesInDOM()

  @DEFAULT_INTERVAL_MS = 500

  _throwErrorIfJQueryIsntLoaded: ->
    throw new ObliqueError("Oblique needs jQuery to work") if not window.jQuery

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

  _mustApplyDirective: (DOMElement, directive) ->
    new ObliqueDOMElement(DOMElement).matchCSSExpression(directive.CSS_EXPRESSION)

  @_isApplyingDirectivesInDOM = false
  _applyDirectivesInDOM: ->
    return if (@_isApplyingDirectivesInDOM)
    @_isApplyingDirectivesInDOM = true
    try
      #TODO: change this to a more human readable loop
      rootElement = document.getElementsByTagName("body")[0]

      rootBqElement=new ObliqueDOMElement rootElement

      rootBqElement.eachDescendant(
        (DOMElement) =>
          obElement=new ObliqueDOMElement(DOMElement)
          for cssExpr in @_directiveCollection.getCSSExpressions()
            continue if not obElement.matchCSSExpression cssExpr
            for directive in @_directiveCollection.getDirectivesBy cssExpr
              directiveName = directive.name
              if not obElement.hasFlag directiveName
                obElement.setFlag directiveName
                new directive DOMElement
      )
    finally
      @_isApplyingDirectivesInDOM = false

  _isAFunction: (memberToTest) ->
    typeof (memberToTest) is "function"

  _throwErrorIfDirectiveIsNotValid: (directiveConstructorFn) ->
    throw ObliqueError("registerDirective must be called with a Directive 'Constructor/Class'")  unless @_isAFunction(directiveConstructorFn)
    throw ObliqueError("directive must has an static CSS_EXPRESSION property")  unless directiveConstructorFn.CSS_EXPRESSION

  getIntervalTimeInMs: ->
    @_intervalTimeInMs

  setIntervalTimeInMs: (newIntervalTimeInMs) ->
    throw new ObliqueError("IntervalTime must be a positive number") if newIntervalTimeInMs <= 0
    @_intervalTimeInMs = newIntervalTimeInMs
    @_listenToDirectivesInDOM()

  registerDirective: (directiveConstructorFn) ->
    @_throwErrorIfDirectiveIsNotValid directiveConstructorFn
    @_directiveCollection.add directiveConstructorFn


  destroy: ->
    @_clearLastInterval()
    try
      delete Oblique._singletonInstance
    catch e
      Oblique._singletonInstance = undefined
