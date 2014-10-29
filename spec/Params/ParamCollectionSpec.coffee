describe "ParamCollection", ->

  ParamCollection=ObliqueNS.ParamCollection
  ArrayParam=ObliqueNS.ArrayParam
  RangeParam=ObliqueNS.RangeParam
  SingleParam=ObliqueNS.SingleParam
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
    expect(paramCollection.getLocationHash()).toBe("")

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
    expect(param.getLocationHash()).toBe("")

  it "must return Empty param object when param array is an empty array", () ->
    paramCollection=new ParamCollection("#album=[]")
    param=paramCollection.getParam("album")
    expect(param).toBeDefined()
    expect(param.isEmpty()).toBeTruthy()
    expect(param.getLocationHash()).toBe("")
