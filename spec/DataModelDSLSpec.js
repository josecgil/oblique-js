// Generated by CoffeeScript 1.7.1
(function() {
  describe("DataModelDSL", function() {
    var DataModelDSL;
    beforeEach(function() {});
    afterEach(function() {});
    DataModelDSL = ObliqueNS.DataModelDSL;
    it("must know if it's only a model", function() {
      var dataModelParser;
      return dataModelParser = new DataModelDSL("Model");
    });
    it("must know if it's not a model when empty string", function() {
      return expect(function() {
        var dataModelParser;
        return dataModelParser = new DataModelDSL("");
      }).toThrow(new ObliqueNS.Error("data-model can't be null or empty"));
    });
    it("must know if it's not a model when undefined", function() {
      return expect(function() {
        var dataModelParser;
        return dataModelParser = new DataModelDSL(void 0);
      }).toThrow(new ObliqueNS.Error("data-model can't be null or empty"));
    });
    it("must know if it's not a model when null", function() {
      return expect(function() {
        var dataModelParser;
        return dataModelParser = new DataModelDSL(null);
      }).toThrow(new ObliqueNS.Error("data-model can't be null or empty"));
    });
    it("must know if it's not a model when a string doesn't begins with 'Model or new'", function() {
      return expect(function() {
        return new DataModelDSL("patata");
      }).toThrow(new ObliqueNS.Error("data-model must begins with 'Model or new'"));
    });
    it("must know if it's not a model when another string doesn't begins with 'Model'", function() {
      return expect(function() {
        return new DataModelDSL("model");
      }).toThrow(new ObliqueNS.Error("data-model must begins with 'Model or new'"));
    });
    it("must know if it's a model when is complex and begins with 'Model'", function() {
      return new DataModelDSL("Model.Colors");
    });
    it("must know if its not a model when begins with 'Model.'", function() {
      return expect(function() {
        return new DataModelDSL("Model.");
      }).toThrow(new ObliqueNS.Error("data-model needs property after dot"));
    });
    it("must know if its not a model when begins with 'Model.Colors.'", function() {
      return expect(function() {
        return new DataModelDSL("Model.Colors.");
      }).toThrow(new ObliqueNS.Error("data-model needs property after dot"));
    });
    it("must understand a simple property", function() {
      var dataModelDSL;
      dataModelDSL = new DataModelDSL("Model.Description");
      expect(dataModelDSL.modelProperties.length).toBe(1);
      return expect(dataModelDSL.modelProperties[0].name).toBe("Description");
    });
    it("must understand a more complex property", function() {
      var dataModelDSL;
      dataModelDSL = new DataModelDSL("Model.Address.Number");
      expect(dataModelDSL.modelProperties.length).toBe(2);
      expect(dataModelDSL.modelProperties[0].name).toBe("Address");
      return expect(dataModelDSL.modelProperties[1].name).toBe("Number");
    });
    it("must understand a very complex property", function() {
      var dataModelDSL;
      dataModelDSL = new DataModelDSL("Model.Cart.Promotion.Id");
      expect(dataModelDSL.modelProperties.length).toBe(3);
      expect(dataModelDSL.modelProperties[0].name).toBe("Cart");
      expect(dataModelDSL.modelProperties[1].name).toBe("Promotion");
      return expect(dataModelDSL.modelProperties[2].name).toBe("Id");
    });
    it("must understand an indexed property", function() {
      var dataModelDSL;
      dataModelDSL = new DataModelDSL("Model.Colors[0].Sizes");
      expect(dataModelDSL.modelProperties.length).toBe(2);
      expect(dataModelDSL.modelProperties[0].name).toBe("Colors");
      expect(dataModelDSL.modelProperties[0].hasIndex).toBeTruthy();
      expect(dataModelDSL.modelProperties[0].index).toBe(0);
      return expect(dataModelDSL.modelProperties[1].name).toBe("Sizes");
    });
    it("must understand another indexed property", function() {
      var dataModelDSL;
      dataModelDSL = new DataModelDSL("Model.Colors[1000]");
      expect(dataModelDSL.modelProperties.length).toBe(1);
      expect(dataModelDSL.modelProperties[0].name).toBe("Colors");
      expect(dataModelDSL.modelProperties[0].hasIndex).toBeTruthy();
      return expect(dataModelDSL.modelProperties[0].index).toBe(1000);
    });
    it("must understand that is full Model", function() {
      var dataModelDSL;
      dataModelDSL = new DataModelDSL("Model");
      expect(dataModelDSL.hasFullModel).toBeTruthy();
      return expect(dataModelDSL.modelProperties).toBeUndefined();
    });
    it("must understand that isnt full Model when model has parts", function() {
      var dataModelDSL;
      dataModelDSL = new DataModelDSL("Model.Colors");
      expect(dataModelDSL.hasFullModel).toBeFalsy();
      return expect(dataModelDSL.modelProperties).toBeDefined();
    });
    it("must understand that isnt full Model when doesn't has model", function() {
      var dataModelDSL;
      dataModelDSL = new DataModelDSL("new Settings()");
      expect(dataModelDSL.hasFullModel).toBeFalsy();
      return expect(dataModelDSL.modelProperties).toBeUndefined();
    });
    it("must know if it's a model when begins with 'new'", function() {
      return new DataModelDSL("new ColorJSCollection()");
    });
    it("must undefine modelProperties when is only object", function() {
      var dataModelDSL;
      dataModelDSL = new DataModelDSL("new ColorJSCollection()");
      return expect(dataModelDSL.modelProperties).toBeUndefined();
    });
    it("must undefine className when is only model", function() {
      var dataModelDSL;
      dataModelDSL = new DataModelDSL("Model");
      return expect(dataModelDSL.className).toBeUndefined();
    });
    it("must know className when is only object", function() {
      var dataModelDSL;
      dataModelDSL = new DataModelDSL("new ColorJSCollection()");
      return expect(dataModelDSL.className).toBe("ColorJSCollection");
    });
    it("must know if has brackets", function() {
      return expect(function() {
        return new DataModelDSL("new ColorJSCollection");
      }).toThrow(new ObliqueNS.Error("data-model needs open bracket after className"));
    });
    it("must know className & model when is object & model", function() {
      var dataModelDSL;
      dataModelDSL = new DataModelDSL("new ColorJSCollection(Model.Colors)");
      expect(dataModelDSL.className).toBe("ColorJSCollection");
      expect(dataModelDSL.modelProperties[0].name).toBe("Colors");
      return expect(dataModelDSL.modelProperties.length).toBe(1);
    });
    it("must know if start bracket are correct", function() {
      return expect(function() {
        return new DataModelDSL("new ColorJSCollection(");
      }).toThrow(new ObliqueNS.Error("data-model needs close bracket after className"));
    });
    return it("must know if end bracket are correct", function() {
      return expect(function() {
        return new DataModelDSL("new ColorJSCollection)");
      }).toThrow(new ObliqueNS.Error("data-model needs open bracket after className"));
    });
  });

}).call(this);
