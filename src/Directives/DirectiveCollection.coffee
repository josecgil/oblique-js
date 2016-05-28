@.ObliqueNS=@.ObliqueNS or {}

class DirectiveCollection

  constructor:()->
    @_directives={}

  _toKeyName:(str)->
    return null if not str
    str.trim().toLowerCase()

  add:(directive)->
    @_directives[@_toKeyName(directive.name)]=directive

  count:() ->
    len=0
    @each(->len++)
    len

  findByName:(name) ->
    @_directives[@_toKeyName(name)]

  each:(callback) ->
    index=0
    for key, value of @_directives
      callback(value, index)
      index++

ObliqueNS.DirectiveCollection=DirectiveCollection



