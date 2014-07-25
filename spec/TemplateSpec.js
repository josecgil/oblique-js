// Generated by CoffeeScript 1.7.1
(function() {
  describe("Template", function() {
    var Template;
    Template = ObliqueNS.Template;
    beforeEach(function() {});
    afterEach(function() {});
    it("must renderHTML a simple template with a simple model", function() {
      var model, template;
      template = new Template("Hello {{this}}!");
      model = "world";
      return expect(template.renderHTML(model)).toBe("Hello world!");
    });
    it("must renderHTML a simple template with a normal model", function() {
      var model, template;
      template = new Template("{{greeting}} {{person}}!");
      model = {
        greeting: "Hello",
        person: "world"
      };
      return expect(template.renderHTML(model)).toBe("Hello world!");
    });
    return it("must renderHTML a template with loop", function() {
      var html, model, template, templateContent;
      templateContent = "<p>{{count}} comentarios</p>\n<ul>\n  {{#comments}}<li><a href=\"/posts/comments/{{id}}\">{{title}}</a></li>{{/comments}}\n</ul>";
      html = "<p>2 comentarios</p>\n<ul>\n  <li><a href=\"/posts/comments/1\">title1</a></li><li><a href=\"/posts/comments/2\">title2</a></li>\n</ul>";
      model = {
        count: "2",
        comments: [
          {
            id: "1",
            title: "title1"
          }, {
            id: "2",
            title: "title2"
          }
        ]
      };
      template = new Template(templateContent);
      return expect(template.renderHTML(model)).toBe(html);
    });
  });

}).call(this);
