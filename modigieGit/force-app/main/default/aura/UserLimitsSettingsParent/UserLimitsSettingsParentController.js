({
	doInit: function(component, event, helper) {
        // create a Default RowItem [Contact Instance] on first time Component Load
        // by call this helper function  
        if(!component.get('v.objectList').length){
        	helper.createObjectData(component, event);    
        }
        
    },
    addNewRow: function(component, event, helper) {
        // call the comman "createObjectData" helper method for add new Object Row to List  
        helper.createObjectData(component, event);
    },
 removeDeletedRow: function(component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute  
        var index = event.getParam("indexVar");
        // get the all List (contactList attribute) and remove the Object Element Using splice method    
        var AllRowsList = component.get("v.objectList");
        AllRowsList.splice(index, 1);
     // set the contactList after remove selected row element  
     component.set("v.objectList", AllRowsList);
 },
    Save: function(component, event, helper) {
        var lstObj = component.get('v.objectList');

        var allDataValidated = true;

        for(var i = 0; i < lstObj.length; i++){
            if(lstObj[i].SelectedOptionValue == null){
                allDataValidated = false;
                lstObj[i].UserOrProfileField = true;
            }
            else{
                lstObj[i].UserOrProfileField = false;
            }

            if(lstObj[i].numberOfLimits == null || isNaN(parseInt(lstObj[i].numberOfLimits)) || parseInt(lstObj[i].numberOfLimits) < 1 || parseInt(lstObj[i].numberOfLimits) > 99999){
                allDataValidated = false;
                lstObj[i].LimitsField = true;
            }
            else{
                lstObj[i].LimitsField = false;
            }
        }
        component.set('v.objectList',lstObj);
        if(allDataValidated){
            var action = component.get("c.storeUserProfileLimits");
            action.setParams({
                "dataMap" : component.get('v.objectList')
            })
            
            action.setCallback(this, function(response){
            });
            $A.enqueueAction(action);	
            return true;
        }
        
    }
})