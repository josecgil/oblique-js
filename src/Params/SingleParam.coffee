@.ObliqueNS=@.ObliqueNS or {}

class SingleParam

  constructor:(@name, @value)->

  getLocationHash: ->
    "#{@name}=#{@value}"

  isEmpty:() ->
    return true if @value is undefined
    return false


ObliqueNS.SingleParam=SingleParam