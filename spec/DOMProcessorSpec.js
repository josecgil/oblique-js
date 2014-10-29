// Generated by CoffeeScript 1.8.0
(function() {
  describe("DOMProcessor", function() {
    var DOMProcessor, ObError;
    DOMProcessor = ObliqueNS.DOMProcessor;
    ObError = ObliqueNS.Error;
    beforeEach(function(done) {
      DOMProcessor().destroy();
      DOMProcessor().setIntervalTimeInMs(10);
      FixtureHelper.clear();
      return done();
    });
    afterEach(function() {
      return DOMProcessor().destroy();
    });
    it("On creation it has a default interval time", function() {
      DOMProcessor().destroy();
      return expect(DOMProcessor().getIntervalTimeInMs()).toBe(DOMProcessor.DEFAULT_INTERVAL_MS);
    });
    it("Can change default interval time", function() {
      var newIntervaltimeMs, oblique;
      newIntervaltimeMs = 10000;
      oblique = DOMProcessor();
      oblique.setIntervalTimeInMs(newIntervaltimeMs);
      return expect(oblique.getIntervalTimeInMs()).toBe(newIntervaltimeMs);
    });
    it("Can't change default interval time to invalid value", function() {
      return expect(function() {
        return DOMProcessor().setIntervalTimeInMs(-1);
      }).toThrow(new ObError("IntervalTime must be a positive number"));
    });
    it("If I register a Directive it calls its constructor when data-ob-directive is in DOM", function(done) {
      var TestDirective;
      TestDirective = (function() {
        function TestDirective() {
          DOMProcessor().destroy();
          done();
        }

        return TestDirective;

      })();
      DOMProcessor().registerDirective("TestDirective", TestDirective);
      DOMProcessor().setIntervalTimeInMs(10);
      return $("#fixture").html("<div data-ob-directive='TestDirective'></div>");
    });
    it("If I register a Directive it calls its constructor only one time when data-ob-directive is in DOM", function(done) {
      var TestDirective, counter;
      counter = 0;
      TestDirective = (function() {
        function TestDirective() {
          counter++;
        }

        return TestDirective;

      })();
      DOMProcessor().registerDirective("TestDirective", TestDirective);
      DOMProcessor().setIntervalTimeInMs(10);
      FixtureHelper.appendHTML("<div data-ob-directive='TestDirective'></div>");
      return setTimeout(function() {
        DOMProcessor().destroy();
        expect(counter).toBe(1);
        return done();
      }, 100);
    });
    it("If I register a Directive it calls its constructor with the correct DOM element", function(done) {
      var TestDirective;
      TestDirective = (function() {
        function TestDirective(data) {
          expect($(data.domElement).is("test[data-ob-directive='TestDirective']")).toBeTruthy();
          DOMProcessor().destroy();
          done();
        }

        return TestDirective;

      })();
      DOMProcessor().registerDirective("TestDirective", TestDirective);
      return FixtureHelper.appendHTML("<test data-ob-directive='TestDirective'></test>");
    });
    it("must call 2 _callbacks if there are in the same tag", function(done) {
      var HideOnClickDirective, ShowOnClickDirective, calls;
      calls = {};
      HideOnClickDirective = (function() {
        function HideOnClickDirective() {
          calls["TestDirective1"] = true;
          if (calls.TestDirective1 && calls.TestDirective2) {
            DOMProcessor().destroy();
            done();
          }
        }

        return HideOnClickDirective;

      })();
      ShowOnClickDirective = (function() {
        function ShowOnClickDirective() {
          calls["TestDirective2"] = true;
          if (calls.TestDirective1 && calls.TestDirective2) {
            DOMProcessor().destroy();
            done();
          }
        }

        return ShowOnClickDirective;

      })();
      DOMProcessor().registerDirective("ShowOnClickDirective", ShowOnClickDirective);
      DOMProcessor().registerDirective("HideOnClickDirective", HideOnClickDirective);
      return FixtureHelper.appendHTML("<test data-ob-directive='ShowOnClickDirective, HideOnClickDirective'></test>");
    });
    it("must call 2 _callbacks if there are in the same tag (2 instances of same tag)", function(done) {
      var HideOnClickDirective, ShowOnClickDirective, calls;
      calls = {};
      calls.TestDirective1 = 0;
      calls.TestDirective2 = 0;
      HideOnClickDirective = (function() {
        function HideOnClickDirective() {
          calls["TestDirective1"]++;
          if ((calls.TestDirective1 === 2) && (calls.TestDirective2 === 2)) {
            DOMProcessor().destroy();
            done();
          }
        }

        return HideOnClickDirective;

      })();
      ShowOnClickDirective = (function() {
        function ShowOnClickDirective() {
          calls["TestDirective2"]++;
          if ((calls.TestDirective1 === 2) && (calls.TestDirective2 === 2)) {
            DOMProcessor().destroy();
            done();
          }
        }

        return ShowOnClickDirective;

      })();
      DOMProcessor().registerDirective("ShowOnClickDirective", ShowOnClickDirective);
      DOMProcessor().registerDirective("HideOnClickDirective", HideOnClickDirective);
      FixtureHelper.appendHTML("<test data-ob-directive='ShowOnClickDirective, HideOnClickDirective'></test>");
      return FixtureHelper.appendHTML("<test data-ob-directive='ShowOnClickDirective, HideOnClickDirective'></test>");
    });
    it("If I register an object that no is a Directive it throws an Error", function() {
      return expect(function() {
        return DOMProcessor().registerDirective("test", {});
      }).toThrow(new ObError("registerDirective must be called with a Directive 'Constructor/Class'"));
    });
    it("must execute 1 directive in a 10000 elements DOM in <200ms", function(done) {
      var DOM_ELEMENTS_COUNT, TestDirective, counter, interval;
      DOM_ELEMENTS_COUNT = 4 * 250;
      FixtureHelper.appendHTML("<p data-ob-directive='TestDirective'>nice DOM</p>", DOM_ELEMENTS_COUNT / 4);
      FixtureHelper.appendHTML("<div data-ob-directive='TestDirective'>nice DOM</div>", DOM_ELEMENTS_COUNT / 4);
      FixtureHelper.appendHTML("<span data-ob-directive='TestDirective'>nice DOM</span>", DOM_ELEMENTS_COUNT / 4);
      FixtureHelper.appendHTML("<test data-ob-directive='TestDirective'>nice DOM</test>", DOM_ELEMENTS_COUNT / 4);
      interval = new Interval();
      counter = 0;
      TestDirective = (function() {
        function TestDirective() {
          counter++;
          if (counter === DOM_ELEMENTS_COUNT) {
            interval.stop();
            expect(interval.timeInMs).toBeLessThan(200);
            done();
          }
        }

        return TestDirective;

      })();
      interval.start();
      DOMProcessor().registerDirective("TestDirective", TestDirective);
      return DOMProcessor().setIntervalTimeInMs(10);
    });
    it("must execute 5 _callbacks in a 10000 elements DOM in <400ms", function(done) {
      var DOM_ELEMENTS_COUNT, TestDirective, TestDirective2, TestDirective3, TestDirective4, TestDirective5, counter, interval;
      DOM_ELEMENTS_COUNT = 4 * 250;
      FixtureHelper.appendHTML("<p data-ob-directive='TestDirective,TestDirective2, TestDirective3, TestDirective4, TestDirective5'>nice DOM</p>", DOM_ELEMENTS_COUNT / 4);
      FixtureHelper.appendHTML("<div data-ob-directive='TestDirective,TestDirective2, TestDirective3, TestDirective4, TestDirective5'>nice DOM</div>", DOM_ELEMENTS_COUNT / 4);
      FixtureHelper.appendHTML("<span data-ob-directive='TestDirective,TestDirective2, TestDirective3, TestDirective4, TestDirective5'>nice DOM</span>", DOM_ELEMENTS_COUNT / 4);
      FixtureHelper.appendHTML("<test data-ob-directive='TestDirective,TestDirective2, TestDirective3, TestDirective4, TestDirective5'>nice DOM</test>", DOM_ELEMENTS_COUNT / 4);
      interval = new Interval();
      counter = 0;
      TestDirective = (function() {
        function TestDirective() {
          counter++;
        }

        return TestDirective;

      })();
      TestDirective2 = (function() {
        function TestDirective2() {
          counter++;
        }

        return TestDirective2;

      })();
      TestDirective3 = (function() {
        function TestDirective3() {
          counter++;
        }

        return TestDirective3;

      })();
      TestDirective4 = (function() {
        function TestDirective4() {
          counter++;
        }

        return TestDirective4;

      })();
      TestDirective5 = (function() {
        function TestDirective5() {
          counter++;
          if (counter === (DOM_ELEMENTS_COUNT * 5)) {
            interval.stop();
            console.log("Processed 5 _callbacks in a 10000 elements DOM in " + interval.timeInMs + "ms");
            expect(interval.timeInMs).toBeLessThan(400);
            done();
          }
        }

        return TestDirective5;

      })();
      interval.start();
      DOMProcessor().registerDirective("TestDirective", TestDirective);
      DOMProcessor().registerDirective("TestDirective2", TestDirective2);
      DOMProcessor().registerDirective("TestDirective3", TestDirective3);
      DOMProcessor().registerDirective("TestDirective4", TestDirective4);
      DOMProcessor().registerDirective("TestDirective5", TestDirective5);
      return DOMProcessor().setIntervalTimeInMs(10);
    });
    return it("must execute 4 _callbacks with different CSSExpressions", function(done) {
      var DOM_ELEMENTS_COUNT, TestDirective, TestDirective2, TestDirective3, TestDirective4, counter;
      DOM_ELEMENTS_COUNT = 4 * 250;
      FixtureHelper.appendHTML("<p data-ob-directive='TestDirective'>nice DOM</p>", DOM_ELEMENTS_COUNT / 4);
      FixtureHelper.appendHTML("<div data-ob-directive='TestDirective2'>nice DOM</div>", DOM_ELEMENTS_COUNT / 4);
      FixtureHelper.appendHTML("<span data-ob-directive='TestDirective3'>nice DOM</span>", DOM_ELEMENTS_COUNT / 4);
      FixtureHelper.appendHTML("<test data-ob-directive='TestDirective4'>nice DOM</test>", DOM_ELEMENTS_COUNT / 4);
      counter = 0;
      TestDirective = (function() {
        function TestDirective() {
          counter++;
        }

        return TestDirective;

      })();
      TestDirective2 = (function() {
        function TestDirective2() {
          counter++;
        }

        return TestDirective2;

      })();
      TestDirective3 = (function() {
        function TestDirective3() {
          counter++;
        }

        return TestDirective3;

      })();
      TestDirective4 = (function() {
        function TestDirective4() {
          counter++;
          if (counter === DOM_ELEMENTS_COUNT) {
            done();
          }
        }

        return TestDirective4;

      })();
      DOMProcessor().registerDirective("TestDirective", TestDirective);
      DOMProcessor().registerDirective("TestDirective2", TestDirective2);
      DOMProcessor().registerDirective("TestDirective3", TestDirective3);
      DOMProcessor().registerDirective("TestDirective4", TestDirective4);
      return DOMProcessor().setIntervalTimeInMs(10);
    });
  });

}).call(this);