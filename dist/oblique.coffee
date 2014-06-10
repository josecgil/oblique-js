if typeof Object.getPrototypeOf isnt "function"
  if typeof "test".__proto__ is "object"
    Object.getPrototypeOf = (object) ->
      object.__proto__
  else
    Object.getPrototypeOf = (object) ->
      # May break if the constructor has been tampered with
      object.constructor::
@.ObliqueNS=@.ObliqueNS or {}

class DirectiveCollection

  constructor:()->
    @directives=[]
    @_cssExpressions=[]

  count:() ->
    @directives.length

  _isAFunction: (memberToTest) ->
    typeof (memberToTest) is "function"

  @NOT_A_FUNCTION_CLASS_ERROR_MESSAGE = "registerDirective must be called with a Directive 'Constructor/Class'"
  @DOESNT_HAVE_PROPERTY_CSS_EXPR_MESSAGE = "directive must has an static CSS_EXPRESSION property"

  _throwErrorIfDirectiveIsNotValid: (directive) ->
    if not @_isAFunction(directive)
      throw new ObliqueNS.Error(ObliqueNS.DirectiveCollection.NOT_A_FUNCTION_CLASS_ERROR_MESSAGE)
    if not directive.CSS_EXPRESSION
      throw new ObliqueNS.Error(ObliqueNS.DirectiveCollection.DOESNT_HAVE_PROPERTY_CSS_EXPR_MESSAGE)

  add:(directive) ->
    @_throwErrorIfDirectiveIsNotValid(directive)

    directive.name=Object.getPrototypeOf(directive).constructor.name

    @directives.push directive

    #pre-calc this when adding a Directive for fast access
    @_buildCSSExpressions()

  at:(index)->
    @directives[index]

  _containsCssExpr: (exprToSearch, exprArray) ->
    for expr in exprArray
      return true if exprToSearch is expr
    false

  _buildCSSExpressions : ->
    @_cssExpressions=[]
    for directive in @directives
      cssExpr = directive.CSS_EXPRESSION
      continue if @_containsCssExpr cssExpr, @_cssExpressions
      @_cssExpressions.push cssExpr

  getCSSExpressions : ->
    @_cssExpressions

  getDirectivesByCSSExpression: (cssExpression) ->
    directivesWithCSSExpr=[]
    for directive in @directives
      cssExpr = directive.CSS_EXPRESSION
      continue if cssExpr isnt cssExpression
      directivesWithCSSExpr.push directive
    directivesWithCSSExpr

ObliqueNS.DirectiveCollection=DirectiveCollection
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
class DirectiveTagError
@.ObliqueNS=@.ObliqueNS or {}

class Element

  constructor:(DOMElement)->
    @_DOMElement=DOMElement
    @_jQueryElement=jQuery(DOMElement)

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

  eachDescendant: (callbackOnDOMElement) ->
    Element._traverse(@_DOMElement, callbackOnDOMElement)

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

ObliqueNS.Element=Element
@.ObliqueNS=@.ObliqueNS or {}

class Error
  constructor: (@message) ->
    return new Error(@message) if @ is window
    @name = "Oblique.Error"

ObliqueNS.Error=Error

@.ObliqueNS=@.ObliqueNS or {}

Param=ObliqueNS.Param

class NamedParams

  constructor : (params, paramSeparator=";", valueSeparator=":") ->
    @params=[]
    for param in params.split paramSeparator
      @params.push new Param param, valueSeparator

  getParam : (paramName) ->
    for param in @params
      return param if param.name is paramName
    null

ObliqueNS.NamedParams=NamedParams
@.ObliqueNS=@.ObliqueNS or {}

class Param

  constructor:(param, valueSeparator=":")->
    paramAndValue=param.split valueSeparator
    @name=paramAndValue[0].trim()
    @value=paramAndValue[1].trim()

  valueAsInt: ->
    parseInt @value, 10

ObliqueNS.Param=Param
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
