// Generated by CoffeeScript 1.8.0
(function() {
  describe("ParamCollection", function() {
    var ArrayParam, EmptyParam, ObError, ParamCollection, RangeParam, SingleParam;
    ParamCollection = ObliqueNS.ParamCollection;
    ArrayParam = ObliqueNS.ArrayParam;
    RangeParam = ObliqueNS.RangeParam;
    SingleParam = ObliqueNS.SingleParam;
    EmptyParam = ObliqueNS.EmptyParam;
    ObError = ObliqueNS.Error;
    it("must return empty params when Hash is empty", function() {
      var paramCollection;
      paramCollection = new ParamCollection("");
      return expect(paramCollection.count()).toBe(0);
    });
    it("must count only one when I add same name param", function() {
      var paramCollection;
      paramCollection = new ParamCollection("");
      paramCollection.add(new SingleParam("sortBy", "descPrice"));
      paramCollection.add(new SingleParam("sortBy", "ascPrice"));
      return expect(paramCollection.count()).toBe(1);
    });
    it("must count each param as one", function() {
      var paramCollection;
      paramCollection = new ParamCollection("");
      paramCollection.add(new SingleParam("sortBy", "descPrice"));
      paramCollection.add(new RangeParam("price", "10", "49"));
      paramCollection.add(new ArrayParam("sizes", ["M"]));
      return expect(paramCollection.count()).toBe(3);
    });
    it("must setSingle a param", function() {
      var paramCollection;
      paramCollection = new ParamCollection("");
      paramCollection.add(new SingleParam("sortBy", "descPrice"));
      return expect(paramCollection.getParam("sortBy").value).toBe("descPrice");
    });
    it("must setSingle another param", function() {
      var paramCollection;
      paramCollection = new ParamCollection("");
      paramCollection.add(new SingleParam("numItems", "48"));
      return expect(paramCollection.getParam("numItems").value).toBe("48");
    });
    it("must re-setSingle a param", function() {
      var paramCollection;
      paramCollection = new ParamCollection("");
      paramCollection.add(new SingleParam("sortBy", "descPrice"));
      paramCollection.add(new SingleParam("sortBy", "ascPrice"));
      return expect(paramCollection.getParam("sortBy").value).toBe("ascPrice");
    });
    it("must setRange a param", function() {
      var paramCollection, priceParam;
      paramCollection = new ParamCollection("");
      paramCollection.add(new RangeParam("price", "10", "49"));
      priceParam = paramCollection.getParam("price");
      expect(priceParam.min).toBe("10");
      return expect(priceParam.max).toBe("49");
    });
    it("must re-setRange a param", function() {
      var paramCollection, priceParam;
      paramCollection = new ParamCollection("");
      paramCollection.add(new RangeParam("price", "10", "49"));
      paramCollection.add(new RangeParam("price", "0", "100"));
      priceParam = paramCollection.getParam("price");
      expect(priceParam.min).toBe("0");
      return expect(priceParam.max).toBe("100");
    });
    it("must know if value is between RangeParam values", function() {
      var priceParam;
      priceParam = new RangeParam("price", "10", "49");
      expect(priceParam.isInRange(15)).toBeTruthy();
      expect(priceParam.isInRange(9)).toBeFalsy();
      return expect(priceParam.isInRange(50)).toBeFalsy();
    });
    it("must add an array param", function() {
      var paramCollection, sizesParam;
      paramCollection = new ParamCollection("");
      paramCollection.add(new ArrayParam("sizes", ["M"]));
      sizesParam = paramCollection.getParam("sizes");
      expect(sizesParam.count()).toBe(1);
      return expect(sizesParam.values[0]).toBe("M");
    });
    it("must add a value to an already existing array param", function() {
      var paramCollection, sizesParam;
      paramCollection = new ParamCollection("");
      paramCollection.add(new ArrayParam("sizes", ["M"]));
      sizesParam = paramCollection.getParam("sizes");
      sizesParam.add("L");
      expect(sizesParam.count()).toBe(2);
      expect(sizesParam.values[0]).toBe("M");
      return expect(sizesParam.values[1]).toBe("L");
    });
    it("must remove an existent param", function() {
      var paramCollection;
      paramCollection = new ParamCollection("");
      paramCollection.add(new ArrayParam("sizes", ["M", "L"]));
      paramCollection.remove("sizes");
      return expect(paramCollection.getParam("sizes").isEmpty()).toBeTruthy();
    });
    it("must ignore remove an inexistent array param value", function() {
      var paramCollection, sizesParam;
      paramCollection = new ParamCollection("");
      paramCollection.add(new ArrayParam("sizes", ["L"]));
      sizesParam = paramCollection.getParam("sizes");
      sizesParam.remove("M");
      return expect(sizesParam.count()).toBe(1);
    });
    it("must remove an existent array param value", function() {
      var paramCollection, sizesParam;
      paramCollection = new ParamCollection("");
      paramCollection.add(new ArrayParam("sizes", ["M", "L"]));
      sizesParam = paramCollection.getParam("sizes");
      sizesParam.remove("M");
      return expect(sizesParam.count()).toBe(1);
    });
    it("must ignore remove an inexistent param name", function() {
      var paramCollection;
      paramCollection = new ParamCollection("");
      paramCollection.add(new ArrayParam("colors", ["rojo"]));
      paramCollection.remove("sizes");
      expect(paramCollection.count()).toBe(1);
      expect(paramCollection.getParam("colors")).toBeDefined();
      return expect(paramCollection.getParam("sizes").isEmpty()).toBeTruthy();
    });
    it("must clear a param by name", function() {
      var paramCollection;
      paramCollection = new ParamCollection("");
      paramCollection.add(new ArrayParam("sizes", ["XL"]));
      paramCollection.remove("sizes");
      return expect(paramCollection.getParam("sizes").isEmpty()).toBeTruthy();
    });
    it("must clear all params", function() {
      var paramCollection;
      paramCollection = new ParamCollection("");
      paramCollection.add(new ArrayParam("sizes", ["XL"]));
      paramCollection.add(new SingleParam("sort", "desc"));
      paramCollection.removeAll();
      return expect(paramCollection.count()).toBe(0);
    });
    it("must return location hash for single param", function() {
      var paramCollection;
      paramCollection = new ParamCollection("");
      paramCollection.add(new SingleParam("sort", "desc"));
      return expect(paramCollection.getLocationHash()).toBe("#sort=desc");
    });
    it("must return location hash for range param", function() {
      var paramCollection;
      paramCollection = new ParamCollection("");
      paramCollection.add(new RangeParam("price", "10", "100"));
      return expect(paramCollection.getLocationHash()).toBe("#price=(10,100)");
    });
    it("must return location hash for array param", function() {
      var paramCollection;
      paramCollection = new ParamCollection("");
      paramCollection.add(new ArrayParam("sizes", ["M", "L", "XL"]));
      return expect(paramCollection.getLocationHash()).toBe("#sizes=[M,L,XL]");
    });
    it("must return location hash for an array param of one", function() {
      var paramCollection;
      paramCollection = new ParamCollection("");
      paramCollection.add(new ArrayParam("sizes", ["M"]));
      return expect(paramCollection.getLocationHash()).toBe("#sizes=[M]");
    });
    it("must return location hash for an array param of zero", function() {
      var paramCollection;
      paramCollection = new ParamCollection("");
      paramCollection.add(new ArrayParam("sizes", []));
      return expect(paramCollection.getLocationHash()).toBe("#sizes");
    });
    it("must return location hash for 2 params", function() {
      var paramCollection;
      paramCollection = new ParamCollection("");
      paramCollection.add(new ArrayParam("sizes", ["M", "L"]));
      paramCollection.add(new SingleParam("sort", "desc"));
      return expect(paramCollection.getLocationHash()).toBe("#sizes=[M,L]&sort=desc");
    });
    it("must return location hash for 3 params", function() {
      var paramCollection;
      paramCollection = new ParamCollection("");
      paramCollection.add(new ArrayParam("sizes", ["M", "L"]));
      paramCollection.add(new RangeParam("price", "10", "40"));
      paramCollection.add(new SingleParam("sort", "desc"));
      return expect(paramCollection.getLocationHash()).toBe("#sizes=[M,L]&price=(10,40)&sort=desc");
    });
    it("must be undefined if I remove last array param value", function() {
      var paramCollection, sizesParam;
      paramCollection = new ParamCollection("");
      paramCollection.add(new ArrayParam("sizes", ["M"]));
      sizesParam = paramCollection.getParam("sizes");
      sizesParam.remove("M");
      return expect(sizesParam.values).toBeUndefined();
    });
    it("must return correct hash when I remove a param value", function() {
      var paramCollection;
      paramCollection = new ParamCollection("");
      paramCollection.add(new ArrayParam("sizes", ["M"]));
      paramCollection.remove("sizes");
      return expect(paramCollection.getLocationHash()).toBe("");
    });
    it("must return location hash for 0 params", function() {
      var paramCollection;
      paramCollection = new ParamCollection("");
      return expect(paramCollection.getLocationHash()).toBe("");
    });
    it("must throw an error if array param value is not an array", function() {
      return expect(function() {
        return new ArrayParam("sizes", "M");
      }).toThrow(new ObError("Param constructor must be called with second param array"));
    });
    it("must throw an error if array param name is not an string", function() {
      return expect(function() {
        return new ArrayParam(1, ["M"]);
      }).toThrow(new ObError("Param constructor must be called with first param string"));
    });
    it("must throw an error if single param name is not an string", function() {
      return expect(function() {
        return new SingleParam(1, "");
      }).toThrow(new ObError("Param constructor must be called with first param string"));
    });
    it("must throw an error if range param name is not an string", function() {
      return expect(function() {
        return new RangeParam(1, "1", "10");
      }).toThrow(new ObError("Param constructor must be called with first param string"));
    });
    it("must throw an error if single param value is not an string", function() {
      return expect(function() {
        return new SingleParam("sort", 1);
      }).toThrow(new ObError("Param constructor must be called with second param string"));
    });
    it("must throw an error if range param min is not an string", function() {
      return expect(function() {
        return new RangeParam("price", 10, "40");
      }).toThrow(new ObError("Param constructor must be called with second param string"));
    });
    it("must throw an error if range param max is not an string", function() {
      return expect(function() {
        return new RangeParam("price", "10", 40);
      }).toThrow(new ObError("Param constructor must be called with third param string"));
    });
    it("must throw an error if array param values are not string", function() {
      return expect(function() {
        return new ArrayParam("sizes", [101, 105]);
      }).toThrow(new ObError("Array param must be an string"));
    });
    it("must understand single param from location hash", function() {
      var paramCollection;
      paramCollection = new ParamCollection("#sort=desc");
      expect(paramCollection.count()).toBe(1);
      return expect(paramCollection.getParam("sort").value).toBe("desc");
    });
    it("must understand single param without value from location hash", function() {
      var paramCollection;
      paramCollection = new ParamCollection("#sort=");
      expect(paramCollection.count()).toBe(0);
      return expect(paramCollection.getParam("sort").isEmpty()).toBeTruthy();
    });
    it("must understand single param without = from location hash", function() {
      var paramCollection;
      paramCollection = new ParamCollection("#sort");
      expect(paramCollection.count()).toBe(0);
      return expect(paramCollection.getParam("sort").isEmpty()).toBeTruthy();
    });
    it("must understand two single param without = from location hash", function() {
      var paramCollection;
      paramCollection = new ParamCollection("#sort&prices");
      expect(paramCollection.count()).toBe(0);
      expect(paramCollection.getParam("sort").isEmpty()).toBeTruthy();
      return expect(paramCollection.getParam("prices").isEmpty()).toBeTruthy();
    });
    it("must understand 2 single params from location hash", function() {
      var paramCollection;
      paramCollection = new ParamCollection("#sort=desc&numItems=48");
      expect(paramCollection.count()).toBe(2);
      expect(paramCollection.getParam("sort").value).toBe("desc");
      return expect(paramCollection.getParam("numItems").value).toBe("48");
    });
    it("must understand 2 single params with whitespaces from location hash", function() {
      var paramCollection;
      paramCollection = new ParamCollection("# sort = desc & numItems = 48 ");
      expect(paramCollection.count()).toBe(2);
      expect(paramCollection.getParam("sort").value).toBe("desc");
      return expect(paramCollection.getParam("numItems").value).toBe("48");
    });
    it("must understand range param from location hash", function() {
      var paramCollection;
      paramCollection = new ParamCollection("#price=(10,20)");
      expect(paramCollection.count()).toBe(1);
      expect(paramCollection.getParam("price").min).toBe("10");
      return expect(paramCollection.getParam("price").max).toBe("20");
    });
    it("must understand array param from location hash", function() {
      var colorsValues, paramCollection;
      paramCollection = new ParamCollection("#colors=[rojo,azul]");
      expect(paramCollection.count()).toBe(1);
      colorsValues = paramCollection.getParam("colors").values;
      expect(colorsValues[0]).toBe("rojo");
      return expect(colorsValues[1]).toBe("azul");
    });
    it("must understand array param with whitespace values from location hash", function() {
      var colorsValues, paramCollection;
      paramCollection = new ParamCollection("#colors=[   rojo ,   azul ]");
      expect(paramCollection.count()).toBe(1);
      colorsValues = paramCollection.getParam("colors").values;
      expect(colorsValues[0]).toBe("rojo");
      return expect(colorsValues[1]).toBe("azul");
    });
    it("must understand range param with whitespace values from location hash", function() {
      var paramCollection;
      paramCollection = new ParamCollection("#price=(   10 , 20  )");
      expect(paramCollection.count()).toBe(1);
      expect(paramCollection.getParam("price").min).toBe("10");
      return expect(paramCollection.getParam("price").max).toBe("20");
    });
    it("must understand 3 different params from location hash", function() {
      var colorsValues, paramCollection;
      paramCollection = new ParamCollection("#colors=[rojo,azul]&price=(10,20)&sort=desc");
      expect(paramCollection.count()).toBe(3);
      colorsValues = paramCollection.getParam("colors").values;
      expect(colorsValues[0]).toBe("rojo");
      expect(colorsValues[1]).toBe("azul");
      expect(paramCollection.getParam("price").min).toBe("10");
      expect(paramCollection.getParam("price").max).toBe("20");
      return expect(paramCollection.getParam("sort").value).toBe("desc");
    });
    it("must return added param object when add", function() {
      var arrayParam, paramCollection;
      paramCollection = new ParamCollection("");
      arrayParam = paramCollection.add(new ArrayParam("sizes", ["M"]));
      expect(arrayParam.count()).toBe(1);
      return expect(arrayParam.values[0]).toBe("M");
    });
    it("must return Empty param object when param doesn't exists", function() {
      var param, paramCollection;
      paramCollection = new ParamCollection("");
      param = paramCollection.getParam("muggel");
      expect(param).toBeDefined();
      expect(param.isEmpty()).toBeTruthy();
      return expect(param.getLocationHash()).toBe("");
    });
    it("must return Empty param object when param doesn't have value", function() {
      var param, paramCollection;
      paramCollection = new ParamCollection("#album=");
      param = paramCollection.getParam("album");
      expect(param).toBeDefined();
      expect(param.isEmpty()).toBeTruthy();
      return expect(paramCollection.getLocationHash()).toBe("#album");
    });
    it("must return Empty param object when param doesn't have value nor =", function() {
      var param, paramCollection;
      paramCollection = new ParamCollection("#album");
      param = paramCollection.getParam("album");
      expect(param).toBeDefined();
      expect(param.isEmpty()).toBeTruthy();
      return expect(paramCollection.getLocationHash()).toBe("#album");
    });
    it("must return Empty param object when param array is an empty array", function() {
      var param, paramCollection;
      paramCollection = new ParamCollection("#album=[]");
      param = paramCollection.getParam("album");
      expect(param).toBeDefined();
      expect(param.isEmpty()).toBeTruthy();
      return expect(param.getLocationHash()).toBe("album");
    });
    it("must return Empty param object when I remove the last value of a param array ", function() {
      var param, paramCollection;
      paramCollection = new ParamCollection("#album=[1]");
      param = paramCollection.getParam("album");
      param.remove("1");
      expect(param).toBeDefined();
      expect(param.isEmpty()).toBeTruthy();
      return expect(param.getLocationHash()).toBe("album");
    });
    it("must compare single param values", function() {
      var param;
      param = new SingleParam("sort", "asc");
      expect(param.valueIsEqualTo("asc")).toBeTruthy();
      return expect(param.valueIsEqualTo("desc")).toBeFalsy();
    });
    it("must know if param array values contains a value", function() {
      var param;
      param = new ArrayParam("sizes", ["L", "XL"]);
      expect(param.containsValue("L")).toBeTruthy();
      return expect(param.containsValue("M")).toBeFalsy();
    });
    it("EmptyParam must behave like SingleParam in valueIsEqualTo()", function() {
      var param;
      param = new EmptyParam();
      expect(param.valueIsEqualTo("asc")).toBeTruthy();
      return expect(param.valueIsEqualTo("desc")).toBeTruthy();
    });
    it("EmptyParam must behave like ArrayParam in contains()", function() {
      var param;
      param = new EmptyParam();
      expect(param.containsValue("XL")).toBeTruthy();
      return expect(param.containsValue("L")).toBeTruthy();
    });
    it("EmptyParam must behave like RangeParam in isInRange()", function() {
      var param;
      param = new EmptyParam();
      expect(param.isInRange("1")).toBeTruthy();
      return expect(param.isInRange("2")).toBeTruthy();
    });
    it("EmptyParam must have name", function() {
      var param;
      param = new EmptyParam();
      return expect(param.name).toBe("EmptyParam");
    });
    it("must find one params by name array", function() {
      var foundedParamCollection, paramCollection, sortParam;
      paramCollection = new ParamCollection();
      paramCollection.addSingleParam("sort", "desc");
      foundedParamCollection = paramCollection.find(["sort"]);
      expect(foundedParamCollection.count()).toBe(1);
      sortParam = foundedParamCollection.getParam("sort");
      expect(sortParam).toBeDefined();
      return expect(sortParam.value).toBe("desc");
    });
    it("must return an Empty param if param searched doesn't exists", function() {
      var foundedParamCollection, paramCollection, priceParam;
      paramCollection = new ParamCollection();
      paramCollection.addSingleParam("sort", "desc");
      foundedParamCollection = paramCollection.find(["price"]);
      expect(foundedParamCollection.count()).toBe(0);
      priceParam = foundedParamCollection.getParam("price");
      expect(priceParam).toBeDefined();
      expect(priceParam.name).toBe("EmptyParam");
      return expect(priceParam.isEmpty()).toBeTruthy();
    });
    it("must find one params by name array when param name is upper case", function() {
      var foundedParamCollection, paramCollection, sortParam;
      paramCollection = new ParamCollection();
      paramCollection.addSingleParam("sort", "desc");
      foundedParamCollection = paramCollection.find(["SORT"]);
      expect(foundedParamCollection.count()).toBe(1);
      sortParam = foundedParamCollection.getParam("sort");
      expect(sortParam).toBeDefined();
      return expect(sortParam.value).toBe("desc");
    });
    it("must find one params by name array when param name is mixed case", function() {
      var foundedParamCollection, paramCollection, sortParam;
      paramCollection = new ParamCollection();
      paramCollection.addSingleParam("sorT", "desc");
      foundedParamCollection = paramCollection.find(["Sort"]);
      expect(foundedParamCollection.count()).toBe(1);
      sortParam = foundedParamCollection.getParam("sOrt");
      expect(sortParam).toBeDefined();
      return expect(sortParam.value).toBe("desc");
    });
    it("must find several params by name array", function() {
      var foundedParamCollection, paramCollection;
      paramCollection = new ParamCollection();
      paramCollection.add(new ArrayParam("sizes", ["M", "L"]));
      paramCollection.add(new RangeParam("price", "10", "40"));
      paramCollection.add(new SingleParam("sort", "desc"));
      foundedParamCollection = paramCollection.find(["sizes", "price", "sort"]);
      expect(foundedParamCollection.count()).toBe(3);
      expect(foundedParamCollection.getParam("sizes").isEmpty()).toBeFalsy();
      expect(foundedParamCollection.getParam("price").isEmpty()).toBeFalsy();
      return expect(foundedParamCollection.getParam("sort").isEmpty()).toBeFalsy();
    });
    it("must find several params by name array excluding some existing params", function() {
      var foundedParamCollection, paramCollection;
      paramCollection = new ParamCollection();
      paramCollection.add(new ArrayParam("sizes", ["M", "L"]));
      paramCollection.add(new RangeParam("price", "10", "40"));
      paramCollection.add(new SingleParam("sort", "desc"));
      expect(paramCollection.count()).toBe(3);
      foundedParamCollection = paramCollection.find(["sizes", "price"]);
      expect(foundedParamCollection.count()).toBe(2);
      expect(foundedParamCollection.getParam("sizes").isEmpty()).toBeFalsy();
      expect(foundedParamCollection.getParam("price").isEmpty()).toBeFalsy();
      return expect(foundedParamCollection.getParam("sort").isEmpty()).toBeTruthy();
    });
    it("must know if a paramCollection isEmpty", function() {
      var paramCollection;
      paramCollection = new ParamCollection();
      return expect(paramCollection.isEmpty()).toBeTruthy();
    });
    it("must know if a paramCollection not isEmpty", function() {
      var paramCollection;
      paramCollection = new ParamCollection();
      paramCollection.add(new ArrayParam("sizes", ["M", "L"]));
      return expect(paramCollection.isEmpty()).toBeFalsy();
    });
    it("must return an Empty param if param searched doesn't exists", function() {
      var foundedParamCollection, paramCollection;
      paramCollection = new ParamCollection();
      paramCollection.addSingleParam("sort", "desc");
      expect(paramCollection.isEmpty()).toBeFalsy();
      foundedParamCollection = paramCollection.find(["price"]);
      return expect(foundedParamCollection.isEmpty()).toBeTruthy();
    });
    it("must return correct hash when value of SingleParam is empty", function() {
      var param;
      param = SingleParam.createFrom("sort");
      return expect(param.getLocationHash()).toBe("sort");
    });
    it("must return correct hash when value of RangeParam is empty", function() {
      var param;
      param = RangeParam.createFrom("price=()");
      return expect(param.getLocationHash()).toBe("price");
    });
    it("must return correct hash when value of ArrayParam is empty", function() {
      var param;
      param = ArrayParam.createFrom("colors=[]");
      return expect(param.getLocationHash()).toBe("colors");
    });
    return it("must understand latin accents chars in param from location hash", function() {
      var paramCollection;
      paramCollection = new ParamCollection("#sort=áéíóúÁÉÍÓÚñÑ");
      expect(paramCollection.count()).toBe(1);
      return expect(paramCollection.getParam("sort").value).toBe("áéíóúÁÉÍÓÚñÑ");
    });
  });

}).call(this);
