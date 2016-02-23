@.ObliqueNS=@.ObliqueNS or {}

class DataModelVariable

  constructor:(@_expression)->
    @_firstEqualPosition=@_expression.indexOf("=")
    @name=@_getVariableName()
    @isSet = @_isSet()

  _getVariableName: () ->
    return @_expression if @_firstEqualPosition is -1
    parts=@_expression.split("=")
    variableName=(parts[0].replace("var ", "")).trim()
    return undefined  if variableName is ""
    variableName

  _isSet:() ->
    return false if @_firstEqualPosition is -1
    nextChar=@_expression.substr(@_firstEqualPosition+1, 1)
    return false if nextChar is "="
    true

ObliqueNS.DataModelVariable=DataModelVariable


