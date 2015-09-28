@.ObliqueNS=@.ObliqueNS or {}

class Directive

  constructor:(@name, @callback, @isGlobal=false)->
    @_throwErrorIfParamsAreNotValid @name, @callback

  _isAFunction: (memberToTest) ->
    typeof (memberToTest) is "function"

  _throwErrorIfParamsAreNotValid: (name, callback) ->
    if not name or typeof name isnt "string"
      throw new ObliqueNS.Error("Directive name must be an string")
    if not @_isAFunction(callback)
      throw new ObliqueNS.Error("Directive must be called with a 'Constructor Function/Class' param")

ObliqueNS.Directive=Directive

