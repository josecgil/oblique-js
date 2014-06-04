@.ObliqueNS=@.ObliqueNS or {}

class Param

  constructor:(param, valueSeparator=":")->
    paramAndValue=param.split valueSeparator
    @name=paramAndValue[0].trim()
    @value=paramAndValue[1].trim()

  valueAsInt: ->
    parseInt @value, 10

ObliqueNS.Param=Param