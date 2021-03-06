describe "Oblique", ->

  beforeEach (done) ->
    Oblique().destroy()
    Oblique().setIntervalTimeInMs 10
    FixtureHelper.clear()
    window.location.hash=""
    done()

  afterEach ->
    Oblique().destroy()
    window.location.hash=""

  it "On creation it has a default interval time", ->
    Oblique().destroy()
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
    $("#fixture").html "<div data-ob-directive='TestDirective'></div>"

  it "must register a directive only with ob-directive", (done)->
    class TestDirective
      constructor: ()->
        Oblique().destroy()
        done()

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10
    $("#fixture").html "<div ob-directive='TestDirective'></div>"

  it "If I register a Directive it calls its constructor only one time when expression is in DOM", (done)->
    counter=0
    class TestDirective
      constructor: ()->
        counter++

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10
    $("#fixture").html "<div data-ob-directive='TestDirective'></div>"

    setTimeout ->
      Oblique().destroy()
      expect(counter).toBe 1
      done()
    , 100


  it "If I register a Directive it calls its constructor with the correct DOM element", (done)->
    class TestDirective
      constructor: (data)->
        expect($(data.domElement).is("test[data-ob-directive='TestDirective']")).toBeTruthy()
        Oblique().destroy()
        done()

    Oblique().registerDirective "TestDirective", TestDirective
    $("#fixture").html "<test data-ob-directive='TestDirective'></test>"

  it "If I register an object that no is a Directive it throws an Error", ()->
    expect(->
      Oblique().registerDirective "test", {}
    ).toThrow(new ObliqueNS.Error("Directive must be called with a 'Constructor Function/Class' param"))

  it "must execute 1 directive in a 10000 elements DOM in <700ms", (done)->

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
          expect(interval.timeInMs).toBeLessThan 700
          done()

    interval.start()
    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10

  it "must execute 5 _callbacks in a 10000 elements DOM in <1800ms", (done)->

    DOM_ELEMENTS_COUNT = 4*250
    FixtureHelper.appendHTML "<p data-ob-directive='TestDirective, TestDirective2, TestDirective3, TestDirective4, TestDirective5'>nice DOM</p>", DOM_ELEMENTS_COUNT/4
    FixtureHelper.appendHTML "<div data-ob-directive='TestDirective, TestDirective2, TestDirective3, TestDirective4, TestDirective5'>nice DOM</div>", DOM_ELEMENTS_COUNT/4
    FixtureHelper.appendHTML "<span data-ob-directive='TestDirective, TestDirective2, TestDirective3, TestDirective4, TestDirective5'>nice DOM</span>", DOM_ELEMENTS_COUNT/4
    FixtureHelper.appendHTML "<test data-ob-directive='TestDirective, TestDirective2, TestDirective3, TestDirective4, TestDirective5'>nice DOM</test>", DOM_ELEMENTS_COUNT/4

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
          expect(interval.timeInMs).toBeLessThan 1800
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
      constructor: (data)->
        expect(data.model).toBeUndefined()
        Oblique().destroy()
        done()

    Oblique().setModel modelToTest

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10

    FixtureHelper.appendHTML "<div data-ob-directive='TestDirective'></div>"

  it "A directive must receive only the part of the model that data-ob-model specifies", (done)->
    modelToTest =
      name : "Carlos",
      content : "content"

    class TestDirective
      constructor: (data)->
        expect(data.model).toBe "Carlos"
        Oblique().destroy()
        done()

    Oblique().setModel modelToTest

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10

    FixtureHelper.appendHTML "<div data-ob-directive='TestDirective' data-ob-model='Model.name'></div>"

  it "must receive the model using ob-model instead of data-ob-model", (done)->
    modelToTest =
      name : "Carlos",
      content : "content"

    class TestDirective
      constructor: (data)->
        expect(data.model).toBe "Carlos"
        Oblique().destroy()
        done()

    Oblique().setModel modelToTest

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10

    FixtureHelper.appendHTML "<div data-ob-directive='TestDirective' ob-model='Model.name'></div>"


  it "A directive must receive part of the model that data-ob-model specifies if is a boolean", (done)->
    modelToTest =
      name : "Carlos",
      isLogged : true

    class TestDirective
      constructor: (data)->
        expect(data.model).toBeTruthy()
        Oblique().destroy()
        done()

    Oblique().setModel modelToTest

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10

    FixtureHelper.appendHTML "<div data-ob-directive='TestDirective' data-ob-model='Model.isLogged'></div>"

  it "A directive must receive part of the model that data-ob-model specifies if is an int", (done)->
    modelToTest =
      name : "Carlos",
      number : 1

    class TestDirective
      constructor: (data)->
        expect(data.model).toBe 1
        Oblique().destroy()
        done()

    Oblique().setModel modelToTest

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10

    FixtureHelper.appendHTML "<div data-ob-directive='TestDirective' data-ob-model='Model.number'></div>"


  it "data-ob-model must work with complex models, simple resuls", (done)->
    modelToTest =
      name : "Carlos"
      content : "content"
      address:
        street: "Gran Via"
        number: 42

    class TestDirective
      constructor: (data)->
        expect(data.model).toBe "Gran Via"
        Oblique().destroy()
        done()

    Oblique().setModel modelToTest

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10

    FixtureHelper.appendHTML "<div data-ob-directive='TestDirective' data-ob-model='Model.address.street'></div>"


  it "data-ob-model must work with complex models, complex results", (done)->
    modelToTest =
      name : "Carlos"
      content : "content"
      address:
        street:
          name: "Gran Via"
          number: 42

    class TestDirective
      constructor: (data)->
        expect(data.model.name).toBe "Gran Via"
        expect(data.model.number).toBe 42
        Oblique().destroy()
        done()

    Oblique().setModel modelToTest

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10

    FixtureHelper.appendHTML "<div data-ob-directive='TestDirective' data-ob-model='Model.address.street'></div>"


  it "data-ob-model must throw an exception if property doesn't exists", (done)->
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
      #expect(error.message).toBe '<div data-ob-directive="TestDirective" data-ob-model="Model.address.num"></div>: data-ob-model expression error: ObliqueError is not defined'
      done()
    )

    FixtureHelper.appendHTML "<div data-ob-directive='TestDirective' data-ob-model='Model.address.num'></div>"

  it "data-ob-model must receive all model if value is 'Model'", (done)->
    modelToTest =
      name : "name",
      content : "content"

    class TestDirective
      constructor: (data)->
        expect(data.model).toBe modelToTest
        Oblique().destroy()
        done()

    Oblique().setModel modelToTest

    Oblique().registerDirective "TestDirective",TestDirective
    Oblique().setIntervalTimeInMs 10

    FixtureHelper.appendHTML "<div data-ob-directive='TestDirective' data-ob-model='Model'></div>"

  it "must render template", ()->
    modelToTest =
      title : "titulo",
      body : "cuerpo"

    expectedHtml="<h1>titulo</h1><div>cuerpo</div>"

    currentHtml=Oblique().renderHTML "/oblique-js/spec/Templates/test_ok.hbs", modelToTest
    expect(currentHtml).toBe expectedHtml

  it "must throw an error if template is not found", ->
    modelToTest =
      title : "titulo",
      body : "cuerpo"

    expect(->
      Oblique().renderHTML "/patata.hbs", modelToTest
    ).toThrow(new ObliqueNS.Error("template '/patata.hbs' not found"))

  it "must throw an error if handlebars is not loaded", ->
    HandlebarsCopy=window.Handlebars
    window.Handlebars=undefined
    try
      expect(->
        Oblique().renderHTML()
      ).toThrow(new ObliqueNS.Error("Oblique().renderHtml(): needs handlebarsjs loaded to render templates"))
    finally
      window.Handlebars=HandlebarsCopy

  it "must execute selected directive when data-ob-directive is found", (done)->
    class TestDirective
      constructor: ()->
        Oblique().destroy()
        done()

    Oblique().setIntervalTimeInMs 10
    Oblique().registerDirective "TestDirective", TestDirective
    $("#fixture").html "<div data-ob-directive='TestDirective'></div>"


  it "must send to directive the correct data model", (done)->
    model=
      name: "Carlos"
      address:
        street: "Gran Via"
        number: 32
    Oblique().setModel model

    class TestDirective
      constructor: (data)->
        expect(data.model.name).toBe "Carlos"
        expect(data.model.address.street).toBe "Gran Via"
        expect(data.model.address.number).toBe 32
        Oblique().destroy()
        done()

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10
    $("#fixture").html "<div data-ob-directive='TestDirective' data-ob-model='Model'>nice DOM</div>"

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
      constructor: (data)->
        expect(data.model).toBe "S"
        Oblique().destroy()
        done()

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10
    $("#fixture").html "<div data-ob-directive='TestDirective' data-ob-model='Model.sizes[1]'>nice DOM</div>"

  it "must create an instance of the selected model-data class", (done)->
    class TestDirective
      constructor: (data)->
        settings=data.model
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
    $("#fixture").html "<div data-ob-directive='TestDirective' data-ob-model='new Settings()'>nice DOM</div>"

  it "must throw an error if class in data-ob-model doesn't exists", (done)->
    class TestDirective
      constructor: ()->

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10
    Oblique().onError( (error) ->
      expect(error.name).toBe "ObliqueNS.Error"
      #expect(error.message).toBe '<div data-ob-directive="TestDirective" data-ob-model="new InventedClass()">nice DOM</div>: data-ob-model expression error: InventedClass is not defined'
      Oblique().destroy()
      done()
    )

    $("#fixture").html "<div data-ob-directive='TestDirective' data-ob-model='new InventedClass()'>nice DOM</div>"


  it "must pass simple param to directive", (done)->
    class TestDirective
      constructor: (data)->
        expect(data.params.name).toBe "Carlos"
        Oblique().destroy()
        done()

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10

    $("#fixture").html "<div data-ob-directive='TestDirective' data-ob-params='{\"name\":\"Carlos\"}'>nice DOM</div>"

  it "must pass simple param to directive using ob-params instead of data-ob-params", (done)->
    class TestDirective
      constructor: (data)->
        expect(data.params.name).toBe "Carlos"
        Oblique().destroy()
        done()

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10

    $("#fixture").html "<div data-ob-directive='TestDirective' ob-params='{\"name\":\"Carlos\"}'>nice DOM</div>"


  it "must pass complex param to directive", (done)->
    class TestDirective
      constructor: (data)->
        expect(data.params.name).toBe "Carlos"
        expect(data.params.address.street).toBe "Gran Via"
        expect(data.params.address.number).toBe 42
        Oblique().destroy()
        done()

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10

    $("#fixture").html "<div data-ob-directive='TestDirective' data-ob-params='{\"name\":\"Carlos\", \"address\":{\"street\":\"Gran Via\", \"number\":42}}'>nice DOM</div>"

  it "must throw an error if param is not valid JSON", (done)->
    class TestDirective
      constructor: ()->

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10
    Oblique().onError( (error) ->
      expect(error.name).toBe "ObliqueNS.Error"
      expect(error.message.indexOf("data-ob-params parse error")!=-1).toBeTruthy()
      Oblique().destroy()
      done()
    )

    $("#fixture").html "<div data-ob-directive='TestDirective' data-ob-params='patata'>nice DOM</div>"

  it "must catch data-ob-directive, data-ob-model & data-ob-params in a single data param", (done)->
    Oblique().setModel "my model"

    class TestDirective
      constructor: (directiveData)->
        expect(directiveData.domElement.outerHTML).toBe "<div data-ob-directive=\"TestDirective\" data-ob-model=\"Model\" data-ob-params=\"{&quot;simpleparam&quot;:&quot;simple param&quot;}\">nice DOM</div>"
        expect(directiveData.jQueryElement.get(0).outerHTML).toBe directiveData.domElement.outerHTML
        expect(directiveData.model).toBe "my model"
        expect(directiveData.params.simpleparam).toBe "simple param"
        Oblique().destroy()
        done()

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10

    $("#fixture").html "<div data-ob-directive='TestDirective' data-ob-model='Model' data-ob-params='{\"simpleparam\":\"simple param\"}'>nice DOM</div>"


  it "must set to undefined model if data-ob-model is not present", (done)->
    Oblique().setModel "my model"

    class TestDirective
      constructor: (directiveData)->
        expect(directiveData.model).toBeUndefined()
        Oblique().destroy()
        done()

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10

    $("#fixture").html "<div data-ob-directive='TestDirective' data-ob-params='{\"simpleparam\":\"simple param\"}'>nice DOM</div>"

  it "must set to undefined params if data-ob-params is not present", (done)->
    Oblique().setModel "my model"

    class TestDirective
      constructor: (directiveData)->
        expect(directiveData.params).toBeUndefined()
        Oblique().destroy()
        done()

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10

    $("#fixture").html "<div data-ob-directive='TestDirective' data-ob-model='Model'>nice DOM</div>"


  it "must eval JS expression in data-ob-model and send it to directive", (done)->
    model=
      name : "Carlos"
      surname: "Gil"

    Oblique().setModel model

    class TestDirective
      constructor: (data)->
        user=data.model
        expect(user instanceof User).toBeTruthy()
        expect(user.name).toBe "Carlos"
        delete window.User
        Oblique().destroy()
        done()

    class User
      constructor:(@name)->

    window.User=User

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10
    $("#fixture").html "<div data-ob-directive='TestDirective' data-ob-model='var carlos=new User(Model.name)'>nice DOM</div>"

  it "must eval JS expression in data-ob-model and send it to directive when variable is global", (done)->
    model=
      name : "Carlos"
      surname: "Gil"

    Oblique().setModel model

    class TestDirective
      constructor: (data)->
        user=data.model
        expect(user instanceof User).toBeTruthy()
        expect(user.name).toBe "Carlos"
        delete window.User
        Oblique().destroy()
        done()

    class User
      constructor:(@name)->

    window.User=User

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10
    $("#fixture").html "<div data-ob-directive='TestDirective' data-ob-model='carlos=new User(Model.name)'>nice DOM</div>"

  it "must eval JS expression in data-ob-model and send it to directive when variable name contains 'var' keyword", (done)->
    model=
      name : "Carlos"
      surname: "Gil"

    Oblique().setModel model

    class TestDirective
      constructor: (data)->
        user=data.model
        expect(user instanceof User).toBeTruthy()
        expect(user.name).toBe "Carlos"
        delete window.User
        delete window.variable
        Oblique().destroy()
        done()

    class User
      constructor:(@name)->

    window.User=User

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10
    $("#fixture").html "<div data-ob-directive='TestDirective' data-ob-model='variable=new User(Model.name)'>nice DOM</div>"

  it "must store & retrieve a simple variable in data-ob-model attribute", (done)->
    count=0
    class TestDirective
      constructor: (data)->
        expect(data.model).toBe 32
        count++

    class TestDirective2
      constructor: (data)->
        count++
        expect(count).toBe 2
        expect(data.model).toBe 32
        Oblique().destroy()
        done()

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().registerDirective "TestDirective2", TestDirective2
    Oblique().setIntervalTimeInMs 10
    FixtureHelper.clear()
    FixtureHelper.appendHTML "<div data-ob-directive='TestDirective' data-ob-model='var variable=32'>nice DOM</div>"
    FixtureHelper.appendHTML "<div data-ob-directive='TestDirective2' data-ob-model='variable'>nice DOM</div>"

  it "must store & retrieve a complex variable in data-ob-model attribute", (done)->
    count=0
    class TestDirective
      constructor: (data)->
        colors=data.model
        expect(colors.values[0]).toBe "Red"
        expect(colors.values[1]).toBe "Green"
        colors.values.push "Blue"
        count++

    class TestDirective2
      constructor: (data)->
        count++
        expect(count).toBe 2
        colors=data.model
        expect(colors.values[0]).toBe "Red"
        expect(colors.values[1]).toBe "Green"
        expect(colors.values[2]).toBe "Blue"
        Oblique().destroy()
        done()

    class Colors
      constructor:(@values)->

    window.Colors=Colors

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().registerDirective "TestDirective2", TestDirective2
    Oblique().setIntervalTimeInMs 10
    FixtureHelper.clear()
    FixtureHelper.appendHTML "<div data-ob-directive='TestDirective' data-ob-model='var colors=new Colors([\"Red\",\"Green\"])'>nice DOM</div>"
    FixtureHelper.appendHTML "<div data-ob-directive='TestDirective2' data-ob-model='colors'>nice DOM</div>"

  it "must work when variable name in data-ob-model matchs local variable name", (done)->
    class TestDirective
      constructor: (data)->
        expect(data.model).toBe 32
        Oblique().destroy()
        done()

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10
    FixtureHelper.clear()
    FixtureHelper.appendHTML "<div data-ob-directive='TestDirective' data-ob-model='var dataModelExpr=32'>nice DOM</div>"


  it "must throw an error if a variable named Model is set in data-ob-model", (done)->
    class TestDirective
      constructor: ->

    Oblique().onError( (error) ->
      expect(error.message).toBe "<div data-ob-directive=\"TestDirective\" data-ob-model=\"var Model=32\">nice DOM</div>: data-ob-model expression error: Can't create a variable named 'Model', is a reserved word"
      Oblique().destroy()
      done()
    )

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10
    FixtureHelper.clear()
    FixtureHelper.appendHTML "<div data-ob-directive='TestDirective' data-ob-model='var Model=32'>nice DOM</div>"


  it "must retrieve simple params from window.location.hash", ()->
    window.location.hash="#sort=desc"
    paramsCollection=Oblique().getHashParams()
    expect(paramsCollection.count()).toBe(1)
    expect(paramsCollection.getParam("sort").value).toBe("desc")

  it "must retrieve complex params from window.location.hash", ()->
    window.location.hash="#sort=desc&price=(10,30)&colors=[rojo,amarillo,verde]"
    paramsCollection=Oblique().getHashParams()
    expect(paramsCollection.count()).toBe(3)
    expect(paramsCollection.getParam("sort").value).toBe("desc")
    expect(paramsCollection.getParam("price").min).toBe("10")
    expect(paramsCollection.getParam("price").max).toBe("30")
    colorValues = paramsCollection.getParam("colors").values
    expect(colorValues[0]).toBe("rojo")
    expect(colorValues[1]).toBe("amarillo")
    expect(colorValues[2]).toBe("verde")

  it "must set window.location.hash from a simple paramCollection", ()->
    window.location.hash=""
    paramsCollection=Oblique().getHashParams()
    paramsCollection.addSingleParam("sort","asc")
    Oblique().setHashParams(paramsCollection)
    expect(window.location.hash).toBe("#sort=asc")

  it "must set window.location.hash from a complex paramCollection", ()->
    window.location.hash=""
    paramsCollection=Oblique().getHashParams()
    paramsCollection.addSingleParam("sort","asc")
    paramsCollection.addRangeParam("price","10","40")
    paramsCollection.addArrayParam("sizes",["101","104","105"])
    Oblique().setHashParams(paramsCollection)
    expect(window.location.hash).toBe("#sort=asc&price=(10,40)&sizes=[101,104,105]")

  it "must set window.location.hash from a manipulated paramCollection", ()->
    window.location.hash=""
    paramsCollection=Oblique().getHashParams()
    sizesParam=paramsCollection.addArrayParam("sizes",["101","104","105"])
    sizesParam.remove("101")
    sizesParam.add("XL")
    Oblique().setHashParams(paramsCollection)
    expect(window.location.hash).toBe("#sizes=[104,105,XL]")

  it "must call a directive onHashChange with correct hashParams", (done)->

    class TestDirective
      constructor: (data)->
        hashParams = data.hashParams
        expect(hashParams.count()).toBe(1)
        expect(hashParams.getParam("patata").value).toBe("true")
        Oblique().destroy()
        done()

      onHashChange:(data)->

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10
    $("#fixture").html "<div data-ob-directive='TestDirective'></div>"

    hashParams=Oblique().getHashParams()
    hashParams.addSingleParam("patata","true")
    Oblique().setHashParams(hashParams)

  it "must call a directive constructor with correct hashParams", (done)->
    hashParams=Oblique().getHashParams()
    hashParams.addSingleParam("sort","desc")
    Oblique().setHashParams(hashParams)

    class TestDirective
      constructor: (data)->
        hashParams = data.hashParams
        expect(hashParams.count()).toBe(1)
        expect(hashParams.getParam("sort").value).toBe("desc")
        Oblique().destroy()
        done()

      onHashChange:()->

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10
    $("#fixture").html "<div data-ob-directive='TestDirective'></div>"


  it "must call a directive onHashChange() when location.hash change", (done)->
    class TestDirective
      constructor: ()->
        hashParams=Oblique().getHashParams()
        hashParams.addSingleParam("sort","desc")
        Oblique().setHashParams(hashParams)

      onHashChange:(data)->
        hashParams = data.hashParams
        expect(hashParams.count()).toBe(1)
        expect(hashParams.getParam("sort").value).toBe("desc")
        Oblique().destroy()
        done()

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10
    $("#fixture").html "<div data-ob-directive='TestDirective'></div>"

  it "must call a directive onHashChange() only once when location.hash change", (done)->

    callCount=0

    class TestDirective
        constructor: ()->

        onHashChange:()->
          callCount++

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10
    $("#fixture").html "<div data-ob-directive='TestDirective'></div>"

    setTimeout(->
      hashParams=Oblique().getHashParams()
      hashParams.removeAll()
      hashParams.addSingleParam("sort","desc")
      Oblique().setHashParams(hashParams)
    , 10)

    setTimeout(->
      expect(callCount).toBe 1
      Oblique().destroy()
      done()
    , 150)

  it "must set correctly # and & when I remove a param from list", ()->
    window.location.hash="#albums=[1]&color=green"
    hashParams = Oblique().getHashParams()
    hashParams.getParam("albums").remove("1")
    Oblique().setHashParams(hashParams)
    expect(window.location.hash).toBe("#albums&color=green")


  it "must set hash to '#' when I remove the last param (to prevent reload of the page)", (done)->
    window.location.hash="#referencetopaginate=1TC111333"
    hashParams = Oblique().getHashParams()
    hashParams.remove("referencetopaginate")
    Oblique().setHashParams(hashParams)
    setTimeout(->
      expect(window.location.hash).toBe("#_")
      done()
    ,10)

  it "must work with params in camel case", ()->
    window.location.hash="#Color=red"
    hashParams = Oblique().getHashParams()
    param=hashParams.getParam("color")
    expect(param).toBeDefined()
    expect(param.value).toBe("red")

  it "must work with params in upper case", ()->
    window.location.hash="#COLOR=red"
    hashParams = Oblique().getHashParams()
    param=hashParams.getParam("color")
    expect(param).toBeDefined()
    expect(param.value).toBe("red")

  it "must work with params with latin characters", ()->
    #window.location.hash="#category=baño"

    hashParams = Oblique().getHashParams()
    hashParams.addSingleParam "category", "baño"
    Oblique().setHashParams(hashParams)

    hashParams = Oblique().getHashParams()
    param=hashParams.getParam "category"
    expect(param).toBeDefined()
    expect(param.value).toBe "baño"


  it "must not throw an error if onHashChange() is not defined in a directive", (done)->

    Oblique().onError((error)->
      expect(false).toBeTruthy("has thrown an error!");
    )

    class TestDirective
      constructor:()->
        window.location.hash="#color=red"

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10
    $("#fixture").html "<div data-ob-directive='TestDirective'></div>"

    setTimeout(->
      done()
    ,20)

  it "must create a variable in data-ob-var", (done)->
    class TestDirective
      constructor: (data)->
        expect(data.model).toBe 1
        done()

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10
    FixtureHelper.clear()
    FixtureHelper.appendHTML "<div data-ob-var='var fooVar=1'></div>"
    FixtureHelper.appendHTML "<div data-ob-directive='TestDirective' data-ob-model='fooVar'>nice DOM</div>"

  it "must create a variable in ob-var instead of data-ob-var", (done)->
    class TestDirective
      constructor: (data)->
        expect(data.model).toBe 1
        done()

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10
    FixtureHelper.clear()
    FixtureHelper.appendHTML "<div ob-var='var fooVar=1'></div>"
    FixtureHelper.appendHTML "<div data-ob-directive='TestDirective' data-ob-model='fooVar'>nice DOM</div>"

  it "must create a variable with complex value in data-ob-var", (done)->
    class TestDirective
      constructor: (data)->
        expect(data.model).toBe 5
        done()

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10
    FixtureHelper.clear()
    FixtureHelper.appendHTML "<div data-ob-var='var fooVar=2*2+1'></div>"
    FixtureHelper.appendHTML "<div data-ob-directive='TestDirective' data-ob-model='fooVar'>nice DOM</div>"

  it "must create a variable with string value in data-ob-var", (done)->
    class TestDirective
      constructor: (data)->
        expect(data.model).toBe "hello"
        done()

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10
    FixtureHelper.clear()
    jsStringValue='var fooVar="hello"'
    FixtureHelper.appendHTML "<div data-ob-var='#{jsStringValue}'></div>"
    FixtureHelper.appendHTML "<div data-ob-directive='TestDirective' data-ob-model='fooVar'>nice DOM</div>"

  it "must create a variable with string value from other variables in data-ob-var", (done)->
    class TestDirective
      constructor: (data)->
        expect(data.model).toBe "hello world"
        done()

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10
    FixtureHelper.clear()
    saluteVar='var salute="hello"'
    spaceVar='var space=" "'
    nameVar='var name="world"'
    FixtureHelper.appendHTML "<div data-ob-var='#{saluteVar}'></div>"
    FixtureHelper.appendHTML "<div data-ob-var='#{spaceVar}'></div>"
    FixtureHelper.appendHTML "<div data-ob-var='#{nameVar}'></div>"
    FixtureHelper.appendHTML "<div data-ob-var='var all=salute+space+name'></div>"
    FixtureHelper.appendHTML "<div data-ob-directive='TestDirective' data-ob-model='all'>nice DOM</div>"

  it "must use a variable in data-ob-model that is created later in DOM", (done)->
    class TestDirective
      constructor: (data)->
        expect(data.model).toBe 1
        done()

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10
    FixtureHelper.clear()
    FixtureHelper.appendHTML "<div data-ob-directive='TestDirective' data-ob-model='fooVar'>nice DOM</div>"
    FixtureHelper.appendHTML "<div data-ob-var='var fooVar=1'></div>"

  it "must call a directive onInterval() when Oblique() timed event occurs", (done)->
    class TestDirective
      constructor: ()->

      onInterval:()->
        done()

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10
    $("#fixture").html "<div data-ob-directive='TestDirective'></div>"

  it "must call a directive almost 80 times in a second", (done)->
    times=0

    class TestDirective
      constructor: ()->

      onInterval:()->
        times++

    setTimeout(->
      expect(times>=80).toBeTruthy()
      done()
    ,1000)

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10
    $("#fixture").html "<div data-ob-directive='TestDirective'></div>"


  it "must call a onError when onInterval() has errors", (done)->
    Oblique().onError((error)->
      expect(error.message).toBeTruthy "Error message"
      done()
    )

    class TestDirective
      constructor: ()->

      onInterval:()->
        throw new Error "Error message"

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10
    $("#fixture").html "<div data-ob-directive='TestDirective'></div>"

  it "must call a directive registered as global when isn't in the DOM", (done)->
    class GlobalTestDirective
      constructor: ()->
        done()

    Oblique().registerDirectiveAsGlobal "GlobalTestDirective", GlobalTestDirective
    Oblique().setIntervalTimeInMs 10


  it "must throw an error if jQuery is not present", ()->
    jQuery=window.jQuery
    error=false;
    try
      window.jQuery=undefined
      Oblique()
    catch e
      error=true;
      expect(e.message).toBe "ObliqueJS needs jQuery to be loaded";
    finally
      window.jQuery=jQuery
    expect(error).toBeTruthy()

  it "must not listen to hashChange when hashChange is disabled", (done)->
    onHashChangeWasCalled=no

    class TestDirective
      constructor: ()->

      onHashChange: ()->
        onHashChangeWasCalled=yes

    Oblique().registerDirectiveAsGlobal "TestDirective", TestDirective

    setTimeout(->
      hashParams=Oblique().getHashParams()
      hashParams.addSingleParam "testDisableHashChange", "true"
      Oblique().disableHashChangeEvent()
      Oblique().setHashParams hashParams
    ,100)

    setTimeout(->
      expect(onHashChangeWasCalled).toBe no
      done()
    ,200)

  it "must match directives when name is lowercase", (done)->
    class TestDirective
      constructor: ()->
        Oblique().destroy()
        done()

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10
    $("#fixture").html "<div data-ob-directive='testdirective'></div>"

  it "must match directives when name is uppercase", (done)->
    class TestDirective
      constructor: ()->
        Oblique().destroy()
        done()

    Oblique().registerDirective "TestDirective", TestDirective
    Oblique().setIntervalTimeInMs 10
    $("#fixture").html "<div data-ob-directive='TESTDIRECTIVE'></div>"
