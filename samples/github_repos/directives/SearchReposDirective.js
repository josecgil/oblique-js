var SearchReposDirective=function(data) {
    this.lastUserName=null;
    this.userNameField=data.jQueryElement;
};

SearchReposDirective.prototype.onInterval=function() {
    var userName=this.userNameField.val();
    if (userName==="") return;
    if (userName===this.lastUserName) return;
    this.lastUserName=userName;
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
};

Oblique().registerDirective("SearchReposDirective", SearchReposDirective);
