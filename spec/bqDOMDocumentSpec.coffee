describe "bqDOMDocument", ->
  beforeEach (done) ->
    $("#fixture").html ""
    done()

  afterEach ->

  it "Can traverse a simple DOM", (done) ->
    testHTML = "<div>A simple DOM</div>"
    $("#fixture").html testHTML
    rootElement = $("#fixture").get(0)
    count = 0;
    bqDOMDocument.traverse rootElement, (DOMElement)->
      count++
      if (count is 2)
        expect($(DOMElement).get(0).outerHTML).toBe testHTML
        done()

  it "Can traverse 10 element DOM", (done) ->
    testHTML = "<div>A medium DOM</div>"

    fixture = $("#fixture")

    fixture.append testHTML for [1..10]

    rootElement = fixture.get(0)
    count = 0;
    bqDOMDocument.traverse rootElement, (DOMElement)->
      return if DOMElement.nodeType isnt bqDOMDocument.ELEMENT_NODE_TYPE
      count++
      return if (count isnt 11)
      expect($(DOMElement).get(0).outerHTML).toBe testHTML
      done()