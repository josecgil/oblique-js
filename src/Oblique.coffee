@.ObliqueNS=@.ObliqueNS or {}

class Oblique

  constructor: ->
    return new Oblique() if @ is window

    return Oblique._singletonInstance  if Oblique._singletonInstance
    Oblique._singletonInstance = @

    @domProcessor=new ObliqueNS.DOMProcessor();
    @templateFactory=new ObliqueNS.TemplateFactory()
    @_onErrorCallbacks=[]

  @DEFAULT_INTERVAL_MS = 500

  getIntervalTimeInMs: ->
    @domProcessor.getIntervalTimeInMs()

  setIntervalTimeInMs: (newIntervalTimeInMs) ->
    @domProcessor.setIntervalTimeInMs(newIntervalTimeInMs)

  registerDirective: (directiveName, directiveConstructorFn) ->
    @domProcessor.registerDirective directiveName, directiveConstructorFn

  destroy: ->
    @domProcessor.destroy()
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

  renderHTML: (url, model) ->
    if Handlebars is undefined
      throw new ObliqueNS.Error("Oblique().renderHtml(): needs handlebarsjs loaded to render templates")
    template=@templateFactory.createFromUrl url
    template.renderHTML model

  onError:(onErrorCallback)->
    @_onErrorCallbacks.push onErrorCallback

  triggerOnError:(error)->
    for callback in @_onErrorCallbacks
      callback(error)
    #throw error

  getHashParams:() ->
    new ObliqueNS.ParamCollection(window.location.hash)

  setHashParams:(paramCollection) ->
    window.location.hash=paramCollection.getLocationHash()

ObliqueNS.Oblique=Oblique
@.Oblique=Oblique
