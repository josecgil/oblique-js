class @ClockDirective
  constructor: (DOMElement)->
    clockElement=$(DOMElement)
    setInterval =>
      currentTime=new Date()
      hours=@pad currentTime.getHours()
      minutes=@pad currentTime.getMinutes()
      seconds=@pad currentTime.getSeconds()
      clockElement.html("Current time:#{hours}:#{minutes}:#{seconds}")
    ,500

  pad: (number, digits=2) ->
    number=number.toString()
    while (number.length<digits)
      number="0"+number
    number

  @CSS_EXPRESSION = "clock"

Oblique().registerDirective ClockDirective