describe "Oblique", ->
  beforeEach (done) ->
    Oblique().destroy()
    Oblique().setIntervalTimeInMs
    FixtureHelper.clear()
    done()

  afterEach ->
    Oblique().destroy()

  it "On creation it has a default interval time", ->
    expect(Oblique().getIntervalTimeInMs()).toBe Oblique.DEFAULT_INTERVAL_MS

  it "Can change default interval time", ->
    newIntervaltimeMs = 10000
    oblique = Oblique()
    oblique.setIntervalTimeInMs newIntervaltimeMs
    expect(oblique.getIntervalTimeInMs()).toBe newIntervaltimeMs

  it "Can't change default interval time to invalid value", ->
    expect(->
      Oblique().setIntervalTimeInMs -1
    ).toThrow(new ObliqueError("IntervalTime must be a positive number"))

  it "If I register a Directive it calls its constructor when expression is in DOM", (done)->
    class TestDirective
      constructor: ()->
        Oblique().destroy()
        done()

      @CSS_EXPRESSION = "*[data-test]"

    Oblique().registerDirective TestDirective
    Oblique().setIntervalTimeInMs 10
    $("#fixture").html "<div data-test></div>"


  it "If I register a Directive it calls its constructor only one time when expression is in DOM", (done)->
    counter=0
    class TestDirective
      constructor: ()->
        counter++

      @CSS_EXPRESSION = "*[data-test]"

    Oblique().registerDirective TestDirective
    Oblique().setIntervalTimeInMs 10
    $("#fixture").html "<div data-test></div>"

    setTimeout ->
      Oblique().destroy()
      expect(counter).toBe 1
      done()
    , 100



  it "If I register a Directive it calls its constructor with the correct DOM element", (done)->
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

  it "must execute 1 directive in a 10000 elements DOM in <200ms", (done)->

    DOM_ELEMENTS_COUNT = 4*250
    FixtureHelper.appendHTML "<p class='test'>nice DOM</p>", DOM_ELEMENTS_COUNT/4
    FixtureHelper.appendHTML "<div class='test'>nice DOM</div>", DOM_ELEMENTS_COUNT/4
    FixtureHelper.appendHTML "<span class='test'>nice DOM</span>", DOM_ELEMENTS_COUNT/4
    FixtureHelper.appendHTML "<test class='test'>nice DOM</test>", DOM_ELEMENTS_COUNT/4

    interval=new Interval()
    counter=0
    class TestDirective
      constructor: ()->
        counter++
        if (counter is (DOM_ELEMENTS_COUNT))
          interval.stop()
          expect(interval.timeInMs).toBeLessThan 200
          done()

      @CSS_EXPRESSION = ".test"

    interval.start()
    Oblique().registerDirective(TestDirective)
    Oblique().setIntervalTimeInMs 10

  it "must execute 5 directives in a 10000 elements DOM in <400ms", (done)->

    #TODO: test with different expressions in each Directive
    DOM_ELEMENTS_COUNT = 4*250
    FixtureHelper.appendHTML "<p class='test'>nice DOM</p>", DOM_ELEMENTS_COUNT/4
    FixtureHelper.appendHTML "<div class='test'>nice DOM</div>", DOM_ELEMENTS_COUNT/4
    FixtureHelper.appendHTML "<span class='test'>nice DOM</span>", DOM_ELEMENTS_COUNT/4
    FixtureHelper.appendHTML "<test class='test'>nice DOM</test>", DOM_ELEMENTS_COUNT/4

    interval=new Interval()
    counter=0
    class TestDirective
      constructor: ()->
        counter++
      @CSS_EXPRESSION = ".test"

    class TestDirective2
      constructor: ()->
        counter++
      @CSS_EXPRESSION = ".test"

    class TestDirective3
      constructor: ()->
        counter++
      @CSS_EXPRESSION = ".test"

    class TestDirective4
      constructor: ()->
        counter++
      @CSS_EXPRESSION = ".test"

    class TestDirective5
      constructor: ()->
        counter++
        if (counter is (DOM_ELEMENTS_COUNT*5))
          interval.stop()
          console.log interval.timeInMs
          expect(interval.timeInMs).toBeLessThan 400
          done()

      @CSS_EXPRESSION = ".test"

    interval.start()
    Oblique().registerDirective(TestDirective)
    Oblique().registerDirective(TestDirective2)
    Oblique().registerDirective(TestDirective3)
    Oblique().registerDirective(TestDirective4)
    Oblique().registerDirective(TestDirective5)
    Oblique().setIntervalTimeInMs 10
