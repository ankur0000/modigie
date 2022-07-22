({
    doInit : function(component, event, helper) {
        component.set('v.columns', [
            {label: 'User/Profile', fieldName: 'modigie__User_Or_Profile__c', type: 'text'},
            {label: 'Name', fieldName: 'modigie__User_or_Profile_Name__c', type: 'text'},
            {label: 'Number of Requests per day', fieldName: 'modigie__Limit_of_modigie_callouts__c', type: 'number'},
        ]);
            component.set('v.toggleSpinner',true);
            
            var action = component.get("c.getUserProfileLimitsData");
            action.setParams({
            })
            
            action.setCallback(this, function(response){
            if(response.getReturnValue() != null){
            component.set('v.data',JSON.parse(response.getReturnValue()));
            
            var result = JSON.parse(response.getReturnValue());
            
            var arr = [];
                      for(var i = 0; i < result.length; i++){
            var tempObj = {"searchObject":result[i].modigie__User_Or_Profile__c,"numberOfLimits":result[i].modigie__Limit_of_modigie_callouts__c,"SelectedOptionValue":result[i].modigie__User_or_Profile_Name__c,"SelectedOptionId":result[i].modigie__User_or_Profile_Id__c};
            arr.push(tempObj);   
        }
        component.set('v.existingData',arr);
        
    }
    else{
    component.set('v.data',null);
    
}
 component.set('v.toggleSpinner',false);
});
$A.enqueueAction(action);	 

var action2 = component.get("c.getAdhocLimitData");
            action2.setParams({
            })
            
            action2.setCallback(this, function(response){
                
                if(response.getState() == "SUCCESS"){
                    if(response.getReturnValue())
                        component.set('v.selectedAdHoc','Limits');
                    else
                    component.set('v.selectedAdHoc','NoLimits');

                }
        
        });
$A.enqueueAction(action2);
},
    openLimitsModal : function(component, event, helper) {
        component.set('v.openLimitsModal',true);
    },
        closeLimitsModal : function(component,event,helper){
            component.set('v.openLimitsModal',false);
            component.set('v.existingData',[]);
            var a = component.get('c.doInit');
            $A.enqueueAction(a);
        },
            handleConfirmSubmit: function(component,event,helper){
                var childComponent = component.find("childCmp");
                var result = childComponent.confirm();
                if(result){
                    component.set('v.openLimitsModal',false);
                    var a = component.get('c.doInit');
                    $A.enqueueAction(a);
                }
                
            },

            handleAdHocChange : function(component, event, helper) {
                console.log(component.get('v.selectedAdHoc'));
                
                var adHocLimit = true;
                
                if(component.get('v.selectedAdHoc') == 'NoLimits')
                    adHocLimit = false;
                
                var action2 = component.get("c.setAdHocLimitData");
          
                action2.setParams({
                "adHocLimit" : adHocLimit
            })
            
            action2.setCallback(this, function(response){});
            $A.enqueueAction(action2);
                
            },
            openReference : function(component, event, helper){
                component.set("v.isReferenceOpen", true);
            },
            closeReference : function(component, event, helper){
                component.set("v.isReferenceOpen", false);
            }   
                
})