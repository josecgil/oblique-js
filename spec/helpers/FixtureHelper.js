// Generated by CoffeeScript 1.10.0
(function() {
  this.FixtureHelper = (function() {
    function FixtureHelper() {}

    FixtureHelper.clear = function() {
      var fixtureJQuery;
      fixtureJQuery = $("#fixture");
      return fixtureJQuery.html("");
    };

    FixtureHelper.appendHTML = function(newHTML, times) {
      var fixtureJQuery, i, ref;
      if (times == null) {
        times = 1;
      }
      fixtureJQuery = $("#fixture");
      for (i = 1, ref = times; 1 <= ref ? i <= ref : i >= ref; 1 <= ref ? i++ : i--) {
        fixtureJQuery.append(newHTML);
      }
      return fixtureJQuery.get(0);
    };

    return FixtureHelper;

  })();

}).call(this);
