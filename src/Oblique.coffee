@.ObliqueNS=@.ObliqueNS or {}

class Oblique

  constructor: ->
    if window.jQuery is undefined
      error=new ObliqueNS.Error "ObliqueJS needs jQuery to be loaded"
      Oblique.logError error
      throw error

    return new Oblique() if @ is window

    return Oblique._singletonInstance  if Oblique._singletonInstance
    Oblique._singletonInstance = @

    @domProcessor=new ObliqueNS.DOMProcessor();
    @templateFactory=new ObliqueNS.TemplateFactory()
    @_onErrorCallbacks=[]

  @DEFAULT_INTERVAL_MS = 500

  @logError = (error) ->
    console.log "--- Init Oblique Error ---"
    console.log error.message
    console.log error.stack
    console.log "--- End  Oblique Error ---"


  getIntervalTimeInMs: ->
    @domProcessor.getIntervalTimeInMs()

  setIntervalTimeInMs: (newIntervalTimeInMs) ->
    @domProcessor.setIntervalTimeInMs(newIntervalTimeInMs)

  registerDirective: (directiveName, directiveConstructorFn) ->
    @domProcessor.registerDirective directiveName, directiveConstructorFn

  registerDirectiveAsGlobal: (directiveName, directiveConstructorFn) ->
    @domProcessor.registerDirectiveAsGlobal directiveName, directiveConstructorFn

  enableHashChangeEvent: ->
    @domProcessor.enableHashChangeEvent()

  disableHashChangeEvent: ->
    @domProcessor.disableHashChangeEvent()


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

  getHashParams:() ->
    new ObliqueNS.ParamCollection(window.location.hash)

  setHashParams:(paramCollection) ->
    hash=paramCollection.getLocationHash()
    location=window.location
    urlWithoutHash=location.protocol+"//"+location.host+location.pathname+location.search
    newUrl=urlWithoutHash+hash
    if(navigator.userAgent.match(/Android/i))
      document.location=uri
    else
      window.location.replace newUrl
      window.history.replaceState null, null, newUrl

ObliqueNS.Oblique=Oblique
@.Oblique=Oblique

