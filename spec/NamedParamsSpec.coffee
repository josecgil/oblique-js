describe "NamedParams", ->

  NamedParams=ObliqueNS.NamedParams

  beforeEach ->

  afterEach ->

  it "must read a simple named param", ()->
    widthValue=new NamedParams("width:100").getParam("width").valueAsInt()
    expect(widthValue).toBe 100

  it "must read another simple named param", ()->
    widthValue=new NamedParams("width:50").getParam("width").valueAsInt()
    expect(widthValue).toBe 50

  it "must read two named param", ()->
    namedParams=new NamedParams "width:1; height:2"
    expect(namedParams.getParam("width").valueAsInt()).toBe 1
    expect(namedParams.getParam("height").valueAsInt()).toBe 2

  it "must read two named params with spaces", ()->
    namedParams=new NamedParams "  width :   1  ; height:  2   "
    expect(namedParams.getParam("width").valueAsInt()).toBe 1
    expect(namedParams.getParam("height").valueAsInt()).toBe 2

  it "must read two named params without spaces", ()->
    namedParams=new NamedParams "width:1;height:2"
    expect(namedParams.getParam("width").valueAsInt()).toBe 1
    expect(namedParams.getParam("height").valueAsInt()).toBe 2

  it "must read two named params separated with | instead of ;", ()->
    namedParams=new NamedParams "width:1|height:2", "|"
    expect(namedParams.getParam("width").valueAsInt()).toBe 1
    expect(namedParams.getParam("height").valueAsInt()).toBe 2

  it "must read two named params/values separated with = instead of :", ()->
    namedParams=new NamedParams "width=1;height=2", ";", "="
    expect(namedParams.getParam("width").valueAsInt()).toBe 1
    expect(namedParams.getParam("height").valueAsInt()).toBe 2
