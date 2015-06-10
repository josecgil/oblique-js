var TimerDirective=function (data) {
    this.directiveElement=data.jQueryElement;

};

TimerDirective.prototype.onInterval=function() {
    var currentTime=new Date();
    var hours=this._pad(currentTime.getHours());
    var minutes=this._pad(currentTime.getMinutes());
    var seconds=this._pad(currentTime.getSeconds());
    var msg="Current time:"+hours+":"+minutes+":"+seconds;
    this.directiveElement.html(msg);
};

TimerDirective.prototype._pad=function(number) {
    var number=number.toString();
    while (number.length<2) {
        number="0"+number;
    }
    return number;
};

Oblique().registerDirective("TimerDirective", TimerDirective);