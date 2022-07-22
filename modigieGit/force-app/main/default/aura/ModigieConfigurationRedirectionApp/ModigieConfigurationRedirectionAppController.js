({
	    doInit: function(component) {
            console.log('------------------>',component.get('v.customerId'));
             var action1 = component.get("c.checkToken");
        
        action1.setParams({
        });
        action1.setCallback(this, function(response1){
            component.set('v.baseUrl',response1.getReturnValue().baseUrl);
            var action2 = component.get('c.saveCustomerId');
            action2.setParams({
                customerId: component.get('v.customerId')
            });
            action2.setCallback(this, function(response2){
                console.log('response.getReturnValue()');
            });
            $A.enqueueAction(action2);
        	window.open(response1.getReturnValue().baseUrl+'/lightning/n/modigie__Configuration_Page?modigie__customerId=' + component.get("v.customerId"),'_top');
        });
        $A.enqueueAction(action1);
	},
    
   
})