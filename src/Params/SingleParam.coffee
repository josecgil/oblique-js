@.ObliqueNS=@.ObliqueNS or {}

Param=ObliqueNS.Param

class SingleParam extends ObliqueNS.Param

  constructor:(@name, @value)->
    super(@name)
    if (not @_isString(@value))
      throw new ObliqueNS.Error("Param constructor must be called with second param string")

  getLocationHash: ->
    "#{@name}=#{@value}"

  isEmpty:() ->
    return true if @value is undefined
    return false

  @is:(strHashParam)->
    hashParam=Param.parse(strHashParam)
    return false if Param.containsChar(hashParam.value,"(")
    return false if Param.containsChar(hashParam.value,"[")
    true

  @createFrom:(strHashParam)->
    hashParam=Param.parse(strHashParam)
    new SingleParam(hashParam.name, hashParam.value)


ObliqueNS.SingleParam=SingleParam