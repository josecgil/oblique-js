// Generated by CoffeeScript 1.10.0
(function() {
  var Template;

  this.ObliqueNS = this.ObliqueNS || {};

  Template = (function() {
    function Template(templateContent) {
      this.compiledTemplate = Handlebars.compile(templateContent);
    }

    Template.prototype.renderHTML = function(model) {
      return this.compiledTemplate(model);
    };

    return Template;

  })();

  ObliqueNS.Template = Template;

}).call(this);
