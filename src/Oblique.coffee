@.ObliqueNS=@.ObliqueNS or {}

class Oblique

  constructor: ->
    return new Oblique() if @ is window

    return Oblique._singletonInstance  if Oblique._singletonInstance
    Oblique._singletonInstance = @

    @directiveProcessor=new ObliqueNS.DirectiveProcessor();
    @templateFactory=new ObliqueNS.TemplateFactory()
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

  renderHtml: (url, model) ->
    if Handlebars is undefined
      throw new ObliqueNS.Error("Oblique().renderHtml() needs handlebarsjs loaded to work")
    template=@templateFactory.createFromUrl url
    template.renderHTML model

  onError:(@_onErrorCallback)->

  triggerOnError:(error)->
    @_onErrorCallback(error)
    throw error

ObliqueNS.Oblique=Oblique
@.Oblique=Oblique

