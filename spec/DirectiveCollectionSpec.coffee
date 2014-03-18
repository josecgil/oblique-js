describe "DirectiveCollection", ->

  DirectiveCollection=ObliqueNS.DirectiveCollection
  ObError=ObliqueNS.Error

  beforeEach () ->

  afterEach ->

  it "must be empty when created", () ->
    directives=new DirectiveCollection()
    expect(directives.count()).toBe 0

  it "must has 1 item when I added one Directive", () ->
    class TestDirective
      constructor: ()->
      @CSS_EXPRESSION = ".test"

    directives=new DirectiveCollection()
    directives.add TestDirective
    expect(directives.count()).toBe 1
    expect(directives.at(0)).toBe(TestDirective)

  it "must return 2 CSSExpressions when I added 2 Directive with different CSSExpressions", () ->
    class TestDirective
      constructor: ()->

      @CSS_EXPRESSION = ".test"

    class TestDirective2
      constructor: ()->

      @CSS_EXPRESSION = ".test2"

    directives=new DirectiveCollection()
    directives.add TestDirective
    directives.add TestDirective2

    cssExpressions=directives.getCSSExpressions()

    expect(cssExpressions.length).toBe 2
    expect(cssExpressions[0]).toBe TestDirective.CSS_EXPRESSION
    expect(cssExpressions[1]).toBe TestDirective2.CSS_EXPRESSION


  it "must return 1 CSSExpressions when I added 2 Directive with same CSSExpressions", () ->
    class TestDirective
      constructor: ()->

      @CSS_EXPRESSION = ".test"

    class TestDirective2
      constructor: ()->

      @CSS_EXPRESSION = ".test"

    directives=new DirectiveCollection()
    directives.add TestDirective
    directives.add TestDirective2

    cssExpressions=directives.getCSSExpressions()

    expect(cssExpressions.length).toBe 1
    expect(cssExpressions[0]).toBe TestDirective.CSS_EXPRESSION

  it "must return all directives that have a CSSExpressions", () ->
    class TestDirective
      constructor: ()->

      @CSS_EXPRESSION = ".test"

    class TestDirective2
      constructor: ()->

      @CSS_EXPRESSION = ".test"

    class TestDirective3
      constructor: ()->

      @CSS_EXPRESSION = ".test2"

    directives=new DirectiveCollection()
    directives.add TestDirective
    directives.add TestDirective2
    directives.add TestDirective3

    expect(directives.getDirectivesByCSSExpression(".test").length).toBe 2
    expect(directives.getDirectivesByCSSExpression(".test2").length).toBe 1

  it "If I add a Directive without CSS_EXPRESSION it throws an Error", ()->
    class TestDirective
    directivesCollection=new DirectiveCollection()
    expect(->
      directivesCollection.add TestDirective
    ).toThrow(new ObError("directive must has an static CSS_EXPRESSION property"))

  it "If I add an object that no is a Directive it throws an Error", ()->
    directivesCollection=new DirectiveCollection()
    expect(->
      directivesCollection.add {}
    ).toThrow(new ObError("registerDirective must be called with a Directive 'Constructor/Class'"))
