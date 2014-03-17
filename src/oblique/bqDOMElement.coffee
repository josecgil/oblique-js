class @bqDOMElement

  @_isTag: (element) ->
    return element.nodeType is 1;

  @traverse: (parentElement, callbackOnDOMElement) ->
    elementToTraverse = []
    if bqDOMElement._isTag parentElement
      elementToTraverse.push parentElement

    callbackOnDOMElement parentElement
    while elementToTraverse.length > 0
      currentElement = elementToTraverse.pop()
      for child in currentElement.children
        if bqDOMElement._isTag child
          elementToTraverse.push child
          callbackOnDOMElement child
