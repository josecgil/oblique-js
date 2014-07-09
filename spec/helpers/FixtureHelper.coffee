class @FixtureHelper

  @clear : ->
    fixtureJQuery = $("#fixture")
    fixtureJQuery.html("")

  @appendHTML : (newHTML, times=1) ->
    fixtureJQuery = $("#fixture")
    fixtureJQuery.append newHTML for [1..times]
    fixtureJQuery.get 0


