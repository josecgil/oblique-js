describe("DirectiveTag Testing", function () {

    beforeEach(function () {
        FixtureHelper.clear();
    });

    afterEach(function () {

    });


    it("Can read a string attribute", function () {
        FixtureHelper.appendHTML('<img data-vc-popup src="http://srcImg.jpg"/>');
        var tag = new DirectiveTag($("img"), "data-vc-popup");
        expect(tag.attr("src")).toBe("http://srcImg.jpg");
    });

    it("Can read an int attribute", function () {
        FixtureHelper.appendHTML('<img data-vc-popup width="2"/>');
        var tag = new DirectiveTag($("img"), "data-vc-popup");
        expect(tag.intAttr("width")).toBe(2);
    });

    it("Can return a jQueryElement respresenting itself when initialized as jQuery Element", function () {
        FixtureHelper.appendHTML('<img data-vc-popup id="UniqueId"/>');
        var tag = new DirectiveTag($("img"), "data-vc-popup");
        expect(tag.jQueryElement.attr("id")).toBe("UniqueId");
    });

    it("Can return a jQueryElement respresenting itself when initialized a normal DOMElement", function () {
        FixtureHelper.appendHTML('<img data-vc-popup id="UniqueId"/>');
        var tag = new DirectiveTag(document.getElementById("UniqueId"), "data-vc-popup");
        expect(tag.jQueryElement.attr("id")).toBe("UniqueId");
    });

    it("Can read an int data-vc-param format", function () {
        FixtureHelper.appendHTML('<a data-vc-popup="width:110;height:500"></a>');
        var directiveTag = new DirectiveTag($("a"), "data-vc-popup");
        expect(directiveTag.intParam("width")).toBe(110);
        expect(directiveTag.intParam("height")).toBe(500);
    });

    it("Can read a string without quotes and blank spaces data-vc-param format", function () {
        FixtureHelper.appendHTML('<a data-vc-test="test:hola"></a>');
        var directiveTag = new DirectiveTag($("a"), "data-vc-test");
        expect(directiveTag.param("test")).toBe("hola");
    });

    it("Can read a string with simple quotes and blank spaces data-vc-param format", function () {
        FixtureHelper.appendHTML('<a data-vc-test="test:\'hola\'"></a>');
        var directiveTag = new DirectiveTag($("a"), "data-vc-test");
        expect(directiveTag.param("test")).toBe("hola");
    });

    it("Can read a string with only a single quote data-vc-param format", function () {
        FixtureHelper.appendHTML('<a data-vc-test="test:\'"></a>');
        var directiveTag = new DirectiveTag($("a"), "data-vc-test");
        expect(directiveTag.param("test")).toBe("'");
    });

    it("Can read a string with only two single quotes data-vc-param format", function () {
        FixtureHelper.appendHTML('<a data-vc-test="test:\'\'"></a>');
        var directiveTag = new DirectiveTag($("a"), "data-vc-test");
        expect(directiveTag.param("test")).toBe("");
    });

    it("Can read a string with double quotes data-vc-param format", function () {
        FixtureHelper.appendHTML("<a data-vc-test='test:\"hola\"'></a>");
        var directiveTag = new DirectiveTag($("a"), "data-vc-test");
        expect(directiveTag.param("test")).toBe("hola");
    });

    it("Can read a param with insentive param name data-vc-param format", function () {
        FixtureHelper.appendHTML('<a data-vc-test="TeSt:hola"></a>');
        var directiveTag = new DirectiveTag($("a"), "data-vc-test");
        expect(directiveTag.param("tEst")).toBe("hola");
    });

    it("Can read a string with simple quotes inside the value data-vc-param format", function () {
        FixtureHelper.appendHTML('<a data-vc-test="test:\'L\'Hospitalet\'"></a>');
        var directiveTag = new DirectiveTag($("a"), "data-vc-test");
        expect(directiveTag.param("test")).toBe("L'Hospitalet");
    });

    it("Can read a string with double quotes inside the value data-vc-param format", function () {
        FixtureHelper.appendHTML("<a data-vc-test='test:\"L\"Hospitalet\"'></a>");
        var directiveTag = new DirectiveTag($("a"), "data-vc-test");
        expect(directiveTag.param("test")).toBe('L"Hospitalet');
    });

    it("Can read params with extras blank spaces data-vc-param format", function () {
        FixtureHelper.appendHTML('<a data-vc-test="test: hola ; test2: \'k\' ;test3 : \'ase\'"></a>');
        var directiveTag = new DirectiveTag($("a"), "data-vc-test");
        expect(directiveTag.param("test")).toBe("hola");
        expect(directiveTag.param("test2")).toBe("k");
        expect(directiveTag.param("test3")).toBe("ase");
    });

    it("Can read params with doubles extras blank spaces data-vc-param format", function () {
        FixtureHelper.appendHTML('<a data-vc-test="test:  hola  ;  test2:  \'k\'  ;test3  :  \'ase\'"></a>');
        var directiveTag = new DirectiveTag($("a"), "data-vc-test");
        expect(directiveTag.param("test")).toBe("hola");
        expect(directiveTag.param("test2")).toBe("k");
        expect(directiveTag.param("test3")).toBe("ase");
    });

    it("Can read data-vc-params from two directives in same tag", function () {
        FixtureHelper.appendHTML('<a data-vc-popup="width:110;height:500" data-vc-test="test:hola"></a>');
        var PopupDirectiveTag = new DirectiveTag($("a"), "data-vc-popup");
        var TestDirectiveTag = new DirectiveTag($("a"), "data-vc-test");
        expect(PopupDirectiveTag.intParam("width")).toBe(110);
        expect(PopupDirectiveTag.intParam("height")).toBe(500);
        expect(TestDirectiveTag.param("test")).toBe("hola");
    });


    it("Can read int data-vc-params with string in value", function () {
        FixtureHelper.appendHTML('<a data-vc-popup="width:110px;height:500px"></a>');
        var PopupDirectiveTag = new DirectiveTag($("a"), "data-vc-popup");
        expect(PopupDirectiveTag.intParam("width")).toBe(110);
        expect(PopupDirectiveTag.intParam("height")).toBe(500);
        expect(PopupDirectiveTag.param("width")).toBe("110px");
        expect(PopupDirectiveTag.param("height")).toBe("500px");
    });


    it("Throws an error if format is incorrect", function () {
        FixtureHelper.appendHTML('<a data-vc-popup="width=110"></a>');
        expect(function () { new DirectiveTag($("a"), "data-vc-popup") }).toThrow(new DirectiveTagError("invalid param 'data-vc-popup -> width=110'"));
    });

    it("Throws an error if value is empty", function () {
        FixtureHelper.appendHTML('<a data-vc-popup="width:"></a>');
        expect(function () { new DirectiveTag($("a"), "data-vc-popup") }).toThrow(new DirectiveTagError("invalid param 'data-vc-popup -> width hasn't value'"));
    });

    it("Must read an empty quote value", function () {
        FixtureHelper.appendHTML('<a data-vc-popup="width:\'\'"></a>');
        var PopupDirectiveTag = new DirectiveTag($("a"), "data-vc-popup");
        expect(PopupDirectiveTag.param("width")).toBe("");
    });

    
    it("Throws an error if second param value is empty", function () {
        FixtureHelper.appendHTML('<a data-vc-popup="width:120;height"></a>');
        expect(function () { new DirectiveTag($("a"), "data-vc-popup") }).toThrow(new DirectiveTagError("invalid param 'data-vc-popup -> height'"));
    });

    it("Throws an error if key value is empty", function () {
        FixtureHelper.appendHTML('<a data-vc-popup=":120px"></a>');
        expect(function () { new DirectiveTag($("a"), "data-vc-popup") }).toThrow(new DirectiveTagError("invalid param 'data-vc-popup -> :120px hasn't key'"));
    });

    //TODO: separar en clases diferentes los estilos diferentes de paso de parámetros
    //
    //var params = new NamedParams("width:110px;height:500px",";").params --> {width:"110px", height:"500px"}
    //var params = new ListParams("#id; .class", ";").params --> ["#id",".class"]

    //TODO: hacer estas clases disponibles como métodos de Oblique()
    //Oblique().parseNamedParams("width:110px;height:500px",";")
    //Oblique().parseListParams("#id; .class", ";")

});
