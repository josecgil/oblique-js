class @Oblique

  constructor: ->
    return new Oblique() if @ is window
    return Oblique._singletonInstance  if Oblique._singletonInstance
    Oblique._singletonInstance = @

    @_throwErrorIfJQueryIsntLoaded()

    #Default private properties
    @_intervalTimeInMs = Oblique.DEFAULT_INTERVAL_MS
    @_lastIntervalId = `undefined`
    @_directiveConstructors = []
    @_listenToDirectivesInDOM()

  @DEFAULT_INTERVAL_MS = 500

  _throwErrorIfJQueryIsntLoaded: ->
    throw new ObliqueError("Oblique needs jQuery to work") if not window.jQuery

  _clearLastInterval: ->
    clearInterval @_lastIntervalId  unless @_lastIntervalId is `undefined`

  _applyDirectivesOnDocumentReady: ->
    $(document).ready =>
      @_applyDirectivesInDOM()

  _setNewInterval: ->
    @_lastIntervalId = setInterval =>
      @_applyDirectivesInDOM()
    , @_intervalTimeInMs

  _listenToDirectivesInDOM: ->
    @_clearLastInterval()
    @_applyDirectivesOnDocumentReady()
    @_setNewInterval()

  _elementHasDirectiveApplied: (DOMElement, directive) ->
    $(DOMElement).data directive.CSS_EXPRESSION

  _applyDirectiveOnElement: (directiveConstructorFn, DOMElement) ->
    $(DOMElement).data directiveConstructorFn.CSS_EXPRESSION, true
    new directiveConstructorFn DOMElement
    return

  _mustApplyDirective: (DOMElement, directive) ->
    return $(DOMElement).is(directive.CSS_EXPRESSION)

  _applyDirectivesInDOM: ->
    #TODO: change this to a more human readable loop
    rootElement = document.getElementsByTagName("body")[0]
    bqDOMDocument.traverse rootElement, (DOMElement) =>
      return true  unless DOMElement.nodeType is bqDOMDocument.ELEMENT_NODE_TYPE
      for directiveConstructorFn in @._directiveConstructors
        if @_mustApplyDirective DOMElement, directiveConstructorFn
          return true if @._elementHasDirectiveApplied(DOMElement, directiveConstructorFn)
          @._applyDirectiveOnElement directiveConstructorFn, DOMElement
      return

  _addDirective: (directiveConstructorFn) ->
    @_directiveConstructors.push directiveConstructorFn

  _isAFunction: (memberToTest) ->
    typeof (memberToTest) is "function"

  _throwErrorIfDirectiveIsNotValid: (directiveConstructorFn) ->
    throw ObliqueError("registerDirective must be called with a Directive 'Constructor/Class'")  unless @_isAFunction(directiveConstructorFn)
    throw ObliqueError("directive must has an static CSS_EXPRESSION property")  unless directiveConstructorFn.CSS_EXPRESSION
    return

  getIntervalTimeInMs: ->
    @_intervalTimeInMs

  setIntervalTimeInMs: (newIntervalTimeInMs) ->
    throw new ObliqueError("IntervalTime must be a positive number") if newIntervalTimeInMs <= 0
    @_intervalTimeInMs = newIntervalTimeInMs
    @_listenToDirectivesInDOM()
    return

  registerDirective: (directiveConstructorFn) ->
    @_throwErrorIfDirectiveIsNotValid directiveConstructorFn
    @_addDirective directiveConstructorFn
    return

  destroyInstance: ->
    @_clearLastInterval();
    Oblique._singletonInstance = undefined;