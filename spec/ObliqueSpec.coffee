describe "Oblique", ->
  beforeEach (done) ->
    Oblique().destroy()
    Oblique().setIntervalTimeInMs
    $("#fixture").html ""
    done()

  afterEach ->
    Oblique().destroy()

  it "On creation it has a default interval time", ->
    expect(Oblique().getIntervalTimeInMs()).toBe Oblique.DEFAULT_INTERVAL_MS

  it "We can change default interval time", ->
    newIntervaltimeMs = 10000
    oblique = Oblique()
    oblique.setIntervalTimeInMs newIntervaltimeMs
    expect(oblique.getIntervalTimeInMs()).toBe newIntervaltimeMs

  it "We can't change default interval time to invalid value", ->
    expect(->
      Oblique().setIntervalTimeInMs -1
    ).toThrow(new ObliqueError("IntervalTime must be a positive number"))

  it "If a register a Directive if calls it constructor when expression is in DOM", (done)->
    class TestDirective
      constructor: (DOMElement)->
        Oblique().destroy()
        done()

      @CSS_EXPRESSION = "*[data-test]"

    Oblique().registerDirective TestDirective
    Oblique().setIntervalTimeInMs 10
    $("#fixture").html "<div data-test></div>"

  it "If a register a Directive if calls it constructor with the correct DOM element", (done)->
    class TestDirective
      constructor: (DOMElement)->
        expect($(DOMElement).is("test[data-test]")).toBeTruthy()
        Oblique().destroy()
        done()

      @CSS_EXPRESSION = "*[data-test]"

    Oblique().registerDirective TestDirective
    $("#fixture").html "<test data-test></test>"

  it "If I register a Directive without CSS_EXPRESSION it throws an Error", ()->
    class TestDirective
    expect(->
      Oblique().registerDirective TestDirective
    ).toThrow(new ObliqueError("directive must has an static CSS_EXPRESSION property"))

  it "If I register an object that no is a Directive it throws an Error", ()->
    expect(->
      Oblique().registerDirective {}
    ).toThrow(new ObliqueError("registerDirective must be called with a Directive 'Constructor/Class'"))
