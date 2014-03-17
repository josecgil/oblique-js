class @bqDOMDocument

  @traverse: (parentElement, callbackOnDOMElement) ->
    elementToTraverse = []
    elementToTraverse.push parentElement
    callbackOnDOMElement parentElement
    while elementToTraverse.length > 0
      currentElement = elementToTraverse.pop()
      for child in currentElement.children
        elementToTraverse.push child
        callbackOnDOMElement child

  @ELEMENT_NODE_TYPE = 1;
