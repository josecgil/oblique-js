var TodoListDirective=function (data) {
    var addButton=data.jQueryElement.find("button");
    var addInputText=data.jQueryElement.find("input");
    var todoListUl=data.jQueryElement.find("ul");


    addButton.click(function(event){
        event.preventDefault();
        var text=addInputText.val();
        todoListUl.append("<li>"+text+" <a href='#'>x</a></li>");
    });

    todoListUl.on("click","a", function(event){
        event.preventDefault();
        $(event.target).parent().remove();
    });

};

Oblique().registerDirective("TodoListDirective", TodoListDirective);