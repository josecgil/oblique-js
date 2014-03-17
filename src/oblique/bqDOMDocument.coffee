class @bqDOMDocument

  @traverse: (rootElement, callbackOnDOMElement) ->
    callbackOnDOMElement rootElement
    $(rootElement).find("*").each(
      (i, DOMElement)->
        callbackOnDOMElement DOMElement
    )

  @ELEMENT_NODE_TYPE = 1;
  