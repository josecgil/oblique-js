// Generated by CoffeeScript 1.8.0
(function() {
  describe("Oblique", function() {
    beforeEach(function(done) {
      Oblique().destroy();
      Oblique().setIntervalTimeInMs;
      FixtureHelper.clear();
      return done();
    });
    afterEach(function() {
      return Oblique().destroy();
    });
    it("On creation it has a default interval time", function() {
      return expect(Oblique().getIntervalTimeInMs()).toBe(Oblique.DEFAULT_INTERVAL_MS);
    });
    it("Can change default interval time", function() {
      var newIntervaltimeMs, oblique;
      newIntervaltimeMs = 10000;
      oblique = Oblique();
      oblique.setIntervalTimeInMs(newIntervaltimeMs);
      return expect(oblique.getIntervalTimeInMs()).toBe(newIntervaltimeMs);
    });
    it("Can't change default interval time to invalid value", function() {
      return expect(function() {
        return Oblique().setIntervalTimeInMs(-1);
      }).toThrow(new ObliqueNS.Error("IntervalTime must be a positive number"));
    });
    it("If I register a Directive it calls its constructor when expression is in DOM", function(done) {
      var TestDirective;
      TestDirective = (function() {
        function TestDirective() {
          Oblique().destroy();
          done();
        }

        return TestDirective;

      })();
      Oblique().registerDirective("TestDirective", TestDirective);
      Oblique().setIntervalTimeInMs(10);
      return $("#fixture").html("<div data-ob-directive='TestDirective'></div>");
    });
    it("If I register a Directive it calls its constructor only one time when expression is in DOM", function(done) {
      var TestDirective, counter;
      counter = 0;
      TestDirective = (function() {
        function TestDirective() {
          counter++;
        }

        return TestDirective;

      })();
      Oblique().registerDirective("TestDirective", TestDirective);
      Oblique().setIntervalTimeInMs(10);
      $("#fixture").html("<div data-ob-directive='TestDirective'></div>");
      return setTimeout(function() {
        Oblique().destroy();
        expect(counter).toBe(1);
        return done();
      }, 100);
    });
    it("If I register a Directive it calls its constructor with the correct DOM element", function(done) {
      var TestDirective;
      TestDirective = (function() {
        function TestDirective(data) {
          expect($(data.domElement).is("test[data-ob-directive='TestDirective']")).toBeTruthy();
          Oblique().destroy();
          done();
        }

        return TestDirective;

      })();
      Oblique().registerDirective("TestDirective", TestDirective);
      return $("#fixture").html("<test data-ob-directive='TestDirective'></test>");
    });
    it("If I register an object that no is a Directive it throws an Error", function() {
      return expect(function() {
        return Oblique().registerDirective("test", {});
      }).toThrow(new ObliqueNS.Error("registerDirective must be called with a Directive 'Constructor/Class'"));
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
      Oblique().registerDirective("TestDirective", TestDirective);
      return Oblique().setIntervalTimeInMs(10);
    });
    it("must execute 5 directives in a 10000 elements DOM in <400ms", function(done) {
      var DOM_ELEMENTS_COUNT, TestDirective, TestDirective2, TestDirective3, TestDirective4, TestDirective5, counter, interval;
      DOM_ELEMENTS_COUNT = 4 * 250;
      FixtureHelper.appendHTML("<p data-ob-directive='TestDirective, TestDirective2, TestDirective3, TestDirective4, TestDirective5'>nice DOM</p>", DOM_ELEMENTS_COUNT / 4);
      FixtureHelper.appendHTML("<div data-ob-directive='TestDirective, TestDirective2, TestDirective3, TestDirective4, TestDirective5'>nice DOM</div>", DOM_ELEMENTS_COUNT / 4);
      FixtureHelper.appendHTML("<span data-ob-directive='TestDirective, TestDirective2, TestDirective3, TestDirective4, TestDirective5'>nice DOM</span>", DOM_ELEMENTS_COUNT / 4);
      FixtureHelper.appendHTML("<test data-ob-directive='TestDirective, TestDirective2, TestDirective3, TestDirective4, TestDirective5'>nice DOM</test>", DOM_ELEMENTS_COUNT / 4);
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
            expect(interval.timeInMs).toBeLessThan(400);
            done();
          }
        }

        return TestDirective5;

      })();
      interval.start();
      Oblique().registerDirective("TestDirective", TestDirective);
      Oblique().registerDirective("TestDirective2", TestDirective2);
      Oblique().registerDirective("TestDirective3", TestDirective3);
      Oblique().registerDirective("TestDirective4", TestDirective4);
      Oblique().registerDirective("TestDirective5", TestDirective5);
      return Oblique().setIntervalTimeInMs(10);
    });
    it("must store and retrieve model", function() {
      Oblique().setModel("test");
      return expect(Oblique().getModel()).toBe("test");
    });
    it("must inform if it has a model", function() {
      Oblique().setModel("test");
      return expect(Oblique().hasModel()).toBeTruthy();
    });
    it("must inform if it has a model", function() {
      return expect(Oblique().hasModel()).toBeFalsy();
    });
    it("If I register a Directive and a model, directive doesn't receives model as second param", function(done) {
      var TestDirective, modelToTest;
      modelToTest = {
        name: "name",
        content: "content"
      };
      TestDirective = (function() {
        function TestDirective(data) {
          expect(data.model).toBeUndefined();
          Oblique().destroy();
          done();
        }

        return TestDirective;

      })();
      Oblique().setModel(modelToTest);
      Oblique().registerDirective("TestDirective", TestDirective);
      Oblique().setIntervalTimeInMs(10);
      return FixtureHelper.appendHTML("<div data-ob-directive='TestDirective'></div>");
    });
    it("A directive must receive only the part of the model that data-ob-model specifies", function(done) {
      var TestDirective, modelToTest;
      modelToTest = {
        name: "Carlos",
        content: "content"
      };
      TestDirective = (function() {
        function TestDirective(data) {
          expect(data.model).toBe("Carlos");
          Oblique().destroy();
          done();
        }

        return TestDirective;

      })();
      Oblique().setModel(modelToTest);
      Oblique().registerDirective("TestDirective", TestDirective);
      Oblique().setIntervalTimeInMs(10);
      return FixtureHelper.appendHTML("<div data-ob-directive='TestDirective' data-ob-model='Model.name'></div>");
    });
    it("data-ob-model must work with complex models, simple resuls", function(done) {
      var TestDirective, modelToTest;
      modelToTest = {
        name: "Carlos",
        content: "content",
        address: {
          street: "Gran Via",
          number: 42
        }
      };
      TestDirective = (function() {
        function TestDirective(data) {
          expect(data.model).toBe("Gran Via");
          Oblique().destroy();
          done();
        }

        return TestDirective;

      })();
      Oblique().setModel(modelToTest);
      Oblique().registerDirective("TestDirective", TestDirective);
      Oblique().setIntervalTimeInMs(10);
      return FixtureHelper.appendHTML("<div data-ob-directive='TestDirective' data-ob-model='Model.address.street'></div>");
    });
    it("data-ob-model must work with complex models, complex results", function(done) {
      var TestDirective, modelToTest;
      modelToTest = {
        name: "Carlos",
        content: "content",
        address: {
          street: {
            name: "Gran Via",
            number: 42
          }
        }
      };
      TestDirective = (function() {
        function TestDirective(data) {
          expect(data.model.name).toBe("Gran Via");
          expect(data.model.number).toBe(42);
          Oblique().destroy();
          done();
        }

        return TestDirective;

      })();
      Oblique().setModel(modelToTest);
      Oblique().registerDirective("TestDirective", TestDirective);
      Oblique().setIntervalTimeInMs(10);
      return FixtureHelper.appendHTML("<div data-ob-directive='TestDirective' data-ob-model='Model.address.street'></div>");
    });
    it("data-ob-model must throw an exception if property doesn't exists", function(done) {
      var TestDirective, modelToTest;
      modelToTest = {
        name: "Carlos",
        content: "content",
        address: {
          street: {
            name: "Gran Via",
            number: 42
          }
        }
      };
      TestDirective = (function() {
        function TestDirective() {}

        return TestDirective;

      })();
      Oblique().setModel(modelToTest);
      Oblique().registerDirective("TestDirective", TestDirective);
      Oblique().setIntervalTimeInMs(10);
      Oblique().onError(function(error) {
        expect(error.name).toBe("ObliqueNS.Error");
        expect(error.message).toBe('<div data-ob-directive="TestDirective" data-ob-model="Model.address.num"></div>: data-ob-model expression is undefined');
        return done();
      });
      return FixtureHelper.appendHTML("<div data-ob-directive='TestDirective' data-ob-model='Model.address.num'></div>");
    });
    it("data-ob-model must receive all model if value is 'Model'", function(done) {
      var TestDirective, modelToTest;
      modelToTest = {
        name: "name",
        content: "content"
      };
      TestDirective = (function() {
        function TestDirective(data) {
          expect(data.model).toBe(modelToTest);
          Oblique().destroy();
          done();
        }

        return TestDirective;

      })();
      Oblique().setModel(modelToTest);
      Oblique().registerDirective("TestDirective", TestDirective);
      Oblique().setIntervalTimeInMs(10);
      return FixtureHelper.appendHTML("<div data-ob-directive='TestDirective' data-ob-model='Model'></div>");
    });
    it("must throw an error if Handlebars isn't loaded", function() {
      return Oblique().renderHtml();
    });
    it("must render template", function() {
      var currentHtml, expectedHtml, modelToTest;
      modelToTest = {
        title: "titulo",
        body: "cuerpo"
      };
      expectedHtml = "<h1>titulo</h1><div>cuerpo</div>";
      currentHtml = Oblique().renderHtml("/oblique-js/spec/templates/test_ok.hbs", modelToTest);
      return expect(currentHtml).toBe(expectedHtml);
    });
    it("must throw an error if template is not found", function() {
      var modelToTest;
      modelToTest = {
        title: "titulo",
        body: "cuerpo"
      };
      return expect(function() {
        return Oblique().renderHtml("/patata.hbs", modelToTest);
      }).toThrow(new ObliqueNS.Error("template '/patata.hbs' not found"));
    });
    it("must throw an error if handlebars is not loaded", function() {
      var HandlebarsCopy;
      HandlebarsCopy = window.Handlebars;
      window.Handlebars = void 0;
      try {
        return expect(function() {
          return Oblique().renderHtml();
        }).toThrow(new ObliqueNS.Error("Oblique().renderHtml() needs handlebarsjs loaded to work"));
      } finally {
        window.Handlebars = HandlebarsCopy;
      }
    });
    it("must execute selected directive when data-ob-directive is found", function(done) {
      var TestDirective;
      TestDirective = (function() {
        function TestDirective() {
          Oblique().destroy();
          done();
        }

        return TestDirective;

      })();
      Oblique().setIntervalTimeInMs(10);
      Oblique().registerDirective("TestDirective", TestDirective);
      return $("#fixture").html("<div data-ob-directive='TestDirective'></div>");
    });
    it("must send to directive the correct data model", function(done) {
      var TestDirective, model;
      model = {
        name: "Carlos",
        address: {
          street: "Gran Via",
          number: 32
        }
      };
      Oblique().setModel(model);
      TestDirective = (function() {
        function TestDirective(data) {
          expect(data.model.name).toBe("Carlos");
          expect(data.model.address.street).toBe("Gran Via");
          expect(data.model.address.number).toBe(32);
          Oblique().destroy();
          done();
        }

        return TestDirective;

      })();
      Oblique().registerDirective("TestDirective", TestDirective);
      Oblique().setIntervalTimeInMs(10);
      return $("#fixture").html("<div data-ob-directive='TestDirective' data-ob-model='Model'>nice DOM</div>");
    });
    it("must send to directive the correct data model array", function(done) {
      var TestDirective, model;
      model = {
        name: "Azul",
        sizes: ["XS", "S", "M", "L", "XL"]
      };
      Oblique().setModel(model);
      TestDirective = (function() {
        function TestDirective(data) {
          expect(data.model).toBe("S");
          Oblique().destroy();
          done();
        }

        return TestDirective;

      })();
      Oblique().registerDirective("TestDirective", TestDirective);
      Oblique().setIntervalTimeInMs(10);
      return $("#fixture").html("<div data-ob-directive='TestDirective' data-ob-model='Model.sizes[1]'>nice DOM</div>");
    });
    it("must create an instance of the selected model-data class", function(done) {
      var Settings, TestDirective;
      TestDirective = (function() {
        function TestDirective(data) {
          var settings;
          settings = data.model;
          expect(settings instanceof Settings).toBeTruthy();
          expect(settings.brand).toBe("VC");
          expect(settings.country).toBe("ES");
          delete window.Settings;
          Oblique().destroy();
          done();
        }

        return TestDirective;

      })();
      Settings = (function() {
        function Settings() {
          this.brand = "VC";
          this.country = "ES";
        }

        return Settings;

      })();
      window.Settings = Settings;
      Oblique().registerDirective("TestDirective", TestDirective);
      Oblique().setIntervalTimeInMs(10);
      return $("#fixture").html("<div data-ob-directive='TestDirective' data-ob-model='new Settings()'>nice DOM</div>");
    });
    it("must throw an error if class in data-ob-model doesn't exists", function(done) {
      var TestDirective;
      TestDirective = (function() {
        function TestDirective() {}

        return TestDirective;

      })();
      Oblique().registerDirective("TestDirective", TestDirective);
      Oblique().setIntervalTimeInMs(10);
      Oblique().onError(function(error) {
        expect(error.name).toBe("ObliqueNS.Error");
        expect(error.message).toBe('<div data-ob-directive="TestDirective" data-ob-model="new InventedClass()">nice DOM</div>: data-ob-model expression error: InventedClass is not defined');
        Oblique().destroy();
        return done();
      });
      return $("#fixture").html("<div data-ob-directive='TestDirective' data-ob-model='new InventedClass()'>nice DOM</div>");
    });
    it("must pass simple param to directive", function(done) {
      var TestDirective;
      TestDirective = (function() {
        function TestDirective(data) {
          expect(data.params.name).toBe("Carlos");
          Oblique().destroy();
          done();
        }

        return TestDirective;

      })();
      Oblique().registerDirective("TestDirective", TestDirective);
      Oblique().setIntervalTimeInMs(10);
      return $("#fixture").html("<div data-ob-directive='TestDirective' data-ob-params='{\"name\":\"Carlos\"}'>nice DOM</div>");
    });
    it("must pass complex param to directive", function(done) {
      var TestDirective;
      TestDirective = (function() {
        function TestDirective(data) {
          expect(data.params.name).toBe("Carlos");
          expect(data.params.address.street).toBe("Gran Via");
          expect(data.params.address.number).toBe(42);
          Oblique().destroy();
          done();
        }

        return TestDirective;

      })();
      Oblique().registerDirective("TestDirective", TestDirective);
      Oblique().setIntervalTimeInMs(10);
      return $("#fixture").html("<div data-ob-directive='TestDirective' data-ob-params='{\"name\":\"Carlos\", \"address\":{\"street\":\"Gran Via\", \"number\":42}}'>nice DOM</div>");
    });
    it("must throw an error if param is not valid JSON", function(done) {
      var TestDirective;
      TestDirective = (function() {
        function TestDirective() {}

        return TestDirective;

      })();
      Oblique().registerDirective("TestDirective", TestDirective);
      Oblique().setIntervalTimeInMs(10);
      Oblique().onError(function(error) {
        expect(error.name).toBe("ObliqueNS.Error");
        expect(error.message).toBe("<div data-ob-directive=\"TestDirective\" data-ob-params=\"patata\">nice DOM</div>: data-ob-params parse error: Unexpected token p");
        Oblique().destroy();
        return done();
      });
      return $("#fixture").html("<div data-ob-directive='TestDirective' data-ob-params='patata'>nice DOM</div>");
    });
    it("must catch data-ob-directive, data-ob-model & data-ob-params in a single data param", function(done) {
      var TestDirective;
      Oblique().setModel("my model");
      TestDirective = (function() {
        function TestDirective(directiveData) {
          expect(directiveData.domElement.outerHTML).toBe("<div data-ob-directive=\"TestDirective\" data-ob-model=\"Model\" data-ob-params=\"{&quot;simpleparam&quot;:&quot;simple param&quot;}\">nice DOM</div>");
          expect(directiveData.jQueryElement.get(0).outerHTML).toBe(directiveData.domElement.outerHTML);
          expect(directiveData.model).toBe("my model");
          expect(directiveData.params.simpleparam).toBe("simple param");
          Oblique().destroy();
          done();
        }

        return TestDirective;

      })();
      Oblique().registerDirective("TestDirective", TestDirective);
      Oblique().setIntervalTimeInMs(10);
      return $("#fixture").html("<div data-ob-directive='TestDirective' data-ob-model='Model' data-ob-params='{\"simpleparam\":\"simple param\"}'>nice DOM</div>");
    });
    it("must set to undefined model if data-ob-model is not present", function(done) {
      var TestDirective;
      Oblique().setModel("my model");
      TestDirective = (function() {
        function TestDirective(directiveData) {
          expect(directiveData.model).toBeUndefined();
          Oblique().destroy();
          done();
        }

        return TestDirective;

      })();
      Oblique().registerDirective("TestDirective", TestDirective);
      Oblique().setIntervalTimeInMs(10);
      return $("#fixture").html("<div data-ob-directive='TestDirective' data-ob-params='{\"simpleparam\":\"simple param\"}'>nice DOM</div>");
    });
    it("must set to undefined params if data-ob-params is not present", function(done) {
      var TestDirective;
      Oblique().setModel("my model");
      TestDirective = (function() {
        function TestDirective(directiveData) {
          expect(directiveData.params).toBeUndefined();
          Oblique().destroy();
          done();
        }

        return TestDirective;

      })();
      Oblique().registerDirective("TestDirective", TestDirective);
      Oblique().setIntervalTimeInMs(10);
      return $("#fixture").html("<div data-ob-directive='TestDirective' data-ob-model='Model'>nice DOM</div>");
    });
    it("must eval JS expression in data-ob-model and send it to directive", function(done) {
      var TestDirective, User, model;
      model = {
        name: "Carlos",
        surname: "Gil"
      };
      Oblique().setModel(model);
      TestDirective = (function() {
        function TestDirective(data) {
          var user;
          user = data.model;
          expect(user instanceof User).toBeTruthy();
          expect(user.name).toBe("Carlos");
          delete window.User;
          Oblique().destroy();
          done();
        }

        return TestDirective;

      })();
      User = (function() {
        function User(name) {
          this.name = name;
        }

        return User;

      })();
      window.User = User;
      Oblique().registerDirective("TestDirective", TestDirective);
      Oblique().setIntervalTimeInMs(10);
      return $("#fixture").html("<div data-ob-directive='TestDirective' data-ob-model='var carlos=new User(Model.name)'>nice DOM</div>");
    });
    it("must eval JS expression in data-ob-model and send it to directive when variable is global", function(done) {
      var TestDirective, User, model;
      model = {
        name: "Carlos",
        surname: "Gil"
      };
      Oblique().setModel(model);
      TestDirective = (function() {
        function TestDirective(data) {
          var user;
          user = data.model;
          expect(user instanceof User).toBeTruthy();
          expect(user.name).toBe("Carlos");
          delete window.User;
          Oblique().destroy();
          done();
        }

        return TestDirective;

      })();
      User = (function() {
        function User(name) {
          this.name = name;
        }

        return User;

      })();
      window.User = User;
      Oblique().registerDirective("TestDirective", TestDirective);
      Oblique().setIntervalTimeInMs(10);
      return $("#fixture").html("<div data-ob-directive='TestDirective' data-ob-model='carlos=new User(Model.name)'>nice DOM</div>");
    });
    it("must eval JS expression in data-ob-model and send it to directive when variable name contains 'var' keyword", function(done) {
      var TestDirective, User, model;
      model = {
        name: "Carlos",
        surname: "Gil"
      };
      Oblique().setModel(model);
      TestDirective = (function() {
        function TestDirective(data) {
          var user;
          user = data.model;
          expect(user instanceof User).toBeTruthy();
          expect(user.name).toBe("Carlos");
          delete window.User;
          delete window.variable;
          Oblique().destroy();
          done();
        }

        return TestDirective;

      })();
      User = (function() {
        function User(name) {
          this.name = name;
        }

        return User;

      })();
      window.User = User;
      Oblique().registerDirective("TestDirective", TestDirective);
      Oblique().setIntervalTimeInMs(10);
      return $("#fixture").html("<div data-ob-directive='TestDirective' data-ob-model='variable=new User(Model.name)'>nice DOM</div>");
    });
    it("must store & retrieve a simple variable in data-ob-model attribute", function(done) {
      var TestDirective, TestDirective2, count;
      count = 0;
      TestDirective = (function() {
        function TestDirective(data) {
          expect(data.model).toBe(32);
          count++;
        }

        return TestDirective;

      })();
      TestDirective2 = (function() {
        function TestDirective2(data) {
          count++;
          expect(count).toBe(2);
          expect(data.model).toBe(32);
          Oblique().destroy();
          done();
        }

        return TestDirective2;

      })();
      Oblique().registerDirective("TestDirective", TestDirective);
      Oblique().registerDirective("TestDirective2", TestDirective2);
      Oblique().setIntervalTimeInMs(10);
      FixtureHelper.clear();
      FixtureHelper.appendHTML("<div data-ob-directive='TestDirective' data-ob-model='var variable=32'>nice DOM</div>");
      return FixtureHelper.appendHTML("<div data-ob-directive='TestDirective2' data-ob-model='variable'>nice DOM</div>");
    });
    it("must store & retrieve a complex variable in data-ob-model attribute", function(done) {
      var Colors, TestDirective, TestDirective2, count;
      count = 0;
      TestDirective = (function() {
        function TestDirective(data) {
          var colors;
          colors = data.model;
          expect(colors.values[0]).toBe("Red");
          expect(colors.values[1]).toBe("Green");
          colors.values.push("Blue");
          count++;
        }

        return TestDirective;

      })();
      TestDirective2 = (function() {
        function TestDirective2(data) {
          var colors;
          count++;
          expect(count).toBe(2);
          colors = data.model;
          expect(colors.values[0]).toBe("Red");
          expect(colors.values[1]).toBe("Green");
          expect(colors.values[2]).toBe("Blue");
          Oblique().destroy();
          done();
        }

        return TestDirective2;

      })();
      Colors = (function() {
        function Colors(values) {
          this.values = values;
        }

        return Colors;

      })();
      window.Colors = Colors;
      Oblique().registerDirective("TestDirective", TestDirective);
      Oblique().registerDirective("TestDirective2", TestDirective2);
      Oblique().setIntervalTimeInMs(10);
      FixtureHelper.clear();
      FixtureHelper.appendHTML("<div data-ob-directive='TestDirective' data-ob-model='var colors=new Colors([\"Red\",\"Green\"])'>nice DOM</div>");
      return FixtureHelper.appendHTML("<div data-ob-directive='TestDirective2' data-ob-model='colors'>nice DOM</div>");
    });
    it("must work when variable name in data-ob-model matchs local variable name", function(done) {
      var TestDirective;
      TestDirective = (function() {
        function TestDirective(data) {
          expect(data.model).toBe(32);
          Oblique().destroy();
          done();
        }

        return TestDirective;

      })();
      Oblique().registerDirective("TestDirective", TestDirective);
      Oblique().setIntervalTimeInMs(10);
      FixtureHelper.clear();
      return FixtureHelper.appendHTML("<div data-ob-directive='TestDirective' data-ob-model='var dataModelExpr=32'>nice DOM</div>");
    });
    it("must throw an error if a variable named Model is set in data-ob-model", function(done) {
      var TestDirective;
      TestDirective = (function() {
        function TestDirective() {}

        return TestDirective;

      })();
      Oblique().onError(function(error) {
        expect(error.message).toBe("<div data-ob-directive=\"TestDirective\" data-ob-model=\"var Model=32\">nice DOM</div>: data-ob-model expression error: Can't create a variable named 'Model', is a reserved word");
        Oblique().destroy();
        return done();
      });
      Oblique().registerDirective("TestDirective", TestDirective);
      Oblique().setIntervalTimeInMs(10);
      FixtureHelper.clear();
      return FixtureHelper.appendHTML("<div data-ob-directive='TestDirective' data-ob-model='var Model=32'>nice DOM</div>");
    });
    it("must retrieve simple params from window.location.hash", function() {
      var paramsCollection;
      window.location.hash = "#sort=desc";
      paramsCollection = Oblique().getHashParams();
      expect(paramsCollection.count()).toBe(1);
      return expect(paramsCollection.getParam("sort").value).toBe("desc");
    });
    it("must retrieve complex params from window.location.hash", function() {
      var colorValues, paramsCollection;
      window.location.hash = "#sort=desc&price=(10,30)&colors=[rojo,amarillo,verde]";
      paramsCollection = Oblique().getHashParams();
      expect(paramsCollection.count()).toBe(3);
      expect(paramsCollection.getParam("sort").value).toBe("desc");
      expect(paramsCollection.getParam("price").min).toBe("10");
      expect(paramsCollection.getParam("price").max).toBe("30");
      colorValues = paramsCollection.getParam("colors").values;
      expect(colorValues[0]).toBe("rojo");
      expect(colorValues[1]).toBe("amarillo");
      return expect(colorValues[2]).toBe("verde");
    });
    it("must set window.location.hash from a simple paramCollection", function() {
      var paramsCollection;
      window.location.hash = "";
      paramsCollection = Oblique().getHashParams();
      paramsCollection.addSingleParam("sort", "asc");
      Oblique().setHashParams(paramsCollection);
      return expect(window.location.hash).toBe("#sort=asc");
    });
    return it("must set window.location.hash from a complex paramCollection", function() {
      var paramsCollection;
      window.location.hash = "";
      paramsCollection = Oblique().getHashParams();
      paramsCollection.addSingleParam("sort", "asc");
      paramsCollection.addRangeParam("price", "10", "40");
      paramsCollection.addArrayParam("sizes", ["101", "104", "105"]);
      Oblique().setHashParams(paramsCollection);
      return expect(window.location.hash).toBe("#sort=asc&price=(10,40)&sizes=[101,104,105]");
    });
  });

}).call(this);
