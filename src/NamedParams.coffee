@.ObliqueNS=@.ObliqueNS or {}

Param=ObliqueNS.Param

class NamedParams

  constructor : (params, paramSeparator=";", valueSeparator=":") ->
    @params=[]
    for param in params.split paramSeparator
      @params.push new Param param, valueSeparator

  getParam : (paramName) ->
    for param in @params
      return param if param.name is paramName
    null

ObliqueNS.NamedParams=NamedParams

