describe "Template", ->

  Template=ObliqueNS.Template

  beforeEach ->

  afterEach ->

  it "must renderHTML a simple template with a simple model", ->
    template=new Template("Hello {{this}}!")
    model="world"
    expect(template.renderHTML model).toBe "Hello world!"

  it "must renderHTML a simple template with a normal model", ->
    template=new Template("{{greeting}} {{person}}!")
    model=
      greeting: "Hello"
      person: "world"

    expect(template.renderHTML model).toBe "Hello world!"

  it "must renderHTML a template with loop", ->

    templateContent="""
      <p>{{count}} comentarios</p>
      <ul>
        {{#comments}}<li><a href="/posts/comments/{{id}}">{{title}}</a></li>{{/comments}}
      </ul>
    """

    html="""
      <p>2 comentarios</p>
      <ul>
        <li><a href="/posts/comments/1">title1</a></li><li><a href="/posts/comments/2">title2</a></li>
      </ul>
    """

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

    template=new Template(templateContent)
    expect(template.renderHTML(model)).toBe html


