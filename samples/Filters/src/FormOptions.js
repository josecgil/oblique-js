(function() {

    var FormOptions=function(formElements) {
        this.formElements=$(formElements);
    };

    FormOptions.prototype.reset=function() {
        this.formElements.each(function(i, element) {
            $(element).prop("checked",false)
        });
    };

    FormOptions.prototype._isEmpty=function(values) {
        if (values==null) return true;
        if (values.length==0) return true;
        return false;
    };

    FormOptions.prototype.updateValues=function(values) {
        if (this._isEmpty(values)) {
            this.reset();
            return;
        };

        var self=this;
        this.formElements.each(function(i, element) {
            var checkedValue=false;
            if (self._valuesContains(values, $(element).val())) {
                checkedValue=true;
            }
            $(element).prop("checked",checkedValue);
        });

    };

    FormOptions.prototype.click=function(clickCallbackFn) {
        this.formElements.click(clickCallbackFn);
    };

    FormOptions.prototype._valuesContains=function(values, elementValue) {
        if (values.indexOf(elementValue)==-1) {
            return false;
        }
        return true;
    };


    window.FormOptions=FormOptions;

}).call(this);

