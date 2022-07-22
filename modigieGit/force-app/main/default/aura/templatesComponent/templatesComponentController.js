({
 	
    doInit : function(component, event, helper) {
        var action2 = component.get('c.getUnlockTimeAndReason');
        action2.setCallback(this, function(result){
            console.log('reslut====>',result.getReturnValue());
            if(result.getState() == 'SUCCESS'){
                console.log(result.getReturnValue()['reasonString']);
                let reasonString = result.getReturnValue()['reasonString'];
                let showWarningMessage = result.getReturnValue()['showWarningMessage'];
                // let isValuesPresent = result.getReturnValue()['isValuesPresent'];
                component.set('v.showWarningMessage', showWarningMessage);
                component.set('v.reasonString', reasonString);
                // component.set('v.isValuesPresent', isValuesPresent);
            }
        });
        $A.enqueueAction(action2);
        console.log('------------',component.get('v.isPerformance'));
        var url_String = window.location.href.toString();
        if (url_String.includes("visualforce.com") || url_String.includes("visual.force.com")) {
            component.set("v.sfdcClassic", true);
        }
        var action = component.get('c.getProcessStates');
        
        var spinnerObj = {Unresponsive_Lead_Get_LinkedIn_URL:false, Unresponsive_Lead_Get_Phone_Insights:false, Unresponsive_Lead_Get_Modigie:false, Unresponsive_Lead_Verify_Employer : false,Lead_Status_Working_Get_LinkedIn_URL:false, Lead_Status_Working_Get_Phone_Insights:false, Lead_Status_Working_Verify_Employer:false, Lead_Status_Working_Get_Modigie:false, Unreachable_Get_LinkedIn_URL:false, Unreachable_Get_Phone_Insights:false, Unreachable_Verify_Employer:false, Unreachable_Get_Modigie:false, Opportunity_Contact_Get_Phone_Insights:false, Opportunity_Contact_Get_LinkedIn:false, Opportunity_Contact_Get_Modigie:false, Validate_Employer_Data_Maintenance:false, Unresponsive_Lead_Verify_Employer :false,Get_Phone_Insights_Campaign:false, No_Mobile_Information_campaign:false,Validate_Employer_campaign:false,Get_linkedin_campaign:false,Get_Phone_Insights:false,No_Mobile_Information:false,Get_linkedin_url:false,Validate_Employer:false,No_Phone_Information:false,Opportunity_Contact_Enrichment:false,Unresponsive_Lead_Toggle:false,Phone_Insights_Data_Maintenance:false,Validate_Employer_Data_Maintenance:false,Dynamic_Criteria_Automation:false};
        component.set('v.toggleSpinnerObject',spinnerObj);
        
        action.setCallback(this, function(result){
        	var state = result.getState();
            if(state == 'SUCCESS') {

                var switchDataObj = JSON.parse(result.getReturnValue());
               component.set('v.proactiveStatus',switchDataObj.Opportunity_Contact_Get_Modigie);
               component.set('v.MaitainQueueSalesEngagemet',switchDataObj.Maintain_Queue_Sales_Engagement);
                
                var selectedList = [];
                
                
                selectedList = JSON.parse(switchDataObj.Selected_Lead_Status);
                

                component.set('v.alreadySelectedStages', selectedList);
                component.set('v.alreadySelectedStagesDemo', selectedList);

                var selectedOppList = [];
                
                
                selectedOppList = JSON.parse(switchDataObj.Selected_Opportunity_Stages);
                
                component.set('v.alreadySelectedOppStages', selectedOppList);
                component.set('v.alreadySelectedOppStagesDemo', selectedOppList);


                if(switchDataObj.Data_Maintenance_LimitsNoLimitsSelection == 'Limits'){
                    component.set('v.showLimitsBox',true);
                }
                else{
                    component.set('v.showLimitsBox',false);
                }

               
                component.set('v.switchData', JSON.parse(result.getReturnValue()));
           		component.set('v.toggleSpinner',false);
            }

            
            
        });
        
        $A.enqueueAction(action);
        
        component.set('v.sameValue',{"Opportunity_Contact_Get_Phone_Insights_L":true, "Unresponsive_Lead_Get_LinkedIn_URL_Limit":true, "Unresponsive_Lead_Get_Phone_Insights_Lim":true, "Unresponsive_Lead_Get_Modigie_Limit":true, "Lead_Status_Working_Get_LinkedIn_URL_Lim":true, "Lead_Status_Working_Get_Phone_Insights_L":true, "Lead_Status_Working_Verify_Employer_Limi":true, "Lead_Status_Working_Get_Modigie_Limit":true, "Unreachable_Get_LinkedIn_URL_Limit":true, "Unreachable_Get_Phone_Insights_Limit":true, "Unreachable_Verify_Employer_Limit":true, "Unreachable_Get_Modigie_Limit":true, "Opportunity_Contact_Get_LinkedIn_Limit":true, "Opportunity_Contact_Get_Modigie_Limit":true, "Validate_Employer_Data_Maintenance_Lmt":true,"Unresponsive_Lead_Verify_Employer_Limit":true,"Get_Phone_Insights_Campaign_Limits":true,"Get_Modigie_Invocable_Limit":true,"Modigie_Phone_Insights_Invocable_Limit":true,"Validate_Employer_Invocable_Limit":true,"LinkedIn_Url_Invocable_Limits":true,"Opp_Contact_Enrichment_Invocable_Limit":true, "Unresponsive_Lead_Invocable_Limits":true, "Phone_Insights_Data_Maintenance_Limits":true, "Validate_Employer_Data_Maintenance_Lmt":true, "Get_Modigie_Campaign_Invocable_Limits":true, "Validate_employer_campaign_Limits":true,"Linkedin_Url_Campaign_Limits":true,"Unresponsive_Lead_Verify_Employer_Limit":true,"Dynamic_Criteria_Automation_Limit":true});

        helper.getAllRulesets(component);
        // var action2 = component.get('c.getAllRulesets');

        // action2.setCallback(this, function(result){
        //     var state = result.getState();
        //     let rulesets = [];
        //     if(state == 'SUCCESS'){
        //         let returnValue = result.getReturnValue();
        //         console.log(returnValue);
        //         for(let i=0; i<returnValue.length; i++){
        //             let ruleset = {};
        //             console.log(returnValue[i].Name);
        //             let automationTriggerValue;
        //             if(returnValue[i].modigie__OnlyOnCreate__c){
        //                 automationTriggerValue = 'created ';
        //             }
        //             else{
        //                 automationTriggerValue = 'created/modified ';
        //             }
        //             // {title: 'Default Ruleset', description: 'Description for Default Ruleset', edit: 'Default Ruleset,Edit', delete: 'Default Ruleset,Delete', active: true, status: 'Default Ruleset,Status', analyse: 'Default Ruleset,Analyse'}
        //             ruleset = {'Id': returnValue[i].Id, 'title': returnValue[i].modigie__Rule_Set_Name__c, 'description': returnValue[i].modigie__Rule_Set_Description__c, 'edit': returnValue[i].Id+',Edit', 'delete': returnValue[i].Id+',Delete', active: returnValue[i].modigie__isActive__c, 'status': returnValue[i].Id+',Status', 'analyse': returnValue[i].Id+',Analyse', 'automationTrigger': automationTriggerValue};
        //             rulesets.push(ruleset);
        //         }
        //         console.log('---------------',rulesets);
        //         component.set('v.ruleSets', rulesets);
        //         component.set('v.spinner', true);
        //     }
        // });

        // $A.enqueueAction(action2);
    },

    hyperLink : function(component, event, helper) 
    {
        component.set('v.hyperLinkModal',"true");
    },

    closeHyperLinkModal : function(component, event, helper) 
    {
        component.set('v.hyperLinkModal',"false");
    },
    
    // common reusable function for toggle sections
    toggleSection : function(component, event, helper) {
        
        // dynamically get aura:id name from 'data-auraId' attribute
        var sectionAuraId = event.target.getAttribute("data-auraId");
        // get section Div element using aura:id
        var sectionDiv = component.find(sectionAuraId).getElement();
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-close'); 
        
        // -1 if 'slds-is-open' class is missing...then set 'slds-is-open' class else set slds-is-close class to element
        if(sectionState == -1){
            sectionDiv.setAttribute('class' , 'slds-section slds-is-close');
        }else{
            sectionDiv.setAttribute('class' , 'slds-section slds-is-open');
        }
    },
    handleToggle:function(component, event, helper)
    {
        //helper.showSpinner(component);
    	var processName = event.getSource().getLocalId();
        
        var spinnerObject = component.get('v.toggleSpinnerObject');
        
        spinnerObject[processName] = true;

            // if(processName == 'No_Mobile_Information')
            // {
            //     if(component.find(processName).get("v.value") == true)
            //     {
            //         component.set('v.leadStageModalButton', true);
            //     }
            // }
        
        
        component.set('v.toggleSpinnerObject',spinnerObject);
        var state = component.find(processName).get("v.value");
        if(state && (processName == 'Phone_Insights_Data_Maintenance' || processName == 'Validate_Employer_Data_Maintenance')){
        	component.set('v.openConfirmModal',true);
     		component.set('v.serviceToggled',processName);
        }
        
        
        //component.set("v.toggleValue" ,  checkCmp.get("v.value"));
        else{
    		var action = component.get('c.changeProcessToggle');	
                
            action.setParams({
            "fieldName" : processName,
            "switchState" : state
            });
            action.setCallback(this, function(a){
                spinnerObject[processName] = false;
                component.set('v.toggleSpinnerObject',spinnerObject);
            });
            
            $A.enqueueAction(action);   
		}
    	
    },
    handleChange:function(component, event, helper)
    {
        //helper.showSpinner(component);
    	var processName = event.getSource().getLocalId();
        
        
        var state = component.find(processName).get("v.value");
        console.log(processName,state);
        
        
        //component.set("v.toggleValue" ,  checkCmp.get("v.value"));
        
        var action = component.get('c.changeTimeBasedMaintainence'); 	
        
        action.setParams({
            "fieldName" : processName,
            "value" : state
        });
        action.setCallback(this, function(a){
            if(processName == 'Data_Maintenance_LimitsNoLimitsSelection'){
                if(state == 'Limits'){
                    component.set('v.showLimitsBox',true);
                    component.set('v.MaitainQueueSalesEngagemet',true);
                }
                else{
                    component.set('v.showLimitsBox',false);
                    component.set('v.MaitainQueueSalesEngagemet',false);
                }    
            }
        });
        
        $A.enqueueAction(action);
    },
    openModal : function(component,event,helper){
        component.set('v.openSelectPhoneModal',true);	
	},
    closeModal : function(component,event,helper){
    	component.set('v.openSelectPhoneModal',false);	
    },
    

    openleadStagesModal : function(component,event,helper)
    {
        component.set('v.loadSpinner', true)

        var action = component.get("c.fetchLeadStages");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();
                var lst = [];
                for(var i = 0; i<response.getReturnValue().length; i++)
                {
                    var obj = {};
                    obj.label = result[i];
                    obj.value = result[i];
                    lst.push(obj);
                }

                component.set('v.availableStages', lst);
                component.set('v.loadSpinner', false)
            }
            else {
            }
        });
        $A.enqueueAction(action);


        component.set('v.leadStageModal', true);
    },

    closeLeadStagesModal : function(component,event,helper)
    {
        component.set('v.leadStageModal', false);
        //component.set('v.alreadySelectedStages', component.get('v.alreadySelectedStagesDemo'));


        var action = component.get('c.getProcessStates');
        
        var spinnerObj = {No_Mobile_Information_campaign:false,Validate_Employer_campaign:false,Get_linkedin_campaign:false,Get_Phone_Insights:false,No_Mobile_Information:false,Get_linkedin_url:false,Validate_Employer:false,No_Phone_Information:false,Opportunity_Contact_Enrichment:false,Unresponsive_Lead_Toggle:false,Phone_Insights_Data_Maintenance:false,Validate_Employer_Data_Maintenance:false};
        component.set('v.toggleSpinnerObject',spinnerObj);
        
        action.setCallback(this, function(result){
        	var state = result.getState();
            if(state == 'SUCCESS') {
                var switchDataObj = JSON.parse(result.getReturnValue());
                
                var selectedList = [];
                
                
                selectedList = JSON.parse(switchDataObj.Selected_Lead_Status);
                
                component.set('v.alreadySelectedStages', selectedList);
                component.set('v.alreadySelectedStagesDemo', selectedList);
             
               
            }
            
        });
        
        $A.enqueueAction(action);

    },


    handleStageChange : function(component,event,helper)
    {
        
        var selectedOptionValue = event.getParam("value");
   
        component.set('v.selectedStages', selectedOptionValue);
        

    },

    doStageSave : function(component,event,helper)
    {
        
        
        var action = component.get("c.getLeadStages");
        action.setParams({ strList : JSON.stringify(component.get('v.selectedStages'))});

        action.setCallback(this, function(response) {
        });

        $A.enqueueAction(action);


        component.set('v.leadStageModal', false);



        
         var currentURL = window.location.href;       
            

        if (currentURL.includes("visualforce.com") || currentURL.includes("visual.force.com")) 
        {
            component.set(
              "v.toastMessage",
              "Lead status successfully saved"
            );
            component.set("v.configurationToast", true);
            $A.enqueueAction(component.get("c.handleToast"));
        }

        else
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Saved',
                message: 'Lead status successfully saved',
                duration:' 3000',
                type: 'Success',
                mode: 'dismissible'
            });
            toastEvent.fire();
        }

            

        
    },


    openOppStagesModal : function(component,event,helper){
        component.set('v.loadSpinner', true)

        var action = component.get("c.fetchOppStages");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();
                var lst = [];
                for(var i = 0; i<response.getReturnValue().length; i++)
                {
                    var obj = {};
                    obj.label = result[i];
                    obj.value = result[i];
                    lst.push(obj);
                }

                component.set('v.availableOppStages', lst);
                component.set('v.loadSpinner', false)
            }
            else {
            }
        });
        $A.enqueueAction(action);
        
        component.set('v.OppStageModal', true);
    },

    closeOppStagesModal : function(component,event,helper)
    {
        component.set('v.OppStageModal', false);


        
        var action = component.get('c.getProcessStates');
        
        // var spinnerObj = {No_Mobile_Information_campaign:false,Validate_Employer_campaign:false,Get_linkedin_campaign:false,Get_Phone_Insights:false,No_Mobile_Information:false,Get_linkedin_url:false,Validate_Employer:false,No_Phone_Information:false,Opportunity_Contact_Enrichment:false,Unresponsive_Lead_Toggle:false,Phone_Insights_Data_Maintenance:false,Validate_Employer_Data_Maintenance:false};
        // component.set('v.toggleSpinnerObject',spinnerObj);
        
        action.setCallback(this, function(result){
        	var state = result.getState();
            if(state == 'SUCCESS') {
                var switchDataObj = JSON.parse(result.getReturnValue());
                
                var selectedList = [];
                
                
                selectedList = JSON.parse(switchDataObj.Selected_Opportunity_Stages);
                
                component.set('v.alreadySelectedOppStages', selectedList);
                component.set('v.alreadySelectedOppStagesDemo', selectedList);


               
               
               
            }
            
        });
        
        $A.enqueueAction(action);

    },
    handleOppStageChange : function(component,event,helper)
    {
        var selectedOptionValue = event.getParam("value");
   
        component.set('v.selectedOppStages', selectedOptionValue);
        
    },

    doOppStageSave : function(component,event,helper)
    {
        
        var action = component.get("c.getOppStages");
        action.setParams({ 
            strList : JSON.stringify(component.get('v.selectedOppStages')),
            opportunityLimitsNoLimits : component.get('v.switchData.Opportunity_Limits_No_Limits_Selection'),
            opportunityRequestLimit : component.get('v.switchData.Opportunity_Request_Limit')
        });

        action.setCallback(this, function(response) {
        });

        $A.enqueueAction(action);


        component.set('v.OppStageModal', false);



        
         var currentURL = window.location.href;       
            

        if (currentURL.includes("visualforce.com") || currentURL.includes("visual.force.com")) 
        {
            component.set(
              "v.toastMessage",
              "Opportuity stages successfully saved"
            );
            component.set("v.configurationToast", true);
            $A.enqueueAction(component.get("c.handleToast"));
        }

        else
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Saved',
                message: 'Opportuity stages successfully saved',
                duration:' 3000',
                type: 'Success',
                mode: 'dismissible'
            });
            toastEvent.fire();
        }
    },

   





    handleToast: function (component, event, helper) {
        
        window.setTimeout(
            $A.getCallback(function() {
                helper.hideToast(component)
            }), 3000
        );
            
      },
    

    handleConfirmSubmit : function(component,event,helper){
    	component.set('v.openConfirmModal',false);
        var action = component.get('c.changeProcessToggle');	
        var processName = component.get("v.serviceToggled");       
        var spinnerObject = component.get('v.toggleSpinnerObject'); 
        action.setParams({
            "fieldName" : processName,
            "switchState" : true
            });
            action.setCallback(this, function(a){
                spinnerObject[processName] = false;
                component.set('v.toggleSpinnerObject',spinnerObject);
            });
            
            $A.enqueueAction(action);      
    },
    
    closeConfirmModal : function(component,event,helper){
    var processName = component.get("v.serviceToggled");  	
    component.set('v.openConfirmModal',false);	
	var spinnerObject = component.get('v.toggleSpinnerObject');
        
        var obj = component.get('v.switchData');
    	obj[processName] = false;
        component.set('v.switchData',obj);
		spinnerObject[processName] = false;
        component.set('v.toggleSpinnerObject',spinnerObject);
    },
    handleLimitChange : function(component,event,helper){
        
        var obj = component.get('v.validationObject');
        if(obj == null){
            obj = {};
        }
        
        if(event.target.value == null || isNaN(parseInt(event.target.value)) || parseInt(event.target.value) < 1 || parseInt(event.target.value) > 99999){
            obj[event.currentTarget.dataset.name] = true;
        }

        else{   
            obj[event.currentTarget.dataset.name] = false;

            var switchDataObj = component.get('v.switchData');

            var sameValueObj = component.get('v.sameValue');
            //if(parseInt(event.target.value) != component.get('v.switchData.Get_Modigie_Invocable_Limit')){
            if(parseInt(event.target.value) != switchDataObj[event.currentTarget.dataset.name]){
                

                //component.set('v.sameValue.Get_Modigie_Invocable_Limit',false);
                sameValueObj[event.currentTarget.dataset.name] = false;
                

                var tempObj =component.get('v.tempValueObject');
                if(tempObj == null){
                    tempObj = {};
                }

                tempObj[event.currentTarget.dataset.name] = parseInt(event.target.value);
                component.set('v.tempValueObject',tempObj);
            }
            else{
                
                
                //component.set('v.sameValue.Get_Modigie_Invocable_Limit',true);
                sameValueObj[event.currentTarget.dataset.name] = true;
            }
            component.set('v.sameValue',sameValueObj);
           /* var action = component.get('c.setInvocableLimits');	
            
            action.setParams({
            "fieldName" : event.currentTarget.dataset.name,
            "value" : parseInt(event.target.value)
            });
            action.setCallback(this, function(a){
            });
            
            $A.enqueueAction(action); */
        }
        component.set('v.validationObject',obj);
    },
    confirmLimit : function(component,event,helper){
        
        var switchDataObj = component.get('v.switchData');
        var tempValueObj = component.get('v.tempValueObject');

        

        //component.set('v.switchData.Get_Modigie_Invocable_Limit',component.get('v.tempValueObject.Get_Modigie_Invocable_Limit'));
        switchDataObj[event.currentTarget.dataset.name] = tempValueObj[event.currentTarget.dataset.name];
        component.set('v.switchData',switchDataObj);
        
        
       // component.set('v.sameValue.Get_Modigie_Invocable_Limit',true);
        
        var sameValueObj = component.get('v.sameValue');
        sameValueObj[event.currentTarget.dataset.name] = true;
        
        component.set('v.sameValue',sameValueObj);
        var action = component.get('c.setInvocableLimits');	
            
        action.setParams({
            "fieldName" : event.currentTarget.dataset.name,
            "value" : tempValueObj[event.currentTarget.dataset.name]
        });
        action.setCallback(this, function(a){
        });
        
        $A.enqueueAction(action);
    },
    displayExistingLimit : function(component,event,helper){
        var switchDataObj = component.get('v.switchData');
        

        //var temp = component.get('v.switchData.Get_Modigie_Invocable_Limit');
        var temp = switchDataObj[event.currentTarget.dataset.name];
        
        //component.set('v.switchData.Get_Modigie_Invocable_Limit',null);
        switchDataObj[event.currentTarget.dataset.name] = null;
        component.set('v.switchData',switchDataObj);
        
       // component.set('v.switchData.Get_Modigie_Invocable_Limit',temp);
        switchDataObj[event.currentTarget.dataset.name] = temp;
        component.set('v.switchData',switchDataObj);

      //  component.set('v.sameValue.Get_Modigie_Invocable_Limit',true);
        var sameValueObj = component.get('v.sameValue');
        sameValueObj[event.currentTarget.dataset.name]= true;
        component.set('v.sameValue',sameValueObj);
    },
    handleLimitSelectionChange : function(component,event,helper){
    

        if(component.get('v.LimitsSelector') == 'true'){
            component.set('v.showLimitsBox',true);
        }
        else{
            component.set('v.showLimitsBox',false);
        }
        
    },


    clickTop : function(component,event,helper)
    {

        component.set('v.topSection', true);
        component.set('v.middleSection', false);
        component.set('v.bottomSection', false);
        
        var cmpTargettop = component.find('top');
        $A.util.addClass(cmpTargettop, 'slds-is-active');
        $A.util.removeClass(cmpTargettop, 'slds-is-incomplete');

        var cmpTargetMiddle = component.find('middle');
        $A.util.addClass(cmpTargetMiddle, 'slds-is-incomplete');
        $A.util.removeClass(cmpTargetMiddle, 'slds-is-active');

        var cmpTargetBottom = component.find('bottom');
        $A.util.addClass(cmpTargetBottom, 'slds-is-incomplete');
        $A.util.removeClass(cmpTargetBottom, 'slds-is-active');
    },

    clickMiddle : function(component,event,helper)
    {

        component.set('v.topSection', false);
        component.set('v.middleSection', true);
        component.set('v.bottomSection', false);
         
        // elem.scrollIntoView(); 
        var cmpTargetMiddle = component.find('middle');
        $A.util.addClass(cmpTargetMiddle, 'slds-is-active');
        $A.util.removeClass(cmpTargetMiddle, 'slds-is-incomplete');

        var cmpTargetTop = component.find('top');
        $A.util.addClass(cmpTargetTop, 'slds-is-incomplete');
        $A.util.removeClass(cmpTargetTop, 'slds-is-active');

        var cmpTargetBottom = component.find('bottom');
        $A.util.addClass(cmpTargetBottom, 'slds-is-incomplete');
        $A.util.removeClass(cmpTargetBottom, 'slds-is-active');



    },
    // clickBottom : function(component,event,helper)
    // {

    //     component.set('v.topSection', false);
    //     component.set('v.middleSection', false);
    //     component.set('v.bottomSection', true);
        
    //     var cmpTargetMiddle = component.find('middle');
    //     $A.util.addClass(cmpTargetMiddle, 'slds-is-incomplete');
    //     $A.util.removeClass(cmpTargetMiddle, 'slds-is-active');

    //     var cmpTargetTop = component.find('top');
    //     $A.util.addClass(cmpTargetTop, 'slds-is-incomplete');
    //     $A.util.removeClass(cmpTargetTop, 'slds-is-active');

    //     var cmpTargetBottom = component.find('bottom');
    //     $A.util.addClass(cmpTargetBottom, 'slds-is-active');
    //     $A.util.removeClass(cmpTargetBottom, 'slds-is-incomplete');
        

    // },


    openleadStagesModal : function(component,event,helper)
    {
        component.set('v.loadSpinner', true)

        var action = component.get("c.fetchLeadStages");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();
                var lst = [];
                for(var i = 0; i<response.getReturnValue().length; i++)
                {
                    var obj = {};
                    obj.label = result[i];
                    obj.value = result[i];
                    lst.push(obj);
                }

                component.set('v.availableStages', lst);
                component.set('v.loadSpinner', false)
            }
            else {
            }
        });
        $A.enqueueAction(action);


        component.set('v.leadStageModal', true);
    },

    openDynamicCriteriaModal : function(component,event, helper){
        component.set('v.showDynamicCriteriaModal',true);
    },

    closeDynamicCriteriaModal : function(component,event, helper){
        component.set('v.showDynamicCriteriaModal',false);
    },
    handleMaintainQueueChange : function(component,event,helper){
        console.log('component.get("v.MaitainQueueSalesEngagemet") ', component.get("v.MaitainQueueSalesEngagemet"));
        var action = component.get("c.setMaintainQueue");
        action.setCallback(this, function(response) {
        });
        action.setParams({
            "maintainQueueState" : component.get("v.MaitainQueueSalesEngagemet")
        });
        $A.enqueueAction(action);
    },

    handleSectionToggle: function (cmp, event) {
        var openSections = event.getParam('openSections');

        if (openSections.length === 0) {
            cmp.set('v.activeSectionsMessage', "All sections are closed");
        } else {
            cmp.set('v.activeSectionsMessage', "Open sections: " + openSections.join(', '));
        }
    },

    openAutomationCriteriaModal : function(component,event, helper){
        component.set('v.automationCriteria',true);
        console.log(component.get('v.showDynamicCriteriaModal'));
    },

    closeAutomationCriteriaModal : function(component,event, helper){
        component.set('v.automationCriteria',false);
    },

    openEditRuleset : function(component, event, helper){
        component.set('v.editRuleset', true);
        component.set('v.automationCriteria',false);
        var ruleset = event.target.value;
        console.log('---------',ruleset);
        component.set('v.selectedRuleset',ruleset);
    },

    closeEditRuleset : function(component, event, helper){
        component.set('v.editRuleset', false);
        // component.set('v.automationCriteria',true);
    },

    openCreateNewRuleset : function(component, event, helper){
        component.set('v.newRuleset', true);
        component.set('v.automationCriteria',false);
        component.set('v.editRuleset', false);
    },

    closeCreateNewRuleset : function(component, event, helper){
        component.set('v.newRuleset', false);
        // component.set('v.automationCriteria', true);
    },

    closeDeleteModal: function(component, event, helper){
        component.set('v.showDeleteModal', false);
    },

    // deleteRuleset : function(component, event, helper){

    //     var list = component.get('v.ruleSets');
    //     // console.log(list[1].title);
    //     for(let i = 0; i < list.length; i++){
    //         console.log(list[i].title,event.target.value);
    //         if(list[i].title == event.target.value && list[i].title != 'Default Ruleset'){

    //             list.splice(i,1);
    //             // console.log(list.splice(i,1));
    //         }
    //     }
    //     console.log(list);
    //     component.set('v.ruleSets', list);
    // },

    handleNewRulesetEvent : function(component, event, helper){
        let leadCriteriaList = event.getParam("leadCriteriaList");
        let contactCriteriaList = event.getParam("contactCriteriaList");
        let rulesetId = event.getParam("rulesetId");
        console.log('rulesetId----------',rulesetId);
        let criteriaList = new Array();

        criteriaList.push(leadCriteriaList);
        criteriaList.push(contactCriteriaList);
        
        
        var newRulesetDetails = event.getParam("newRulesetDetails");
        console.log("details----->",newRulesetDetails["creditRecordId"]);

        

        let rulesetDetails = {
            "title" : newRulesetDetails["title"],
                "description" : newRulesetDetails["description"],
                "automationTrigger" : newRulesetDetails["automationTrigger"],
                "numberOfRequests": newRulesetDetails["numberOfRequests"], 
                "maintainQueue": newRulesetDetails["maintainQueue"],
                "Limits_No_Limits_Selection": newRulesetDetails["Limits_No_Limits_Selection"],
                "leadSelectedLogic": newRulesetDetails["leadSelectedLogic"], 
                "contactSelectedLogic": newRulesetDetails["contactSelectedLogic"],
                "leadLogic": newRulesetDetails["leadLogic"],
                "contactLogic": newRulesetDetails["contactLogic"],
                "isActive": newRulesetDetails["isActive"],
                "creditRecordId": newRulesetDetails["creditRecordId"],
                "isPerformance": component.get('v.isPerformance')
        }


        let title = newRulesetDetails["title"];
        let description = newRulesetDetails["description"];
        let edit = title + ',Edit';
        let del = title + ',Delete';
        let status = title + ',Status';
        let analyse = title + ',Analyse';
        let active = false;
        let creditRecordId = newRulesetDetails["creditRecordId"];
        let details = {"title":title, "description": description, "edit": edit, "delete": del, "status": status, "analyse": analyse, "active": active, "creditRecordId": creditRecordId};
        var list = component.get('v.ruleSets');
        list.push(details);
        // component.set('v.ruleSets', list);
        component.set('v.newRuleset', false);
        component.set('v.editRuleset', false);
        // component.set("v.enteredValue", valueFromChild);

        var action = component.get('c.saveRulesetDetails');
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                console.log(response.getReturnValue());
                // $A.get('e.force:refreshView').fire();
                helper.getAllRulesets(component);
            }
        });

        action.setParams({
            "rulesetDetails": rulesetDetails,
            "criteriaList": criteriaList,
            "editRulesetId": rulesetId
        });

        $A.enqueueAction(action);
    },



    // demo start

    // handleEditRulesetEvent : function(component, event, helper){
    //     let leadCriteriaList = event.getParam("leadCriteriaList");
    //     let contactCriteriaList = event.getParam("contactCriteriaList");
    //     let criteriaList = new Array();

    //     criteriaList.push(leadCriteriaList);
    //     criteriaList.push(contactCriteriaList);
        
        
    //     var newRulesetDetails = event.getParam("newRulesetDetails");
    //     console.log("details----->",newRulesetDetails);
        

    //     let rulesetDetails = {
    //         "title" : newRulesetDetails["title"],
    //             "description" : newRulesetDetails["description"],
    //             "automationTrigger" : newRulesetDetails["automationTrigger"],
    //             "numberOfRequests": newRulesetDetails["numberOfRequests"], 
    //             "maintainQueue": newRulesetDetails["maintainQueue"],
    //             "Limits_No_Limits_Selection": newRulesetDetails["Limits_No_Limits_Selection"],
    //             "leadSelectedLogic": newRulesetDetails["leadSelectedLogic"], 
    //             "contactSelectedLogic": newRulesetDetails["contactSelectedLogic"],
    //             "leadLogic": newRulesetDetails["leadLogic"],
    //             "contactLogic": newRulesetDetails["contactLogic"],
    //             "isActive": newRulesetDetails["isActive"]
    //     }


    //     let title = newRulesetDetails["title"];
    //     let description = newRulesetDetails["description"];
    //     let edit = title + ',Edit';
    //     let del = title + ',Delete';
    //     let status = title + ',Status';
    //     let analyse = title + ',Analyse';
    //     let active = false;
    //     let details = {"title":title, "description": description, "edit": edit, "delete": del, "status": status, "analyse": analyse, "active": active};
    //     var list = component.get('v.ruleSets');
    //     list.push(details);
    //     component.set('v.ruleSets', list);
    //     component.set('v.newRuleset', false);
    //     // component.set('v.automationCriteria', true);
    //     // component.set("v.enteredValue", valueFromChild);

    //     var action = component.get('c.saveRulesetDetails');
    //     action.setCallback(this, function(response){
    //         if(response.getState() === "SUCCESS"){
    //             console.log(response.getReturnValue());
    //         }
    //     });

    //     action.setParams({
    //         "rulesetDetails": rulesetDetails,
    //         "criteriaList": criteriaList
    //     });

    //     $A.enqueueAction(action);
    // },

    // demo end

    handleRulesetSectionToggle: function (cmp, event) {
        var openSections = event.getParam('openSections');

        if (openSections.length === 0) {
            cmp.set('v.activeRulesetSectionsMessage', "All sections are closed");
        } else {
            cmp.set('v.activeRulesetSectionsMessage', "Open sections: " + openSections.join(', '));
        }
    },

    handleButtonMenu: function(component, event, helper){
        console.log(event.getParam('value').split(','));
        var returnedValue = event.getParam('value').split(',');
        
        if(returnedValue[1] == 'Edit'){
            // var action = component.get('c.editRuleset');

            // action.setCallback(this, function(response){
            //     if(response.getState() == 'SUCCESS'){
            //         console.log('==============----',response.getReturnValue());
            //         component.set('v.selectedRulesetName',response.getReturnValue());
            //     }
            // });

            // action.setParams({
            //     "rulesetId": returnedValue[0],
            // });

            // $A.enqueueAction(action);

            component.set('v.editRuleset', true);
            component.set('v.automationCriteria',false);
            var ruleset = returnedValue[0];
            console.log('---------',ruleset);
            component.set('v.selectedRuleset',ruleset);
        }
        else if(returnedValue[1] == 'Delete'){
            component.set('v.showDeleteModal', true);
            component.set('v.automationCriteria',false);
            component.set('v.selectedRuleset',returnedValue[0]);
            console.log(component.get('v.showDeleteModal'),'-------',component.get('v.selectedRuleset'));
            // var list = component.get('v.ruleSets');
            // for(let i = 0; i < list.length; i++){
            //     console.log(list[i].Id,returnedValue[0]);
            //     if(list[i].Id == returnedValue[0]){
            //         console.log('-----------------------------------');
            //         var action = component.get("c.deleteTheRuleset");
            //         action.setCallback(this, function(response){
            //             console.log(response.getState());
            //             if(response.getState() == 'SUCCESS'){
            //                 console.log(response.getReturnValue());
            //             }
            //         });
            //         action.setParams({
            //             "rulesetId": returnedValue[0],
            //         });
            //         $A.enqueueAction(action);
            //         list.splice(i,1);
            //         // console.log(list.splice(i,1));
            //     }
            // }
            // console.log(list);
            // component.set('v.ruleSets', list);
        }
        else if(returnedValue[1] == 'Status'){
            var list = component.get('v.ruleSets');
            // console.log(list[1].title);

            var action = component.get('c.changeStatus');

            action.setCallback(this, function(response){
                if(response.getState() == 'SUCCESS'){
                    console.log('==============----',response.getReturnValue());
                }
            });

            action.setParams({
                "rulesetId": returnedValue[0],
            });

            $A.enqueueAction(action);
            for(let i = 0; i < list.length; i++){
                console.log(list[i].title,returnedValue);
                if(list[i].Id == returnedValue[0]){

                    list[i].active = !list[i].active;
                    console.log(list[i].active);
                }
            }
            component.set('v.ruleSets', list);
        }
        else if(returnedValue[1] == 'Analyse'){
            component.set('v.showAnalyzeModal', true);
            component.set('v.selectedRuleset',returnedValue[0]);

            var action = component.get("c.getAnalysisData");	
            var id = returnedValue[0];
            var list = component.get('v.ruleSets');
            for(let i=0; i<list.length; i++){
                if(list[i].Id == id){
                    console.log(list[i].automationTrigger);
                    component.set('v.automationTrigger',list[i].automationTrigger);
                }
            }
            // id = id.slice(0,-3);
            action.setParams({
            "rulesetId" : id,
            });
            action.setCallback(this, function(result){
                var returnValue = result.getReturnValue();
                console.log('===============',result.getReturnValue());
                let leadCount = returnValue['Lead-Count'];
                let contactCount = returnValue['Contact-Count'];
                let leadUser = returnValue['Lead-User'];
                let contactUser = returnValue['Contact-User'];
                let calculation = returnValue['Acticipated-Call'];
                if(leadCount < 1){
                    component.set('v.showAlternateTextLead', true);
                }
                if(contactCount < 1){
                    component.set('v.showAlternateTextContact', true);
                }
                console.log(leadUser, contactUser);
                // leadUser = [{isAutomation: true,
                //     total: 22,
                //     userId: "0051U000005tLCEQA2",
                //     userName: "Vaibhav Vyas"},
                //     {isAutomation: true,
                //         total: 1,
                //         userId: "0051U000008RaIwQAK",
                //         userName: "Test Account 1"},
                //         {isAutomation: true,
                //             total: 22,
                //             userId: "0051U000005tLCEQA2",
                //             userName: "Vaibhav Vyas"},
                //             {isAutomation: true,
                //                 total: 1,
                //                 userId: "0051U000008RaIwQAK",
                //                 userName: "Test Account 1"},{isAutomation: true,
                //                     total: 22,
                //                     userId: "0051U000005tLCEQA2",
                //                     userName: "Vaibhav Vyas"},
                //                     {isAutomation: true,
                //                         total: 1,
                //                         userId: "0051U000008RaIwQAK",
                //                         userName: "Test Account 1"},{isAutomation: true,
                //                             total: 22,
                //                             userId: "0051U000005tLCEQA2",
                //                             userName: "Vaibhav Vyas"},
                //                             {isAutomation: true,
                //                                 total: 1,
                //                                 userId: "0051U000008RaIwQAK",
                //                                 userName: "Test Account 1"},{isAutomation: true,
                //                                     total: 22,
                //                                     userId: "0051U000005tLCEQA2",
                //                                     userName: "Vaibhav Vyas"},
                //                                     {isAutomation: true,
                //                                         total: 1,
                //                                         userId: "0051U000008RaIwQAK",
                //                                         userName: "Test Account 1"},{isAutomation: true,
                //                                             total: 22,
                //                                             userId: "0051U000005tLCEQA2",
                //                                             userName: "Vaibhav Vyas"},
                //                                             {isAutomation: true,
                //                                                 total: 1,
                //                                                 userId: "0051U000008RaIwQAK",
                //                                                 userName: "Test Account 1"},{isAutomation: true,
                //                                                     total: 22,
                //                                                     userId: "0051U000005tLCEQA2",
                //                                                     userName: "Vaibhav Vyas"},
                //                                                     {isAutomation: true,
                //                                                         total: 1,
                //                                                         userId: "0051U000008RaIwQAK",
                //                                                         userName: "Test Account 1"},
                //                                                         {isAutomation: true,
                //                                                             total: 22,
                //                                                             userId: "0051U000005tLCEQA2",
                //                                                             userName: "Vaibhav Vyas"},
                //                                                             {isAutomation: true,
                //                                                                 total: 1,
                //                                                                 userId: "0051U000008RaIwQAK",
                //                                                                 userName: "Test Account 1"},
                //                                                                 {isAutomation: true,
                //                                                                     total: 22,
                //                                                                     userId: "0051U000005tLCEQA2",
                //                                                                     userName: "Vaibhav Vyas"},
                //                                                                     {isAutomation: true,
                //                                                                         total: 1,
                //                                                                         userId: "0051U000008RaIwQAK",
                //                                                                         userName: "Test Account 1"},
                //                                                                         {isAutomation: true,
                //                                                                             total: 22,
                //                                                                             userId: "0051U000005tLCEQA2",
                //                                                                             userName: "Vaibhav Vyas"},
                //                                                                             {isAutomation: true,
                //                                                                                 total: 1,
                //                                                                                 userId: "0051U000008RaIwQAK",
                //                                                                                 userName: "Test Account 1"},
                //                                                                                 {isAutomation: true,
                //                                                                                     total: 22,
                //                                                                                     userId: "0051U000005tLCEQA2",
                //                                                                                     userName: "Vaibhav Vyas"},
                //                                                                                     {isAutomation: true,
                //                                                                                         total: 1,
                //                                                                                         userId: "0051U000008RaIwQAK",
                //                                                                                         userName: "Test Account 1"},
                //                                                                                         {isAutomation: true,
                //                                                                                             total: 22,
                //                                                                                             userId: "0051U000005tLCEQA2",
                //                                                                                             userName: "Vaibhav Vyas"},
                //                                                                                             {isAutomation: true,
                //                                                                                                 total: 1,
                //                                                                                                 userId: "0051U000008RaIwQAK",
                //                                                                                                 userName: "Test Account 1"},
                //                                                                                                 {isAutomation: true,
                //                                                                                                     total: 22,
                //                                                                                                     userId: "0051U000005tLCEQA2",
                //                                                                                                     userName: "Vaibhav Vyas"},
                //                                                                                                     {isAutomation: true,
                //                                                                                                         total: 1,
                //                                                                                                         userId: "0051U000008RaIwQAK",
                //                                                                                                         userName: "Test Account 1"},
                // ];
                // if(leadUser.length<=7){
                //     document.getElementById("scrollable").style.height = "100%";
                // }
                console.log('Lead-User-->', returnValue['Lead-User']);
                component.set('v.mostActiveUserListLead', leadUser);
                component.set('v.mostActiveUserListContact', contactUser);
                component.set('v.leadCount', leadCount);
                component.set('v.contactCount', contactCount);
                component.set('v.anticipatedQueriesCalculation', calculation);
                // spinnerObject[processName] = false;
                component.set('v.analyzeSpinner',true);

            });
            
            $A.enqueueAction(action); 
        }
    },

    closeAnalyzeModal: function(component){
        component.set('v.showAnalyzeModal', false);
        component.set('v.analyzeSpinner',false);
        component.set('v.selectedObject','Lead');
        component.set('v.showContactUserList', false);
        
    },

    handleRadioChange: function(component){
        console.log(component.get('v.selectedObject'));
        if(component.get('v.selectedObject') == 'Contact'){
            component.set('v.showContactUserList', true);
        }
        else{
            component.set('v.showContactUserList', false);
        }
        
    },

    handleInputChange: function(component){
        component.set('v.showSaveOption', true);
    },

    hideSaveOption: function(component){
        component.set('v.showSaveOption', false);
    },

    deleteRuleset: function(component){
        component.set('v.showDeleteModal', false);
        let rulesetId = component.get('v.selectedRuleset');
        var list = component.get('v.ruleSets');
            // console.log(list[1].title);
            for(let i = 0; i < list.length; i++){
                console.log(list[i].Id,rulesetId);
                if(list[i].Id == rulesetId){
                    console.log('-----------------------------------');
                    var action = component.get("c.deleteTheRuleset");
                    action.setCallback(this, function(response){
                        console.log(response.getState());
                        if(response.getState() == 'SUCCESS'){
                            console.log(response.getReturnValue());
                        }
                    });
                    action.setParams({
                        "rulesetId": rulesetId,
                    });
                    $A.enqueueAction(action);
                    list.splice(i,1);
                    // console.log(list.splice(i,1));
                }
            }
            console.log(list);
            component.set('v.ruleSets', list);
    },

    handleProactiveButtonMenu: function(component, event){
        var returnedValue = event.getParam('value');
        console.log(returnedValue);
        if(returnedValue == 'proactiveEdit'){
            $A.enqueueAction(component.get('c.openOppStagesModal'));
        }
        else if(returnedValue == 'proactiveStatus'){
            var action = component.get('c.saveStatus');
            action.setCallback(this, function(response){
                if(response.getState() == 'SUCCESS'){
                    console.log(response.getReturnValue());
                    component.set('v.proactiveStatus',!component.get('v.proactiveStatus'));
                }
            });
            $A.enqueueAction(action);
        }
    }
    


    
})