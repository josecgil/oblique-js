describe "TimedDOMObserver", ->

  TimedDOMObserver=ObliqueNS.TimedDOMObserver

  beforeEach (done) ->
    done()

  afterEach ->

  it "should be called almost one time", (done)->
    observer=new TimedDOMObserver()
    observer.onChange(->
      observer.destroy()
      done()
    )
    observer.setIntervalInMs 10
    observer.observe()

  it "should be called almost 10 times", (done)->
    count=0
    observer=new TimedDOMObserver()
    observer.onChange(->
      count++
      observer.destroy() if count is 10
    )
    observer.setIntervalInMs 1

    setTimeout(->
      expect(count).toBe 10
      done()
    ,500)

    observer.observe()
