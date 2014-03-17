class @ClockDirective
  constructor: (DOMElement)->
    clockElement=$(DOMElement)
    setInterval ->
      currentTime=new Date()
      hours=currentTime.getHours()
      minutes=currentTime.getMinutes()
      seconds=currentTime.getSeconds()
      clockElement.html("Current time:#{hours}:#{minutes}:#{seconds}")
    ,500

  @CSS_EXPRESSION = "clock"

Oblique().registerDirective ClockDirective