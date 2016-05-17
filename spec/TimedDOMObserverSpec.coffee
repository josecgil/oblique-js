describe "TimedDOMObserver", ->

  TimedDOMObserver=ObliqueNS.TimedDOMObserver

  beforeEach (done) ->
    done()

  afterEach ->

  it "should be called almost one time", (done)->
    observer=new TimedDOMObserver(10)
    observer.onChange(->
      observer.destroy()
      done()
    )
    observer.observe()

  it "should be called almost 10 times", (done)->
    count=0
    observer=new TimedDOMObserver(1)
    observer.onChange(->
      count++
      observer.destroy() if count is 10
    )

    setTimeout(->
      expect(count).toBe 10
      done()
    ,500)

    observer.observe()


