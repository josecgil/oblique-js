// Generated by CoffeeScript 1.10.0
(function() {
  var TimedDOMObserver;

  this.ObliqueNS = this.ObliqueNS || {};

  TimedDOMObserver = (function() {
    function TimedDOMObserver(intervalInMs) {
      this.intervalInMs = intervalInMs;
      this._intervalId = void 0;
      this._callback = function() {};
    }

    TimedDOMObserver.prototype.onChange = function(callback) {
      return this._callback = callback;
    };

    TimedDOMObserver.prototype.getIntervalInMs = function() {
      return this.intervalInMs;
    };

    TimedDOMObserver.prototype.observe = function() {
      return this._intervalId = setInterval((function(_this) {
        return function() {
          return _this._callback();
        };
      })(this), this.intervalInMs);
    };

    TimedDOMObserver.prototype.destroy = function() {
      if (this._intervalId) {
        clearInterval(this._intervalId);
      }
      return this._intervalId = void 0;
    };

    return TimedDOMObserver;

  })();

  ObliqueNS.TimedDOMObserver = TimedDOMObserver;

}).call(this);
