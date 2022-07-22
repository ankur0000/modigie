({
    doinit : function(component, event, helper) {
        var action = component.get('c.getPhoneFields');
        var modigieFieldName, modigieFieldApiName, modigieFieldNameContact, modigieFieldApiNameContact;
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                console.log('response ======================>',response.getReturnValue());
                let result = response.getReturnValue();
                var fields = [];
                var contactFields = [];
                var top3Priorities = [];
                var top3PrioritiesContact = [];
                var allLeadFields = [];
                var allContactFields = [];
                for (var key in result[0]) {
                    if(key != 'modigie__tom_priority_mobile_1__c' && key != 'modigie__tom_priority_mobile_2__c' && key != 'modigie__tom_priority_mobile_3__c' && key != 'modigie__tom_priority_map_to_dialer_1__c' && key != 'modigie__tom_priority_map_to_dialer_2__c' && key != 'modigie__tom_priority_map_to_dialer_3__c')
                    {
                        allLeadFields.push({label:result[0][key], apiname:key});
                    }
                    if(key != 'modigie__modigie_verified_number__c' && key != 'modigie__alternate_mobile_number_1__c' && key != 'modigie__alternate_mobile_number_2__c' && key != 'modigie__tom_priority_mobile_1__c' && key != 'modigie__tom_priority_mobile_2__c' && key != 'modigie__tom_priority_mobile_3__c' && key != 'modigie__tom_priority_map_to_dialer_1__c' && key != 'modigie__tom_priority_map_to_dialer_2__c' && key != 'modigie__tom_priority_map_to_dialer_3__c'){
                        fields.push({label:result[0][key], apiname:key});
                    }
                    
                    if(key == 'modigie__modigie_verified_number__c'){
                        top3Priorities[0] = result[0][key];
                        modigieFieldName = result[0][key];
                        modigieFieldApiName = key;
                    }
                    if(key == 'modigie__alternate_mobile_number_1__c'){
                        top3Priorities[1] = result[0][key];
                    }
                    if(key == 'modigie__alternate_mobile_number_2__c'){
                        top3Priorities[2] = result[0][key];
                    }
                    
                    
                }
                console.log(fields,'----',top3Priorities);
                component.set('v.leadPriorities', top3Priorities);
                component.set('v.leadPhoneFields', fields);
                component.set('v.allLeadFields', allLeadFields);
                console.log('allLeadFields-----------------------',allLeadFields);

                for (var key in result[2]) {
                    if(key != 'modigie__tom_priority_mobile_1__c' && key != 'modigie__tom_priority_mobile_2__c' && key != 'modigie__tom_priority_mobile_3__c' && key != 'modigie__tom_priority_map_to_dialer_1__c' && key != 'modigie__tom_priority_map_to_dialer_2__c' && key != 'modigie__tom_priority_map_to_dialer_3__c'){
                        allContactFields.push({label:result[2][key], apiname:key});
                    }
                    if(key != 'modigie__modigie_verified_number__c' && key != 'modigie__alternate_mobile_number1__c' && key != 'modigie__alternate_mobile_number2__c'&& key != 'modigie__tom_priority_mobile_1__c' && key != 'modigie__tom_priority_mobile_2__c' && key != 'modigie__tom_priority_mobile_3__c' && key != 'modigie__tom_priority_map_to_dialer_1__c' && key != 'modigie__tom_priority_map_to_dialer_2__c' && key != 'modigie__tom_priority_map_to_dialer_3__c'){
                        contactFields.push({label:result[2][key], apiname:key});
                    }
                    
                        if(key == 'modigie__modigie_verified_number__c'){
                            top3PrioritiesContact[0] = result[2][key];
                            modigieFieldNameContact = result[0][key];
                            modigieFieldApiNameContact = key;
                        }
                        if(key == 'modigie__alternate_mobile_number1__c'){
                            top3PrioritiesContact[1] = result[2][key];
                        }
                        if(key == 'modigie__alternate_mobile_number2__c'){
                            top3PrioritiesContact[2] = result[2][key];
                        }
                    
                    
                }

                console.log(contactFields,'----',top3PrioritiesContact);
                component.set('v.contactPriorities', top3PrioritiesContact);
                component.set('v.contactPhoneFields', contactFields);
                component.set('v.allContactFields', allContactFields);
                console.log('allContactFields-----------------------',allContactFields);
                component.set('v.spinner', true);
            }
        });

        $A.enqueueAction(action);

        var action2 = component.get('c.getPriorities');
        action2.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                let result = response.getReturnValue();
                console.log('Priorities--------------------->',response.getReturnValue());
                let leadPriorities = result[0];
                console.log(leadPriorities[3]);
                let contactPriorities = result[1];
                component.set('v.leadPriority1', modigieFieldName);
                component.set('v.leadPriority1API', modigieFieldApiName);
                component.set('v.leadPriority2', leadPriorities[1]);
                if(leadPriorities[1] == 'Overwrite'){
                    component.set('v.leadOverwriteFF', true);
                }else{
                    component.set('v.leadOverwriteFF', false);
                }
                component.set('v.leadPriority3', leadPriorities[2]);
                if(leadPriorities[2] == 'Overwrite'){
                    component.set('v.leadOverwriteSF', false);
                }else{
                    component.set('v.leadOverwriteSF', true);
                }
                component.set('v.leadPriority4', leadPriorities[3]);
                component.set('v.leadPriority5', leadPriorities[4]);
                component.set('v.leadPriority6', leadPriorities[5]);
                
                component.set('v.contactPriority1', modigieFieldNameContact);
                component.set('v.contactPriority1API', modigieFieldApiNameContact);
                component.set('v.contactPriority2', contactPriorities[1]);
                if(contactPriorities[1] == 'Overwrite'){
                    component.set('v.conOverwriteFF', true);
                }else{
                    component.set('v.conOverwriteFF', false);
                }
                component.set('v.contactPriority3', contactPriorities[2]);
                if(contactPriorities[2] == 'Overwrite'){
                    component.set('v.conOverwriteSF', false);
                }else{
                    component.set('v.conOverwriteSF', true);
                }
                component.set('v.contactPriority4', contactPriorities[3]);
                component.set('v.contactPriority5', contactPriorities[4]);
                component.set('v.contactPriority6', contactPriorities[5]);

                let leadResetPriorities = result[4];
                let contactResetPriorities = result[5];
                component.set('v.leadResetPriority1', leadResetPriorities[0]);
                component.set('v.leadResetPriority2', leadResetPriorities[1]);
                component.set('v.leadResetPriority3', leadResetPriorities[2]);
                component.set('v.contactResetPriority1', contactResetPriorities[0]);
                component.set('v.contactResetPriority2', contactResetPriorities[1]);
                component.set('v.contactResetPriority3', contactResetPriorities[2]);

                console.log('==========',result[2][0]);
                
                if(result.length == 7){
                    component.set('v.disableToggle', false);
                    component.set('v.toggleValue', false);
                    component.set('v.noSubscription', true);
                }else{
                    if(result[2][0] == 'true'){
                        console.log('if==========',result[2][0]);
                        component.set('v.toggleValue', true);
                    }
                    else{
                        console.log('else==========',result[2][0]);
                        component.set('v.toggleValue', false);
                    }
                    if(result[3][0] == 'true'){
                        component.set('v.disableToggle', false);
                        component.set('v.noSubscription', false);
                    }
                    else{
                        component.set('v.disableToggle', true);
                        component.set('v.toggleValue', false);
                    }
                }
            }
        });
        $A.enqueueAction(action2);
    },

    handleSelect: function(component, event, helper){
        var a = event.getSource();
        var id = a.getLocalId();   
        var bool = component.find(id).get('v.checked');
        switch(id){
            case 'lead_overwrite_firstField':
                component.set('v.leadOverwriteFF', bool ? true : false);
                component.set('v.onChange', true);
                break;
            case 'lead_overwrite_socondField':
                component.set('v.leadOverwriteSF', bool ? true : false);
                component.set('v.onChange', true);
                break;
            case 'con_overwrite_firstField':
                component.set('v.conOverwriteFF', bool ? true : false);
                component.set('v.onChangeContact', true);
                break;
            case 'con_overwrite_secondField':
                component.set('v.conOverwriteSF', bool ? true : false);
                component.set('v.onChangeContact', true);
                break;
        }
        /*
        var tab = event.getSource();
        switch (tab.get('v.id')) {
            case 'one' :
                var leadOverwriteFFCmp = component.find("lead_overwrite_firstField");
                if(leadOverwriteFFCmp != undefined && leadOverwriteFFCmp != null){
                    component.set('v.onChange', true);
                    console.log('leadOverwriteFFCmp.get("v.value")', leadOverwriteFFCmp.get("v.value"));
                    var leadOverwriteFFBool = leadOverwriteFFCmp.get("v.value");
                    if(leadOverwriteFFBool==true){
                        console.log('lead overwrite first field - true');
                        component.set('v.leadOverwriteFF', true);
                    }else{
                        console.log('lead overwrite first field - false');
                        component.set('v.leadOverwriteFF', false);
                    }
                }
                //
                var leadOverwriteSFCmp = component.find("lead_overwrite_socondField");
                if(leadOverwriteSFCmp != undefined && leadOverwriteSFCmp != null){
                    component.set('v.onChange', true);
                    console.log('leadOverwriteSFCmp.get("v.value")', leadOverwriteSFCmp.get("v.value"));
                    var leadOverwriteSFBool = leadOverwriteSFCmp.get("v.value");
                    if(leadOverwriteSFBool==true){
                        component.set('v.leadOverwriteFF', true);
                        console.log('lead overwrite second field - true');
                    }else{
                        component.set('v.leadOverwriteFF', false);
                        console.log('lead overwrite second field - false');
                    }
                }
                break;
            case 'two' :
                var conOverwriteFFCmp = component.find("con_overwrite_firstField");
                if(conOverwriteFFCmp != undefined && conOverwriteFFCmp != null){
                    component.set('v.onChangeContact', true);
                    console.log('conOverwriteFFCmp.get("v.value")', conOverwriteFFCmp.get("v.value"));
                    var conOverwriteFFBool = conOverwriteFFCmp.get("v.value");
                    if(conOverwriteFFBool==true){
                        console.log('contact overwrite first field - true');
                        component.set('v.conOverwriteFF', true);
                    }else{
                        console.log('contact overwrite first field - false');
                        component.set('v.conOverwriteFF', false);
                    }                    
                }
                //
                var conOverwriteSFCmp = component.find("con_overwrite_secondField");
                if(conOverwriteSFCmp != undefined && conOverwriteSFCmp != null){
                    component.set('v.onChangeContact', true);
                    console.log('conOverwriteSFCmp.get("v.value")', conOverwriteSFCmp.get("v.value"));
                    var conOverwriteSFBool = conOverwriteSFCmp.get("v.value");
                    if(conOverwriteSFBool==true){
                        console.log('contact overwrite second field - true');
                        component.set('v.conOverwriteFF', true);
                    }else{
                        console.log('contact overwrite second field - false');
                        component.set('v.conOverwriteFF', false);
                    }
                }
                break;
        }
        */
    },

    getCustomSelectedValue : function(component, event, helper) {
        var a = event.getSource();
        var id = a.getLocalId();   
        console.log(id);  
        //find autocomplete component using aura id
        console.log('Fired');
        if(id=='lead'){
            component.set('v.onChange', true);
        }
        else{
            component.set('v.onChangeContact', true);
        }
		
        
	},

    onCancel: function(component){
        component.set('v.onChange', false);
    },

    onSave: function(component){
        let leadPriority1 = component.get('v.leadPriority1');
        let leadPriority4 = component.get('v.leadPriority4');
        let leadPriority5 = component.get('v.leadPriority5');
        let leadPriority6 = component.get('v.leadPriority6');
        
        let leadResetPriority1 = component.get('v.leadResetPriority1');
        let leadResetPriority2 = component.get('v.leadResetPriority2');
        let leadResetPriority3 = component.get('v.leadResetPriority3');
        let leadPriorities = [];
        leadPriorities.push(leadPriority4);
        leadPriorities.push(leadPriority5);
        leadPriorities.push(leadPriority6);
        leadPriorities.push(leadResetPriority1);
        if(component.get('v.leadOverwriteFF')==true){
            leadPriorities.push('Overwrite');
        }else{
            leadPriorities.push('NA');
        }
        leadPriorities.push(leadResetPriority2);
        if(component.get('v.leadOverwriteSF')==false){
            leadPriorities.push('Overwrite');
        }else{
            leadPriorities.push('NA');
        }
        console.log(leadPriorities);

        var action = component.get('c.savePrioritiesForLead');
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                console.log(response.getReturnValue());
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Saved Successfully!!!',
                    duration:' 3000',
                    type: 'Success',
                    mode: 'dismissible'
                });
                toastEvent.fire();
            }
        });
        action.setParams({
            'leadPriorities': leadPriorities
        });
        console.log(leadPriority1, 'leadPriority1');
        console.log(leadResetPriority1, 'leadResetPriority1');
        let leadApiName = component.get('v.leadPriority1API');
        if(leadResetPriority1 == leadResetPriority2 &&  leadResetPriority1 != null && leadResetPriority1 != 'undefined' && leadResetPriority1 != '' &&  leadResetPriority2 != null && leadResetPriority2 != 'undefined' && leadResetPriority2 != '' ){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message: 'Duplicate value selected in Target Fields!',
                duration:' 3000',
                type: 'Error',
                mode: 'dismissible'
            });
            toastEvent.fire();
        }
        else if((leadResetPriority1 != null && leadResetPriority1 != 'undefined' && leadResetPriority1 != '' && leadResetPriority1.startsWith('modigie__')) || (leadResetPriority2 != null && leadResetPriority2 != 'undefined' && leadResetPriority2 != '' && leadResetPriority2.startsWith('modigie__'))){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message: 'Modigie Field can\'t be selected in Target Fields!',
                duration:' 3000',
                type: 'Error',
                mode: 'dismissible'
            });
            toastEvent.fire();
        }
        else if((leadPriority4 == leadApiName) || 
        (leadPriority5 == leadApiName) || 
        (leadPriority6 == leadApiName) || 
        (leadPriority5 == leadPriority4 && leadPriority5 != null && leadPriority5 != 'undefined' && leadPriority5 != '' &&  leadPriority4 != null && leadPriority4 != 'undefined' && leadPriority4 != '') || 
        (leadPriority5 == leadPriority6 && leadPriority5 != null && leadPriority5 != 'undefined' && leadPriority5 != '' &&  leadPriority6 != null && leadPriority6 != 'undefined' && leadPriority6 != '') || 
        (leadPriority6 == leadPriority4 && leadPriority6 != null && leadPriority6 != 'undefined' && leadPriority6 != '' &&  leadPriority4 != null && leadPriority4 != 'undefined' && leadPriority4 != '')){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message: 'Duplicate value selected in Source Fields!',
                duration:' 3000',
                type: 'Error',
                mode: 'dismissible'
            });
            toastEvent.fire();
        }
        else{
            $A.enqueueAction(action);
            component.set('v.onChange', false);
        }
        
    },

    onCancelContact: function(component){
        component.set('v.onChangeContact', false);
    },

    handleToggleChange: function(component){
        //SFD-65 No disclaimer needed
        var action = component.get('c.saveToggleForTom');
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                console.log(response.getReturnValue());
                if(component.get('v.noSubscription')){
                    window.location.reload();
                }
            }
        });
        action.setParams({
            "toggleValue" : component.get('v.toggleValue')
        });

        $A.enqueueAction(action);
        
    },

    handleConfirm: function(component){
        component.set('v.showConfirmModal', false);
        console.log(component.get('v.toggleValue'));
        var action = component.get('c.saveToggleForTom');
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                console.log(response.getReturnValue());
            }
        });
        action.setParams({
            "toggleValue" : component.get('v.toggleValue')
        });

        $A.enqueueAction(action);
    },

    handleCancel: function(component){
        component.set('v.showConfirmModal', false);
        component.set('v.toggleValue', false);
    },

    onSaveContact: function(component){
        let contactPriority1 = component.get('v.contactPriority1');
        let contactPriority4 = component.get('v.contactPriority4');
        let contactPriority5 = component.get('v.contactPriority5');
        let contactPriority6 = component.get('v.contactPriority6');
        
        let contactResetPriority1 = component.get('v.contactResetPriority1');
        let contactResetPriority2 = component.get('v.contactResetPriority2');
        let contactResetPriority3 = component.get('v.contactResetPriority3');


        let contactPriorities = [];
        contactPriorities.push(contactPriority4);
        contactPriorities.push(contactPriority5);
        contactPriorities.push(contactPriority6);
        contactPriorities.push(contactResetPriority1);
        if(component.get('v.conOverwriteFF')==true){
            contactPriorities.push('Overwrite');
        }else{
            contactPriorities.push('NA');
        }
        contactPriorities.push(contactResetPriority2);
        if(component.get('v.conOverwriteSF')==false){
            contactPriorities.push('Overwrite');
        }else{
            contactPriorities.push('NA');
        }
        console.log(contactPriorities);

        var action = component.get('c.savePrioritiesForContact');
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                console.log(response.getReturnValue());
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Saved Successfully!!!',
                    duration:' 3000',
                    type: 'Success',
                    mode: 'dismissible'
                });
                toastEvent.fire();
            }
        });
        action.setParams({
            'contactPriorities': contactPriorities
        });
        
        console.log(contactPriority1, 'contactPriority1');        
        console.log(contactResetPriority1, 'conResetPriority1');
        let conApiName = component.get('v.contactPriority1API');
        if(contactResetPriority1 == contactResetPriority2 && contactResetPriority1 != null && contactResetPriority1 != 'undefined' && contactResetPriority1 != '' &&  contactResetPriority2 != null && contactResetPriority2 != 'undefined' && contactResetPriority2 != ''){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message: 'Duplicate value selected in Target Fields!',
                duration:' 3000',
                type: 'Error',
                mode: 'dismissible'
            });
            toastEvent.fire();
        }
        else if((contactResetPriority1 != null && contactResetPriority1 != 'undefined' && contactResetPriority1 != '' && contactResetPriority1.startsWith('modigie__')) || (contactResetPriority2 != null && contactResetPriority2 != 'undefined' && contactResetPriority2 != '' && contactResetPriority2.startsWith('modigie__'))){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message: 'Modigie Field can\'t be selected in Target Fields!',
                duration:' 3000',
                type: 'Error',
                mode: 'dismissible'
            });
            toastEvent.fire();
        }
        else if((contactPriority4 == conApiName) || 
        (contactPriority5 == conApiName) || 
        (contactPriority6 == conApiName) || 
        (contactPriority5 == contactPriority4 && contactPriority5 != null && contactPriority5 != 'undefined' && contactPriority5 != '' &&  contactPriority4 != null && contactPriority4 != 'undefined' && contactPriority4 != '') || 
        (contactPriority5 == contactPriority6 && contactPriority5 != null && contactPriority5 != 'undefined' && contactPriority5 != '' &&  contactPriority6 != null && contactPriority6 != 'undefined' && contactPriority6 != '') || 
        (contactPriority6 == contactPriority4 && contactPriority6 != null && contactPriority6 != 'undefined' && contactPriority6 != '' &&  contactPriority4 != null && contactPriority4 != 'undefined' && contactPriority4 != '')){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message: 'Duplicate value selected in Source Fields!',
                duration:' 3000',
                type: 'Error',
                mode: 'dismissible'
            });
            toastEvent.fire();
        }
        else{
            $A.enqueueAction(action);
            component.set('v.onChangeContact', false);
        }
    },
    openReference : function(component, event, helper){
        component.set("v.isReferenceOpen", true);
    },
    closeReference : function(component, event, helper){
        component.set("v.isReferenceOpen", false);
    },
    handleTomCriteria: function(component){
        component.set('v.tomOrUntom', 'TOM');
        component.set('v.showCriteriaModal', true);
        console.log(component.get('v.showCriteriaModal'));
    },
    //handleUntomCriteria: function(component){
    //    component.set('v.tomOrUntom', 'unTOM');
    //    component.set('v.showCriteriaModal', true);
    //},
    closeCriteria : function(component, event, helper){
        component.set('v.showCriteriaModal', false);
        // component.set('v.automationCriteria', true);
    },
    // handleTomUntomEvent: function(component, event){
    //     compo
    // }
})