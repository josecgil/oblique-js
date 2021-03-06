describe "DOMProcessor", ->

  DOMProcessor=ObliqueNS.DOMProcessor
  ObError=ObliqueNS.Error

  beforeEach (done) ->
    DOMProcessor().destroy()
    DOMProcessor().setIntervalTimeInMs 10
    FixtureHelper.clear()
    done()

  afterEach ->
    DOMProcessor().destroy()

  it "On creation it has a default interval time", ->
    DOMProcessor().destroy()
    expect(DOMProcessor().getIntervalTimeInMs()).toBe DOMProcessor.DEFAULT_INTERVAL_MS

  it "Can change default interval time", ->
    newIntervaltimeMs = 10000
    oblique = DOMProcessor()
    oblique.setIntervalTimeInMs newIntervaltimeMs
    expect(oblique.getIntervalTimeInMs()).toBe newIntervaltimeMs

  it "Can't change default interval time to invalid value", ->
    expect(->
      DOMProcessor().setIntervalTimeInMs -1
    ).toThrow(new ObError("IntervalTime must be a positive number"))

  it "If I register a Directive it calls its constructor when data-ob-directive is in DOM", (done)->
    class TestDirective
      constructor: ()->
        DOMProcessor().destroy()
        done()

    DOMProcessor().registerDirective "TestDirective", TestDirective
    DOMProcessor().setIntervalTimeInMs 10
    $("#fixture").html "<div data-ob-directive='TestDirective'></div>"


  it "If I register a Directive it calls its constructor only one time when data-ob-directive is in DOM", (done)->
    counter=0
    class TestDirective
      constructor: ()->
        counter++

    DOMProcessor().registerDirective "TestDirective", TestDirective
    DOMProcessor().setIntervalTimeInMs 10

    FixtureHelper.appendHTML "<div data-ob-directive='TestDirective'></div>"

    setTimeout ->
      DOMProcessor().destroy()
      expect(counter).toBe 1
      done()
    , 100



  it "If I register a Directive it calls its constructor with the correct DOM element", (done)->
    class TestDirective
      constructor: (data)->
        expect($(data.domElement).is("test[data-ob-directive='TestDirective']")).toBeTruthy()
        DOMProcessor().destroy()
        done()

    DOMProcessor().registerDirective "TestDirective", TestDirective
    FixtureHelper.appendHTML "<test data-ob-directive='TestDirective'></test>"

  it "must call 2 _callbacks if there are in the same tag", (done)->
    calls={};
    class HideOnClickDirective
      constructor: ()->
        calls["TestDirective1"]=true;
        if (calls.TestDirective1 && calls.TestDirective2)
          DOMProcessor().destroy()
          done()

    class ShowOnClickDirective
      constructor: ()->
        calls["TestDirective2"]=true;
        if (calls.TestDirective1 && calls.TestDirective2)
          DOMProcessor().destroy()
          done()


    DOMProcessor().registerDirective "ShowOnClickDirective", ShowOnClickDirective
    DOMProcessor().registerDirective "HideOnClickDirective", HideOnClickDirective
    FixtureHelper.appendHTML "<test data-ob-directive='ShowOnClickDirective, HideOnClickDirective'></test>"

  it "must call 2 _callbacks if there are in the same tag (2 instances of same tag)", (done)->
    calls={};
    calls.TestDirective1=0
    calls.TestDirective2=0
    class HideOnClickDirective
      constructor: ()->
        calls["TestDirective1"]++;
        if (calls.TestDirective1 is 2) and (calls.TestDirective2 is 2)
          DOMProcessor().destroy()
          done()

    class ShowOnClickDirective
      constructor: ()->
        calls["TestDirective2"]++;
        if (calls.TestDirective1 is 2) and (calls.TestDirective2 is 2)
          DOMProcessor().destroy()
          done()


    DOMProcessor().registerDirective "ShowOnClickDirective", ShowOnClickDirective
    DOMProcessor().registerDirective "HideOnClickDirective", HideOnClickDirective
    FixtureHelper.appendHTML "<test data-ob-directive='ShowOnClickDirective, HideOnClickDirective'></test>"
    FixtureHelper.appendHTML "<test data-ob-directive='ShowOnClickDirective, HideOnClickDirective'></test>"

  it "If I register an object that no is a Directive it throws an Error", ()->
    expect(->
      DOMProcessor().registerDirective "test", {}
    ).toThrow(new ObError("Directive must be called with a 'Constructor Function/Class' param"))

  it "must execute 1 directive in a 10000 elements DOM in <600ms", (done)->

    DOM_ELEMENTS_COUNT = 4*250
    FixtureHelper.appendHTML "<p data-ob-directive='TestDirective'>nice DOM</p>", DOM_ELEMENTS_COUNT/4
    FixtureHelper.appendHTML "<div data-ob-directive='TestDirective'>nice DOM</div>", DOM_ELEMENTS_COUNT/4
    FixtureHelper.appendHTML "<span data-ob-directive='TestDirective'>nice DOM</span>", DOM_ELEMENTS_COUNT/4
    FixtureHelper.appendHTML "<test data-ob-directive='TestDirective'>nice DOM</test>", DOM_ELEMENTS_COUNT/4


    interval=new Interval()
    counter=0
    class TestDirective
      constructor: ()->
        counter++
        if (counter is (DOM_ELEMENTS_COUNT))
          interval.stop()
          expect(interval.timeInMs).toBeLessThan 600
          done()

    interval.start()
    DOMProcessor().registerDirective "TestDirective", TestDirective
    DOMProcessor().setIntervalTimeInMs 10

  it "must execute 5 _callbacks in a 10000 elements DOM in <1100ms", (done)->

    #TODO: test with different expressions in each Directive
    DOM_ELEMENTS_COUNT = 4*250
    FixtureHelper.appendHTML "<p data-ob-directive='TestDirective,TestDirective2, TestDirective3, TestDirective4, TestDirective5'>nice DOM</p>", DOM_ELEMENTS_COUNT/4
    FixtureHelper.appendHTML "<div data-ob-directive='TestDirective,TestDirective2, TestDirective3, TestDirective4, TestDirective5'>nice DOM</div>", DOM_ELEMENTS_COUNT/4
    FixtureHelper.appendHTML "<span data-ob-directive='TestDirective,TestDirective2, TestDirective3, TestDirective4, TestDirective5'>nice DOM</span>", DOM_ELEMENTS_COUNT/4
    FixtureHelper.appendHTML "<test data-ob-directive='TestDirective,TestDirective2, TestDirective3, TestDirective4, TestDirective5'>nice DOM</test>", DOM_ELEMENTS_COUNT/4

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
          console.log "Processed 5 _callbacks in a 10000 elements DOM in #{interval.timeInMs}ms"
          expect(interval.timeInMs).toBeLessThan 1100
          done()

    interval.start()
    DOMProcessor().registerDirective "TestDirective", TestDirective
    DOMProcessor().registerDirective "TestDirective2", TestDirective2
    DOMProcessor().registerDirective "TestDirective3", TestDirective3
    DOMProcessor().registerDirective "TestDirective4", TestDirective4
    DOMProcessor().registerDirective "TestDirective5", TestDirective5
    DOMProcessor().setIntervalTimeInMs 10

  it "must execute 4 _callbacks with different CSSExpressions", (done)->

    DOM_ELEMENTS_COUNT = 4*250
    FixtureHelper.appendHTML "<p data-ob-directive='TestDirective'>nice DOM</p>", DOM_ELEMENTS_COUNT/4
    FixtureHelper.appendHTML "<div data-ob-directive='TestDirective2'>nice DOM</div>", DOM_ELEMENTS_COUNT/4
    FixtureHelper.appendHTML "<span data-ob-directive='TestDirective3'>nice DOM</span>", DOM_ELEMENTS_COUNT/4
    FixtureHelper.appendHTML "<test data-ob-directive='TestDirective4'>nice DOM</test>", DOM_ELEMENTS_COUNT/4

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

    DOMProcessor().registerDirective "TestDirective", TestDirective
    DOMProcessor().registerDirective "TestDirective2", TestDirective2
    DOMProcessor().registerDirective "TestDirective3", TestDirective3
    DOMProcessor().registerDirective "TestDirective4", TestDirective4
    DOMProcessor().setIntervalTimeInMs 10




