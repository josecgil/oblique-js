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

    directives=new DirectiveCollection()
    directives.add "TestDirective", TestDirective
    expect(directives.count()).toBe 1
    expect(directives.at(0)).toBe(TestDirective)


  it "If I add an object that not is a Directive it throws an Error", ()->
    directivesCollection=new DirectiveCollection()
    expect(->
      directivesCollection.add "Test", {}
    ).toThrow(new ObError("registerDirective must be called with a Directive 'Constructor/Class'"))

  it "must return al directive by his name", () ->
    class TestDirective
      constructor: ()->

    class TestDirective2
      constructor: ()->


    directives=new DirectiveCollection()
    directives.add "TestDirective", TestDirective
    directives.add "TestDirective2", TestDirective2

    expect(directives.getDirectiveByName("TestDirective")).toBe TestDirective
