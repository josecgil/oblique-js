@.ObliqueNS=@.ObliqueNS or {}

Param=ObliqueNS.Param

class RangeParam extends ObliqueNS.Param

  constructor:(@name, @min, @max)->
    super(@name)
    if (not @_isString(@min))
      throw new ObliqueNS.Error("Param constructor must be called with second param string")
    if (not @_isString(@max))
      throw new ObliqueNS.Error("Param constructor must be called with third param string")

  getLocationHash:->
     "#{@name}=(#{@min},#{@max})"

  isEmpty:() ->
    return true if (@min is undefined and @max is undefined)
    return false

  @is:(strHashParam)->
    hashParam=Param.parse(strHashParam)
    return true if Param.containsChar(hashParam.value,"(")
    false

  @createFrom:(strHashParam)->
    hashParam=Param.parse(strHashParam)
    value=hashParam.value.replace("(","").replace(")","")
    min=(value.split(",")[0]).trim()
    max=(value.split(",")[1]).trim()
    new RangeParam(hashParam.name, min, max)

ObliqueNS.RangeParam=RangeParam