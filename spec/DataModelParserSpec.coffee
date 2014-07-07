describe "DataModelDSL", ->
  beforeEach () ->

  afterEach ->

  it "must know if it's only a model", ->
    dataModelParser=new DataModelDSL "Model"

  it "must know if it's not a model when empty string", ->
    expect(->
      dataModelParser=new DataModelDSL ""
    ).toThrow(new ObliqueNS.Error("data-model can't be null or empty"))

  it "must know if it's not a model when undefined", ->
    expect(->
      dataModelParser=new DataModelDSL undefined
    ).toThrow(new ObliqueNS.Error("data-model can't be null or empty"))

  it "must know if it's not a model when null", ->
    expect(->
      dataModelParser=new DataModelDSL null
    ).toThrow(new ObliqueNS.Error("data-model can't be null or empty"))

  it "must know if it's not a model when a string doesn't begins with 'Model or new'", ->
    expect(->
      new DataModelDSL "patata"
    ).toThrow(new ObliqueNS.Error("data-model must begins with 'Model or new'"))

  it "must know if it's not a model when another string doesn't begins with 'Model'", ->
    expect(->
      new DataModelDSL "model"
    ).toThrow(new ObliqueNS.Error("data-model must begins with 'Model or new'"))

  it "must know if it's a model when is complex and begins with 'Model'", ->
    new DataModelDSL "Model.Colors"

  it "must know if its not a model when begins with 'Model.'", ->
    expect(->
      new DataModelDSL "Model."
    ).toThrow(new ObliqueNS.Error("data-model needs property after dot"))

  it "must know if its not a model when begins with 'Model.Colors.'", ->
    expect(->
      new DataModelDSL "Model.Colors."
    ).toThrow(new ObliqueNS.Error("data-model needs property after dot"))

  it "must understand a simple property", ->
    dataModelDSL=new DataModelDSL "Model.Description"
    expect(dataModelDSL.modelProperties.length).toBe 1
    expect(dataModelDSL.modelProperties[0].name).toBe "Description"

  it "must understand a more complex property", ->
    dataModelDSL=new DataModelDSL "Model.Address.Number"
    expect(dataModelDSL.modelProperties.length).toBe 2
    expect(dataModelDSL.modelProperties[0].name).toBe "Address"
    expect(dataModelDSL.modelProperties[1].name).toBe "Number"

  it "must understand a very complex property", ->
    dataModelDSL=new DataModelDSL "Model.Cart.Promotion.Id"
    expect(dataModelDSL.modelProperties.length).toBe 3
    expect(dataModelDSL.modelProperties[0].name).toBe "Cart"
    expect(dataModelDSL.modelProperties[1].name).toBe "Promotion"
    expect(dataModelDSL.modelProperties[2].name).toBe "Id"

  it "must understand an indexed property", ->
    dataModelDSL=new DataModelDSL "Model.Colors[0].Sizes"
    expect(dataModelDSL.modelProperties.length).toBe 2
    expect(dataModelDSL.modelProperties[0].name).toBe "Colors"
    expect(dataModelDSL.modelProperties[0].hasIndex).toBeTruthy()
    expect(dataModelDSL.modelProperties[0].index).toBe 0

    expect(dataModelDSL.modelProperties[1].name).toBe "Sizes"

  it "must understand another indexed property", ->
    dataModelDSL=new DataModelDSL "Model.Colors[1000]"
    expect(dataModelDSL.modelProperties.length).toBe 1
    expect(dataModelDSL.modelProperties[0].name).toBe "Colors"
    expect(dataModelDSL.modelProperties[0].hasIndex).toBeTruthy()
    expect(dataModelDSL.modelProperties[0].index).toBe 1000

  it "must understand that is full Model", ->
    dataModelDSL=new DataModelDSL "Model"
    expect(dataModelDSL.hasFullModel).toBeTruthy()
    expect(dataModelDSL.modelProperties).toBeUndefined()

  it "must understand that isnt full Model when model has parts", ->
    dataModelDSL=new DataModelDSL "Model.Colors"
    expect(dataModelDSL.hasFullModel).toBeFalsy()
    expect(dataModelDSL.modelProperties).toBeDefined()

  it "must understand that isnt full Model when doesn't has model", ->
    dataModelDSL=new DataModelDSL "new Settings()"
    expect(dataModelDSL.hasFullModel).toBeFalsy()
    expect(dataModelDSL.modelProperties).toBeUndefined()

  it "must know if it's a model when begins with 'new'", ->
    new DataModelDSL "new ColorJSCollection()"

  it "must undefine modelProperties when is only object", ->
    dataModelDSL=new DataModelDSL "new ColorJSCollection()"
    expect(dataModelDSL.modelProperties).toBeUndefined()

  it "must undefine className when is only model", ->
    dataModelDSL=new DataModelDSL "Model"
    expect(dataModelDSL.className).toBeUndefined()

  it "must know className when is only object", ->
    dataModelDSL=new DataModelDSL "new ColorJSCollection()"
    expect(dataModelDSL.className).toBe "ColorJSCollection"

  it "must know if has brackets", ->
    expect(->
      new DataModelDSL "new ColorJSCollection"
    ).toThrow(new ObliqueNS.Error("data-model needs open bracket after className"))

  it "must know className & model when is object & model", ->
    dataModelDSL=new DataModelDSL "new ColorJSCollection(Model.Colors)"
    expect(dataModelDSL.className).toBe "ColorJSCollection"
    expect(dataModelDSL.modelProperties[0].name).toBe "Colors"
    expect(dataModelDSL.modelProperties.length).toBe 1

  it "must know if start bracket are correct", ->
    expect(->
      new DataModelDSL "new ColorJSCollection("
    ).toThrow(new ObliqueNS.Error("data-model needs close bracket after className"))

  it "must know if end bracket are correct", ->
    expect(->
      new DataModelDSL "new ColorJSCollection)"
    ).toThrow(new ObliqueNS.Error("data-model needs open bracket after className"))

#data-bq-model="new Setting()"



class ModelDSLPart
  constructor:(part)->
    @name=part
    @hasIndex=false
    @index=undefined
    firstBracePosition = part.indexOf "["
    if firstBracePosition isnt -1
      @hasIndex= true
      @name=part.substr 0, firstBracePosition
      lastBracePosition = part.indexOf "]"
      indexStr=part.slice firstBracePosition+1, lastBracePosition
      @index=parseInt(indexStr, 10)

class ModelDSL
  constructor:(@_expression) ->
    @hasFullModel=false
    @_partsByDot = @_expression.split(".")
    @_checkSyntax()
    @_partsByDot.shift()

    if @_partsByDot.length is 0
      @hasFullModel=true
      @properties=undefined
      return

    @properties=[]
    for part in @_partsByDot
      @properties.push new ModelDSLPart(part)

  _checkSyntax:() ->
    throw new ObliqueNS.Error("data-model must begins with 'Model or new'") if @_partsByDot[0] isnt "Model"
    lastIndex = @_partsByDot.length - 1
    throw new ObliqueNS.Error("data-model needs property after dot") if @_partsByDot[lastIndex] is ""

class ClassDSL
  constructor:(@_expression)->
    classNameAndBrackets = @_expression.split(" ")[1]
    openBracket = classNameAndBrackets.indexOf("(")
    throw new ObliqueNS.Error("data-model needs open bracket after className") if openBracket is -1

    closeBracket=classNameAndBrackets.indexOf(")", openBracket)
    throw new ObliqueNS.Error("data-model needs close bracket after className") if closeBracket is -1
    @name = classNameAndBrackets.slice(0, openBracket)


class DataModelDSL
  constructor:(@_expression) ->
    @_checkIsNullOrEmpty()
    @hasFullModel = false
    @modelProperties=undefined
    @className=undefined

    @_hasClass = @_expression.split(" ")[0] is "new"
    if (@_hasClass)
      @className=(new ClassDSL @_expression).name

    modelExpression=@_extractModelExpression()
    if (modelExpression isnt "")
      modelDSL = new ModelDSL modelExpression
      @modelProperties=modelDSL.properties
      @hasFullModel=modelDSL.hasFullModel

  _extractModelExpression:()->
    return @_expression if not @_hasClass
    modelFirstPosition=@_expression.indexOf("(Model")
    return "" if (modelFirstPosition is -1)
    modelLastPosition=@_expression.indexOf(")")
    return @_expression.slice(modelFirstPosition+1, modelLastPosition)

  _checkIsNullOrEmpty:() ->
    throw new ObliqueNS.Error("data-model can't be null or empty") if @_isNullOrEmpty()

  _isNullOrEmpty:() ->
    return true if @_expression is undefined
    return true if @_expression is null
    return true if @_expression is ""
    false