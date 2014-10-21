describe "HashParams", ->

  HashParams=ObliqueNS.HashParams

  it "must return empty params when Hash is empty", () ->
    hashParams=new HashParams("")
    expect(hashParams.isEmpty()).toBeTruthy()

  it "must setSingle a param", () ->
    hashParams=new HashParams("")
    hashParams.setSingle("sortBy","descPrice")
    expect(hashParams.params.sortBy).toBe "descPrice"

  it "must setSingle another param", () ->
    hashParams=new HashParams("")
    hashParams.setSingle("numItems","48")
    expect(hashParams.params.numItems).toBe "48"

  it "must re-setSingle a param", () ->
    hashParams=new HashParams("")
    hashParams.setSingle("sortBy","descPrice")
    hashParams.setSingle("sortBy","ascPrice")
    expect(hashParams.params.sortBy).toBe "ascPrice"

  it "must setRange a param", () ->
    hashParams=new HashParams("")
    hashParams.setRange("price","10","49")
    expect(hashParams.params.price.min).toBe "10"
    expect(hashParams.params.price.max).toBe "49"

  it "must re-setRange a param", () ->
    hashParams=new HashParams("")
    hashParams.setRange("price","10","49")
    hashParams.setRange("price","0","100")
    expect(hashParams.params.price.min).toBe "0"
    expect(hashParams.params.price.max).toBe "100"

  it "must add a param", () ->
    hashParams=new HashParams("")
    hashParams.add("sizes","M")
    expect(hashParams.params.sizes.length).toBe 1
    expect(hashParams.params.sizes[0]).toBe "M"

  it "must add 2 params", () ->
    hashParams=new HashParams("")
    hashParams.add("sizes","M")
    hashParams.add("sizes","L")
    expect(hashParams.params.sizes.length).toBe 2
    expect(hashParams.params.sizes[0]).toBe "M"
    expect(hashParams.params.sizes[1]).toBe "L"

  it "must reset a single param if add is called", () ->
    hashParams=new HashParams("")
    hashParams.setSingle("sizes","106")
    hashParams.add("sizes","M")
    expect(hashParams.params.sizes.length).toBe 1
    expect(hashParams.params.sizes[0]).toBe "M"

  it "must remove an existent param", () ->
    hashParams=new HashParams("")
    hashParams.add("sizes","M")
    hashParams.remove("sizes","M")
    expect(hashParams.params.sizes.length).toBe 0

  it "must ignore remove an inexistent param value", () ->
    hashParams=new HashParams("")
    hashParams.add("sizes","L")
    hashParams.remove("sizes","M")
    expect(hashParams.params.sizes.length).toBe 1

  it "must ignore remove an inexistent param name", () ->
    hashParams=new HashParams("")
    hashParams.add("colors","rojo")
    hashParams.remove("sizes","M")
    expect(hashParams.params.colors.length).toBe 1
    expect(hashParams.params.sizes).toBeUndefined()

  it "must clear a param by name", () ->
    hashParams=new HashParams("")
    hashParams.add("sizes","XL")
    hashParams.clear("sizes")
    expect(hashParams.params.sizes).toBeUndefined()

  it "must clear all params", () ->
    hashParams=new HashParams("")
    hashParams.setSingle("numItems","42")
    hashParams.add("sizes","XL")
    hashParams.clearAll()
    expect(hashParams.isEmpty()).toBeTruthy()


###
  route = Oblique().getHashRoute()
  Oblique().setHashRoute(route);

  new HashRoute(window.location.hash)

  -route.add("color", colorName)
  -route.remove("color", colorName)
  -route.set("sort","descPrice")
  -route.setRange("price",10,42)

  -route.clear("sort")
  -route.clearAll()

  -var params=route.getParams()

  -params.color
  -params.sort

  window.location.hash=route.getHash() #price=[1,10]&sort=desc

  Validar que los datos "seteados" sean strings?

###

