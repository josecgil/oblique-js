// Generated by CoffeeScript 1.7.1
(function() {
  describe("DataModelVariable", function() {
    var DataModelVariable;
    beforeEach(function() {});
    afterEach(function() {});
    DataModelVariable = ObliqueNS.DataModelVariable;
    it("must know variable name when local variable is set", function() {
      var dataModelVariable;
      dataModelVariable = new DataModelVariable("var number=32");
      return expect(dataModelVariable.name).toBe("number");
    });
    it("must know variable name when another local variable is set", function() {
      var dataModelVariable;
      dataModelVariable = new DataModelVariable("var patata='patataValue'");
      return expect(dataModelVariable.name).toBe("patata");
    });
    it("must know variable name when global variable is set", function() {
      var dataModelVariable;
      dataModelVariable = new DataModelVariable("number=32");
      return expect(dataModelVariable.name).toBe("number");
    });
    it("must know variable name when local variable is set with new object", function() {
      var dataModelVariable;
      dataModelVariable = new DataModelVariable("var currentDate=new Date()");
      return expect(dataModelVariable.name).toBe("currentDate");
    });
    it("must know if variable is set", function() {
      var dataModelVariable;
      dataModelVariable = new DataModelVariable("var currentDate=new Date()");
      return expect(dataModelVariable.isSet).toBeTruthy();
    });
    it("must know if simple variable is set", function() {
      var dataModelVariable;
      dataModelVariable = new DataModelVariable("var number=32");
      return expect(dataModelVariable.isSet).toBeTruthy();
    });
    it("must know if variable is not set", function() {
      var dataModelVariable;
      dataModelVariable = new DataModelVariable("number");
      return expect(dataModelVariable.isSet).toBeFalsy();
    });
    it("must know if variable is not set when comparison expression", function() {
      var dataModelVariable;
      dataModelVariable = new DataModelVariable("number==32");
      return expect(dataModelVariable.isSet).toBeFalsy();
    });
    it("must know if variable is not set when strict comparison expression", function() {
      var dataModelVariable;
      dataModelVariable = new DataModelVariable("number===32");
      return expect(dataModelVariable.isSet).toBeFalsy();
    });
    return it("must know if variable is not set when comparison expression", function() {
      var dataModelVariable;
      dataModelVariable = new DataModelVariable("is32=(number==32)");
      return expect(dataModelVariable.isSet).toBeTruthy();
    });
  });

}).call(this);