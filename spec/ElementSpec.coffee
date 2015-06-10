
describe "Element", ->

  Element=ObliqueNS.Element

  beforeEach (done) ->
    $("#fixture").html ""
    done()

  afterEach ->
    $("#fixture").html ""

  it "Can traverse a simple DOM", (done) ->
    testHTML="<div>A simple DOM</div>"
    rootElement = FixtureHelper.appendHTML testHTML
    count = 0;
    Element._traverse rootElement, (DOMElement)->
      count++
      if (count is 2)
        expect($(DOMElement).get(0).outerHTML).toBe testHTML
        done()

  it "Can traverse a normal DOM", (done) ->
    testHTML = "<div>A medium DOM</div>"

    ELEMENTS_COUNT = 10
    rootElement = FixtureHelper.appendHTML testHTML, ELEMENTS_COUNT

    count = 0;
    Element._traverse rootElement, (DOMElement)->
      count++
      return if (count isnt ELEMENTS_COUNT+1)
      expect($(DOMElement).get(0).outerHTML).toBe testHTML
      done()

  it "Can traverse a large DOM", (done) ->
    testHTML = "<div>A large DOM</div>"

    ELEMENTS_COUNT = 10000
    rootElement = FixtureHelper.appendHTML testHTML, ELEMENTS_COUNT

    count = 0;
    Element._traverse rootElement, (DOMElement)->
      count++
      return if (count isnt ELEMENTS_COUNT+1)
      expect($(DOMElement).get(0).outerHTML).toBe testHTML
      done()

  it "Can traverse complex DOM", (done) ->
    testHTML = "<div id='one'>A complex <strong>DOM</strong>.<p>Is Here</p>.</div>"
    rootElement = FixtureHelper.appendHTML testHTML

    traversedDOMElements=[]
    Element._traverse rootElement, (DOMElement)->
      traversedDOMElements.push $(DOMElement)
      return if (traversedDOMElements.length isnt 4)
      expect(traversedDOMElements[0].is("div#fixture")).toBeTruthy()
      expect(traversedDOMElements[1].is("div#one")).toBeTruthy()
      expect(traversedDOMElements[2].is("strong")).toBeTruthy()
      expect(traversedDOMElements[3].is("p")).toBeTruthy()
      done()

  it "If a set a flag, flag is set", () ->
    testHTML = "<div></div>"
    fixture = FixtureHelper.appendHTML testHTML
    bqElement=new Element(fixture)
    FLAG_NAME = "visited"
    bqElement.setFlag FLAG_NAME
    expect(bqElement.hasFlag FLAG_NAME).toBeTruthy()

  it "If a set a flag and I recreate the same DOMElement flag is set", () ->
    testHTML = "<div></div>"
    fixture = FixtureHelper.appendHTML testHTML
    bqElement=new Element fixture
    FLAG_NAME = "visited"
    bqElement.setFlag FLAG_NAME

    bqElement2=new Element fixture
    hasVisitedFlag = bqElement2.hasFlag FLAG_NAME
    expect(hasVisitedFlag).toBeTruthy()

  it "If a unset a flag, flag is not present", () ->
    fixture = $("#fixture")
    bqElement=new Element(fixture.get(0))
    FLAG_NAME = "visited"
    bqElement.setFlag FLAG_NAME
    expect(bqElement.hasFlag FLAG_NAME).toBeTruthy()
    bqElement.unsetFlag FLAG_NAME
    expect(bqElement.hasFlag FLAG_NAME).toBeFalsy()

  it "must know if an attribute is present", () ->
    FixtureHelper.appendHTML "<div id='data-model-test1' data-model='name'></div>"
    bqElement=new Element $("#data-model-test1")
    expect(bqElement.hasAttribute("data-model")).toBeTruthy()

  it "must know if an attribute is present", () ->
    FixtureHelper.appendHTML "<div id='data-model-test2'></div>"
    bqElement=new Element $("#data-model-test2")
    expect(bqElement.hasAttribute("data-model")).toBeFalsy()

  it "must return undefined if an attribute isn't present", () ->
    FixtureHelper.appendHTML "<div id='data-model-test2'></div>"
    bqElement=new Element $("#data-model-test2")
    expect(bqElement.getAttributeValue("data-model")).toBeUndefined()

  it "must know an attribute value", () ->
    FixtureHelper.appendHTML "<div id='data-model-test3' data-model='name'></div>"
    bqElement=new Element $("#data-model-test3")
    expect(bqElement.getAttributeValue("data-model")).toBe "name"

  it "must returns element html", () ->
    FixtureHelper.appendHTML '<div id="elementHtml" data-test="element html"></div>'
    bqElement=new Element $("#elementHtml")
    expect(bqElement.getHtml()).toBe '<div id="elementHtml" data-test="element html"></div>'

  it "must returns DOMElement", () ->
    FixtureHelper.appendHTML '<div id="elementHtml" data-test="element html"></div>'
    bqElement=new Element $("#elementHtml")
    expect(bqElement.getDOMElement().outerHTML).toBe '<div id="elementHtml" data-test="element html"></div>'

  it "must returns jQueryElement", () ->
    FixtureHelper.appendHTML '<div id="elementHtml" data-test="element html"></div>'
    bqElement=new Element $("#elementHtml")
    expect(bqElement.getjQueryElement().get(0).outerHTML).toBe '<div id="elementHtml" data-test="element html"></div>'

