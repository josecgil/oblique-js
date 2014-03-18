window.ObliqueNS=window.ObliqueNS or {}

class Error
  constructor: (@message) ->
    @name = "Oblique.Error"
    return new Error(@message) if @ is window

ObliqueNS.Error=Error