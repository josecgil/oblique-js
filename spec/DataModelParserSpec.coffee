describe "DataModelParser", ->
  beforeEach () ->

  afterEach ->

  it "must know if it's only a model", ->
    dataModelParser=new DataModelParser "Model"
    expect(dataModelParser.isModel()).toBeTruthy()

  it "must know if it's not a model when empty string", ->
    dataModelParser=new DataModelParser ""
    expect(dataModelParser.isModel()).toBeFalsy()

  it "must know if it's not a model when undefined", ->
    dataModelParser=new DataModelParser undefined
    expect(dataModelParser.isModel()).toBeFalsy()

  it "must know if it's not a model when null", ->
    dataModelParser=new DataModelParser null
    expect(dataModelParser.isModel()).toBeFalsy()

  it "must know if it's not a model when a string doesn't begins with 'Model'", ->
    dataModelParser=new DataModelParser "patata"
    expect(dataModelParser.isModel()).toBeFalsy()

  it "must know if it's not a model when another string doesn't begins with 'Model'", ->
    dataModelParser=new DataModelParser "model"
    expect(dataModelParser.isModel()).toBeFalsy()

  it "must know if it's a model when is complex and begins with 'Model'", ->
    dataModelParser=new DataModelParser "Model.Colors"
    expect(dataModelParser.isModel()).toBeTruthy()

  it "must know if its not a model when begins with 'Model.'", ->
    dataModelParser=new DataModelParser "Model."
    expect(dataModelParser.isModel()).toBeFalsy()

  it "must know if its not a model when begins with 'Model.Colors.'", ->
    dataModelParser=new DataModelParser "Model.Colors."
    expect(dataModelParser.isModel()).toBeFalsy()

class DataModelParser

  constructor:(@modelExpression) ->

  isModel:() ->
    return false if @modelExpression is undefined
    return false if @modelExpression is null
    modelExprArray = @modelExpression.split(".")
    return false if modelExprArray[0] isnt "Model"
    lastIndex = modelExprArray.length - 1
    return false if modelExprArray[lastIndex] is ""
    true

