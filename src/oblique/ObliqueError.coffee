class @ObliqueError
  constructor: (@message) ->
    @name = "ObliqueError"
    return new ObliqueError(@message) if @ is window
