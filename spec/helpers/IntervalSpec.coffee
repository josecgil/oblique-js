describe "Interval", ->
  beforeEach (done) ->
    done()

  afterEach ->

  it "must count any interval greater than 1 ms", (done)->
    interval=new Interval()
    interval.start()

    setTimeout(
      ->
        interval.stop()
        expect(interval.timeInMs).toBeGreaterThan 1
        done()
    ,10)

  it "must count 0 if I check without start() or stop()", ()->
    interval=new Interval()
    expect(interval.timeInMs).toBe 0

  it "must count -1 if I check with start() but without stop()", ()->
    interval=new Interval()
    interval.start()
    expect(interval.timeInMs).toBe -1

