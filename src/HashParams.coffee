@.ObliqueNS=@.ObliqueNS or {}

class HashParams

  constructor:() ->
    @clearAll()

  isEmpty:()->
    $.isEmptyObject @params

  setSingle: (name, value) ->
    @params[name]=value

  setRange:(name, min, max) ->
    @params[name]={ min: min, max: max }

  _isAnArray:(value) ->
    return false if (value is undefined)
    return false if (Object.prototype.toString.call(value)) isnt '[object Array]'
    true

  add:(name, value) ->
    @params[name]=[] if (not @_isAnArray(@params[name]) )
    @params[name].push value

  remove:(name, value) ->
    array=@params[name]
    return if (not @_isAnArray(array) )
    index=array.indexOf(value)
    return if index is -1
    array.splice(index,1)

  clear:(name)->
    @params[name]=undefined

  clearAll: ->
    @params={}

ObliqueNS.HashParams=HashParams

