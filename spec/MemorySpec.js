// Generated by CoffeeScript 1.8.0
(function() {
  describe("Memory", function() {
    var Memory;
    beforeEach(function() {});
    afterEach(function() {});
    Memory = ObliqueNS.Memory;
    it("must return empty script when there is no variables", function() {
      var memory;
      memory = new Memory();
      return expect(memory.localVarsScript()).toBe("");
    });
    it("must return script with one var when there is one var", function() {
      var memory;
      memory = new Memory();
      memory.setVar("name", "Carlos");
      return expect(memory.localVarsScript()).toBe("var name=this._memory.getVar(\"name\");");
    });
    it("must return script with one var when there is one var (number)", function() {
      var memory;
      memory = new Memory();
      memory.setVar("num", 32);
      return expect(memory.localVarsScript()).toBe("var num=this._memory.getVar(\"num\");");
    });
    it("must return script with one var when there is one var (instance of Date)", function() {
      var memory, script;
      memory = new Memory();
      memory.setVar("date", new Date(2014, 0, 31));
      script = memory.localVarsScript();
      expect(script).toBe("var date=this._memory.getVar(\"date\");");
      this._memory = memory;
      eval(script);
      this._memory = void 0;
      expect(date.getFullYear()).toBe(2014);
      expect(date.getMonth()).toBe(0);
      return expect(date.getDate()).toBe(31);
    });
    it("must return script with two vars when there is two vars", function() {
      var memory;
      memory = new Memory();
      memory.setVar("name", "Cristina");
      memory.setVar("surname", "Cirera");
      return expect(memory.localVarsScript()).toBe('var name=this._memory.getVar(\"name\");var surname=this._memory.getVar(\"surname\");');
    });
    return it("must throw an error if variable name is Model", function() {
      var memory;
      memory = new Memory();
      return expect(function() {
        return memory.setVar("Model", "value");
      }).toThrow(new ObliqueNS.Error("Can't create a variable named 'Model', is a reserved word"));
    });
  });

}).call(this);
