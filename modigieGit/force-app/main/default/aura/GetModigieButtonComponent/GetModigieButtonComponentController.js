({
    /*doInit: function(component, event, helper) {
        var recid = component.get('v.recordId');
        var action = component.get("c.checkValidateRecord");
        action.setParams({
            "recid": recid
        });
        action.setCallback(this, function(response){
            if(response.getReturnValue() == 'Validated')
            {
                component.set("v.StatusCheck",true);
                var message = "The record is already validated";
                component.set("v.StatusMessage",message);
                
            }
            /   else if(response.getReturnValue() == 'In Escalation')
            {
                component.set("v.StatusCheck",true);
                var message = "The record is already "+response.getReturnValue()
                component.set("v.StatusMessage",message);
                
            }
                else if(response.getReturnValue() == 'Requires More Research')
                {
                    component.set("v.StatusCheck",true);
                    var message = "The record "+response.getReturnValue();
                    component.set("v.StatusMessage",message);
                    
                }  
            else if(response.getReturnValue() == 'Not available')
            {
                component.set("v.StatusCheck",true);
                var message = "The record is unvalidated";
                component.set("v.StatusMessage",message);
                
            }
                else if(response.getReturnValue() == 'No record Available')
                {
                    component.set("v.alreadySynced",true);
                }
                    else if(response.getReturnValue() == 'You are not an authorized User')
                    {
                        component.set("v.StatusCheck",true);
                        var message = response.getReturnValue();
                        component.set("v.StatusMessage",message);
                        
                    }
                        else if(response.getReturnValue() == 'Unfortunately, your account does not have enough credits to process your request.  Please inform your administrator or contact Modigie at support@modigie.com or call 415-960-4474 to add more credits to your account.')
                        {
                            component.set("v.StatusCheck",true);
                            var message = response.getReturnValue();
                            component.set("v.StatusMessage",message);
                        }
            else if(response.getReturnValue() == 'User does not have needed permissions for Access Token object and/or fields.')
            {
                component.set("v.StatusCheck",true);
                            var message = response.getReturnValue();
                            component.set("v.StatusMessage",message);
            }
        });
        $A.enqueueAction(action);
    },
    
    openModel: function(component, event, helper) {
        var recid = component.get('v.recordId');
        component.set("v.toggleSpinner", true);
        component.set("v.disableSubmit", true);
        var action1 = component.get("c.makeGetCallout");
        var currentdate = new Date(); 
        var datetime = currentdate.getHours() + ":"  
      //  + (currentdate.getMonth()+1)  + "/" 
      //  + currentdate.getFullYear() + " @ "  
        
        + currentdate.getMinutes() + ":" 
        + currentdate.getSeconds();
        action1.setParams({
            "recid": recid
        });
        action1.setCallback(this, function(response1){
            
            var currentdate1 = new Date(); 
        var datetime1 = currentdate1.getHours() + ":"
     //   + (currentdate1.getMonth()+1)  + "/" 
     //   + currentdate1.getFullYear() + " @ "  
          
        + currentdate1.getMinutes() + ":" 
        + currentdate1.getSeconds();
            
            
            var calloutResponse = JSON.parse(response1.getReturnValue());
            if(calloutResponse == 'Invalid token!')
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error",
                    "title": "Error!",
                    "message": "Invalid token!"
                });
                toastEvent.fire();
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
            else if(calloutResponse == 'Error! Not enough credits available for this client!')
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error",
                    "title": "Error!",
                    "message": "Error! Not enough credits available for this client!"
                });
                toastEvent.fire();
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
            else if(calloutResponse == 'Invalid user!')
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error",
                    "title": "Error!",
                    "message": "Invalid user!"
                });
                toastEvent.fire();
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
            else if(calloutResponse == 'Error! Not enough values provided!')
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error",
                    "title": "Error!",
                    "message": "Error! Not enough values provided!"
                });
                toastEvent.fire();
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
            else
            {
            var state = response1.getState();
            if (state === "SUCCESS")
            {
                var action2 = component.get("c.dataToModigie");
                var stringresponse = calloutResponse.toString();
                action2.setParams({
                    "resMap": stringresponse,
                    "recids": recid,
                    "jobstart": datetime,
                    "jobend": datetime1,
                });
                action2.setCallback(this, function(response2){
                    component.set("v.returnMap", response2.getReturnValue());
                    var dataMap = component.get("v.returnMap");
                    component.set("v.modiRecordid", dataMap.modiRecId);
                    if(dataMap.Status == 'VALIDATED')
                    {
                        component.set("v.toggleSpinner", false);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type": "success",
                            "title": "Success!",
                            "message": "Thank you, the record has been successfully submitted to Modigie."
                        });
                        toastEvent.fire();
                        var navEvt = $A.get("e.force:navigateToSObject");
                        navEvt.setParams({
                            "recordId": recid,
                            "slideDevName": "detail"
                        });
                        navEvt.fire();
                    }
                    else if(dataMap.Status == 'UNVALIDATED')
                    {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type": "info",
                            //"title": "Sorry!",
                            "message": "Unfortunately this record is not currently available"
                        });
                        toastEvent.fire();
                        var dismissActionPanel = $A.get("e.force:closeQuickAction");
                        dismissActionPanel.fire();
                      /*  var action3 = component.get("c.getToggleRecord");
                        action3.setParams({
                        });
                        action3.setCallback(this, function(response3){
                            
                            if(response3.getReturnValue() == false)
                            {
                                component.set("v.toggleSpinner", false);
                                component.set("v.getModigie", false);
                                component.set("v.disableSubmit", true);
                                component.set("v.isEscalate", true);
                            }
                            else
                            {
                                
                                // If Auto-Escalation is True Automatically escalate the record.
                                var recid = component.get('v.modiRecordid');
                                component.set("v.disableSubmit", true);
                                var action4 = component.get("c.escalateRecord");
                                action4.setParams({
                                    "recid": recid
                                });
                                action4.setCallback(this, function(response4){
                                    var state = response4.getState();
                                    if (state === "SUCCESS")
                                    {
                                        var calloutResponse = JSON.parse(response4.getReturnValue());
                                        var stringresponse = calloutResponse.toString();
                                        var action5 = component.get("c.updateOnEscalation");
                                        action5.setParams({
                                            "response": stringresponse,
                                            "recid": recid
                                        });
                                        action5.setCallback(this, function(response5){
                                            component.set("v.toggleSpinner", false);
                                            if(response5.getReturnValue() == 'success')
                                            {
                                                var toastEvent = $A.get("e.force:showToast");
                                                toastEvent.setParams({
                                                    "type": "success",
                                                    "title": "Success!",
                                                    "message": "Congratulations, The record has been escalated"
                                                });
                                                toastEvent.fire();
                                                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                                                dismissActionPanel.fire();
                                                location.reload();
                                            }
                                            else
                                            {
                                                var toastEvent = $A.get("e.force:showToast");
                                                toastEvent.setParams({
                                                    "type": "error",
                                                    "title": "Error!",
                                                    "message": "Error encountered, Please try Again"
                                                });
                                                toastEvent.fire();
                                                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                                                dismissActionPanel.fire();
                                                location.reload();
                                            }
                                        });
                                        $A.enqueueAction(action5);
                                    }
                                    else if (state === "ERROR") 
                                    {
                                        var toastEvent = $A.get("e.force:showToast");
                                        toastEvent.setParams({
                                            "type": "error",
                                            "title": "Error!",
                                            "message": "Error encountered, Please try Again"
                                        });
                                        toastEvent.fire();
                                        var dismissActionPanel = $A.get("e.force:closeQuickAction");
                                        dismissActionPanel.fire();
                                        location.reload();
                                    }            
                                });
                                $A.enqueueAction(action4);
                            }
                        });
                        $A.enqueueAction(action3);  /
                    }
                    else
                    {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type": "error",
                            "title": "Error!",
                            "message": "Please try Again"
                        });
                        toastEvent.fire();
                        var dismissActionPanel = $A.get("e.force:closeQuickAction");
                        dismissActionPanel.fire();
                       // location.reload();
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
                    "message": "Error encountered, Please try Again"
                });
                toastEvent.fire();
              //  location.reload();
            }
            }
        });
        $A.enqueueAction(action1);
    },
    
    // Escalation when Auto-escalation will off
  /*  escalate: function(component, event, helper) {
        var recid = component.get('v.modiRecordid');
        component.set("v.disableEscalateButton", true);
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
                            "message": "Congratulations, The record has been escalated"
                        });
                        toastEvent.fire();
                        var dismissActionPanel = $A.get("e.force:closeQuickAction");
                        dismissActionPanel.fire();
                        location.reload();
                    }
                    else
                    {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type": "error",
                            "title": "Error!",
                            "message": "Error encountered, Please try Again"
                        });
                        toastEvent.fire();
                        var dismissActionPanel = $A.get("e.force:closeQuickAction");
                        dismissActionPanel.fire();
                        location.reload();
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
                    "message": "Error encountered, Please try Again"
                });
                toastEvent.fire();
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
                location.reload();
            }            
        });
        $A.enqueueAction(action1);
    },
    /
    closeModel : function(component, event, helper) {
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    }*/
    
})