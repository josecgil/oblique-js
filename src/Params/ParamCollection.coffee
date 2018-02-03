@.ObliqueNS=@.ObliqueNS or {}

ParamParser=ObliqueNS.ParamParser
ArrayParam=ObliqueNS.ArrayParam
RangeParam=ObliqueNS.RangeParam
SingleParam=ObliqueNS.SingleParam
EmptyParam=ObliqueNS.EmptyParam

class ParamCollection

  constructor:(locationHash) ->
    @removeAll()
    return if @_StringIsEmpty(locationHash)

    paramParser=new ParamParser locationHash


    for hashParam in paramParser.hashParams
      hashParam=decodeURIComponent(hashParam);
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
    hash = "#"
    for paramName, param of @_params
      continue if param is undefined
      hash += param.getLocationHash() + "&"

    if (hash.length isnt 1)
      hash=hash.substr(0,hash.length-1)

    hash="#_" if hash is "#"
    hash

  _isEmpty:(paramCollection) ->
    return true if paramCollection is undefined
    return paramCollection.isEmpty()

  hasSameParams:(other) ->
    me = this
    me = new ParamCollection() if @_isEmpty(me)
    other = new ParamCollection() if @_isEmpty(other)

    meAsStr=me.getLocationHash()
    otherAsStr=other.getLocationHash()

    meAsStr is otherAsStr


ObliqueNS.ParamCollection=ParamCollection