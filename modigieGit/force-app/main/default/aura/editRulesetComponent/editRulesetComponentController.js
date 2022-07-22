({
    doInit: function(component, event, helper) {
        var action = component.get('c.getObjectFieldInfo');
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                console.log('Result -->> ', response.getReturnValue());
                var result = response.getReturnValue();
                console.log('result[0]' , result[0]);
                component.set('v.fieldsLabel',result[0]);
                component.set('v.fieldsDataType',result[1]);
                
                var fields = [];
                for (var key in result[0]) {
                    fields.push({label:result[0][key], apiname:key});
                }
                component.set('v.fields', fields);
                
                component.set('v.contactFieldsLabel',result[2]);
                component.set('v.contactFieldsDataType',result[3]);
                
                fields = [];
                for (var key in result[2]) {
                    fields.push({label:result[2][key], apiname:key});
                }
                component.set('v.contactFields', fields);	
            }
            else if(state === "ERROR"){
                let errors = response.getError();
                let message = 'Unknown error'; // Default error message
                // Retrieve the error message sent by the server
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                
                console.error(message);
                // Fire error toast
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({title: "Error",message: message, type: "error"});
                toastEvent.fire();    
            }
        })
        $A.enqueueAction(action);
        console.log('id',component.get('v.rulesetId'));
        if(component.get('v.rulesetId')){
            var action4 = component.get('c.getRulesetDetails');
            action4.setCallback(this, function(response){
                let state = response.getState();
                if(state === "SUCCESS"){
                    console.log('=======ankur',response.getReturnValue());
                }
            });
            action4.setParams({
                "rulesetId": component.get('v.rulesetId'),
            });
            $A.enqueueAction(action4);
        }
        // var action2 = component.get('c.getAutomationCriteria');
        // action2.setCallback(this, function (response) {
        //     let state = response.getState();
        //     if(state === "SUCCESS"){
        //         console.log('Result2 -->> ', response.getReturnValue());
        //         component.set('v.critriaList',response.getReturnValue()[0]);
        //         component.set('v.contactCriteriaList',response.getReturnValue()[1]);
        //         component.set('v.isCriteriaLoaded', true);
        //     }
        //     else if(state === "ERROR"){
        //         let errors = response.getError();
        //         let message = 'Unknown error'; // Default error message
        //         // Retrieve the error message sent by the server
        //         if (errors && Array.isArray(errors) && errors.length > 0) {
        //             message = errors[0].message;
        //         }
                
        //         console.error(message);
        //         // Fire error toast
        //         let toastEvent = $A.get("e.force:showToast");
        //         toastEvent.setParams({title: "Error",message: message, type: "error"});
        //         toastEvent.fire();    
        //     }
            
            
        // })
        // $A.enqueueAction(action2);
        // var action3 = component.get('c.getLogicCriteria');
        // action3.setCallback(this, function (response) {
        //     let state = response.getState();
        //     if(state === "SUCCESS"){
        //         console.log('Result3 -->> ', response.getReturnValue());
        //         component.set('v.selectedLogic',response.getReturnValue()[0]);
        //         component.set('v.leadLogic',response.getReturnValue()[1]);
        //         component.set('v.contactSelectedLogic',response.getReturnValue()[2]);
        //         component.set('v.contactLogic',response.getReturnValue()[3]);
        //         component.set('v.isLogicLoaded', true);
        //     }
        //     else if(state === "ERROR"){
        //         let errors = response.getError();
        //         let message = 'Unknown error'; // Default error message
        //         // Retrieve the error message sent by the server
        //         if (errors && Array.isArray(errors) && errors.length > 0) {
        //             message = errors[0].message;
        //         }
                
        //         console.error(message);
        //         // Fire error toast
        //         let toastEvent = $A.get("e.force:showToast");
        //         toastEvent.setParams({title: "Error",message: message, type: "error"});
        //         toastEvent.fire();    
        //     }
        // })
        // $A.enqueueAction(action3);
    },

    myAction : function(component, event, helper) {

    },

    saveRulesetDetails : function(component, event, helper){
        var evt = component.getEvent('getNewRulesetData');
        let rulesetName = component.get('v.ruleName');
        let description = component.get('v.description');
        let automationTrigger = component.get('v.automationTrigger');
        let numberOfRequests = component.get('v.requestLimit');
        let maintainQueue = component.get('v.maintainQueue');
        let Limits_No_Limits_Selection = component.get('v.Limits_No_Limits_Selection');
        let leadSelectedLogic = component.get('v.selectedLogic');
        let contactSelectedLogic = component.get('v.contactSelectedLogic');
        let leadLogic = component.get('v.leadLogic');
        let contactLogic = component.get('v.contactLogic');

        let leadCriteriaList = component.get('v.critriaList');
        let contactCriteriaList = component.get('v.contactCriteriaList');
        console.log(leadCriteriaList,'----------------',contactCriteriaList);

        evt.setParams({
            "newRulesetDetails" : {
                "title" : rulesetName,
                "description" : description,
                "automationTrigger" : automationTrigger,
                "numberOfRequests": numberOfRequests, 
                "maintainQueue": maintainQueue,
                "Limits_No_Limits_Selection": Limits_No_Limits_Selection,
                "leadSelectedLogic": leadSelectedLogic, 
                "contactSelectedLogic": contactSelectedLogic,
                "leadLogic": leadLogic,
                "contactLogic": contactLogic,
                "isActive": true
            },
            "leadCriteriaList": leadCriteriaList,
            "contactCriteriaList": contactCriteriaList
            
        });
        evt.fire();
        
        
    },

    handleNext : function(component, event, helper){
        let nextStep = component.get('v.nextStep');
        component.set('v.nextStep', !nextStep);
        console.log(nextStep,component.get('v.nextStep'));
    },

    handleBack: function(component){
        let nextStep = component.get('v.nextStep');
        component.set('v.nextStep', !nextStep);
    },

    handleChange: function(component){
        let limitNoLimit = component.get('v.Limits_No_Limits_Selection');
        if(limitNoLimit == 'Limits'){
            component.set('v.showNumberOfRequests', true);
        }
        else{
            component.set('v.showNumberOfRequests', false);
        }
    },

    addNewRow : function(component, event, helper) {
        helper.createObjectData(component, event);
        console.log('List Of Objects --> ', component.get("v.critriaList"));
    },

    removeDeletedRow: function(component, event, helper) {
        var index = event.getParam("indexVar");
        var AllRowsList;
        console.log('component.get(\'v.selectedObject\')',component.get('v.selectedObject'));
        if(component.get('v.selectedObject') == 'Lead'){
            AllRowsList = component.get("v.critriaList");
            AllRowsList.splice(index, 1);
            component.set("v.critriaList", AllRowsList);
        }
        else{
            AllRowsList = component.get("v.contactCriteriaList");
            AllRowsList.splice(index, 1);
            component.set("v.contactCriteriaList", AllRowsList);    
        }
        
        
    },

    
    handleLogicInput : function(component,event,helper) {
        var name = event.getSource().get("v.name");
        if(name == 'customLeadLogic') {
            component.set('{!v.logicError}', false);
        }else if(name == 'customContactLogic') {
            component.set('{!v.contactLogicError}', false);
        }
    }
})