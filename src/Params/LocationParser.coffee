@.ObliqueNS=@.ObliqueNS or {}

class LocationParser

  constructor:(locationHash) ->
    locationHash=locationHash.replace("#","")+"&"

    @hashParams=[]
    currentParam=""
    isInsideValue=false
    for ch in locationHash
      if ch is ']' or ch is ')'
        isInsideValue=false
      if ch is '[' or ch is '('
        isInsideValue=true

      if ch is '&' and not isInsideValue
        @hashParams.push(currentParam)
        currentParam=""
        continue

      currentParam=currentParam+ch

ObliqueNS.LocationParser=LocationParser

