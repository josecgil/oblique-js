describe "DataModelVariable", ->

  DataModelVariable=ObliqueNS.DataModelVariable

  it "must know variable name when local variable is set", () ->
    dataModelVariable=new DataModelVariable("var number=32")
    expect(dataModelVariable.name).toBe "number"

  it "must know variable name when another local variable is set", () ->
    dataModelVariable=new DataModelVariable("var patata='patataValue'")
    expect(dataModelVariable.name).toBe "patata"

  it "must know variable name when global variable is set", () ->
    dataModelVariable=new DataModelVariable("number=32")
    expect(dataModelVariable.name).toBe "number"

  it "must know variable name when local variable is set with new object", () ->
    dataModelVariable=new DataModelVariable("var currentDate=new Date()")
    expect(dataModelVariable.name).toBe "currentDate"

  it "must know if variable is set", () ->
    dataModelVariable=new DataModelVariable("var currentDate=new Date()")
    expect(dataModelVariable.isSet).toBeTruthy()

  it "must know if simple variable is set", () ->
    dataModelVariable=new DataModelVariable("var number=32")
    expect(dataModelVariable.isSet).toBeTruthy()

  it "must know if variable is not set", () ->
    dataModelVariable=new DataModelVariable("number")
    expect(dataModelVariable.isSet).toBeFalsy()

  it "must know if variable is not set when comparison expression", () ->
    dataModelVariable=new DataModelVariable("number==32")
    expect(dataModelVariable.isSet).toBeFalsy()

  it "must know if variable is not set when strict comparison expression", () ->
    dataModelVariable=new DataModelVariable("number===32")
    expect(dataModelVariable.isSet).toBeFalsy()

  it "must know if variable is not set when comparison expression", () ->
    dataModelVariable=new DataModelVariable("is32=(number==32)")
    expect(dataModelVariable.isSet).toBeTruthy()