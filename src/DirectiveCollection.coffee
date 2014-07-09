@.ObliqueNS=@.ObliqueNS or {}

class DirectiveCollection

  constructor:()->
    @directives=[]
    @_directivesByName={}

  count:() ->
    @directives.length

  _isAFunction: (memberToTest) ->
    typeof (memberToTest) is "function"

  @NOT_A_FUNCTION_CLASS_ERROR_MESSAGE = "registerDirective must be called with a Directive 'Constructor/Class'"

  _throwErrorIfDirectiveIsNotValid: (directiveName, directive) ->
    if not directiveName or typeof directiveName isnt "string"
      throw new ObliqueNS.Error("registerDirective must be called with a string directiveName")
    if not @_isAFunction(directive)
      throw new ObliqueNS.Error(ObliqueNS.DirectiveCollection.NOT_A_FUNCTION_CLASS_ERROR_MESSAGE)

  add:(directiveName, directiveFn) ->
    @_throwErrorIfDirectiveIsNotValid(directiveName, directiveFn)

    @directives.push directiveFn
    @_directivesByName[directiveName]=directiveFn

  at:(index)->
    @directives[index]

  getDirectiveByName : (directiveName) ->
    @_directivesByName[directiveName]

ObliqueNS.DirectiveCollection=DirectiveCollection

