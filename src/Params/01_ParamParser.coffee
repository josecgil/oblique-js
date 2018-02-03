@.ObliqueNS=@.ObliqueNS or {}

class ParamParser

  constructor:(params, separator="&") ->
    params=params.replace("#","")+separator

    @hashParams=[]
    currentParam=""
    isInsideValue=false
    for ch in params
      if ch is ']' or ch is ')'
        isInsideValue=false
      if ch is '[' or ch is '('
        isInsideValue=true

      if ch is separator and not isInsideValue
        @hashParams.push(currentParam)
        currentParam=""
        continue

      currentParam=currentParam+ch

ObliqueNS.ParamParser=ParamParser
