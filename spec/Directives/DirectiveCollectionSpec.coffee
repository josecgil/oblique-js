describe "DirectiveCollection", ->

  Directive=ObliqueNS.Directive
  DirectiveCollection=ObliqueNS.DirectiveCollection

  it "must be empty when created", () ->
    directives=new DirectiveCollection()
    expect(directives.count()).toBe 0

  it "must be count=1 when added 1 Directive", () ->
    class SampleDirective
      constructor:()->

    directives=new DirectiveCollection()
    directives.add new Directive("SampleDirective", SampleDirective)
    expect(directives.count()).toBe 1

  it "must iterate on each directive added", () ->
    class SampleDirective
      constructor:()->

    class SampleDirective2
      constructor:()->

    directives=new DirectiveCollection()
    directives.add new Directive("SampleDirective", SampleDirective)
    directives.add new Directive("SampleDirective2", SampleDirective2)

    expect(directives.count()).toBe 2

    directives.each(
      (directive, index)->
        if index is 0
          expect(directive.name).toBe "SampleDirective"
          expect(directive.callback).toBe SampleDirective
        if index is 1
          expect(directive.name).toBe "SampleDirective2"
          expect(directive.callback).toBe SampleDirective2
    )

  it "must return a directive by name", () ->
    class SampleDirective3
      constructor:()->

    class SampleDirective4
      constructor:()->

    directives=new DirectiveCollection()
    directives.add new Directive("SampleDirective3", SampleDirective3)
    directives.add new Directive("SampleDirective4", SampleDirective4)

    directive=directives.findByName("SampleDirective3")
    expect(directive.name).toBe "SampleDirective3"
    expect(directive.callback).toBe SampleDirective3
    expect(directive.isGlobal).toBeFalsy()
