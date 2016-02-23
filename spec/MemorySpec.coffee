describe "Memory", ->

  beforeEach () ->

  afterEach ->

  Memory=ObliqueNS.Memory

  it "must return empty script when there is no variables", () ->
    memory=new Memory()
    expect(memory.localVarsScript()).toBe ""

  it "must return script with one var when there is one var", () ->
    memory=new Memory()
    memory.setVar("name","Carlos")
    expect(memory.localVarsScript()).toBe "var name=this._memory.getVar(\"name\");"

  it "must return script with one var when there is one var (number)", () ->
    memory=new Memory()
    memory.setVar("num",32)
    expect(memory.localVarsScript()).toBe "var num=this._memory.getVar(\"num\");"

  it "must return script with one var when there is one var (instance of Date)", () ->
    memory=new Memory()
    memory.setVar("date",new Date(2014,0,31))
    script = memory.localVarsScript()
    expect(script).toBe "var date=this._memory.getVar(\"date\");"
    this._memory=memory
    eval(script)
    this._memory=undefined
    expect(date.getFullYear()).toBe 2014
    expect(date.getMonth()).toBe 0
    expect(date.getDate()).toBe 31

  it "must return script with two vars when there is two vars", () ->
    memory=new Memory()
    memory.setVar("name","Cristina")
    memory.setVar("surname","Cirera")
    expect(memory.localVarsScript()).toBe 'var name=this._memory.getVar(\"name\");var surname=this._memory.getVar(\"surname\");'

  it "must throw an error if variable name is Model", () ->
    memory=new Memory()
    expect(->
      memory.setVar("Model","value")
    ).toThrow(new ObliqueNS.Error("Can't create a variable named 'Model', is a reserved word"))



