@.ObliqueNS=@.ObliqueNS or {}

class CallbackCollection

  constructor:()->
    @_callbacks=[]
    @_callbacksByName={}

  count:() ->
    @_callbacks.length

  _isAFunction: (memberToTest) ->
    typeof (memberToTest) is "function"

  _throwErrorIfCallbackIsNotValid: (callbackName, callbackFn) ->
    if not callbackName or typeof callbackName isnt "string"
      throw new ObliqueNS.Error("registerDirective must be called with a string directiveName")
    if not @_isAFunction(callbackFn)
      throw new ObliqueNS.Error("registerDirective must be called with a Directive 'Constructor/Class'")

  add:(callbackName, callbackFn) ->
    @_throwErrorIfCallbackIsNotValid(callbackName, callbackFn)

    @_callbacks.push callbackFn
    @_callbacksByName[callbackName]=callbackFn

  at:(index)->
    @_callbacks[index]

  getCallbackByName : (name) ->
    @_callbacksByName[name]

ObliqueNS.CallbackCollection=CallbackCollection