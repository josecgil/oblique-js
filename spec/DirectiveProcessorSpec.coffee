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

  it "If I register a Directive it calls its constructor when expression is in DOM", (done)->
    class TestDirective
      constructor: ()->
        DirectiveProcessor().destroy()
        done()

      @CSS_EXPRESSION = "*[data-test]"

    DirectiveProcessor().registerDirective TestDirective
    DirectiveProcessor().setIntervalTimeInMs 10
    $("#fixture").html "<div data-test></div>"


  it "If I register a Directive it calls its constructor only one time when expression is in DOM", (done)->
    counter=0
    class TestDirective
      constructor: ()->
        counter++

      @CSS_EXPRESSION = "*[data-test]"

    DirectiveProcessor().registerDirective TestDirective
    DirectiveProcessor().setIntervalTimeInMs 10

    FixtureHelper.appendHTML "<div data-test></div>"

    setTimeout ->
      DirectiveProcessor().destroy()
      expect(counter).toBe 1
      done()
    , 100



  it "If I register a Directive it calls its constructor with the correct DOM element", (done)->
    class TestDirective
      constructor: (DOMElement)->
        expect($(DOMElement).is("test[data-test]")).toBeTruthy()
        DirectiveProcessor().destroy()
        done()

      @CSS_EXPRESSION = "*[data-test]"

    DirectiveProcessor().registerDirective TestDirective
    FixtureHelper.appendHTML "<test data-test></test>"

  it "must call 2 directives if there are in the same tag", (done)->
    calls={};
    class HideOnClickDirective
      constructor: ()->
        calls["TestDirective1"]=true;
        if (calls.TestDirective1 && calls.TestDirective2)
          DirectiveProcessor().destroy()
          done()

      @CSS_EXPRESSION = "*[data-show-onclick]"

    class ShowOnClickDirective
      constructor: ()->
        calls["TestDirective2"]=true;
        if (calls.TestDirective1 && calls.TestDirective2)
          DirectiveProcessor().destroy()
          done()

      @CSS_EXPRESSION = "*[data-hide-onclick]"


    DirectiveProcessor().registerDirective ShowOnClickDirective
    DirectiveProcessor().registerDirective HideOnClickDirective
    FixtureHelper.appendHTML "<test data-hide-onclick data-show-onclick></test>"

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

      @CSS_EXPRESSION = "*[data-hide-onclick]"

    class ShowOnClickDirective
      constructor: ()->
        calls["TestDirective2"]++;
        if (calls.TestDirective1 is 2) and (calls.TestDirective2 is 2)
          DirectiveProcessor().destroy()
          done()

      @CSS_EXPRESSION = "*[data-show-onclick]"


    DirectiveProcessor().registerDirective ShowOnClickDirective
    DirectiveProcessor().registerDirective HideOnClickDirective
    FixtureHelper.appendHTML "<test id='test' data-hide-onclick data-show-onclick></test>"
    FixtureHelper.appendHTML "<test id='test' data-hide-onclick data-show-onclick></test>"

  it "CMS Bug", (done)->
    calls={};
    calls.HideOnClickDirective=0
    calls.ShowOnClickDirective=0

    class HideOnClickDirective
      constructor: ()->
        calls["HideOnClickDirective"]++;
        if (calls.HideOnClickDirective is 4) and (calls.ShowOnClickDirective is 4)
          DirectiveProcessor().destroy()
          done()

      @CSS_EXPRESSION = "*[data-hide-onclick]"

    class ShowOnClickDirective
      constructor: ()->
        calls["ShowOnClickDirective"]++;
        if (calls.HideOnClickDirective is 4) and (calls.ShowOnClickDirective is 4)
          DirectiveProcessor().destroy()
          done()

      @CSS_EXPRESSION = "*[data-show-onclick]"

    html=
      """
        <p>
          <span class="form-inline">
            <label>
              <input type="radio" value="Castellano" name="IdLanguage" id="IdLanguage" data-show-onclick="*[data-castellano]" data-hide-onclick="*[data-english]" checked="checked"> Castellano
            </label>
            <label>
              <input type="radio" value="Ingles" name="IdLanguage" id="IdLanguage" data-show-onclick="*[data-english]" data-hide-onclick="*[data-castellano]"> Inglés
            </label>
          </span>
        </p>

        <p>
          <span class="form-inline">
            <label>
              <input type="radio" value="Castellano" name="IdLanguage" id="IdLanguage" data-show-onclick="*[data-castellano]" data-hide-onclick="*[data-english]" checked="checked"> Castellano
            </label>
            <label>
              <input type="radio" value="Ingles" name="IdLanguage" id="IdLanguage" data-show-onclick="*[data-english]" data-hide-onclick="*[data-castellano]"> Inglés
            </label>
          </span>
        </p>

      """
    DirectiveProcessor().registerDirective ShowOnClickDirective
    DirectiveProcessor().registerDirective HideOnClickDirective
    FixtureHelper.appendHTML html

  it "If I register a Directive without CSS_EXPRESSION it throws an Error", ()->
    class TestDirective
    expect(->
      DirectiveProcessor().registerDirective TestDirective
    ).toThrow(new ObError("directive must has an static CSS_EXPRESSION property"))

  it "If I register an object that no is a Directive it throws an Error", ()->
    expect(->
      DirectiveProcessor().registerDirective {}
    ).toThrow(new ObError("registerDirective must be called with a Directive 'Constructor/Class'"))

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
    DirectiveProcessor().registerDirective(TestDirective)
    DirectiveProcessor().setIntervalTimeInMs 10

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
          expect(interval.timeInMs).toBeLessThan 400
          done()

      @CSS_EXPRESSION = ".test"

    interval.start()
    DirectiveProcessor().registerDirective(TestDirective)
    DirectiveProcessor().registerDirective(TestDirective2)
    DirectiveProcessor().registerDirective(TestDirective3)
    DirectiveProcessor().registerDirective(TestDirective4)
    DirectiveProcessor().registerDirective(TestDirective5)
    DirectiveProcessor().setIntervalTimeInMs 10

  it "must execute 4 directives with different CSSExpressions", (done)->

    DOM_ELEMENTS_COUNT = 4*250
    FixtureHelper.appendHTML "<p class='test1'>nice DOM</p>", DOM_ELEMENTS_COUNT/4
    FixtureHelper.appendHTML "<div class='test2'>nice DOM</div>", DOM_ELEMENTS_COUNT/4
    FixtureHelper.appendHTML "<span class='test3'>nice DOM</span>", DOM_ELEMENTS_COUNT/4
    FixtureHelper.appendHTML "<test class='test4'>nice DOM</test>", DOM_ELEMENTS_COUNT/4

    counter=0
    class TestDirective
      constructor: ()->
        counter++
      @CSS_EXPRESSION = ".test1"

    class TestDirective2
      constructor: ()->
        counter++
      @CSS_EXPRESSION = ".test2"

    class TestDirective3
      constructor: ()->
        counter++
      @CSS_EXPRESSION = ".test3"

    class TestDirective4
      constructor: ()->
        counter++
        done() if (counter is DOM_ELEMENTS_COUNT)
      @CSS_EXPRESSION = ".test4"

    DirectiveProcessor().registerDirective(TestDirective)
    DirectiveProcessor().registerDirective(TestDirective2)
    DirectiveProcessor().registerDirective(TestDirective3)
    DirectiveProcessor().registerDirective(TestDirective4)
    DirectiveProcessor().setIntervalTimeInMs 10
