class @ObliqueError
  constructor: (@message) ->
    return new ObliqueError(@message) if @ is window

class @Oblique

  constructor: ->
    return new Oblique()  if @ is window
    return Oblique._singletonInstance  if Oblique._singletonInstance
    Oblique._singletonInstance = @

    #Default private properties
    @_intervalTimeInMs = Oblique.DEFAULT_INTERVAL_MS
    @_lastIntervalId = `undefined`
    @_directiveConstructors = []
    @_listenToDirectivesInDOM()

  @DEFAULT_INTERVAL_MS = 500

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
    rootElement = document.getElementsByTagName("body")[0]
    bqDOMDocument.traverse rootElement, (DOMElement) =>
      return true  unless DOMElement.nodeType is bqDOMDocument.NODE_TYPE_ELEMENT
      for directiveConstructorFn in @._directiveConstructors
        if @_mustApplyDirective DOMElement, directiveConstructorFn
          return true if @._elementHasDirectiveApplied(DOMElement, directiveConstructorFn)
          @._applyDirectiveOnElement directiveConstructorFn, DOMElement
      return

  _addDirective: (directiveConstructorFn) ->
    @_directiveConstructors.push directiveConstructorFn

  _isAFunction: (memberToTest) ->
    typeof (memberToTest) is "function"

  _containsDirective: (directiveConstructorFnToCheck) ->
    containsDirective = false
    $.each @_directiveConstructors, (i, directiveConstructorFn) ->
      if directiveConstructorFn.CSS_EXPRESSION is directiveConstructorFnToCheck.CSS_EXPRESSION
        containsDirective = true
        false

    containsDirective

  _throwErrorIfDirectiveIsNotValid: (directiveConstructorFn) ->
    throw ObliqueError("registerDirective must be called with a Directive 'Constructor/Class'")  unless @_isAFunction(directiveConstructorFn)
    throw ObliqueError("directive must has an static CSS_EXPRESSION property")  unless directiveConstructorFn.CSS_EXPRESSION
    throw ObliqueError("Directive '" + directiveConstructorFn.CSS_EXPRESSION + "' already registered")  if @_containsDirective(directiveConstructorFn)
    return

  getIntervalTimeInMs: ->
    @_intervalTimeInMs

  setIntervalTimeInMs: (newIntervalTimeInMs) ->
    @_intervalTimeInMs = newIntervalTimeInMs
    @_listenToDirectivesInDOM()
    return

  registerDirective: (directiveConstructorFn) ->
    @_throwErrorIfDirectiveIsNotValid directiveConstructorFn
    @_addDirective directiveConstructorFn
    return