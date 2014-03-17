class @ObliqueDOMElement

  constructor:(DOMElement)->
    @_DOMElement=DOMElement
    @_jQueryElement=jQuery(DOMElement)

  isTag: ->
    ObliqueDOMElement._isTag(@_DOMElement)

  matchCSSExpression: (cssExpression) ->
    @_jQueryElement.is(cssExpression)

  setFlag: (flagName) ->
    @_jQueryElement.data(flagName, true)

  unsetFlag: (flagName) ->
    @_jQueryElement.removeData(flagName)

  hasFlag: (flagName) ->
    @_jQueryElement.data(flagName)

  eachDescendant: (callbackOnDOMElement) ->
    ObliqueDOMElement._traverse(@_DOMElement, callbackOnDOMElement)

  @_isTag: (DOMElement) ->
    DOMElement.nodeType is 1

  @_traverse: (parentElement, callbackOnDOMElement) ->
    elementsToTraverse = []
    if ObliqueDOMElement._isTag parentElement
      elementsToTraverse.push parentElement

    callbackOnDOMElement parentElement
    while elementsToTraverse.length > 0
      currentElement = elementsToTraverse.pop()
      for child in currentElement.children
        if ObliqueDOMElement._isTag child
          elementsToTraverse.push child
          callbackOnDOMElement child
