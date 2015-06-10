@.ObliqueNS=@.ObliqueNS or {}

class ObliqueError extends Error
  constructor: (@message) ->
    return new Error(@message) if @ is window
    @name = "ObliqueNS.Error"

ObliqueNS.Error=ObliqueError
