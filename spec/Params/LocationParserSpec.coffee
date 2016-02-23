describe "LocationParser", ->

  LocationParser=ObliqueNS.LocationParser

  it "must return params splitted by &", () ->
      locationParser=new LocationParser("color=red&price=(13,34)&categories=[BODIES,T-SHIRT]")
      expect(locationParser.hashParams.length).toBe 3
      expect(locationParser.hashParams[0]).toBe "color=red"
      expect(locationParser.hashParams[1]).toBe "price=(13,34)"
      expect(locationParser.hashParams[2]).toBe "categories=[BODIES,T-SHIRT]"

  it "must return params whose values contains & in []", () ->
    locationParser=new LocationParser("color=red&price=(13,34)&categories=[JACK & JONES,T-SHIRT]")
    expect(locationParser.hashParams.length).toBe 3
    expect(locationParser.hashParams[0]).toBe "color=red"
    expect(locationParser.hashParams[1]).toBe "price=(13,34)"
    expect(locationParser.hashParams[2]).toBe "categories=[JACK & JONES,T-SHIRT]"

  it "must return params whose values contains & in ()", () ->
    locationParser=new LocationParser("color=red&brand=(LEVIS & SONS,ADIDAS)")
    expect(locationParser.hashParams.length).toBe 2
    expect(locationParser.hashParams[0]).toBe "color=red"
    expect(locationParser.hashParams[1]).toBe "brand=(LEVIS & SONS,ADIDAS)"

  it "must return params whose values contains ( in ()", () ->
    locationParser=new LocationParser("color=red&brand=(LEVIS (& SONS) BRAND),ADIDAS)&price=(12,22)")
    expect(locationParser.hashParams.length).toBe 3
    expect(locationParser.hashParams[0]).toBe "color=red"
    expect(locationParser.hashParams[1]).toBe "brand=(LEVIS (& SONS) BRAND),ADIDAS)"
    expect(locationParser.hashParams[2]).toBe "price=(12,22)"

  it "must return params whose values contains ] in ()", () ->
    locationParser=new LocationParser("color=red&brand=(LEVIS SONS] BRAND),ADIDAS)&price=(12,22)")
    expect(locationParser.hashParams.length).toBe 3
    expect(locationParser.hashParams[0]).toBe "color=red"
    expect(locationParser.hashParams[1]).toBe "brand=(LEVIS SONS] BRAND),ADIDAS)"
    expect(locationParser.hashParams[2]).toBe "price=(12,22)"

  it "must return params whose values contains ]( in ()", () ->
    locationParser=new LocationParser("color=red&brand=(LEVIS SONS]( BRAND),ADIDAS)&price=(12,22)")
    expect(locationParser.hashParams.length).toBe 3
    expect(locationParser.hashParams[0]).toBe "color=red"
    expect(locationParser.hashParams[1]).toBe "brand=(LEVIS SONS]( BRAND),ADIDAS)"
    expect(locationParser.hashParams[2]).toBe "price=(12,22)"
