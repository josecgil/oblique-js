#Add string::trim() if not present
unless String::trim
  String::trim = ->
    @replace /^\s+|\s+$/g, ""

