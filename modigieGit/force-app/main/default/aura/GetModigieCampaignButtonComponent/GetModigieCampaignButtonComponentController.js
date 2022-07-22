({
  /*  doInit: function(component, event, helper){
        var recid = component.get('v.recordId');
        var action = component.get("c.CampaignCallout");
        action.setParams({
            "recid": recid
        });
        action.setCallback(this, function(response){
            component.set("v.resMap", response.getReturnValue());
            var count = response.getReturnValue();
            if(count.TokenExist == 1)
            {
                component.set("v.showModel", true);
                component.set("v.totalCampaignMembers", count.totalSize);
                component.set("v.alreadyValidatedMembers",count.alreadyValidated);
                component.set("v.recordsToProcess", count.recordsToProcess);
                component.set("v.memberCount", count.recordsToProcess);
                component.set("v.creditCount", count.remainingCredit);
                var state = response.getState();         
            }
            else
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error",
                    "title": "Error!",
                    "message": "You are not an authorised user"
                });
                toastEvent.fire();
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            //    location.reload();
            }
            
        });
        $A.enqueueAction(action);
    },
    
    SyncNewRecords: function(component, event, helper) {
        var recid = component.get('v.recordId');
        component.set("v.disableSubmit", true);
        if(component.get('v.memberCount') == 0)
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "No records available to process"
            });
            toastEvent.fire();
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
        }
        else if(component.get('v.creditCount') >= component.get('v.memberCount'))
        {
            component.set("v.toggleSpinner", true);
            var action = component.get("c.campaignCalloutForNewMembers");
            action.setParams({
                "recid": recid
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                component.set("v.toggleSpinner", false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "title": "Success!",
                    "message": "The records have been successfully submitted to Modigie."
                });
                toastEvent.fire();
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            });
            $A.enqueueAction(action);
        }
        else if(component.get('v.creditCount') < component.get('v.memberCount'))
        {
            var redSize = component.get('v.memberCount') - component.get('v.creditCount');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "The batch size is "+component.get('v.memberCount')+" and the available credits are not enough. Please reduce the number of selected records to "+redSize
            });
            toastEvent.fire();
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
        }
    },
    
    closeModel : function(component, event, helper) {
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    }
  */  
})