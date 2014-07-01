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
    ).toThrow(new ObliqueNS.Error("IntervalTime must be a positive number"))

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
    ).toThrow(new ObliqueNS.Error("directive must has an static CSS_EXPRESSION property"))

  it "If I register an object that no is a Directive it throws an Error", ()->
    expect(->
      Oblique().registerDirective {}
    ).toThrow(new ObliqueNS.Error("registerDirective must be called with a Directive 'Constructor/Class'"))

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


  it "must store and retrieve model", ()->
    Oblique().setModel "test"

    expect(Oblique().getModel()).toBe "test"

  it "must inform if it has a model", ()->
    Oblique().setModel "test"
    expect(Oblique().hasModel()).toBeTruthy()

  it "must inform if it has a model", ()->
    expect(Oblique().hasModel()).toBeFalsy()


  it "If I register a Directive and a model, directive doesn't receives model as second param", (done)->
    modelToTest =
      name : "name",
      content : "content"

    class TestDirective
      constructor: (domElement, model)->
        expect(model).toBeUndefined()
        Oblique().destroy()
        done()

      @CSS_EXPRESSION = "*[data-test]"

    Oblique().setModel modelToTest

    Oblique().registerDirective TestDirective
    Oblique().setIntervalTimeInMs 10

    FixtureHelper.appendHTML "<div data-test ></div>"

  it "A directive must receive only the part of the model that data-model specifies", (done)->
    modelToTest =
      name : "Carlos",
      content : "content"

    class TestDirective
      constructor: (domElement, model)->
        expect(model).toBe "Carlos"
        Oblique().destroy()
        done()

      @CSS_EXPRESSION = "*[data-test]"

    Oblique().setModel modelToTest

    Oblique().registerDirective TestDirective
    Oblique().setIntervalTimeInMs 10

    FixtureHelper.appendHTML "<div data-test data-model='name'></div>"

  it "data-model must work with complex models, simple resuls", (done)->
    modelToTest =
      name : "Carlos"
      content : "content"
      address:
        street: "Gran Via"
        number: 42

    class TestDirective
      constructor: (domElement, model)->
        expect(model).toBe "Gran Via"
        Oblique().destroy()
        done()

      @CSS_EXPRESSION = "*[data-test]"

    Oblique().setModel modelToTest

    Oblique().registerDirective TestDirective
    Oblique().setIntervalTimeInMs 10

    FixtureHelper.appendHTML "<div data-test data-model='address.street'></div>"


  it "data-model must work with complex models, complex results", (done)->
    modelToTest =
      name : "Carlos"
      content : "content"
      address:
        street:
          name: "Gran Via"
          number: 42

    class TestDirective
      constructor: (domElement, model)->
        expect(model.name).toBe "Gran Via"
        expect(model.number).toBe 42
        Oblique().destroy()
        done()

      @CSS_EXPRESSION = "*[data-test]"

    Oblique().setModel modelToTest

    Oblique().registerDirective TestDirective
    Oblique().setIntervalTimeInMs 10

    FixtureHelper.appendHTML "<div data-test data-model='address.street'></div>"


  it "data-model must throw an exception if property doesn't exists", (done)->
    modelToTest =
      name : "Carlos"
      content : "content"
      address:
        street:
          name: "Gran Via"
          number: 42

    class TestDirective
      constructor: ->

      @CSS_EXPRESSION = "*[data-test]"

    Oblique().setModel modelToTest

    Oblique().registerDirective TestDirective
    Oblique().setIntervalTimeInMs 10

    Oblique().onError( (error) ->
      expect(error.name).toBe "ObliqueNS.Error"
      done()
    )

    FixtureHelper.appendHTML "<div data-test data-model='address.num'></div>"

  it "data-model must receive all model if value is 'this'", (done)->
    modelToTest =
      name : "name",
      content : "content"

    class TestDirective
      constructor: (domElement, model)->
        expect(model).toBe modelToTest
        Oblique().destroy()
        done()

      @CSS_EXPRESSION = "*[data-test]"

    Oblique().setModel modelToTest

    Oblique().registerDirective TestDirective
    Oblique().setIntervalTimeInMs 10

    FixtureHelper.appendHTML "<div data-test data-model='this'></div>"

  it "must render template", ()->
    modelToTest =
      title : "titulo",
      body : "cuerpo"

    expectedHtml="<h1>titulo</h1><div>cuerpo</div>"

    currentHtml=Oblique().renderHtml "/oblique-js/spec/templates/test_ok.hbs", modelToTest
    expect(currentHtml).toBe expectedHtml

  it "must throw an error if template is not found", ->
    modelToTest =
      title : "titulo",
      body : "cuerpo"

    expect(->
      Oblique().renderHtml "/patata.hbs", modelToTest
    ).toThrow(new ObliqueNS.Error("template '/patata.hbs' not found"))

  it "must throw an error if handlebars is not loaded", ->
    handlebarsCopy=window.Handlebars
    window.Handlebars=undefined
    try
      expect(->
        Oblique().renderHtml()
      ).toThrow(new ObliqueNS.Error("Oblique().renderHtml() needs handlebarsjs loaded to work"))
    finally
      window.Handlebars=handlebarsCopy
