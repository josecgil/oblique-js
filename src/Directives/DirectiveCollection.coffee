@.ObliqueNS=@.ObliqueNS or {}

class DirectiveCollection

  constructor:()->
    @_directives={}

  add:(directive)->
    @_directives[directive.name]=directive

  count:() ->
    len=0
    @each(->len++)
    len

  findByName:(name) ->
    @_directives[name]

  each:(callback) ->
    index=0
    for key, value of @_directives
      callback(value, index)
      index++

ObliqueNS.DirectiveCollection=DirectiveCollection



