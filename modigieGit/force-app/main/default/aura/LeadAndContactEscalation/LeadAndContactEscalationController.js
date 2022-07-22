({
	/*doinit : function(component, event, helper) {
		var recid = component.get('v.recordId');
        var action = component.get("c.checkModigieRecord");
        action.setParams({
            "recid": recid
        });
        action.setCallback(this, function(response){
            if(response.getReturnValue() == 'Validated')
            {
                component.set("v.StatusCheck",true);
                var message = "Your record is already "+response.getReturnValue()
                component.set("v.StatusMessage",message);
                
            }
            else if(response.getReturnValue() == 'In Escalation')
            {
                component.set("v.StatusCheck",true);
                var message = "Your record is already "+response.getReturnValue()
                component.set("v.StatusMessage",message);
                
            }
                else if(response.getReturnValue() == 'Not available')
                {
                    component.set("v.StatusCheck",true);
                    var message = "Your record is "+response.getReturnValue()
                    component.set("v.StatusMessage",message);
                    
                }
                    else if(response.getReturnValue() == 'Requires More Research')
                    {
                        component.set("v.viewEscalationMessage", true);
                    }
        });
        $A.enqueueAction(action);
    },
    
    submitModel : function(component, event, helper){
        var recid = component.get('v.recordId');
        component.set("v.disableSubmit", true);
        component.set("v.toggleSpinner", true);
        
        var action1 = component.get("c.escalateRecord");
        action1.setParams({
            "recid": recid
        });
        action1.setCallback(this, function(response1){
            var state = response1.getState();
            if (state === "SUCCESS")
            {
                var calloutResponse = JSON.parse(response1.getReturnValue());
                var stringresponse = calloutResponse.toString();
                var action2 = component.get("c.updateOnEscalation");
                action2.setParams({
                    "response": stringresponse,
                    "recid": recid
                });
                action2.setCallback(this, function(response2){
                    component.set("v.toggleSpinner", false);
                    if(response2.getReturnValue() == 'success')
                    {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type": "success",
                            "title": "Success!",
                            "message": "Congratulations, Your record has been escalated"
                        });
                        toastEvent.fire();
                        var dismissActionPanel = $A.get("e.force:closeQuickAction");
                        dismissActionPanel.fire();
                    }
                    else
                    {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type": "error",
                            "title": "Error!",
                            "message": "Please try again, Error encountered"
                        });
                        toastEvent.fire();
                        var dismissActionPanel = $A.get("e.force:closeQuickAction");
                        dismissActionPanel.fire();
                    }
                });
                $A.enqueueAction(action2);
            }
            else if (state === "ERROR") 
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error",
                    "title": "Error!",
                    "message": "Please try again, Error encountered"
                });
                toastEvent.fire();
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
                location.reload();
            }            
        });
        $A.enqueueAction(action1);
        
    },
    
    closeModel : function(component, event, helper) {
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    }
   */ 
})