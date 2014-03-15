describe "Oblique", ->
  beforeEach (done) ->
    Oblique().destroyInstance()
    @oblique = Oblique()
    $("#fixture").html ""
    done()

  afterEach ->
    @oblique.destroyInstance()
    @oblique = undefined

  it "On creation it has a default interval time", ->
    expect(@oblique.getIntervalTimeInMs()).toBe Oblique.DEFAULT_INTERVAL_MS

  it "We can change default interval time", ->
    newIntervaltimeMs = 10000
    @oblique.setIntervalTimeInMs newIntervaltimeMs
    expect(@oblique.getIntervalTimeInMs()).toBe newIntervaltimeMs

  it "We can't change default interval time to invalid value", ->
    try
      @oblique.setIntervalTimeInMs -1
      throw Error "It must throw an ObliqueError"
    catch error
      if not (error instanceof ObliqueError)
        throw Error "It must throw an ObliqueError"

  it "If a register a Directive if calls it constructor when expression is in DOM", (done)->
    class TestDirective
      constructor: (DOMElement)->
        Oblique().destroyInstance()
        done()

      @CSS_EXPRESSION = "*[data-test]"

    @oblique.registerDirective TestDirective
    @oblique.setIntervalTimeInMs 10
    newHTML = "<div data-test></div>"
    $("#fixture").html newHTML

  it "If a register a Directive if calls it constructor with the correct DOM element", (done)->
    class TestDirective
      constructor: (DOMElement)->
        expect($(DOMElement).is("test[data-test]")).toBeTruthy()
        Oblique().destroyInstance()
        done()

      @CSS_EXPRESSION = "*[data-test]"

    @oblique.registerDirective TestDirective
    @oblique.setIntervalTimeInMs 10
    newHTML = "<test data-test></test>"
    $("#fixture").html newHTML