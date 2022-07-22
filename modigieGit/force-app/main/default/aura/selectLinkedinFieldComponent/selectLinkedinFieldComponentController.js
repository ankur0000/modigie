({
    doInit : function(component, event, helper) {
        var action = component.get('c.checkFieldExistence');
        
        action.setCallback(this, function(result){
            
            var resultString = JSON.parse(result.getReturnValue());
            console.log('resultString', resultString);
            
            var state = result.getState();
            if(state == 'SUCCESS') {
                component.set('v.contactField', resultString.modigie__Contact_Alt_LinkedIn_Url_Field_Name__c);
                component.set('v.leadField', resultString.modigie__Lead_Alt_LinkedIn_Url_Field_Name__c);
                component.set('v.isActiveCon', resultString.modigie__Is_Active_Contact_Alt_LinkedIn_Url__c);
                component.set('v.isActiveLead', resultString.modigie__Is_Active_Lead_Alt_LinkedIn_Url__c);
                component.set('v.contactFieldOldValue', resultString.modigie__Contact_Alt_LinkedIn_Url_Field_Name__c);
                component.set('v.leadFieldOldValue', resultString.modigie__Lead_Alt_LinkedIn_Url_Field_Name__c);
            }
        });
        $A.enqueueAction(action);
    },
    

    handleCancel : function(component, event, helper) {
        component.set('v.showContactSave',false);
        component.set('v.disableContactToggle',true);
        component.set('v.showLeadSave',false);
        component.set('v.disableLeadToggle',true);
        component.set('v.disableContactField',true);
        component.set('v.disableLeadField',true);
    },
    
    handleInputChange : function(component, event, helper) {
        console.log('event.getSource().get(\'v.name\')', event.getSource().get('v.name'));
        
        console.log('v.contactField', component.get('v.contactField'));
        console.log('v.contactField', component.get('v.contactField') == '');
        /*     if(component.get('v.contactField') !== component.get('v.contactFieldOldValue')){
            component.set('v.showContactSave',true);
            component.set('v.disableContactToggle',false);
        }
        
        if(component.get('v.leadField') !== component.get('v.leadFieldOldValue')){
            component.set('v.showLeadSave',true);
            component.set('v.disableLeadToggle',false);
        }*/
        
        
    },
    
    editLinkedInSetting : function(component, event, helper){
        component.set('v.disableSettings',false);
    },
    saveLinkedInSetting : function(component, event, helper){
        var settingsObj = {'modigie__Contact_Alt_LinkedIn_Url_Field_Name__c': component.get('v.contactField'),'modigie__Lead_Alt_LinkedIn_Url_Field_Name__c' : component.get('v.leadField'),'modigie__Is_Active_Contact_Alt_LinkedIn_Url__c':component.get('v.isActiveCon'),'modigie__Is_Active_Lead_Alt_LinkedIn_Url__c':component.get('v.isActiveLead')};
		
        var action = component.get('c.saveAltFieldSettings');
        action.setParams({
            'inputSetting' : JSON.stringify(settingsObj)
        })
        action.setCallback(this, function(result){
            var state = result.getState();
            if(state == 'SUCCESS') {
            	var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Alternate LinkedIn Configuration Saved Successfully.',
                    type: 'success'
                });
                toastEvent.fire();
        		component.set('v.disableSettings',true);
            }
            else{
            	var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message: result.getError()[0].message,
                    type: 'error'
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    openReference : function(component, event, helper){
        component.set("v.isReferenceOpen", true);
    },
    closeReference : function(component, event, helper){
        component.set("v.isReferenceOpen", false);
    }
})