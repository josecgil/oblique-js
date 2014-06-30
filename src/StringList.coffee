@.ObliqueNS=@.ObliqueNS or {}

class StringList

  constructor:(values, separator=",")->
    @_values=values.split(separator);

  toStringArray: ->
    @_values

  _valueToInt: (value) ->
    number=parseInt value, 10
    return 0 if isNaN number
    number

  toIntArray: ->
    @_valueToInt value for value in @_values



ObliqueNS.StringList=StringList