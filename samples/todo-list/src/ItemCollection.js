var ItemCollection=function() {
    this.items=[];
    this.lastId=0;
};

ItemCollection.prototype.newId=function() {
    return this.lastId++;
};

ItemCollection.prototype.add=function(text){
    var newItem={
        id:this.newId(),
        text:text
    };
    this.items.push(newItem);
};

ItemCollection.prototype.removeById=function(id) {
    for(var i=0; i<this.items.length; i++) {
        var item=this.items[i];
        if (item.id==id) {
            this.items.splice(i, 1);
            return item;
        }
    }
    return null;
};

ItemCollection.prototype.allItems=function() {
    return this.items;
};