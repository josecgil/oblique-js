@.ObliqueNS=@.ObliqueNS or {}

Param=ObliqueNS.Param

class RangeParam extends ObliqueNS.Param

  constructor:(@name, @min, @max)->
    super(@name)
    if (not @_isValidValue(@min))
      throw new ObliqueNS.Error("Param constructor must be called with second param string")
    if (not @_isValidValue(@max))
      throw new ObliqueNS.Error("Param constructor must be called with third param string")

  _isValidValue:(value) ->
    return true if value is undefined
    return @_isString(value)

  getLocationHash:->
    return "#{@name}=(#{@min},#{@max})" if not @isEmpty()
    @name

  isEmpty:() ->
    return true if (@min is undefined and @max is undefined)
    return false

  isInRange:(value) ->
    return false if value<@min
    return false if value>@max
    true

  @is:(strHashParam)->
    hashParam=Param.parse(strHashParam)
    return true if Param.containsChar(hashParam.value,"(")
    false

  @createFrom:(strHashParam)->
    hashParam=Param.parse(strHashParam)
    min=undefined
    max=undefined
    if (not Param.stringIsNullOrEmpty(hashParam.value))
      value=hashParam.value.replace("(","").replace(")","")
      if (value.trim().length>0)
        min=(value.split(",")[0]).trim()
        max=(value.split(",")[1]).trim()
    new RangeParam(hashParam.name, min, max)

ObliqueNS.RangeParam=RangeParam