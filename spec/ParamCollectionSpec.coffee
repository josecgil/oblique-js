describe "ParamCollection", ->

  ParamCollection=ObliqueNS.ParamCollection

  ## quitar un param correcto de un array
  # tests de length en paramCollection

  it "must return empty params when Hash is empty", () ->
    paramCollection=new ParamCollection("")
    expect(paramCollection.length).toBe(0)

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

  it "must ignore remove an inexistent param name", () ->
    hashParams=new ParamCollection("")
    hashParams.add("colors","rojo")
    hashParams.remove("sizes","M")
    expect(hashParams.params.colors.length).toBe 1
    expect(hashParams.params.sizes).toBeUndefined()

  it "must clear a param by name", () ->
    hashParams=new ParamCollection("")
    hashParams.add("sizes","XL")
    hashParams.clear("sizes")
    expect(hashParams.params.sizes).toBeUndefined()

  it "must clear all params", () ->
    hashParams=new ParamCollection("")
    hashParams.setSingle("numItems","42")
    hashParams.add("sizes","XL")
    hashParams.clearAll()
    expect(hashParams.isEmpty()).toBeTruthy()


###

  paramCollection=Params.createFromHash(window.location.hash)

  paramCollection.values
  paramCollection.add()
  paramCollection.set("artPorPagina",42)
  paramCollection.setRange("price",12,42)

  route = Oblique().getHashRoute()
  Oblique().setHashRoute(route);

  new HashRoute(window.location.hash)

  -route.add("color", colorName)
  -route.remove("color", colorName)
  -route.set("sort","descPrice")
  -route.setRange("price",10,42)

  -route.clear("sort")
  -route.clearAll()

  -var params=hashParams.buildRoute()

  -params.color
  -params.sort

  window.location.hash=route.getHash() #price=[1,10]&sort=desc

  Validar que los datos "seteados" sean strings?


paramCollection=new ParamCollection()
paramCollection.add(new SimpleParam("sort","desc"))
paramCollection.add(new RangeParam("price",12,42))
paramCollection.add(new ArrayParam("color",["rojo","azul","amarillo"]))

Oblique().getHashParams().remove("price")

Oblique().getHashParams().removeAll()

paramCollection=createParamCollection(window.location.hash)

paramCollection=Oblique().getHashParams()
colorParam=paramCollection.getParam("color")
colorParam.remove("rojo")

priceParam=paramCollection.getParam("price");
priceParam.min=24;
priceParam.max=100;

  ###



class SingleParam

  constructor:(@name, @value)->

class RangeParam

  constructor:(@name, @min, @max)->

class ArrayParam

  constructor:(@name, @values)->
    @length=@values.length

  add:(value)->
    @values.push value
    @length=@values.length

  remove:(value)->
    index=@values.indexOf value
    return if index is -1
    @values.splice index, 1
    @length=@values.length

