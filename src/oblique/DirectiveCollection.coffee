class @DirectiveCollection
  constructor:()->
    @directives=[]

  count:() ->
    @directives.length

  add:(directive) ->
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

  getDirectivesBy: (cssExpression) ->
    directivesWithCSSExpr=[]
    for directive in @directives
      cssExpr = directive.CSS_EXPRESSION
      continue if cssExpr isnt cssExpression
      directivesWithCSSExpr.push directive
    directivesWithCSSExpr