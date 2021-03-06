// Generated by CoffeeScript 1.10.0
(function() {
  describe("TimedDOMObserver", function() {
    var TimedDOMObserver;
    TimedDOMObserver = ObliqueNS.TimedDOMObserver;
    beforeEach(function(done) {
      return done();
    });
    afterEach(function() {});
    it("should be called almost one time", function(done) {
      var observer;
      observer = new TimedDOMObserver(10);
      observer.onChange(function() {
        observer.destroy();
        return done();
      });
      return observer.observe();
    });
    return it("should be called almost 10 times", function(done) {
      var count, observer;
      count = 0;
      observer = new TimedDOMObserver(1);
      observer.onChange(function() {
        count++;
        if (count === 10) {
          return observer.destroy();
        }
      });
      setTimeout(function() {
        expect(count).toBe(10);
        return done();
      }, 500);
      return observer.observe();
    });
  });

}).call(this);
