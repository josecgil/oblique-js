@.ObliqueNS=@.ObliqueNS or {}

class RangeParam

  constructor:(@name, @min, @max)->

  getLocationHash:->
     "#{@name}=[#{@min},#{@max}]"

  isEmpty:() ->
    return true if (@min is undefined and @max is undefined)
    return false


ObliqueNS.RangeParam=RangeParam