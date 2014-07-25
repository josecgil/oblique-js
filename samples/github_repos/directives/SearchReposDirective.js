var SearchReposDirective=function(data) {
    var lastUserName=null;
    setInterval(function(){
        var userName=data.jQueryElement.val();
        if (userName==="") return;
        if (userName===lastUserName) return;
        lastUserName=userName;
        var githubApiUrl="https://api.github.com/users/"+userName+"/repos";
        var results=$("#results");
        results.html("loading repos...");
        $.getJSON( githubApiUrl, function( githubRepos ) {
            var i, repo;
            if (githubRepos.length===0) {
                results.html("There is no github repos for this user");
                return;
            }
            results.html("");
            for(i=0; i<githubRepos.length;i++) {
                repo=githubRepos[i];
                results.append("<p>"+repo.name+"</p>");
            }
        });
    },1000);

};
Oblique().registerDirective("SearchReposDirective", SearchReposDirective);
