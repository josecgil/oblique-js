window.ObliqueNS=window.ObliqueNS or {}

class TimedDOMObserver

  constructor:->
    @_reset()
    @_callback=undefined
    @_intervalInMs=500

  onChange:(callback)->
    @_callback=callback

  setIntervalInMs:(newIntervalInMs) ->
    @_intervalInMs=newIntervalInMs

  observe:->
    @destroy()
    return if not @_callback
    @_intervalId=setInterval(=>
      @_callback()
    , @_intervalInMs)

  _reset:->
    @_intervalId=undefined

  destroy: ->
    if @_intervalId
      clearInterval @_intervalId
      @_reset()

ObliqueNS.TimedDOMObserver=TimedDOMObserver