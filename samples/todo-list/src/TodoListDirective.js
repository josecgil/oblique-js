var TodoListDirective=function (data) {
    this.itemCollection=data.model;
    var addButton=data.jQueryElement.find("button");
    var addInputText=data.jQueryElement.find("input");
    this.todoListSection=data.jQueryElement.find("section");

    var self=this;

    addButton.click(function(event){
        event.preventDefault();
        var text=addInputText.val();
        self.itemCollection.add(text);
        self.renderHTML();
    });

    this.todoListSection.on("click","a", function(event){
        event.preventDefault();
        var id=$(event.target).attr("data-id");
        self.itemCollection.removeById(id);
        self.renderHTML();
    });

};

TodoListDirective.prototype.renderHTML=function() {
    var items=Oblique().renderHTML("Templates/items.hbs", this.itemCollection.allItems());
    this.todoListSection.html(items);
};


Oblique().registerDirective("TodoListDirective", TodoListDirective);