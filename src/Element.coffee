@.ObliqueNS=@.ObliqueNS or {}

class Element

  constructor:(DOMElement)->
    @_jQueryElement=jQuery(DOMElement)

  getDOMElement:->
    @_jQueryElement.get 0

  getjQueryElement:->
    @_jQueryElement

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

  hasAttribute: (attributeName) ->
    attrValue=@getAttributeValue attributeName
    return false if attrValue is undefined
    true

  getAttributeValue: (attributeName) ->
    @_jQueryElement.attr attributeName

  eachDescendant: (callbackOnDOMElement) ->
    Element._traverse(@getDOMElement(), callbackOnDOMElement)

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

  getHtml:->
    @getDOMElement().outerHTML

ObliqueNS.Element=Element