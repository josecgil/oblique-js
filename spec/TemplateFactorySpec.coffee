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