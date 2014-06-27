@.ObliqueNS=@.ObliqueNS or {}

class ListParams

  constructor:(values, separator=",")->
    @_values=values.split(separator);

  valuesAsString: ->
    @_values

  _valueToInt: (value) ->
    number=parseInt value, 10
    return 0 if isNaN number
    number

  valuesAsInt: ->
    @_valueToInt value for value in @_values


ObliqueNS.ListParams=ListParams