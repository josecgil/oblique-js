class @bqDOMDocument

  ###
  @traverseOld: (rootElement, callbackOnDOMElement) ->
  currentDOMElement = rootElement.firstChild
  while currentDOMElement
    callbackOnDOMElement currentDOMElement
    currentDOMElement = currentDOMElement.firstChild or currentDOMElement.nextSibling or ((if currentDOMElement.parentNode is rootElement then null else currentDOMElement.parentNode.nextSibling))
  ###

  @addNodeToVisited: (node, visitedNodes) ->
    visitedNodes.push node

  @removeNodeFromVisited: (node, visitedNodes) ->
    index = visitedNodes.indexOf node
    visitedNodes.splice index, 1 if (index > -1)


  @nodeHasBeenVisited: (node, visitedNodes) ->
    return visitedNodes.indexOf(node) > -1

  @traverse: (rootElemet, callbackOnDOMElement) ->
    visitedNodes = []
    currentNode = rootElemet
    while currentNode

      # If node have already been visited
      if nodeHasBeenVisited node, visitedNodes

        # Remove mark for visited nodes
        @removeNodeFromVisited(node, visitedNodes)

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
  