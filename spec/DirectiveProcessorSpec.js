// Generated by CoffeeScript 1.7.1
(function() {
  describe("DirectiveProcessor", function() {
    var DirectiveProcessor, ObError;
    DirectiveProcessor = ObliqueNS.DirectiveProcessor;
    ObError = ObliqueNS.Error;
    beforeEach(function(done) {
      DirectiveProcessor().destroy();
      DirectiveProcessor().setIntervalTimeInMs(10);
      FixtureHelper.clear();
      return done();
    });
    afterEach(function() {
      return DirectiveProcessor().destroy();
    });
    it("On creation it has a default interval time", function() {
      DirectiveProcessor().destroy();
      return expect(DirectiveProcessor().getIntervalTimeInMs()).toBe(DirectiveProcessor.DEFAULT_INTERVAL_MS);
    });
    it("Can change default interval time", function() {
      var newIntervaltimeMs, oblique;
      newIntervaltimeMs = 10000;
      oblique = DirectiveProcessor();
      oblique.setIntervalTimeInMs(newIntervaltimeMs);
      return expect(oblique.getIntervalTimeInMs()).toBe(newIntervaltimeMs);
    });
    it("Can't change default interval time to invalid value", function() {
      return expect(function() {
        return DirectiveProcessor().setIntervalTimeInMs(-1);
      }).toThrow(new ObError("IntervalTime must be a positive number"));
    });
    it("If I register a Directive it calls its constructor when data-directive is in DOM", function(done) {
      var TestDirective;
      TestDirective = (function() {
        function TestDirective() {
          DirectiveProcessor().destroy();
          done();
        }

        return TestDirective;

      })();
      DirectiveProcessor().registerDirective("TestDirective", TestDirective);
      DirectiveProcessor().setIntervalTimeInMs(10);
      return $("#fixture").html("<div data-directive='TestDirective'></div>");
    });
    it("If I register a Directive it calls its constructor only one time when data-directive is in DOM", function(done) {
      var TestDirective, counter;
      counter = 0;
      TestDirective = (function() {
        function TestDirective() {
          counter++;
        }

        return TestDirective;

      })();
      DirectiveProcessor().registerDirective("TestDirective", TestDirective);
      DirectiveProcessor().setIntervalTimeInMs(10);
      FixtureHelper.appendHTML("<div data-directive='TestDirective'></div>");
      return setTimeout(function() {
        DirectiveProcessor().destroy();
        expect(counter).toBe(1);
        return done();
      }, 100);
    });
    it("If I register a Directive it calls its constructor with the correct DOM element", function(done) {
      var TestDirective;
      TestDirective = (function() {
        function TestDirective(data) {
          expect($(data.domElement).is("test[data-directive='TestDirective']")).toBeTruthy();
          DirectiveProcessor().destroy();
          done();
        }

        return TestDirective;

      })();
      DirectiveProcessor().registerDirective("TestDirective", TestDirective);
      return FixtureHelper.appendHTML("<test data-directive='TestDirective'></test>");
    });
    it("must call 2 directives if there are in the same tag", function(done) {
      var HideOnClickDirective, ShowOnClickDirective, calls;
      calls = {};
      HideOnClickDirective = (function() {
        function HideOnClickDirective() {
          calls["TestDirective1"] = true;
          if (calls.TestDirective1 && calls.TestDirective2) {
            DirectiveProcessor().destroy();
            done();
          }
        }

        return HideOnClickDirective;

      })();
      ShowOnClickDirective = (function() {
        function ShowOnClickDirective() {
          calls["TestDirective2"] = true;
          if (calls.TestDirective1 && calls.TestDirective2) {
            DirectiveProcessor().destroy();
            done();
          }
        }

        return ShowOnClickDirective;

      })();
      DirectiveProcessor().registerDirective("ShowOnClickDirective", ShowOnClickDirective);
      DirectiveProcessor().registerDirective("HideOnClickDirective", HideOnClickDirective);
      return FixtureHelper.appendHTML("<test data-directive='ShowOnClickDirective, HideOnClickDirective'></test>");
    });
    it("must call 2 directives if there are in the same tag (2 instances of same tag)", function(done) {
      var HideOnClickDirective, ShowOnClickDirective, calls;
      calls = {};
      calls.TestDirective1 = 0;
      calls.TestDirective2 = 0;
      HideOnClickDirective = (function() {
        function HideOnClickDirective() {
          calls["TestDirective1"]++;
          if ((calls.TestDirective1 === 2) && (calls.TestDirective2 === 2)) {
            DirectiveProcessor().destroy();
            done();
          }
        }

        return HideOnClickDirective;

      })();
      ShowOnClickDirective = (function() {
        function ShowOnClickDirective() {
          calls["TestDirective2"]++;
          if ((calls.TestDirective1 === 2) && (calls.TestDirective2 === 2)) {
            DirectiveProcessor().destroy();
            done();
          }
        }

        return ShowOnClickDirective;

      })();
      DirectiveProcessor().registerDirective("ShowOnClickDirective", ShowOnClickDirective);
      DirectiveProcessor().registerDirective("HideOnClickDirective", HideOnClickDirective);
      FixtureHelper.appendHTML("<test data-directive='ShowOnClickDirective, HideOnClickDirective'></test>");
      return FixtureHelper.appendHTML("<test data-directive='ShowOnClickDirective, HideOnClickDirective'></test>");
    });
    it("If I register an object that no is a Directive it throws an Error", function() {
      return expect(function() {
        return DirectiveProcessor().registerDirective("test", {});
      }).toThrow(new ObError("registerDirective must be called with a Directive 'Constructor/Class'"));
    });
    it("must execute 1 directive in a 10000 elements DOM in <200ms", function(done) {
      var DOM_ELEMENTS_COUNT, TestDirective, counter, interval;
      DOM_ELEMENTS_COUNT = 4 * 250;
      FixtureHelper.appendHTML("<p data-directive='TestDirective'>nice DOM</p>", DOM_ELEMENTS_COUNT / 4);
      FixtureHelper.appendHTML("<div data-directive='TestDirective'>nice DOM</div>", DOM_ELEMENTS_COUNT / 4);
      FixtureHelper.appendHTML("<span data-directive='TestDirective'>nice DOM</span>", DOM_ELEMENTS_COUNT / 4);
      FixtureHelper.appendHTML("<test data-directive='TestDirective'>nice DOM</test>", DOM_ELEMENTS_COUNT / 4);
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
      DirectiveProcessor().registerDirective("TestDirective", TestDirective);
      return DirectiveProcessor().setIntervalTimeInMs(10);
    });
    it("must execute 5 directives in a 10000 elements DOM in <400ms", function(done) {
      var DOM_ELEMENTS_COUNT, TestDirective, TestDirective2, TestDirective3, TestDirective4, TestDirective5, counter, interval;
      DOM_ELEMENTS_COUNT = 4 * 250;
      FixtureHelper.appendHTML("<p data-directive='TestDirective,TestDirective2, TestDirective3, TestDirective4, TestDirective5'>nice DOM</p>", DOM_ELEMENTS_COUNT / 4);
      FixtureHelper.appendHTML("<div data-directive='TestDirective,TestDirective2, TestDirective3, TestDirective4, TestDirective5'>nice DOM</div>", DOM_ELEMENTS_COUNT / 4);
      FixtureHelper.appendHTML("<span data-directive='TestDirective,TestDirective2, TestDirective3, TestDirective4, TestDirective5'>nice DOM</span>", DOM_ELEMENTS_COUNT / 4);
      FixtureHelper.appendHTML("<test data-directive='TestDirective,TestDirective2, TestDirective3, TestDirective4, TestDirective5'>nice DOM</test>", DOM_ELEMENTS_COUNT / 4);
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
            console.log("Processed 5 directives in a 10000 elements DOM in " + interval.timeInMs + "ms");
            expect(interval.timeInMs).toBeLessThan(400);
            done();
          }
        }

        return TestDirective5;

      })();
      interval.start();
      DirectiveProcessor().registerDirective("TestDirective", TestDirective);
      DirectiveProcessor().registerDirective("TestDirective2", TestDirective2);
      DirectiveProcessor().registerDirective("TestDirective3", TestDirective3);
      DirectiveProcessor().registerDirective("TestDirective4", TestDirective4);
      DirectiveProcessor().registerDirective("TestDirective5", TestDirective5);
      return DirectiveProcessor().setIntervalTimeInMs(10);
    });
    return it("must execute 4 directives with different CSSExpressions", function(done) {
      var DOM_ELEMENTS_COUNT, TestDirective, TestDirective2, TestDirective3, TestDirective4, counter;
      DOM_ELEMENTS_COUNT = 4 * 250;
      FixtureHelper.appendHTML("<p data-directive='TestDirective'>nice DOM</p>", DOM_ELEMENTS_COUNT / 4);
      FixtureHelper.appendHTML("<div data-directive='TestDirective2'>nice DOM</div>", DOM_ELEMENTS_COUNT / 4);
      FixtureHelper.appendHTML("<span data-directive='TestDirective3'>nice DOM</span>", DOM_ELEMENTS_COUNT / 4);
      FixtureHelper.appendHTML("<test data-directive='TestDirective4'>nice DOM</test>", DOM_ELEMENTS_COUNT / 4);
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
      DirectiveProcessor().registerDirective("TestDirective", TestDirective);
      DirectiveProcessor().registerDirective("TestDirective2", TestDirective2);
      DirectiveProcessor().registerDirective("TestDirective3", TestDirective3);
      DirectiveProcessor().registerDirective("TestDirective4", TestDirective4);
      return DirectiveProcessor().setIntervalTimeInMs(10);
    });
  });

}).call(this);
