describe "TemplateFactory", ->

  TemplateFactory=ObliqueNS.TemplateFactory

  beforeEach ->
    FixtureHelper.clear()

  afterEach ->
    FixtureHelper.clear()

  it "must create a template from string", ->
    templateFactory=new TemplateFactory()
    template=templateFactory.createFromString "Hello {{this}}!"
    expect(template.renderHTML("world")).toBe "Hello world!"

  it "must create a template from tag", ->
    templateContent="<script id='hello' type='text/x-handlebars-template'>Hello {{this}}!</script>"
    FixtureHelper.appendHTML templateContent

    templateFactory=new TemplateFactory()
    template=templateFactory.createFromDOMElement $("#hello")
    expect(template.renderHTML("world")).toBe "Hello world!"

  it "must create a template from Url", ->
    model=
      title: "titulo"
      body: "cuerpo"

    html="<h1>titulo</h1><div>cuerpo</div>"

    templateFactory=new TemplateFactory()
    template=templateFactory.createFromUrl "/oblique-js/spec/templates/test_ok.hbs"
    expect(template.renderHTML(model)).toBe html

  it "must throw an error if template is not found", ->
    expect(->
      new TemplateFactory().createFromUrl "/patata.hbs"
    ).toThrow(new ObliqueNS.Error("template '/patata.hbs' not found"))




