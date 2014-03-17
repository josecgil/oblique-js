class @bqDOMElement

  constructor:(DOMElement)->
    @_DOMElement=DOMElement
    @_jQueryElement=$(DOMElement)

  isTag: ->
    bqDOMElement._isTag(@_DOMElement)

  matchCSSExpression: (cssExpression) ->
    @_jQueryElement.is(cssExpression)

  ###
  TODO: falta setflag(name) unsetFlag(name) en esta clase como sustituto de:
      $(DOMElement).data directive.CSS_EXPRESSION
        falta también testear todo lo nuevo
  ###

  setFlag: (flagName) ->
    @_jQueryElement.data(flagName,true)

  hasFlag: (flagName) ->
    return true if @_jQueryElement.data(flagName) is true
    false

  unsetFlag: (flagName) ->
    @_jQueryElement.data(flagName, false)


  @_isTag: (DOMElement) ->
    DOMElement.nodeType is 1


  eachDescendant: (callbackOnDOMElement) ->
    bqDOMElement._traverse(@_DOMElement, callbackOnDOMElement)

  @_traverse: (parentElement, callbackOnDOMElement) ->
    elementsToTraverse = []
    if bqDOMElement._isTag parentElement
      elementsToTraverse.push parentElement

    callbackOnDOMElement parentElement
    while elementsToTraverse.length > 0
      currentElement = elementsToTraverse.pop()
      for child in currentElement.children
        if bqDOMElement._isTag child
          elementsToTraverse.push child
          callbackOnDOMElement child
