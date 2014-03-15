describe "Oblique", ->
  beforeEach ->
    Oblique().destroyInstance()
    @oblique = Oblique()

  afterEach ->
    @oblique.destroyInstance()
    @oblique = undefined

  it "On creation it has a default interval time", ->
    expect(@oblique.getIntervalTimeInMs()).toBe Oblique.DEFAULT_INTERVAL_MS

  it "We can change default interval time", ->
    newIntervaltimeMs = 10000
    @oblique.setIntervalTimeInMs newIntervaltimeMs
    expect(@oblique.getIntervalTimeInMs()).toBe newIntervaltimeMs

  it "We can't change default interval time to invalid value", ->
    try
      @oblique.setIntervalTimeInMs -1
      throw Error "It must throw an ObliqueError"
    catch error
      if not (error instanceof ObliqueError)
        throw Error "It must throw an ObliqueError"