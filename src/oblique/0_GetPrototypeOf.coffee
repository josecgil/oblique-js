if typeof Object.getPrototypeOf isnt "function"
  if typeof "test".__proto__ is "object"
    Object.getPrototypeOf = (object) ->
      object.__proto__
  else
    Object.getPrototypeOf = (object) ->
      # May break if the constructor has been tampered with
      object.constructor::