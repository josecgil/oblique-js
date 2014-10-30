@.ObliqueNS=@.ObliqueNS or {}

class Param

  constructor:(@name)->
    if not @_isString(@name)
      throw new ObliqueNS.Error("Param constructor must be called with first param string")

  _isString:(value)->
    return true if typeof(value) is 'string'
    false

  @containsChar:(fullStr, char) ->
    return false if fullStr.indexOf(char) is -1
    true

  @stringIsNullOrEmpty:(value) ->
    return true if value is undefined
    return true if value.trim().length is 0
    false

  @parse:(strHashParam)->
    hashArray=strHashParam.split("=")
    name=hashArray[0].trim()
    value=hashArray[1].trim()
    {name:name, value:value}

  getLocationHash: ->
    ""

  isEmpty:() ->
    true

  valueIsEqualTo:() ->
    true

  containsValue:() ->
    true

  isInRange:()->
    true

ObliqueNS.Param=Param