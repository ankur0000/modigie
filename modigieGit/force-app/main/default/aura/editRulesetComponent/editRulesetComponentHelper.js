({
    helperMethod : function() {

    },

    createObjectData : function(component,event) {
        console.log('component.get(\'v.contactCriteriaList\') -->',component.get('v.contactCriteriaList').length);
        var RowItemList;
        if(component.get('v.selectedObject') == 'Lead'){
            RowItemList = component.get("v.critriaList");
            RowItemList.push({SelectedField:component.get('v.fields')[0].apiname, SelectedOperator:"notEquals", CriteriaValue:""});
            // set the updated list to attribute (contactList) again    
            component.set("v.critriaList", RowItemList);
        }

        if(component.get('v.selectedObject') == 'Contact' || !component.get('v.contactCriteriaList').length){
            RowItemList = component.get('v.contactCriteriaList');
            RowItemList.push({SelectedField:component.get('v.fields')[2].apiname, SelectedOperator:"notEquals", CriteriaValue:""});
            component.set('v.contactCriteriaList', RowItemList)
        }
        
    }
})