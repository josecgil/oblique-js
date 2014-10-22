@.ObliqueNS=@.ObliqueNS or {}

class ParamCollection

  constructor:() ->
    @removeAll()

  add:(param)->
    @_params[param.name]=param

  remove:(paramName)->
    @_params[paramName]=undefined

  removeAll: ->
    @_params={}

  getParam:(paramName)->
    @_params[paramName]

  count: ->
    count = 0
    for paramName, param of @_params
      count++ if not @_isEmpty(param)
    count

  _isEmpty: (param)  ->
    return true if param is undefined
    return param.isEmpty()

  getLocationHash: ->
    return "" if @count() is 0

    hash = "#"
    for paramName, param of @_params
      hash += param.getLocationHash()+"&"

    hash=hash.substr(0,hash.length-1)
    hash

ObliqueNS.ParamCollection=ParamCollection


