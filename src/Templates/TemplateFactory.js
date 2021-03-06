// Generated by CoffeeScript 1.10.0
(function() {
  var TemplateFactory;

  this.ObliqueNS = this.ObliqueNS || {};

  TemplateFactory = (function() {
    var Template;

    function TemplateFactory() {}

    Template = ObliqueNS.Template;

    TemplateFactory.prototype.createFromString = function(templateStr) {
      return new Template(templateStr);
    };

    TemplateFactory.prototype.createFromDOMElement = function(element) {
      return this.createFromString($(element).html());
    };

    TemplateFactory.prototype.createFromUrl = function(url) {
      var errorMessage, errorStatusCode, template, templateContent;
      templateContent = void 0;
      errorStatusCode = 200;
      errorMessage = void 0;
      jQuery.ajax({
        url: url,
        success: function(data) {
          return templateContent = data;
        },
        error: function(e) {
          errorStatusCode = e.status;
          return errorMessage = e.statusCode;
        },
        async: false
      });
      if (errorStatusCode === 404) {
        throw new ObliqueNS.Error("template '" + url + "' not found");
      }
      if (errorStatusCode !== 200) {
        throw new ObliqueNS.Error(errorMessage);
      }
      return template = this.createFromString(templateContent);
    };

    return TemplateFactory;

  })();

  ObliqueNS.TemplateFactory = TemplateFactory;

}).call(this);
