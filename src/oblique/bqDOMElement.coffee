class @bqDOMElement

  constructor:(DOMElement)->
    @_DOMElement=DOMElement
    @_jQueryElement=$(DOMElement)
    @_DOMElement.bqFlags={}

  isTag: ->
    bqDOMElement._isTag(@_DOMElement)

  matchCSSExpression: (cssExpression) ->
    @_jQueryElement.is(cssExpression)

  setFlag: (flagName) ->
    @_DOMElement.bqFlags[flagName]=true

  hasFlag: (flagName) ->
    return true if @_DOMElement.bqFlags[flagName] is true
    false

  unsetFlag: (flagName) ->
    delete @_DOMElement.bqFlags[flagName]

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
