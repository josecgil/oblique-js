@.ObliqueNS=@.ObliqueNS or {}

class ParamCollection

  constructor:() ->
    @_params={}
    @length=0

  add:(param)->
    @_params[param.name]=param

  remove:(paramName)->
    @_params[paramName]=undefined

  getParam:(paramName)->
    @_params[paramName]

#old code

  isEmpty:()->
    $.isEmptyObject @values

  setSingle: (name, value) ->
    @values[name]=value

  setRange:(name, min, max) ->
    @values[name]={ min: min, max: max }

  _isAnArray:(value) ->
    return false if (value is undefined)
    return false if (Object.prototype.toString.call(value)) isnt '[object Array]'
    true

  clear:(name)->
    @values[name]=undefined

  clearAll: ->
    @values={}

ObliqueNS.ParamCollection=ParamCollection


