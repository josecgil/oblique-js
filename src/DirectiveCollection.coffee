@.ObliqueNS=@.ObliqueNS or {}

class DirectiveCollection

  constructor:()->
    @directives=[]
    @_cssExpressions=[]

  count:() ->
    @directives.length

  _isAFunction: (memberToTest) ->
    typeof (memberToTest) is "function"

  @NOT_A_FUNCTION_CLASS_ERROR_MESSAGE = "registerDirective must be called with a Directive 'Constructor/Class'"
  @DOESNT_HAVE_PROPERTY_CSS_EXPR_MESSAGE = "directive must has an static CSS_EXPRESSION property"

  _throwErrorIfDirectiveIsNotValid: (directive) ->
    if not @_isAFunction(directive)
      throw new ObliqueNS.Error(ObliqueNS.DirectiveCollection.NOT_A_FUNCTION_CLASS_ERROR_MESSAGE)
    if not directive.CSS_EXPRESSION
      throw new ObliqueNS.Error(ObliqueNS.DirectiveCollection.DOESNT_HAVE_PROPERTY_CSS_EXPR_MESSAGE)

  _hashCode: (str) ->
    hash = 0
    i = undefined
    chr = undefined
    len = undefined
    return hash if str.length is 0
    i = 0
    len = str.length

    while i < len
      chr = str.charCodeAt(i)
      hash = ((hash << 5) - hash) + chr
      hash |= 0
      i++
    hash

  add:(directive) ->
    @_throwErrorIfDirectiveIsNotValid(directive)

    directive.hashCode=@_hashCode(directive.toString()+directive.CSS_EXPRESSION).toString()

    @directives.push directive

    #pre-calc this when adding a Directive for fast access
    @_buildCSSExpressions()

  at:(index)->
    @directives[index]

  _containsCssExpr: (exprToSearch, exprArray) ->
    for expr in exprArray
      return true if exprToSearch is expr
    false

  _buildCSSExpressions : ->
    @_cssExpressions=[]
    for directive in @directives
      cssExpr = directive.CSS_EXPRESSION
      continue if @_containsCssExpr cssExpr, @_cssExpressions
      @_cssExpressions.push cssExpr

  getCSSExpressions : ->
    @_cssExpressions

  getDirectivesByCSSExpression: (cssExpression) ->
    directivesWithCSSExpr=[]
    for directive in @directives
      cssExpr = directive.CSS_EXPRESSION
      continue if cssExpr isnt cssExpression
      directivesWithCSSExpr.push directive
    directivesWithCSSExpr

ObliqueNS.DirectiveCollection=DirectiveCollection