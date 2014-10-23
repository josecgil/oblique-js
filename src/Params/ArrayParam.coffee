@.ObliqueNS=@.ObliqueNS or {}

Param=ObliqueNS.Param

class ArrayParam extends ObliqueNS.Param

  constructor:(@name, values)->
    super(@name)
    if not @_isArray(values)
      throw new ObliqueNS.Error("Param constructor must be called with second param array")
    @values=[]
    for value in values
      @add value

  _isArray:(value)->
    return true if Object.prototype.toString.call(value) is '[object Array]'
    false

  add:(value)->
    if (not @_isString(value))
      throw new ObliqueNS.Error("Array param must be an string")
    @values.push value

  remove:(value)->
    index=@values.indexOf value
    return if index is -1
    @values.splice index, 1
    @values=undefined if @count() is 0

  isEmpty:() ->
    return true if @values is undefined
    return true if @count() is 0
    return false

  getLocationHash: ->
    return "" if @count() is 0
    hash = "#{@name}=["
    for value in @values
      hash += "#{value},"
    hash = hash.substr(0,hash.length-1)
    hash += "]"

  count:->
    @values.length

  @createFrom:(strHashParam)->
    hashParam=Param.parse(strHashParam)
    value=hashParam.value.replace("[","").replace("]","")
    values=value.split(",")
    trimmedValues=[]
    for value in values
      trimmedValues.push value.trim()

    new ArrayParam(hashParam.name, trimmedValues)


ObliqueNS.ArrayParam=ArrayParam