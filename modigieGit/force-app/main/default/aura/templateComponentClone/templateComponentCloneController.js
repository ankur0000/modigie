({
 	
  /*  doInit : function(component, event, helper) {
        var action = component.get('c.getProcessStates');
        
        var spinnerObj = {Unresponsive_Lead_Get_LinkedIn_URL:false, Unresponsive_Lead_Get_Phone_Insights:false, Unresponsive_Lead_Get_Modigie:false, Lead_Status_Working_Get_LinkedIn_URL:false, Lead_Status_Working_Get_Phone_Insights:false, Lead_Status_Working_Verify_Employer:false, Lead_Status_Working_Get_Modigie:false, Unreachable_Get_LinkedIn_URL:false, Unreachable_Get_Phone_Insights:false, Unreachable_Verify_Employer:false, Unreachable_Get_Modigie:false, Opportunity_Contact_Get_Phone_Insights:false, Opportunity_Contact_Get_LinkedIn:false, Opportunity_Contact_Get_Modigie:false, Validate_Employer_Data_Maintenance:false, Unresponsive_Lead_Verify_Employer :false,Get_Phone_Insights_Campaign:false, No_Mobile_Information_campaign:false,Validate_Employer_campaign:false,Get_linkedin_campaign:false,Get_Phone_Insights:false,No_Mobile_Information:false,Get_linkedin_url:false,Validate_Employer:false,No_Phone_Information:false,Opportunity_Contact_Enrichment:false,Unresponsive_Lead_Toggle:false,Phone_Insights_Data_Maintenance:false,Validate_Employer_Data_Maintenance:false};
        component.set('v.toggleSpinnerObject',spinnerObj);
        
        action.setCallback(this, function(result){
        	var state = result.getState();
            if(state == 'SUCCESS') {

                var switchDataObj = JSON.parse(result.getReturnValue());
                var selectedList = [];
                
                
                selectedList = JSON.parse(switchDataObj.Selected_Lead_Status);
                
                component.set('v.alreadySelectedStages', selectedList);
                component.set('v.alreadySelectedStagesDemo', selectedList);

                var selectedOppList = [];
                
                
                selectedOppList = JSON.parse(switchDataObj.Selected_Opportunity_Stages);
                
                component.set('v.alreadySelectedOppStages', selectedOppList);
                component.set('v.alreadySelectedOppStagesDemo', selectedOppList);


                if(switchDataObj.Limits_No_Limits_Selection == 'Limits'){
                    component.set('v.showLimitsBox',true);
                }
                else{
                    component.set('v.showLimitsBox',false);
                }

               
                component.set('v.switchData', JSON.parse(result.getReturnValue()));
           		component.set('v.toggleSpinner',false);
            }

            else
            {
            }
            
        });
        
        $A.enqueueAction(action);
        
        component.set('v.sameValue',{"Opportunity_Contact_Get_Phone_Insights_L":true, "Unresponsive_Lead_Get_LinkedIn_URL_Limit":true, "Unresponsive_Lead_Get_Phone_Insights_Lim":true, "Unresponsive_Lead_Get_Modigie_Limit":true, "Lead_Status_Working_Get_LinkedIn_URL_Lim":true, "Lead_Status_Working_Get_Phone_Insights_L":true, "Lead_Status_Working_Verify_Employer_Limi":true, "Lead_Status_Working_Get_Modigie_Limit":true, "Unreachable_Get_LinkedIn_URL_Limit":true, "Unreachable_Get_Phone_Insights_Limit":true, "Unreachable_Verify_Employer_Limit":true, "Unreachable_Get_Modigie_Limit":true, "Opportunity_Contact_Get_LinkedIn_Limit":true, "Opportunity_Contact_Get_Modigie_Limit":true, "Validate_Employer_Data_Maintenance_Lmt":true,"Unresponsive_Lead_Verify_Employer_Limit":true,"Get_Phone_Insights_Campaign_Limits":true,"Get_Modigie_Invocable_Limit":true,"Modigie_Phone_Insights_Invocable_Limit":true,"Validate_Employer_Invocable_Limit":true,"LinkedIn_Url_Invocable_Limits":true,"Opp_Contact_Enrichment_Invocable_Limit":true, "Unresponsive_Lead_Invocable_Limits":true, "Phone_Insights_Data_Maintenance_Limits":true, "Validate_Employer_Data_Maintenance_Lmt":true, "Get_Modigie_Campaign_Invocable_Limits":true, "Validate_employer_campaign_Limits":true,"Linkedin_Url_Campaign_Limits":true});
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
      
        
        
        //component.set("v.toggleValue" ,  checkCmp.get("v.value"));
        
        var action = component.get('c.changeTimeBasedMaintainence'); 	
        
        action.setParams({
            "fieldName" : processName,
            "value" : state
        });
        action.setCallback(this, function(a){
            if(processName == 'Limits_No_Limits_Selection'){
                if(state == 'Limits'){
                    component.set('v.showLimitsBox',true);
                }
                else{
                    component.set('v.showLimitsBox',false);
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
            

        if (currentURL.includes("visualforce.com")) 
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


    openOppStagesModal : function(component,event,helper)
    {
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
        action.setParams({ strList : JSON.stringify(component.get('v.selectedOppStages'))});

        action.setCallback(this, function(response) {
        });

        $A.enqueueAction(action);


        component.set('v.OppStageModal', false);



        
         var currentURL = window.location.href;       
            

        if (currentURL.includes("visualforce.com")) 
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
        let delay = 3000;
        setTimeout(() => {
          component.set("v.configurationToast", false);
        }, delay);
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
            
            $A.enqueueAction(action); 
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
    clickBottom : function(component,event,helper)
    {

        component.set('v.topSection', false);
        component.set('v.middleSection', false);
        component.set('v.bottomSection', true);
        
        var cmpTargetMiddle = component.find('middle');
        $A.util.addClass(cmpTargetMiddle, 'slds-is-incomplete');
        $A.util.removeClass(cmpTargetMiddle, 'slds-is-active');

        var cmpTargetTop = component.find('top');
        $A.util.addClass(cmpTargetTop, 'slds-is-incomplete');
        $A.util.removeClass(cmpTargetTop, 'slds-is-active');

        var cmpTargetBottom = component.find('bottom');
        $A.util.addClass(cmpTargetBottom, 'slds-is-active');
        $A.util.removeClass(cmpTargetBottom, 'slds-is-incomplete');
        

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
*/
    


    
})