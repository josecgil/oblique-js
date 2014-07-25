@.ObliqueNS=@.ObliqueNS or {}
class Memory

  constructor:()->
    @_vars={}

  setVar:(name, value)->
    if name is "Model"
      throw new ObliqueNS.Error("Can't create a variable named 'Model', is a reserved word")
    @_vars[name]=value

  getVar:(name)->
    @_vars[name]

  localVarsScript:->
    script=""
    for own variableName, variableValue of @_vars
      script=script+"var #{variableName}=this._memory.getVar(\"#{variableName}\");"
    script

ObliqueNS.Memory=Memory