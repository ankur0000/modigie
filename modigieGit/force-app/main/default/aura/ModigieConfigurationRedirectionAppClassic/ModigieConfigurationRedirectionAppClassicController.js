({
	    doInit: function(component) {
        	
             var action1 = component.get("c.checkToken");
        
        action1.setParams({
        });
        action1.setCallback(this, function(response1){
            component.set('v.baseUrl',response1.getReturnValue().baseUrl);
        	window.open(response1.getReturnValue().baseUrl+'/apex/modigie__ModigieConfigurationVFPage?modigie__customerId=' + component.get("v.customerId"),'_top');
        });
        $A.enqueueAction(action1);
	},
    
   
})