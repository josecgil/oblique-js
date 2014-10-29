@.ObliqueNS=@.ObliqueNS or {}

class EmptyParam extends ObliqueNS.Param

  constructor:()->

  getLocationHash: ->
    ""

  isEmpty:() ->
    return true

  valueIsEqualTo:() ->
    return true

  containsValue:() ->
    return true


ObliqueNS.EmptyParam=EmptyParam