({
	
    doInit : function(component,event,helper){
    
    	var action = component.get('c.getPhoneNumberForInsights');
        action.setCallback(this, function(result){
        	var state = result.getState();
            if(state == 'SUCCESS') {
                var selectedFields = JSON.parse(result.getReturnValue());	
            	component.set('v.selectedFields',selectedFields);
            
                var obj = {MobileCon:selectedFields.selectedFieldsContact.includes('Mobile'),PhoneCon:selectedFields.selectedFieldsContact.includes('Phone'),OtherPhone:selectedFields.selectedFieldsContact.includes('Other'),ModigieValNumberCon:selectedFields.selectedFieldsContact.includes('Modigie_Verified_Number'),Alternate1Con:selectedFields.selectedFieldsContact.includes('modigie__Verified_Alt1__c'),Alternate2Con:selectedFields.selectedFieldsContact.includes('modigie__Verified_Alt2__c'),MobileLead:selectedFields.selectedFieldsLead.includes('Mobile'),PhoneLead:selectedFields.selectedFieldsLead.includes('Phone'),ModigieValNumberLead:selectedFields.selectedFieldsLead.includes('Modigie_Verified_Number'),Alternate1Lead:selectedFields.selectedFieldsLead.includes('modigie__Verified_Alt1__c'),Alternate2Lead:selectedFields.selectedFieldsLead.includes('modigie__Verified_Alt2__c')};
				component.set('v.mobilePhoneData',obj);
            	component.set('v.toggleSpinner',false);
            }
            
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message:result.getReturnValue(),
                    type: 'error',
                });
                toastEvent.fire();
            	var parentMethod = component.get("v.method");
            	//fire event from child and capture in parent
            	$A.enqueueAction(parentMethod);
            }               
           	 
        });
    	$A.enqueueAction(action);
    },
    closeModal : function(component, event, helper) {
		var parentMethod = component.get("v.method");
        //fire event from child and capture in parent
        $A.enqueueAction(parentMethod);
	},
    handleChangeContact : function(component,event,helper){
       	
        
        var selectedFields = component.get('v.selectedFields');
        if(selectedFields.selectedFieldsContact.indexOf(event.target.dataset.name + ',') != -1){
            selectedFields.selectedFieldsContact =selectedFields.selectedFieldsContact.replace(event.target.dataset.name + ',' ,'');    
        }
        else{
            selectedFields.selectedFieldsContact += event.target.dataset.name + ',';
        }
    	
    	if(selectedFields.selectedFieldsContact == '' && selectedFields.selectedFieldsLead == ''){ 
            component.set('v.disableSubmit',true);
        }
        else{
            component.set('v.disableSubmit',false);
        }
    	
    	component.set('v.selectedFields',selectedFields);
    },
    
    handleChangeLead : function(component,event,helper){
       	
        
        var selectedFields = component.get('v.selectedFields');
        if(selectedFields.selectedFieldsLead.indexOf(event.target.dataset.name + ',') != -1){
            selectedFields.selectedFieldsLead =selectedFields.selectedFieldsLead.replace(event.target.dataset.name + ',' ,'');    
        }
        else{
            selectedFields.selectedFieldsLead += event.target.dataset.name + ',';
        }
    	
    	if(selectedFields.selectedFieldsContact == '' && selectedFields.selectedFieldsLead == ''){ 
            component.set('v.disableSubmit',true);
        }
        else{
            component.set('v.disableSubmit',false);
        }
    	
    	component.set('v.selectedFields',selectedFields);
    },
    
    handleSubmit:function(component,event,helper){
        component.set('v.toggleSpinner',true);
        component.set('v.disableSubmit',true);
        var action = component.get('c.setPhoneNumberForInsights');
        action.setParams({
            "data" : JSON.stringify(component.get('v.selectedFields'))
        });
        action.setCallback(this, function(result){
        	var state = result.getState();
            if(state == 'SUCCESS') {
            	var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message:'Phone numbers saved successfully.',
                    type: 'success',
                });
                toastEvent.fire(); 
            }
            
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message:result.getReturnValue(),
                    type: 'error',
                });
                toastEvent.fire();
            }               
            var parentMethod = component.get("v.method");
            //fire event from child and capture in parent
            $A.enqueueAction(parentMethod);
        });
    	$A.enqueueAction(action);
    }
})