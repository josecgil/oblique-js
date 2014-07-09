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

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10
    $("#fixture").html "<div data-directive='TestDirective'></div>"


  it "If I register a Directive it calls its constructor only one time when expression is in DOM", (done)->
    counter=0
    class TestDirective
      constructor: ()->
        counter++

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10
    $("#fixture").html "<div data-directive='TestDirective'></div>"

    setTimeout ->
      Oblique().destroy()
      expect(counter).toBe 1
      done()
    , 100



  it "If I register a Directive it calls its constructor with the correct DOM element", (done)->
    class TestDirective
      constructor: (DOMElement)->
        expect($(DOMElement).is("test[data-directive='TestDirective']")).toBeTruthy()
        Oblique().destroy()
        done()

    Oblique().registerDirective "TestDirective", TestDirective
    $("#fixture").html "<test data-directive='TestDirective'></test>"

  it "If I register an object that no is a Directive it throws an Error", ()->
    expect(->
      Oblique().registerDirective "test", {}
    ).toThrow(new ObliqueNS.Error("registerDirective must be called with a Directive 'Constructor/Class'"))

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

    interval.start()
    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10

  it "must execute 5 directives in a 10000 elements DOM in <400ms", (done)->

    #TODO: test with different expressions in each Directive
    DOM_ELEMENTS_COUNT = 4*250
    FixtureHelper.appendHTML "<p data-directive='TestDirective, TestDirective2, TestDirective3, TestDirective4, TestDirective5'>nice DOM</p>", DOM_ELEMENTS_COUNT/4
    FixtureHelper.appendHTML "<div data-directive='TestDirective, TestDirective2, TestDirective3, TestDirective4, TestDirective5'>nice DOM</div>", DOM_ELEMENTS_COUNT/4
    FixtureHelper.appendHTML "<span data-directive='TestDirective, TestDirective2, TestDirective3, TestDirective4, TestDirective5'>nice DOM</span>", DOM_ELEMENTS_COUNT/4
    FixtureHelper.appendHTML "<test data-directive='TestDirective, TestDirective2, TestDirective3, TestDirective4, TestDirective5'>nice DOM</test>", DOM_ELEMENTS_COUNT/4

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
          expect(interval.timeInMs).toBeLessThan 400
          done()

    interval.start()
    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().registerDirective "TestDirective2", TestDirective2
    Oblique().registerDirective "TestDirective3", TestDirective3
    Oblique().registerDirective "TestDirective4", TestDirective4
    Oblique().registerDirective "TestDirective5", TestDirective5
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

    Oblique().setModel modelToTest

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10

    FixtureHelper.appendHTML "<div data-directive='TestDirective'></div>"

  it "A directive must receive only the part of the model that data-model specifies", (done)->
    modelToTest =
      name : "Carlos",
      content : "content"

    class TestDirective
      constructor: (domElement, model)->
        expect(model).toBe "Carlos"
        Oblique().destroy()
        done()

    Oblique().setModel modelToTest

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10

    FixtureHelper.appendHTML "<div data-directive='TestDirective' data-model='Model.name'></div>"

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

    Oblique().setModel modelToTest

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10

    FixtureHelper.appendHTML "<div data-directive='TestDirective' data-model='Model.address.street'></div>"


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

    Oblique().setModel modelToTest

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10

    FixtureHelper.appendHTML "<div data-directive='TestDirective' data-model='Model.address.street'></div>"


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

    Oblique().setModel modelToTest

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10

    Oblique().onError( (error) ->
      expect(error.name).toBe "ObliqueNS.Error"
      done()
    )

    FixtureHelper.appendHTML "<div data-directive='TestDirective' data-model='Model.address.num'></div>"

  it "data-model must receive all model if value is 'Model'", (done)->
    modelToTest =
      name : "name",
      content : "content"

    class TestDirective
      constructor: (domElement, model)->
        expect(model).toBe modelToTest
        Oblique().destroy()
        done()

    Oblique().setModel modelToTest

    Oblique().registerDirective "TestDirective",TestDirective
    Oblique().setIntervalTimeInMs 10

    FixtureHelper.appendHTML "<div data-directive='TestDirective' data-model='Model'></div>"

  it "must throw an error if Handlebars isn't loaded", ()->
    #expect(->
    Oblique().renderHtml()
    #).toThrow(new ObliqueNS.Error("Oblique needs handlebarsjs loaded to render templates"))

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
    HandlebarsCopy=window.Handlebars
    window.Handlebars=undefined
    try
      expect(->
        Oblique().renderHtml()
      ).toThrow(new ObliqueNS.Error("Oblique().renderHtml() needs handlebarsjs loaded to work"))
    finally
      window.Handlebars=HandlebarsCopy


  it "must execute selected directive when data-directive is found", (done)->
    class TestDirective
      constructor: (obj)->
        obj.Model

        Oblique().destroy()
        done()

    Oblique().setIntervalTimeInMs 10
    Oblique().registerDirective "TestDirective", TestDirective
    $("#fixture").html "<div data-directive='TestDirective'></div>"


  it "must send to directive the correct data model", (done)->
    model=
      name: "Carlos"
      address:
        street: "Gran Via"
        number: 32
    Oblique().setModel model

    class TestDirective
      constructor: (domElement, directiveModel)->
        expect(directiveModel.name).toBe "Carlos"
        expect(directiveModel.address.street).toBe "Gran Via"
        expect(directiveModel.address.number).toBe 32
        Oblique().destroy()
        done()

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10
    $("#fixture").html "<div data-directive='TestDirective' data-model='Model'>nice DOM</div>"

  it "must send to directive the correct data model array", (done)->
    model=
      name: "Azul"
      sizes:[
        "XS"
        "S"
        "M"
        "L"
        "XL"
      ]
    Oblique().setModel model

    class TestDirective
      constructor: (domElement, directiveModel)->
        expect(directiveModel).toBe "S"
        Oblique().destroy()
        done()

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10
    $("#fixture").html "<div data-directive='TestDirective' data-model='Model.sizes[1]'>nice DOM</div>"

  it "must create an instance of the selected model-data class", (done)->
    class TestDirective
      constructor: (domElement, settings)->
        expect(settings instanceof Settings).toBeTruthy()
        expect(settings.brand).toBe "VC"
        expect(settings.country).toBe "ES"
        delete window.Settings
        Oblique().destroy()
        done()

    class Settings
      constructor:()->
        @brand="VC"
        @country="ES"

    window.Settings=Settings
    
    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10
    $("#fixture").html "<div data-directive='TestDirective' data-model='new Settings()'>nice DOM</div>"

  it "must throw an error if class in data-model doesn't exists", (done)->
    class TestDirective
      constructor: ()->

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10
    Oblique().onError( (error) ->
      expect(error.name).toBe "ObliqueNS.Error"
      expect(error.message).toBe "<div data-directive=\"TestDirective\" data-model=\"new InventedClass()\">nice DOM</div>: 'InventedClass' isn't an existing class in data-model"
      Oblique().destroy()
      done()
    )

    $("#fixture").html "<div data-directive='TestDirective' data-model='new InventedClass()'>nice DOM</div>"


  it "must pass simple param to directive", (done)->
    class TestDirective
      constructor: (domElement, model, params)->
        expect(params.name).toBe "Carlos"
        Oblique().destroy()
        done()

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10

    $("#fixture").html "<div data-directive='TestDirective' data-params='{\"name\":\"Carlos\"}'>nice DOM</div>"

  it "must pass complex param to directive", (done)->
    class TestDirective
      constructor: (domElement, model, params)->
        expect(params.name).toBe "Carlos"
        expect(params.address.street).toBe "Gran Via"
        expect(params.address.number).toBe 42
        Oblique().destroy()
        done()

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10

    $("#fixture").html "<div data-directive='TestDirective' data-params='{\"name\":\"Carlos\", \"address\":{\"street\":\"Gran Via\", \"number\":42}}'>nice DOM</div>"

  it "must throw an error if param is not valid JSON", (done)->
    class TestDirective
      constructor: ()->

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10
    Oblique().onError( (error) ->
      expect(error.name).toBe "ObliqueNS.Error"
      expect(error.message).toBe "<div data-directive=\"TestDirective\" data-params=\"patata\">nice DOM</div>: data-params parse error: Unexpected token p"
      Oblique().destroy()
      done()
    )

    $("#fixture").html "<div data-directive='TestDirective' data-params='patata'>nice DOM</div>"
