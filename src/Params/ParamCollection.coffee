@.ObliqueNS=@.ObliqueNS or {}

ArrayParam=ObliqueNS.ArrayParam
RangeParam=ObliqueNS.RangeParam
SingleParam=ObliqueNS.SingleParam

class ParamCollection

  constructor:(locationHash) ->
    @removeAll()
    return if @_StringIsEmpty(locationHash)

    locationHash=locationHash.replace("#","")

    for hashParam in locationHash.split("&")
      param=undefined
      if (SingleParam.is(hashParam))
        param=SingleParam.createFrom(hashParam)
      else if (RangeParam.is(hashParam))
        param=RangeParam.createFrom(hashParam)
      else
        param=ArrayParam.createFrom(hashParam)
      @add(param)

  _StringIsEmpty:(value)->
    return true if value is undefined
    return true if value.trim().length is 0
    return false

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


