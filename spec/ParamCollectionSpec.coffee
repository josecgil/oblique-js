describe "ParamCollection", ->

  ParamCollection=ObliqueNS.ParamCollection
  ArrayParam=ObliqueNS.ArrayParam
  RangeParam=ObliqueNS.RangeParam
  SingleParam=ObliqueNS.SingleParam

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
    expect(sizesParam.values.length).toBe 1
    expect(sizesParam.values[0]).toBe "M"

  it "must add a value to an already existing array param", () ->
    paramCollection=new ParamCollection("")
    paramCollection.add(new ArrayParam("sizes",["M"]))
    sizesParam = paramCollection.getParam("sizes")
    sizesParam.add("L")

    expect(sizesParam.values.length).toBe 2
    expect(sizesParam.values[0]).toBe "M"
    expect(sizesParam.values[1]).toBe "L"

  it "must remove an existent param", () ->
    paramCollection=new ParamCollection("")
    paramCollection.add(new ArrayParam("sizes",["M","L"]))
    paramCollection.remove("sizes")
    expect(paramCollection.getParam("sizes")).toBeUndefined()

  it "must ignore remove an inexistent array param value", () ->
    paramCollection=new ParamCollection("")
    paramCollection.add(new ArrayParam("sizes",["L"]))
    sizesParam=paramCollection.getParam("sizes");
    sizesParam.remove("M")
    expect(sizesParam.length).toBe(1)

  it "must remove an existent array param value", () ->
    paramCollection=new ParamCollection("")
    paramCollection.add(new ArrayParam("sizes",["M","L"]))
    sizesParam=paramCollection.getParam("sizes");
    sizesParam.remove("M")
    expect(sizesParam.length).toBe(1)

  it "must ignore remove an inexistent param name", () ->
    paramCollection=new ParamCollection("")
    paramCollection.add(new ArrayParam("colors",["rojo"]))

    paramCollection.remove("sizes")

    expect(paramCollection.count()).toBe 1
    expect(paramCollection.getParam("colors")).toBeDefined()
    expect(paramCollection.getParam("sizes")).toBeUndefined()

  it "must clear a param by name", () ->
    paramCollection=new ParamCollection("")
    paramCollection.add(new ArrayParam("sizes",["XL"]))
    paramCollection.remove("sizes")
    expect(paramCollection.getParam("sizes")).toBeUndefined()

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
    expect(paramCollection.getLocationHash()).toBe("#price=[10,100]")

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

  it "must be undefined if I remove last array param value", () ->
    paramCollection=new ParamCollection("")
    paramCollection.add(new ArrayParam("sizes",["M"]))

    sizesParam = paramCollection.getParam("sizes")
    sizesParam.remove("M")
    expect(sizesParam.values).toBeUndefined()


  it "must return location hash for 0 params", () ->
    paramCollection=new ParamCollection("")
    expect(paramCollection.getLocationHash()).toBe("")


###

  paramCollection=Params.createFromHash(window.location.hash)


  route = Oblique().getHashRoute()
  Oblique().setHashRoute(route);
  window.location.hash=route.getHash() #price=[1,10]&sort=desc
  Validar que los datos "seteados" sean strings?

  paramCollection=createParamCollection(window.location.hash)

  paramCollection=Oblique().getHashParams()
###