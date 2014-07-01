@.ObliqueNS=@.ObliqueNS or {}

class JSON

  constructor:(@value)->

  getPathValue:(path)->
    parts=path.split "."
    value=@value
    for part in parts
      throw new ObliqueNS.Error("'"+path+"' not found in JSON Object") if not value.hasOwnProperty(part)
      value=value[part]
    value

ObliqueNS.JSON=JSON
