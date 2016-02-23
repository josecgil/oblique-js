describe "ParamCollection", ->

  ParamCollection=ObliqueNS.ParamCollection
  ArrayParam=ObliqueNS.ArrayParam
  RangeParam=ObliqueNS.RangeParam
  SingleParam=ObliqueNS.SingleParam
  EmptyParam=ObliqueNS.EmptyParam
  ObError=ObliqueNS.Error

  it "must return empty params when Hash is empty", () ->
    paramCollection=new ParamCollection("")
    expect(paramCollection.count()).toBe(0)

  it "must count only one when I add same name param", () ->
    paramCollection=new ParamCollection("")
    paramCollection.add(new SingleParam("sortBy","descPrice"))
    paramCollection.add(new SingleParam("sortBy","ascPrice"))
    expect(paramCollection.count()).toBe(1)

  it "must count each param as one", () ->
    paramCollection=new ParamCollection("")
    paramCollection.add(new SingleParam("sortBy","descPrice"))
    paramCollection.add(new RangeParam("price","10", "49"))
    paramCollection.add(new ArrayParam("sizes",["M"]))
    expect(paramCollection.count()).toBe(3)

  it "must setSingle a param", () ->
    paramCollection=new ParamCollection("")
    paramCollection.add(new SingleParam("sortBy","descPrice"))
    expect(paramCollection.getParam("sortBy").value).toBe "descPrice"

  it "must setSingle another param", () ->
    paramCollection=new ParamCollection("")
    paramCollection.add(new SingleParam("numItems","48"))
    expect(paramCollection.getParam("numItems").value).toBe "48"

  it "must re-setSingle a param", () ->
    paramCollection=new ParamCollection("")
    paramCollection.add(new SingleParam("sortBy","descPrice"))
    paramCollection.add(new SingleParam("sortBy","ascPrice"))
    expect(paramCollection.getParam("sortBy").value).toBe "ascPrice"

  it "must setRange a param", () ->
    paramCollection=new ParamCollection("")
    paramCollection.add(new RangeParam("price","10", "49"))
    priceParam = paramCollection.getParam("price")
    expect(priceParam.min).toBe "10"
    expect(priceParam.max).toBe "49"

  it "must re-setRange a param", () ->
    paramCollection=new ParamCollection("")
    paramCollection.add(new RangeParam("price","10", "49"))
    paramCollection.add(new RangeParam("price","0", "100"))
    priceParam = paramCollection.getParam("price")
    expect(priceParam.min).toBe "0"
    expect(priceParam.max).toBe "100"

  it "must know if value is between RangeParam values", () ->
    priceParam=new RangeParam("price","10", "49")
    expect(priceParam.isInRange(15)).toBeTruthy()
    expect(priceParam.isInRange(9)).toBeFalsy()
    expect(priceParam.isInRange(50)).toBeFalsy()

  it "must add an array param", () ->
    paramCollection=new ParamCollection("")
    paramCollection.add(new ArrayParam("sizes",["M"]))
    sizesParam = paramCollection.getParam("sizes")
    expect(sizesParam.count()).toBe 1
    expect(sizesParam.values[0]).toBe "M"

  it "must add a value to an already existing array param", () ->
    paramCollection=new ParamCollection("")
    paramCollection.add(new ArrayParam("sizes",["M"]))
    sizesParam = paramCollection.getParam("sizes")
    sizesParam.add("L")

    expect(sizesParam.count()).toBe 2
    expect(sizesParam.values[0]).toBe "M"
    expect(sizesParam.values[1]).toBe "L"

  it "must remove an existent param", () ->
    paramCollection=new ParamCollection("")
    paramCollection.add(new ArrayParam("sizes",["M","L"]))
    paramCollection.remove("sizes")
    expect(paramCollection.getParam("sizes").isEmpty()).toBeTruthy()

  it "must ignore remove an inexistent array param value", () ->
    paramCollection=new ParamCollection("")
    paramCollection.add(new ArrayParam("sizes",["L"]))
    sizesParam=paramCollection.getParam("sizes");
    sizesParam.remove("M")
    expect(sizesParam.count()).toBe(1)

  it "must remove an existent array param value", () ->
    paramCollection=new ParamCollection("")
    paramCollection.add(new ArrayParam("sizes",["M","L"]))
    sizesParam=paramCollection.getParam("sizes");
    sizesParam.remove("M")
    expect(sizesParam.count()).toBe(1)

  it "must ignore remove an inexistent param name", () ->
    paramCollection=new ParamCollection("")
    paramCollection.add(new ArrayParam("colors",["rojo"]))

    paramCollection.remove("sizes")

    expect(paramCollection.count()).toBe 1
    expect(paramCollection.getParam("colors")).toBeDefined()
    expect(paramCollection.getParam("sizes").isEmpty()).toBeTruthy()

  it "must clear a param by name", () ->
    paramCollection=new ParamCollection("")
    paramCollection.add(new ArrayParam("sizes",["XL"]))
    paramCollection.remove("sizes")
    expect(paramCollection.getParam("sizes").isEmpty()).toBeTruthy()

  it "must clear all params", () ->
    paramCollection=new ParamCollection("")
    paramCollection.add(new ArrayParam("sizes",["XL"]))
    paramCollection.add(new SingleParam("sort","desc"))
    paramCollection.removeAll()
    expect(paramCollection.count()).toBe(0)

  it "must return location hash for single param", () ->
    paramCollection=new ParamCollection("")
    paramCollection.add(new SingleParam("sort","desc"))
    expect(paramCollection.getLocationHash()).toBe("#sort=desc")

  it "must return location hash for range param", () ->
    paramCollection=new ParamCollection("")
    paramCollection.add(new RangeParam("price","10","100"))
    expect(paramCollection.getLocationHash()).toBe("#price=(10,100)")

  it "must return location hash for array param", () ->
    paramCollection=new ParamCollection("")
    paramCollection.add(new ArrayParam("sizes",["M","L","XL"]))
    expect(paramCollection.getLocationHash()).toBe("#sizes=[M,L,XL]")

  it "must return location hash for an array param of one", () ->
    paramCollection=new ParamCollection("")
    paramCollection.add(new ArrayParam("sizes",["M"]))
    expect(paramCollection.getLocationHash()).toBe("#sizes=[M]")

  it "must return location hash for an array param of zero", () ->
    paramCollection=new ParamCollection("")
    paramCollection.add(new ArrayParam("sizes",[]))
    expect(paramCollection.getLocationHash()).toBe("#sizes")

  it "must return location hash for 2 params", () ->
    paramCollection=new ParamCollection("")
    paramCollection.add(new ArrayParam("sizes",["M","L"]))
    paramCollection.add(new SingleParam("sort","desc"))
    expect(paramCollection.getLocationHash()).toBe("#sizes=[M,L]&sort=desc")

  it "must return location hash for 3 params", () ->
    paramCollection=new ParamCollection("")
    paramCollection.add(new ArrayParam("sizes",["M","L"]))
    paramCollection.add(new RangeParam("price","10","40"))
    paramCollection.add(new SingleParam("sort","desc"))
    expect(paramCollection.getLocationHash()).toBe("#sizes=[M,L]&price=(10,40)&sort=desc")

  it "must be undefined if I remove last array param value", () ->
    paramCollection=new ParamCollection("")
    paramCollection.add(new ArrayParam("sizes",["M"]))

    sizesParam = paramCollection.getParam("sizes")
    sizesParam.remove("M")
    expect(sizesParam.values).toBeUndefined()

  it "must return correct hash when I remove a param value", () ->
    paramCollection=new ParamCollection("")
    paramCollection.add(new ArrayParam("sizes",["M"]))
    paramCollection.remove("sizes")
    expect(paramCollection.getLocationHash()).toBe("")

  it "must return location hash for 0 params", () ->
    paramCollection=new ParamCollection("")
    expect(paramCollection.getLocationHash()).toBe("")

  it "must throw an error if array param value is not an array", () ->
    expect(->
      new ArrayParam("sizes","M")
    ).toThrow(new ObError("Param constructor must be called with second param array"))

  it "must throw an error if array param name is not an string", () ->
    expect(->
      new ArrayParam(1,["M"])
    ).toThrow(new ObError("Param constructor must be called with first param string"))

  it "must throw an error if single param name is not an string", () ->
    expect(->
      new SingleParam(1,"")
    ).toThrow(new ObError("Param constructor must be called with first param string"))

  it "must throw an error if range param name is not an string", () ->
    expect(->
      new RangeParam(1,"1","10")
    ).toThrow(new ObError("Param constructor must be called with first param string"))

  it "must throw an error if single param value is not an string", () ->
    expect(->
      new SingleParam("sort",1)
    ).toThrow(new ObError("Param constructor must be called with second param string"))

  it "must throw an error if range param min is not an string", () ->
    expect(->
      new RangeParam("price",10, "40")
    ).toThrow(new ObError("Param constructor must be called with second param string"))

  it "must throw an error if range param max is not an string", () ->
    expect(->
      new RangeParam("price","10", 40)
    ).toThrow(new ObError("Param constructor must be called with third param string"))

  it "must throw an error if array param values are not string", () ->
    expect(->
      new ArrayParam("sizes",[101,105])
    ).toThrow(new ObError("Array param must be an string"))

  it "must understand single param from location hash", () ->
    paramCollection=new ParamCollection("#sort=desc")
    expect(paramCollection.count()).toBe(1)
    expect(paramCollection.getParam("sort").value).toBe("desc")

  it "must understand single param without value from location hash", () ->
    paramCollection=new ParamCollection("#sort=")
    expect(paramCollection.count()).toBe(0)
    expect(paramCollection.getParam("sort").isEmpty()).toBeTruthy()

  it "must understand single param without = from location hash", () ->
    paramCollection=new ParamCollection("#sort")
    expect(paramCollection.count()).toBe(0)
    expect(paramCollection.getParam("sort").isEmpty()).toBeTruthy()

  it "must understand two single param without = from location hash", () ->
    paramCollection=new ParamCollection("#sort&prices")
    expect(paramCollection.count()).toBe(0)
    expect(paramCollection.getParam("sort").isEmpty()).toBeTruthy()
    expect(paramCollection.getParam("prices").isEmpty()).toBeTruthy()

  it "must understand 2 single params from location hash", () ->
    paramCollection=new ParamCollection("#sort=desc&numItems=48")
    expect(paramCollection.count()).toBe(2)
    expect(paramCollection.getParam("sort").value).toBe("desc")
    expect(paramCollection.getParam("numItems").value).toBe("48")

  it "must understand 2 single params with whitespaces from location hash", () ->
    paramCollection=new ParamCollection("# sort = desc & numItems = 48 ")
    expect(paramCollection.count()).toBe(2)
    expect(paramCollection.getParam("sort").value).toBe("desc")
    expect(paramCollection.getParam("numItems").value).toBe("48")

  it "must understand range param from location hash", () ->
    paramCollection=new ParamCollection("#price=(10,20)")
    expect(paramCollection.count()).toBe(1)
    expect(paramCollection.getParam("price").min).toBe("10")
    expect(paramCollection.getParam("price").max).toBe("20")

  it "must understand array param from location hash", () ->
    paramCollection=new ParamCollection("#colors=[rojo,azul]")
    expect(paramCollection.count()).toBe(1)
    colorsValues = paramCollection.getParam("colors").values
    expect(colorsValues[0]).toBe("rojo")
    expect(colorsValues[1]).toBe("azul")

  it "must understand array param with whitespace values from location hash", () ->
    paramCollection=new ParamCollection("#colors=[   rojo ,   azul ]")
    expect(paramCollection.count()).toBe(1)
    colorsValues = paramCollection.getParam("colors").values
    expect(colorsValues[0]).toBe("rojo")
    expect(colorsValues[1]).toBe("azul")

  it "must understand range param with whitespace values from location hash", () ->
    paramCollection=new ParamCollection("#price=(   10 , 20  )")
    expect(paramCollection.count()).toBe(1)
    expect(paramCollection.getParam("price").min).toBe("10")
    expect(paramCollection.getParam("price").max).toBe("20")


  it "must understand 3 different params from location hash", () ->
    paramCollection=new ParamCollection("#colors=[rojo,azul]&price=(10,20)&sort=desc")
    expect(paramCollection.count()).toBe(3)
    colorsValues = paramCollection.getParam("colors").values
    expect(colorsValues[0]).toBe("rojo")
    expect(colorsValues[1]).toBe("azul")
    expect(paramCollection.getParam("price").min).toBe("10")
    expect(paramCollection.getParam("price").max).toBe("20")
    expect(paramCollection.getParam("sort").value).toBe("desc")

  it "must return added param object when add", () ->
    paramCollection=new ParamCollection("")
    arrayParam=paramCollection.add(new ArrayParam("sizes",["M"]))
    expect(arrayParam.count()).toBe(1)
    expect(arrayParam.values[0]).toBe("M")

  it "must return Empty param object when param doesn't exists", () ->
    paramCollection=new ParamCollection("")
    param=paramCollection.getParam("muggel")
    expect(param).toBeDefined()
    expect(param.isEmpty()).toBeTruthy()
    expect(param.getLocationHash()).toBe("")

  it "must return Empty param object when param doesn't have value", () ->
    paramCollection=new ParamCollection("#album=")
    param=paramCollection.getParam("album")
    expect(param).toBeDefined()
    expect(param.isEmpty()).toBeTruthy()
    expect(paramCollection.getLocationHash()).toBe("#album")

  it "must return Empty param object when param doesn't have value nor =", () ->
    paramCollection=new ParamCollection("#album")
    param=paramCollection.getParam("album")
    expect(param).toBeDefined()
    expect(param.isEmpty()).toBeTruthy()
    expect(paramCollection.getLocationHash()).toBe("#album")

  it "must return Empty param object when param array is an empty array", () ->
    paramCollection=new ParamCollection("#album=[]")
    param=paramCollection.getParam("album")
    expect(param).toBeDefined()
    expect(param.isEmpty()).toBeTruthy()
    expect(param.getLocationHash()).toBe("album")

  it "must return Empty param object when I remove the last value of a param array ", () ->
    paramCollection=new ParamCollection("#album=[1]")
    param=paramCollection.getParam("album")
    param.remove("1")
    expect(param).toBeDefined()
    expect(param.isEmpty()).toBeTruthy()
    expect(param.getLocationHash()).toBe("album")

  it "must compare single param values", () ->
    param=new SingleParam("sort","asc")
    expect(param.valueIsEqualTo("asc")).toBeTruthy()
    expect(param.valueIsEqualTo("desc")).toBeFalsy()

  it "must know if param array values contains a value", () ->
    param=new ArrayParam("sizes",["L","XL"])
    expect(param.containsValue("L")).toBeTruthy()
    expect(param.containsValue("M")).toBeFalsy()

  it "EmptyParam must behave like SingleParam in valueIsEqualTo()", () ->
    param=new EmptyParam()
    expect(param.valueIsEqualTo("asc")).toBeTruthy()
    expect(param.valueIsEqualTo("desc")).toBeTruthy()

  it "EmptyParam must behave like ArrayParam in contains()", () ->
    param=new EmptyParam()
    expect(param.containsValue("XL")).toBeTruthy()
    expect(param.containsValue("L")).toBeTruthy()

  it "EmptyParam must behave like RangeParam in isInRange()", () ->
    param=new EmptyParam()
    expect(param.isInRange("1")).toBeTruthy()
    expect(param.isInRange("2")).toBeTruthy()

  it "EmptyParam must have name", () ->
    param=new EmptyParam()
    expect(param.name).toBe("EmptyParam")

  it "must find one params by name array", () ->
    paramCollection=new ParamCollection()
    paramCollection.addSingleParam("sort","desc")
    foundedParamCollection=paramCollection.find(["sort"])
    expect(foundedParamCollection.count()).toBe(1)
    sortParam=foundedParamCollection.getParam("sort")
    expect(sortParam).toBeDefined()
    expect(sortParam.value).toBe("desc")

  it "must return an Empty param if param searched doesn't exists", () ->
    paramCollection=new ParamCollection()
    paramCollection.addSingleParam("sort","desc")
    foundedParamCollection=paramCollection.find(["price"])
    expect(foundedParamCollection.count()).toBe(0)
    priceParam=foundedParamCollection.getParam("price")
    expect(priceParam).toBeDefined()
    expect(priceParam.name).toBe("EmptyParam")
    expect(priceParam.isEmpty()).toBeTruthy()

  it "must find one params by name array when param name is upper case", () ->
    paramCollection=new ParamCollection()
    paramCollection.addSingleParam("sort","desc")
    foundedParamCollection=paramCollection.find(["SORT"])
    expect(foundedParamCollection.count()).toBe(1)
    sortParam=foundedParamCollection.getParam("sort")
    expect(sortParam).toBeDefined()
    expect(sortParam.value).toBe("desc")

  it "must find one params by name array when param name is mixed case", () ->
    paramCollection=new ParamCollection()
    paramCollection.addSingleParam("sorT","desc")
    foundedParamCollection=paramCollection.find(["Sort"])
    expect(foundedParamCollection.count()).toBe(1)
    sortParam=foundedParamCollection.getParam("sOrt")
    expect(sortParam).toBeDefined()
    expect(sortParam.value).toBe("desc")

  it "must find several params by name array", () ->
    paramCollection=new ParamCollection()
    paramCollection.add(new ArrayParam("sizes",["M","L"]))
    paramCollection.add(new RangeParam("price","10","40"))
    paramCollection.add(new SingleParam("sort","desc"))

    foundedParamCollection=paramCollection.find(["sizes","price","sort"])
    expect(foundedParamCollection.count()).toBe(3)
    expect(foundedParamCollection.getParam("sizes").isEmpty()).toBeFalsy()
    expect(foundedParamCollection.getParam("price").isEmpty()).toBeFalsy()
    expect(foundedParamCollection.getParam("sort").isEmpty()).toBeFalsy()

  it "must find several params by name array excluding some existing params", () ->
    paramCollection=new ParamCollection()
    paramCollection.add(new ArrayParam("sizes",["M","L"]))
    paramCollection.add(new RangeParam("price","10","40"))
    paramCollection.add(new SingleParam("sort","desc"))

    expect(paramCollection.count()).toBe(3)

    foundedParamCollection=paramCollection.find(["sizes","price"])
    expect(foundedParamCollection.count()).toBe(2)
    expect(foundedParamCollection.getParam("sizes").isEmpty()).toBeFalsy()
    expect(foundedParamCollection.getParam("price").isEmpty()).toBeFalsy()
    expect(foundedParamCollection.getParam("sort").isEmpty()).toBeTruthy()

  it "must know if a paramCollection isEmpty", () ->
    paramCollection=new ParamCollection()
    expect(paramCollection.isEmpty()).toBeTruthy()

  it "must know if a paramCollection not isEmpty", () ->
    paramCollection=new ParamCollection()
    paramCollection.add(new ArrayParam("sizes",["M","L"]))
    expect(paramCollection.isEmpty()).toBeFalsy()

  it "must return an Empty param if param searched doesn't exists", () ->
    paramCollection=new ParamCollection()
    paramCollection.addSingleParam("sort","desc")
    expect(paramCollection.isEmpty()).toBeFalsy()

    foundedParamCollection=paramCollection.find(["price"])
    expect(foundedParamCollection.isEmpty()).toBeTruthy()

  it "must return correct hash when value of SingleParam is empty", () ->
    param=SingleParam.createFrom("sort")
    expect(param.getLocationHash()).toBe("sort")

  it "must return correct hash when value of RangeParam is empty", () ->
    param=RangeParam.createFrom("price=()")
    expect(param.getLocationHash()).toBe("price")

  it "must return correct hash when value of ArrayParam is empty", () ->
    param=ArrayParam.createFrom("colors=[]")
    expect(param.getLocationHash()).toBe("colors")

  it "must understand latin accents chars in array param from location hash", () ->
    paramCollection=new ParamCollection("#features=[BAÑO]")
    expect(paramCollection.count()).toBe(1)
    expect(paramCollection.getParam("features").values[0]).toBe("BAÑO")

  it "must understand latin accents chars in single param from location hash", () ->
    paramCollection=new ParamCollection("#feature=BAÑO")
    expect(paramCollection.count()).toBe(1)
    expect(paramCollection.getParam("feature").value).toBe("BAÑO")

  it "must understand latin accents chars in Range param from location hash", () ->
    paramCollection=new ParamCollection("#features=(BAÑO,adiós)")
    expect(paramCollection.count()).toBe(1)
    expect(paramCollection.getParam("features").min).toBe("BAÑO")
    expect(paramCollection.getParam("features").max).toBe("adiós")


  it "must understand reserved char & in Range param from location hash", () ->
    paramCollection=new ParamCollection("#filter=[JACK & JONES, Otro param]")
    expect(paramCollection.count()).toBe(1)
    filterValues=paramCollection.getParam("filter").values

    expect(filterValues.length).toBe 2
    expect(filterValues[0]).toBe "JACK & JONES"
    expect(filterValues[1]).toBe "Otro param"



