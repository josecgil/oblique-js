@.ObliqueNS=@.ObliqueNS or {}

class Oblique

  constructor: ->
    return new Oblique() if @ is window

    return Oblique._singletonInstance  if Oblique._singletonInstance
    Oblique._singletonInstance = @

    @directiveProcessor=new ObliqueNS.DirectiveProcessor();
    @_onErrorCallback=->

  @DEFAULT_INTERVAL_MS = 500

  getIntervalTimeInMs: ->
    @directiveProcessor.getIntervalTimeInMs()

  setIntervalTimeInMs: (newIntervalTimeInMs) ->
    @directiveProcessor.setIntervalTimeInMs(newIntervalTimeInMs)

  registerDirective: (directiveConstructorFn) ->
    @directiveProcessor.registerDirective(directiveConstructorFn)

  destroy: ->
    @directiveProcessor.destroy()
    try
      delete Oblique._singletonInstance
    catch e
      Oblique._singletonInstance = undefined

  setModel: (@_model) ->

  getModel: ->
    @_model

  hasModel: ->
    return true if @_model
    false

  onError:(@_onErrorCallback)->

  triggerOnError:(error)->
    @_onErrorCallback(error)
    throw error

ObliqueNS.Oblique=Oblique
@.Oblique=Oblique