class @bqDOMDocument

  ###
  @traverseOld: (rootElement, callbackOnDOMElement) ->
  currentDOMElement = rootElement.firstChild
  while currentDOMElement
    callbackOnDOMElement currentDOMElement
    currentDOMElement = currentDOMElement.firstChild or currentDOMElement.nextSibling or ((if currentDOMElement.parentNode is rootElement then null else currentDOMElement.parentNode.nextSibling))
  ###
  
@traverse: (rootElemet, callbackOnDOMElement) ->
    currentNode = rootElemet
    while currentNode

      # If node have already been visited
      if currentNode.hasBeenVisited

        # Remove mark for visited nodes
        currentNode.hasBeenVisited = undefined

        # Once we reach the rootElemet element again traversal
        # is done and we can break
        break if currentNode is rootElemet
        if currentNode.nextSibling
          currentNode = currentNode.nextSibling
        else
          currentNode = currentNode.parentNode

        # else this is the first visit to the node
      else
        callbackOnDOMElement currentNode

        # If node has childnodes then we mark this node as
        # visited as we are sure to be back later
        if currentNode.firstChild
          currentNode.hasBeenVisited = true
          currentNode = currentNode.firstChild
        else if currentNode.nextSibling
          currentNode = currentNode.nextSibling
        else
          currentNode = currentNode.parentNode
    return

  @ELEMENT_NODE_TYPE = 1;
  