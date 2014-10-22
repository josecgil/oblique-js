@.ObliqueNS=@.ObliqueNS or {}

class ArrayParam

  constructor:(@name, @values)->
    @length=@values.length

  add:(value)->
    @values.push value
    @length=@values.length

  remove:(value)->
    index=@values.indexOf value
    return if index is -1
    @values.splice index, 1
    @length=@values.length
    @values=undefined if @length is 0

  isEmpty:() ->
    return true if @values is undefined
    return true if @length is 0
    return false

  getLocationHash: ->
    return "" if @length is 0
    hash = "#{@name}=["
    for value in @values
      hash += "#{value},"
    hash = hash.substr(0,hash.length-1)
    hash += "]"

ObliqueNS.ArrayParam=ArrayParam