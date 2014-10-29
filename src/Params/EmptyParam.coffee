@.ObliqueNS=@.ObliqueNS or {}

class EmptyParam extends ObliqueNS.Param

  constructor:()->

  getLocationHash: ->
    ""

  isEmpty:() ->
    return true

ObliqueNS.EmptyParam=EmptyParam