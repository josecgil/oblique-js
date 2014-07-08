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

  _throwErrorIfDirectiveIsNotValid: (directive) ->
    if not @_isAFunction(directive)
      throw new ObliqueNS.Error(ObliqueNS.DirectiveCollection.NOT_A_FUNCTION_CLASS_ERROR_MESSAGE)

  add:(directive) ->
    @_throwErrorIfDirectiveIsNotValid(directive)

    @directives.push directive


  at:(index)->
    @directives[index]

  stringStartsWith : (str, strBegin) ->
    str.slice(0, strBegin.length) is strBegin

  getDirectiveByName : (directiveName) ->
    for directive in @directives
      return directive if @stringStartsWith(directive.toString(), "function #{directiveName}(")
    undefined



ObliqueNS.DirectiveCollection=DirectiveCollection

