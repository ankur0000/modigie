({
	createObjectData: function(component, event) {
        // get the contactList from component and add(push) New Object to List  
        var RowItemList = component.get("v.objectList");
        RowItemList.push({
            "searchObject":"User"
        });
        // set the updated list to attribute (contactList) again    
        component.set("v.objectList", RowItemList);
    }
})