describe "CallbackCollection", ->

  CallbackCollection=ObliqueNS.CallbackCollection
  ObError=ObliqueNS.Error

  it "must be empty when created", () ->
    directives=new CallbackCollection()
    expect(directives.count()).toBe 0

  it "must has 1 item when I added one Directive", () ->
    class TestDirective
      constructor: ()->

    directives=new CallbackCollection()
    directives.add "TestDirective", TestDirective
    expect(directives.count()).toBe 1
    expect(directives.at(0)).toBe(TestDirective)


  it "If I add an object that not is a Directive it throws an Error", ()->
    directivesCollection=new CallbackCollection()
    expect(->
      directivesCollection.add "Test", {}
    ).toThrow(new ObError("registerDirective must be called with a Directive 'Constructor/Class'"))

  it "must return a directive by his name", () ->
    class TestDirective
      constructor: ()->

    class TestDirective2
      constructor: ()->


    directives=new CallbackCollection()
    directives.add "TestDirective", TestDirective
    directives.add "TestDirective2", TestDirective2

    expect(directives.getCallbackByName("TestDirective")).toBe TestDirective

  it "must iterate by it's directives", (done) ->
    class TestDirective
      constructor: ()->

    class TestDirective2
      constructor: ()->

    directives=new CallbackCollection()
    directives.add "TestDirective", TestDirective
    directives.add "TestDirective2", TestDirective2
    count=0
    directives.each (directiveName, directiveFn)->
      if count is 0
        expect(directiveName).toBe "TestDirective"
        expect(directiveFn).toBe TestDirective
      if count is 1
        expect(directiveName).toBe "TestDirective2"
        expect(directiveFn).toBe TestDirective2
      done() if count is 1
      count++
