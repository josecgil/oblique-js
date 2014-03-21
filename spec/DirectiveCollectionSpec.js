// Generated by CoffeeScript 1.7.1
(function() {
  describe("DirectiveCollection", function() {
    var DirectiveCollection, ObError;
    DirectiveCollection = ObliqueNS.DirectiveCollection;
    ObError = ObliqueNS.Error;
    beforeEach(function() {});
    afterEach(function() {});
    it("must be empty when created", function() {
      var directives;
      directives = new DirectiveCollection();
      return expect(directives.count()).toBe(0);
    });
    it("must has 1 item when I added one Directive", function() {
      var TestDirective, directives;
      TestDirective = (function() {
        function TestDirective() {}

        TestDirective.CSS_EXPRESSION = ".test";

        return TestDirective;

      })();
      directives = new DirectiveCollection();
      directives.add(TestDirective);
      expect(directives.count()).toBe(1);
      return expect(directives.at(0)).toBe(TestDirective);
    });
    it("must return 2 CSSExpressions when I added 2 Directive with different CSSExpressions", function() {
      var TestDirective, TestDirective2, cssExpressions, directives;
      TestDirective = (function() {
        function TestDirective() {}

        TestDirective.CSS_EXPRESSION = ".test";

        return TestDirective;

      })();
      TestDirective2 = (function() {
        function TestDirective2() {}

        TestDirective2.CSS_EXPRESSION = ".test2";

        return TestDirective2;

      })();
      directives = new DirectiveCollection();
      directives.add(TestDirective);
      directives.add(TestDirective2);
      cssExpressions = directives.getCSSExpressions();
      expect(cssExpressions.length).toBe(2);
      expect(cssExpressions[0]).toBe(TestDirective.CSS_EXPRESSION);
      return expect(cssExpressions[1]).toBe(TestDirective2.CSS_EXPRESSION);
    });
    it("must return 1 CSSExpressions when I added 2 Directive with same CSSExpressions", function() {
      var TestDirective, TestDirective2, cssExpressions, directives;
      TestDirective = (function() {
        function TestDirective() {}

        TestDirective.CSS_EXPRESSION = ".test";

        return TestDirective;

      })();
      TestDirective2 = (function() {
        function TestDirective2() {}

        TestDirective2.CSS_EXPRESSION = ".test";

        return TestDirective2;

      })();
      directives = new DirectiveCollection();
      directives.add(TestDirective);
      directives.add(TestDirective2);
      cssExpressions = directives.getCSSExpressions();
      expect(cssExpressions.length).toBe(1);
      return expect(cssExpressions[0]).toBe(TestDirective.CSS_EXPRESSION);
    });
    it("must return all directives that have a CSSExpressions", function() {
      var TestDirective, TestDirective2, TestDirective3, directives;
      TestDirective = (function() {
        function TestDirective() {}

        TestDirective.CSS_EXPRESSION = ".test";

        return TestDirective;

      })();
      TestDirective2 = (function() {
        function TestDirective2() {}

        TestDirective2.CSS_EXPRESSION = ".test";

        return TestDirective2;

      })();
      TestDirective3 = (function() {
        function TestDirective3() {}

        TestDirective3.CSS_EXPRESSION = ".test2";

        return TestDirective3;

      })();
      directives = new DirectiveCollection();
      directives.add(TestDirective);
      directives.add(TestDirective2);
      directives.add(TestDirective3);
      expect(directives.getDirectivesByCSSExpression(".test").length).toBe(2);
      return expect(directives.getDirectivesByCSSExpression(".test2").length).toBe(1);
    });
    it("If I add a Directive without CSS_EXPRESSION it throws an Error", function() {
      var TestDirective, directivesCollection;
      TestDirective = (function() {
        function TestDirective() {}

        return TestDirective;

      })();
      directivesCollection = new DirectiveCollection();
      return expect(function() {
        return directivesCollection.add(TestDirective);
      }).toThrow(new ObError("directive must has an static CSS_EXPRESSION property"));
    });
    return it("If I add an object that no is a Directive it throws an Error", function() {
      var directivesCollection;
      directivesCollection = new DirectiveCollection();
      return expect(function() {
        return directivesCollection.add({});
      }).toThrow(new ObError("registerDirective must be called with a Directive 'Constructor/Class'"));
    });
  });

}).call(this);
