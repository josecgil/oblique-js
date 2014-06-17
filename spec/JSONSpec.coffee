describe "JSON", ->

  JSON=ObliqueNS.JSON

  beforeEach ->

  afterEach ->

  it "must return JSON passed", ()->
    json=
      name: "name"
      content: "content"
    expect(new JSON(json).value).toBe json

  it "must extract simple property", ()->
    json=
      name: "Carlos"
      content: "content"
    expect(new JSON(json).getPathValue("name")).toBe "Carlos"

  it "must extract complex property", ()->
    json=
      name: "Carlos"
      content: "content"
      address:
        name: "Gran Via"
        number: 42
    expect(new JSON(json).getPathValue("address.number")).toBe 42

  it "must throw exception if getPathValue not found", ()->
    json=
      name: "Carlos"
      content: "content"
      address:
        name: "Gran Via"
        number: 42
    expect(->
      new JSON(json).getPathValue("address.patata")
    ).toThrow(new ObliqueNS.Error("'address.patata' not found in JSON Object"))

  it "must return undefined if value is undefined", ()->
    json=
      name: "Carlos"
      content: "content"
      address:
        name: "Gran Via"
        number: undefined
    expect(new JSON(json).getPathValue("address.number")).toBeUndefined()


  it "must perform better than JSONPath", ()->
    json=
      name: "Carlos"
      content: "content"
      address:
        name: "Gran Via"
        number: undefined
        city:
          name: "VNG"
          number: 1
          postalCode: "08800"

    interval=new Interval()

    interval.start()
    for [1..1000]
      new JSON(json).getPathValue "address.number"
    jsonPathObliqueTime=interval.stop()

    interval.start()
    for [1..1000]
      jsonPath(json, "address.number")
    jsonPathTime=interval.stop()

    console.log "ObliqueJSON #{jsonPathObliqueTime}ms vs JSONPath #{jsonPathTime}ms"

    expect(jsonPathObliqueTime).toBeLessThan jsonPathTime

  it "must retrieve array correctly", ()->
    json =
        title: "example glossary"
        id: "SGML"
        sortAs: "SGML"
        term: "Standard Generalized Markup Language"
        acronym: "SGML"
        definition:
          para: "A meta-markup language, used to create markup languages such as DocBook."
          seeAlso: [
            "GML"
            "XML"
          ]
        see: "markup"
    extractedJSON = new JSON(json).getPathValue("definition.seeAlso")
    expect(extractedJSON[0]).toBe "GML"
    expect(extractedJSON[1]).toBe "XML"



