describe "StringList", ->

  StringList=ObliqueNS.StringList

  beforeEach ->

  afterEach ->

  it "must read a simple param", ()->
    values=new StringList("100").toStringArray()
    expect(values[0]).toBe "100"
    expect(values.length).toBe 1

  it "must read another simple param", ()->
    values=new StringList("101").toStringArray()
    expect(values[0]).toBe "101"
    expect(values.length).toBe 1

  it "must read two simple params", ()->
    values=new StringList("101,102").toStringArray()
    expect(values[0]).toBe "101"
    expect(values[1]).toBe "102"
    expect(values.length).toBe 2

  it "must read two simple params as int", ()->
    values=new StringList("101,102").toIntArray()
    expect(values[0]).toBe 101
    expect(values[1]).toBe 102
    expect(values.length).toBe 2

  it "must read two simple params semicolon separated", ()->
    values=new StringList("101;102",";").toIntArray()
    expect(values[0]).toBe 101
    expect(values[1]).toBe 102
    expect(values.length).toBe 2

  it "must read letter list as Int as zeros", ()->
    values=new StringList("A, B").toIntArray()
    expect(values[0]).toBe 0
    expect(values[1]).toBe 0
    expect(values.length).toBe 2
