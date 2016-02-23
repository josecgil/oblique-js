describe "Directive", ->

  Directive=ObliqueNS.Directive

  it "must create a simple Directive with default values", () ->
    class SampleDirective
      constructor:()->

    directive=new Directive("SampleDirective", SampleDirective)
    expect(directive.name).toBe("SampleDirective")
    expect(directive.callback).toBe(SampleDirective)
    expect(directive.isGlobal).toBeFalsy()

  it "must create a global Directive via constructor", () ->
    class SampleDirective
      constructor:()->

    directive=new Directive("SampleDirective", SampleDirective, true)
    expect(directive.name).toBe("SampleDirective")
    expect(directive.callback).toBe(SampleDirective)
    expect(directive.isGlobal).toBeTruthy()

  it "must throw an error if created without params", () ->
    class SampleDirective
      constructor:()->
    expect(->
      new Directive()
    ).toThrow(new ObliqueNS.Error("Directive name must be an string"))

  it "must throw an error if created without a proper callback", () ->
    class SampleDirective
      constructor:()->
    expect(->
      new Directive("SampleDirective", 1)
    ).toThrow(new ObliqueNS.Error("Directive must be called with a 'Constructor Function/Class' param"))


