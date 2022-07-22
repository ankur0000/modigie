({
    doInit : function(component, event, helper) {
        component.set('v.lstUserOrProfileName',null);
        component.set('v.errorObject',{});
        /* var obj = {};
        component.set('v.dataObject',obj);*/
        if(component.get('v.dataObject.SelectedOptionValue')){
            var cmpTarget = component.find('ProfileUserInput');
            $A.util.addClass(cmpTarget, 'slds-has-selection');
            component.set('v.optionSelected',true);
            component.set('v.lstUserOrProfileName',null);    
        }
    },
    handleSearchChange : function(component, event, helper) {
		component.set('v.searchTerm',event.target.value);
        
        var obj = component.get('v.dataObject');
        
        
        var a = component.get('c.searchUserProfile');
        $A.enqueueAction(a);
	},
    
    searchUserProfile : function(component,event,helper){
        var action = component.get("c.fetchUserProfileData");
        
        var obj = component.get('v.dataObject');
        
        action.setParams({
            "searchTerm" : component.get('v.searchTerm'),
            "searchObject": obj.searchObject,
            "dataMap" : component.get('v.ListOfDataObject')
           // "searchObject": component.get('v.searchObject')
        })
        
        action.setCallback(this, function(response){
            var lstUserOrProfileName = JSON.parse(response.getReturnValue());
            component.set('v.lstUserOrProfileName',lstUserOrProfileName);
        });
        $A.enqueueAction(action);	
    },
    handleSearchObjectChange : function(component,event,helper){
    	var a = component.get('c.searchUserProfile');
        $A.enqueueAction(a);
    },
    optionClick : function(component,event,helper){
        
        component.set('v.dataObject.SelectedOptionValue',event.currentTarget.dataset.name);
        component.set('v.dataObject.SelectedOptionId',event.currentTarget.dataset.id);
       	
        var cmpTarget = component.find('ProfileUserInput');
        $A.util.addClass(cmpTarget, 'slds-has-selection');
        component.set('v.optionSelected',true);
        component.set('v.dataObject.UserOrProfileField',false);
        component.set('v.lstUserOrProfileName',null);
    },
    hideOptions : function(component,event,helper){
    },
    removeSelectedOption : function(component,event,helper){
    	var cmpTarget = component.find('ProfileUserInput');
        $A.util.removeClass(cmpTarget, 'slds-has-selection');
        component.set('v.dataObject.SelectedOptionValue',null);
        component.set('v.dataObject.SelectedOptionId',null);
        component.set('v.optionSelected',false);
    },
    AddNewRow : function(component, event, helper){
        // fire the AddNewRowEvt Lightning Event 
         component.getEvent("AddRowEvt").fire();     
     },
     
     removeRow : function(component, event, helper){
      // fire the DeleteRowEvt Lightning Event and pass the deleted Row Index to Event parameter/attribute
        component.getEvent("DeleteRowEvt").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
     },
    handleLimitChange : function(component, event, helper){
       	var cmpTarget = component.find('NumberOfLimitsField');
       /* if(event.target.value == '' || event.target.value == null || event.target.value == undefined || !Number.isInteger(event.target.value)){
            component.set('v.errorObject.LimitsField',true);
        	$A.util.addClass(cmpTarget, 'slds-has-error');	
        }
        else{*/
                
        	//component.set('v.errorObject.LimitsField',false);
        //	$A.util.removeClass(cmpTarget, 'slds-has-error');

        if(event.target.value == null || isNaN(parseInt(event.target.value)) || parseInt(event.target.value) < 1 || parseInt(event.target.value) > 99999){
            component.set('v.dataObject.LimitsField',true);
            
        }
        else{
            component.set('v.dataObject.LimitsField',false);
            component.set('v.dataObject.numberOfLimits',parseInt(event.target.value));
        }
       // }
        
    }
})