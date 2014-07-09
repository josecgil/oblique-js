class @Interval
  constructor:->
    @timeInMs=0

  start:->
    @timeInMs=-1
    @_startDate=new Date()

  stop:->
    endDate=new Date()
    @timeInMs=endDate-@_startDate


