class @DirectiveCollection
  constructor:()->
    @directives=[]

  count:() ->
    @directives.length

  _isAFunction: (memberToTest) ->
    typeof (memberToTest) is "function"

  NOT_A_FUNCTION_CLASS_ERROR_MESSAGE = "registerDirective must be called with a Directive 'Constructor/Class'"
  DOESNT_HAVE_PROPERTY_CSS_EXPR_MESSAGE = "directive must has an static CSS_EXPRESSION property"

  _throwErrorIfDirectiveIsNotValid: (directive) ->
    throw ObliqueError(NOT_A_FUNCTION_CLASS_ERROR_MESSAGE) if not @_isAFunction(directive)
    throw ObliqueError(DOESNT_HAVE_PROPERTY_CSS_EXPR_MESSAGE) if not directive.CSS_EXPRESSION

  add:(directive) ->
    @_throwErrorIfDirectiveIsNotValid(directive)
    @directives.push directive

  at:(index)->
    @directives[index]

  _containsCssExpr: (exprToSearch, exprArray) ->
    for expr in exprArray
      return true if exprToSearch is expr
    false

  getCSSExpressions: ->
    cssExpressions=[]
    for directive in @directives
      cssExpr = directive.CSS_EXPRESSION
      continue if @_containsCssExpr cssExpr, cssExpressions
      cssExpressions.push cssExpr
    cssExpressions

  getDirectivesByCSSExpression: (cssExpression) ->
    directivesWithCSSExpr=[]
    for directive in @directives
      cssExpr = directive.CSS_EXPRESSION
      continue if cssExpr isnt cssExpression
      directivesWithCSSExpr.push directive
    directivesWithCSSExpr