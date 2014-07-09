@.ObliqueNS=@.ObliqueNS or {}

class Error
  constructor: (@message) ->
    return new Error(@message) if @ is window
    @name = "Oblique.Error"

ObliqueNS.Error=Error


