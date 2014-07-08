

describe "DirectiveProcessor", ->

  DirectiveProcessor=ObliqueNS.DirectiveProcessor
  ObError=ObliqueNS.Error

  beforeEach (done) ->
    DirectiveProcessor().destroy()
    DirectiveProcessor().setIntervalTimeInMs 10
    FixtureHelper.clear()
    done()

  afterEach ->
    DirectiveProcessor().destroy()

  it "On creation it has a default interval time", ->
    DirectiveProcessor().destroy()
    expect(DirectiveProcessor().getIntervalTimeInMs()).toBe DirectiveProcessor.DEFAULT_INTERVAL_MS

  it "Can change default interval time", ->
    newIntervaltimeMs = 10000
    oblique = DirectiveProcessor()
    oblique.setIntervalTimeInMs newIntervaltimeMs
    expect(oblique.getIntervalTimeInMs()).toBe newIntervaltimeMs

  it "Can't change default interval time to invalid value", ->
    expect(->
      DirectiveProcessor().setIntervalTimeInMs -1
    ).toThrow(new ObError("IntervalTime must be a positive number"))

  it "If I register a Directive it calls its constructor when data-directive is in DOM", (done)->
    class TestDirective
      constructor: ()->
        DirectiveProcessor().destroy()
        done()

    DirectiveProcessor().registerDirective TestDirective
    DirectiveProcessor().setIntervalTimeInMs 10
    $("#fixture").html "<div data-directive='TestDirective'></div>"


  it "If I register a Directive it calls its constructor only one time when data-directive is in DOM", (done)->
    counter=0
    class TestDirective
      constructor: ()->
        counter++

    DirectiveProcessor().registerDirective TestDirective
    DirectiveProcessor().setIntervalTimeInMs 10

    FixtureHelper.appendHTML "<div data-directive='TestDirective'></div>"

    setTimeout ->
      DirectiveProcessor().destroy()
      expect(counter).toBe 1
      done()
    , 100



  it "If I register a Directive it calls its constructor with the correct DOM element", (done)->
    class TestDirective
      constructor: (DOMElement)->
        expect($(DOMElement).is("test[data-directive='TestDirective']")).toBeTruthy()
        DirectiveProcessor().destroy()
        done()

    DirectiveProcessor().registerDirective TestDirective
    FixtureHelper.appendHTML "<test data-directive='TestDirective'></test>"

  it "must call 2 directives if there are in the same tag", (done)->
    calls={};
    class HideOnClickDirective
      constructor: ()->
        calls["TestDirective1"]=true;
        if (calls.TestDirective1 && calls.TestDirective2)
          DirectiveProcessor().destroy()
          done()

    class ShowOnClickDirective
      constructor: ()->
        calls["TestDirective2"]=true;
        if (calls.TestDirective1 && calls.TestDirective2)
          DirectiveProcessor().destroy()
          done()


    DirectiveProcessor().registerDirective ShowOnClickDirective
    DirectiveProcessor().registerDirective HideOnClickDirective
    FixtureHelper.appendHTML "<test data-directive='ShowOnClickDirective, HideOnClickDirective'></test>"

  it "must call 2 directives if there are in the same tag (2 instances of same tag)", (done)->
    calls={};
    calls.TestDirective1=0
    calls.TestDirective2=0
    class HideOnClickDirective
      constructor: ()->
        calls["TestDirective1"]++;
        if (calls.TestDirective1 is 2) and (calls.TestDirective2 is 2)
          DirectiveProcessor().destroy()
          done()

    class ShowOnClickDirective
      constructor: ()->
        calls["TestDirective2"]++;
        if (calls.TestDirective1 is 2) and (calls.TestDirective2 is 2)
          DirectiveProcessor().destroy()
          done()


    DirectiveProcessor().registerDirective ShowOnClickDirective
    DirectiveProcessor().registerDirective HideOnClickDirective
    FixtureHelper.appendHTML "<test data-directive='ShowOnClickDirective, HideOnClickDirective'></test>"
    FixtureHelper.appendHTML "<test data-directive='ShowOnClickDirective, HideOnClickDirective'></test>"

  it "If I register an object that no is a Directive it throws an Error", ()->
    expect(->
      DirectiveProcessor().registerDirective {}
    ).toThrow(new ObError("registerDirective must be called with a Directive 'Constructor/Class'"))

  it "must execute 1 directive in a 10000 elements DOM in <200ms", (done)->

    DOM_ELEMENTS_COUNT = 4*250
    FixtureHelper.appendHTML "<p data-directive='TestDirective'>nice DOM</p>", DOM_ELEMENTS_COUNT/4
    FixtureHelper.appendHTML "<div data-directive='TestDirective'>nice DOM</div>", DOM_ELEMENTS_COUNT/4
    FixtureHelper.appendHTML "<span data-directive='TestDirective'>nice DOM</span>", DOM_ELEMENTS_COUNT/4
    FixtureHelper.appendHTML "<test data-directive='TestDirective'>nice DOM</test>", DOM_ELEMENTS_COUNT/4

    interval=new Interval()
    counter=0
    class TestDirective
      constructor: ()->
        counter++
        if (counter is (DOM_ELEMENTS_COUNT))
          interval.stop()
          expect(interval.timeInMs).toBeLessThan 200
          done()

      @NAME="TestDirective"

    interval.start()
    DirectiveProcessor().registerDirective(TestDirective)
    DirectiveProcessor().setIntervalTimeInMs 10

  it "must execute 5 directives in a 10000 elements DOM in <400ms", (done)->

    #TODO: test with different expressions in each Directive
    DOM_ELEMENTS_COUNT = 4*250
    FixtureHelper.appendHTML "<p data-directive='TestDirective,TestDirective2, TestDirective3, TestDirective4, TestDirective5'>nice DOM</p>", DOM_ELEMENTS_COUNT/4
    FixtureHelper.appendHTML "<div data-directive='TestDirective,TestDirective2, TestDirective3, TestDirective4, TestDirective5'>nice DOM</div>", DOM_ELEMENTS_COUNT/4
    FixtureHelper.appendHTML "<span data-directive='TestDirective,TestDirective2, TestDirective3, TestDirective4, TestDirective5'>nice DOM</span>", DOM_ELEMENTS_COUNT/4
    FixtureHelper.appendHTML "<test data-directive='TestDirective,TestDirective2, TestDirective3, TestDirective4, TestDirective5'>nice DOM</test>", DOM_ELEMENTS_COUNT/4

    interval=new Interval()
    counter=0
    class TestDirective
      constructor: ()->
        counter++

    class TestDirective2
      constructor: ()->
        counter++

    class TestDirective3
      constructor: ()->
        counter++

    class TestDirective4
      constructor: ()->
        counter++

    class TestDirective5
      constructor: ()->
        counter++
        if (counter is (DOM_ELEMENTS_COUNT*5))
          interval.stop()
          console.log "Processed 5 directives in a 10000 elements DOM in #{interval.timeInMs}ms"
          expect(interval.timeInMs).toBeLessThan 400
          done()

    interval.start()
    DirectiveProcessor().registerDirective(TestDirective)
    DirectiveProcessor().registerDirective(TestDirective2)
    DirectiveProcessor().registerDirective(TestDirective3)
    DirectiveProcessor().registerDirective(TestDirective4)
    DirectiveProcessor().registerDirective(TestDirective5)
    DirectiveProcessor().setIntervalTimeInMs 10

  it "must execute 4 directives with different CSSExpressions", (done)->

    DOM_ELEMENTS_COUNT = 4*250
    FixtureHelper.appendHTML "<p data-directive='TestDirective'>nice DOM</p>", DOM_ELEMENTS_COUNT/4
    FixtureHelper.appendHTML "<div data-directive='TestDirective2'>nice DOM</div>", DOM_ELEMENTS_COUNT/4
    FixtureHelper.appendHTML "<span data-directive='TestDirective3'>nice DOM</span>", DOM_ELEMENTS_COUNT/4
    FixtureHelper.appendHTML "<test data-directive='TestDirective4'>nice DOM</test>", DOM_ELEMENTS_COUNT/4

    counter=0
    class TestDirective
      constructor: ()->
        counter++

    class TestDirective2
      constructor: ()->
        counter++

    class TestDirective3
      constructor: ()->
        counter++

    class TestDirective4
      constructor: ()->
        counter++
        done() if (counter is DOM_ELEMENTS_COUNT)

    DirectiveProcessor().registerDirective(TestDirective)
    DirectiveProcessor().registerDirective(TestDirective2)
    DirectiveProcessor().registerDirective(TestDirective3)
    DirectiveProcessor().registerDirective(TestDirective4)
    DirectiveProcessor().setIntervalTimeInMs 10