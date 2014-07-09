@.ObliqueNS=@.ObliqueNS or {}

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
    @_expression=@_removeExtraSpaces @_expression

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

  _removeExtraSpaces:(str)->
    while str.indexOf("  ") isnt -1
      str=str.replace("  ", " ")
    str=str.trim()
    str=str.replace " (", "("
    str=str.replace " )", ")"
    str=str.replace "( ", "("
    str=str.replace ") ", ")"
    str

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

ObliqueNS.DataModelDSL=DataModelDSL


