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
    bqDOMElement.traverse rootElement, (DOMElement)->
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
    bqDOMElement.traverse rootElement, (DOMElement)->
      count++
      return if (count isnt 11)
      expect($(DOMElement).get(0).outerHTML).toBe testHTML
      done()

  it "Can traverse complex DOM", (done) ->
    testHTML = "<div id='one'>A complex <strong>DOM</strong>.<p>Is Here</p>.</div>"

    fixture = $("#fixture")
    fixture.append testHTML

    traversedDOMElements=[]
    rootElement = fixture.get(0)
    bqDOMElement.traverse rootElement, (DOMElement)->
      console.log "---> " + DOMElement.outerHTML
      traversedDOMElements.push $(DOMElement)
      return if (traversedDOMElements.length isnt 4)
      expect(traversedDOMElements[0].is("div#fixture")).toBeTruthy()
      expect(traversedDOMElements[1].is("div#one")).toBeTruthy()
      expect(traversedDOMElements[2].is("strong")).toBeTruthy()
      expect(traversedDOMElements[3].is("p")).toBeTruthy()
      done()