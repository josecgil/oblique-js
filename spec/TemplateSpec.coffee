describe "Template", ->
  beforeEach ->

  afterEach ->

  it "must parse a simple template with a simple model", ->
    template=new Template()
    template.setContent "Hello {{this}}!"
    model="world"
    expect(template.parse model).toBe "Hello world!"

  it "must parse a simple template with a normal model", ->
    template=new Template()
    template.setContent "{{greeting}} {{person}}!"
    model=
      greeting: "Hello"
      person: "world"

    expect(template.parse model).toBe "Hello world!"

###
  it "must parse a template with loop", ->
    template=new Template()

    templateContent="""
      <p>{{count}} comentarios</p>
      <ul>
        {{#comments}}
          <li><a href="/posts/comments/{{id}}">{{title}}</a></li>
        {{/comments}}
      </ul>
    """

    html="""
      <p>2 comentarios</p>
      <ul>
        <li><a href='/posts/comments/1'>title1</a></li>
        <li><a href='/posts/comments/2'>title2</a></li>
      </ul>
    """


    template.setContent(templateContent)
    model= {
      count: "2",
      comments: [
        {
          id: "1",
          title: "title1"
        },
        {
          id: "2",
          title: "title2"
        }
      ]
    }

    expect(template.parse(model)).toBe html
###

class Template

  constructor:()->

  setContent:(@content) ->

  parse:(model) ->
    compiledTemplate = Handlebars.compile(@content)
    compiledTemplate(model)