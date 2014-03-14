class @ObliqueDOMDocument

  @traverse: (rootElement, callbackOnDOMElement) ->
    currentDOMElement = rootElement.firstChild
    while currentDOMElement
      callbackOnDOMElement currentDOMElement
      currentDOMElement = currentDOMElement.firstChild or currentDOMElement.nextSibling or ((if currentDOMElement.parentNode is rootElement then null else currentDOMElement.parentNode.nextSibling))

  @NODE_TYPE_ELEMENT = 1;
