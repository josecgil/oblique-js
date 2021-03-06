// Generated by CoffeeScript 1.10.0
(function() {
  describe("Element", function() {
    var Element;
    Element = ObliqueNS.Element;
    beforeEach(function(done) {
      $("#fixture").html("");
      return done();
    });
    afterEach(function() {
      return $("#fixture").html("");
    });
    it("Can traverse a simple DOM", function(done) {
      var count, rootElement, testHTML;
      testHTML = "<div>A simple DOM</div>";
      rootElement = FixtureHelper.appendHTML(testHTML);
      count = 0;
      return Element._traverse(rootElement, function(DOMElement) {
        count++;
        if (count === 2) {
          expect($(DOMElement).get(0).outerHTML).toBe(testHTML);
          return done();
        }
      });
    });
    it("Can traverse a normal DOM", function(done) {
      var ELEMENTS_COUNT, count, rootElement, testHTML;
      testHTML = "<div>A medium DOM</div>";
      ELEMENTS_COUNT = 10;
      rootElement = FixtureHelper.appendHTML(testHTML, ELEMENTS_COUNT);
      count = 0;
      return Element._traverse(rootElement, function(DOMElement) {
        count++;
        if (count !== ELEMENTS_COUNT + 1) {
          return;
        }
        expect($(DOMElement).get(0).outerHTML).toBe(testHTML);
        return done();
      });
    });
    it("Can traverse a large DOM", function(done) {
      var ELEMENTS_COUNT, count, rootElement, testHTML;
      testHTML = "<div>A large DOM</div>";
      ELEMENTS_COUNT = 10000;
      rootElement = FixtureHelper.appendHTML(testHTML, ELEMENTS_COUNT);
      count = 0;
      return Element._traverse(rootElement, function(DOMElement) {
        count++;
        if (count !== ELEMENTS_COUNT + 1) {
          return;
        }
        expect($(DOMElement).get(0).outerHTML).toBe(testHTML);
        return done();
      });
    });
    it("Can traverse complex DOM", function(done) {
      var rootElement, testHTML, traversedDOMElements;
      testHTML = "<div id='one'>A complex <strong>DOM</strong>.<p>Is Here</p>.</div>";
      rootElement = FixtureHelper.appendHTML(testHTML);
      traversedDOMElements = [];
      return Element._traverse(rootElement, function(DOMElement) {
        traversedDOMElements.push($(DOMElement));
        if (traversedDOMElements.length !== 4) {
          return;
        }
        expect(traversedDOMElements[0].is("div#fixture")).toBeTruthy();
        expect(traversedDOMElements[1].is("div#one")).toBeTruthy();
        expect(traversedDOMElements[2].is("strong")).toBeTruthy();
        expect(traversedDOMElements[3].is("p")).toBeTruthy();
        return done();
      });
    });
    it("If a set a flag, flag is set", function() {
      var FLAG_NAME, bqElement, fixture, testHTML;
      testHTML = "<div></div>";
      fixture = FixtureHelper.appendHTML(testHTML);
      bqElement = new Element(fixture);
      FLAG_NAME = "visited";
      bqElement.setFlag(FLAG_NAME);
      return expect(bqElement.hasFlag(FLAG_NAME)).toBeTruthy();
    });
    it("If a set a flag and I recreate the same DOMElement flag is set", function() {
      var FLAG_NAME, bqElement, bqElement2, fixture, hasVisitedFlag, testHTML;
      testHTML = "<div></div>";
      fixture = FixtureHelper.appendHTML(testHTML);
      bqElement = new Element(fixture);
      FLAG_NAME = "visited";
      bqElement.setFlag(FLAG_NAME);
      bqElement2 = new Element(fixture);
      hasVisitedFlag = bqElement2.hasFlag(FLAG_NAME);
      return expect(hasVisitedFlag).toBeTruthy();
    });
    it("If a unset a flag, flag is not present", function() {
      var FLAG_NAME, bqElement, fixture;
      fixture = $("#fixture");
      bqElement = new Element(fixture.get(0));
      FLAG_NAME = "visited";
      bqElement.setFlag(FLAG_NAME);
      expect(bqElement.hasFlag(FLAG_NAME)).toBeTruthy();
      bqElement.unsetFlag(FLAG_NAME);
      return expect(bqElement.hasFlag(FLAG_NAME)).toBeFalsy();
    });
    it("must know if an attribute is present", function() {
      var bqElement;
      FixtureHelper.appendHTML("<div id='data-model-test1' data-model='name'></div>");
      bqElement = new Element($("#data-model-test1"));
      return expect(bqElement.hasAttribute("data-model")).toBeTruthy();
    });
    it("must know if an attribute is present", function() {
      var bqElement;
      FixtureHelper.appendHTML("<div id='data-model-test2'></div>");
      bqElement = new Element($("#data-model-test2"));
      return expect(bqElement.hasAttribute("data-model")).toBeFalsy();
    });
    it("must return undefined if an attribute isn't present", function() {
      var bqElement;
      FixtureHelper.appendHTML("<div id='data-model-test2'></div>");
      bqElement = new Element($("#data-model-test2"));
      return expect(bqElement.getAttributeValue("data-model")).toBeUndefined();
    });
    it("must know an attribute value", function() {
      var bqElement;
      FixtureHelper.appendHTML("<div id='data-model-test3' data-model='name'></div>");
      bqElement = new Element($("#data-model-test3"));
      return expect(bqElement.getAttributeValue("data-model")).toBe("name");
    });
    it("must returns element html", function() {
      var bqElement;
      FixtureHelper.appendHTML('<div id="elementHtml" data-test="element html"></div>');
      bqElement = new Element($("#elementHtml"));
      return expect(bqElement.getHtml()).toBe('<div id="elementHtml" data-test="element html"></div>');
    });
    it("must returns DOMElement", function() {
      var bqElement;
      FixtureHelper.appendHTML('<div id="elementHtml" data-test="element html"></div>');
      bqElement = new Element($("#elementHtml"));
      return expect(bqElement.getDOMElement().outerHTML).toBe('<div id="elementHtml" data-test="element html"></div>');
    });
    return it("must returns jQueryElement", function() {
      var bqElement;
      FixtureHelper.appendHTML('<div id="elementHtml" data-test="element html"></div>');
      bqElement = new Element($("#elementHtml"));
      return expect(bqElement.getjQueryElement().get(0).outerHTML).toBe('<div id="elementHtml" data-test="element html"></div>');
    });
  });

}).call(this);
