describe "ObliqueDOMElement", ->
  beforeEach (done) ->
    $("#fixture").html ""
    done()

  afterEach ->

  makeHTMLInFixture = (newHTML, times=1) ->
    fixtureJQuery = $("#fixture")
    fixtureJQuery.html("")
    fixtureJQuery.append newHTML for [1..times]
    fixtureJQuery.get 0

  it "Can traverse a simple DOM", (done) ->
    testHTML="<div>A simple DOM</div>"
    rootElement = makeHTMLInFixture testHTML
    count = 0;
    ObliqueDOMElement._traverse rootElement, (DOMElement)->
      count++
      if (count is 2)
        expect($(DOMElement).get(0).outerHTML).toBe testHTML
        done()

  it "Can traverse a normal DOM", (done) ->
    testHTML = "<div>A medium DOM</div>"

    ELEMENTS_COUNT = 10
    rootElement = makeHTMLInFixture testHTML, ELEMENTS_COUNT

    count = 0;
    ObliqueDOMElement._traverse rootElement, (DOMElement)->
      count++
      return if (count isnt ELEMENTS_COUNT+1)
      expect($(DOMElement).get(0).outerHTML).toBe testHTML
      done()

  it "Can traverse a large DOM", (done) ->
    testHTML = "<div>A large DOM</div>"

    ELEMENTS_COUNT = 10000
    rootElement = makeHTMLInFixture testHTML, ELEMENTS_COUNT

    count = 0;
    ObliqueDOMElement._traverse rootElement, (DOMElement)->
      count++
      return if (count isnt ELEMENTS_COUNT+1)
      expect($(DOMElement).get(0).outerHTML).toBe testHTML
      done()

  it "Can traverse complex DOM", (done) ->
    testHTML = "<div id='one'>A complex <strong>DOM</strong>.<p>Is Here</p>.</div>"
    rootElement = makeHTMLInFixture testHTML

    traversedDOMElements=[]
    ObliqueDOMElement._traverse rootElement, (DOMElement)->
      traversedDOMElements.push $(DOMElement)
      return if (traversedDOMElements.length isnt 4)
      expect(traversedDOMElements[0].is("div#fixture")).toBeTruthy()
      expect(traversedDOMElements[1].is("div#one")).toBeTruthy()
      expect(traversedDOMElements[2].is("strong")).toBeTruthy()
      expect(traversedDOMElements[3].is("p")).toBeTruthy()
      done()

  it "If a set a flag, flag is set", () ->
    testHTML = "<div></div>"
    fixture = makeHTMLInFixture testHTML
    bqElement=new ObliqueDOMElement(fixture)
    FLAG_NAME = "visited"
    bqElement.setFlag FLAG_NAME
    expect(bqElement.hasFlag FLAG_NAME).toBeTruthy()

  it "If a set a flag and I recreate the same DOMElement flag is set", () ->
    testHTML = "<div></div>"
    fixture = makeHTMLInFixture testHTML
    bqElement=new ObliqueDOMElement fixture
    FLAG_NAME = "visited"
    bqElement.setFlag FLAG_NAME

    bqElement2=new ObliqueDOMElement fixture
    hasVisitedFlag = bqElement2.hasFlag FLAG_NAME
    expect(hasVisitedFlag).toBeTruthy()


  it "If a unset a flag, flag is not present", () ->
    fixture = $("#fixture")
    bqElement=new ObliqueDOMElement(fixture.get(0))
    FLAG_NAME = "visited"
    bqElement.setFlag FLAG_NAME
    expect(bqElement.hasFlag FLAG_NAME).toBeTruthy()
    bqElement.unsetFlag FLAG_NAME
    expect(bqElement.hasFlag FLAG_NAME).toBeFalsy()
