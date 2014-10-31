@.ObliqueNS=@.ObliqueNS or {}

ArrayParam=ObliqueNS.ArrayParam
RangeParam=ObliqueNS.RangeParam
SingleParam=ObliqueNS.SingleParam
EmptyParam=ObliqueNS.EmptyParam

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
      else if (ArrayParam.is(hashParam))
        param=ArrayParam.createFrom(hashParam)
      else
        param=new EmptyParam()

      @add(param)

  _StringIsEmpty:(value)->
    return true if value is undefined
    return true if value.trim().length is 0
    return false

  add:(param)->
    @_params[param.name.toLowerCase()]=param
    param

  addSingleParam:(name, value)->
    @add new SingleParam(name, value)

  addRangeParam:(name, min, max)->
    @add new RangeParam(name, min, max)

  addArrayParam:(name, values)->
    @add new ArrayParam(name, values)

  remove:(paramName)->
    @_params[paramName]=undefined

  removeAll: ->
    @_params={}

  getParam:(paramName)->
    param=@_params[paramName.toLowerCase()]
    return new EmptyParam() if param is undefined
    param

  find:(paramNames)->
    lowerCaseParamNames = (param.toLowerCase() for param in paramNames)

    foundedParamCollection=new ParamCollection()
    for paramName, param of @_params
      if (not @_isEmptyParam(param)) and (paramName.toLowerCase() in lowerCaseParamNames)
        foundedParamCollection.add param
    foundedParamCollection

  isEmpty:->
    return true if @count() is 0
    false

  count: ->
    count = 0
    for paramName, param of @_params
      count++ if not @_isEmptyParam(param)
    count

  _isEmptyParam: (param)  ->
    return true if param is undefined
    return param.isEmpty()

  getLocationHash: ->
    return "" if @count() is 0

    hash = "#"
    for paramName, param of @_params
      continue if param.isEmpty()

      hash += param.getLocationHash() + "&"

    hash=hash.substr(0,hash.length-1)
    hash

ObliqueNS.ParamCollection=ParamCollection


