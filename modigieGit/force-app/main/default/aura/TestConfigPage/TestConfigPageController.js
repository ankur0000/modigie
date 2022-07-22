({
   /* doinit : function(component, event, helper) {
      
        component.set("v.toggleSpinner",true);
      
        var lstOptions = [];
        
        var lstoptionshourinter = [];
        lstoptionshourinter.push('00');

        for(var i = 1; i <= 11; i++){
            var str = '';

            if(i < 10){
                str = '0' + i;
            }
           
            else{
                str = i + '';
            }

            lstOptions.push(str);
            lstoptionshourinter.push(str);
        }
        lstOptions.push(12 + '');

        component.set('v.optionsHourTime',lstOptions);
        component.set('v.optionsHoursInterval',lstoptionshourinter);

        var lstOptionsMinInterval = [];
        var lstOptionsMinTime = [];

        lstOptionsMinInterval.push('00');
        for(var i = 0; i < 60; i++){
            var str = '';

            if(i < 10){
                str = '0' + i;
            }
            else{
                str = i + '';
            }

            if(60 % i == 0){
                
                lstOptionsMinInterval.push(str);    
            }
            
            lstOptionsMinTime.push(str);
        }


        component.set('v.optionsMinuteInterval',lstOptionsMinInterval);
        component.set('v.optionsMinuteTime',lstOptionsMinTime);
        
        
       
        
        
        

        
        
        
        
        var action1 = component.get("c.checkToken");
        
        action1.setParams({
        });
        action1.setCallback(this, function(response1){
            
            


            if(component.get('v.pageReference.state.modigie__customerId')==null){

                if(response1.getReturnValue().apiKey != null)
                {
                    
                    component.set("v.tokenCheck", true);
                    component.set("v.creditsId", response1.getReturnValue().creditsId);
                    component.set("v.apiKey", response1.getReturnValue().apiKey);
                    component.set("v.serviceCredentials", response1.getReturnValue().serviceCredential);
                    component.set("v.customerId", response1.getReturnValue().customerId);
                    component.set("v.privateKey", response1.getReturnValue().privateKey);
                }
            
            }
       
            else{
                component.set("v.customerId", component.get('v.pageReference.state.modigie__customerId'));
            }    
            
            if(response1.getReturnValue().apiKey != null){
                component.set('v.showTabs',true);
            }

            component.set("v.toggleSpinner",false);
            component.set('v.baseUrl',response1.getReturnValue().baseUrl);
            component.set("v.canCreateToken", response1.getReturnValue().TokenCreate); 

        });
        $A.enqueueAction(action1);
    

    


        var action2 = component.get("c.getJobTimeDetails");
        action2.setParams({
        });
        action2.setCallback(this, function(response1){
           
                component.set('v.jobTimeDetails',null);
           
           if(response1.getReturnValue() != null){

           
            component.set('v.isInterval',false);
                component.set('v.isIntervalPick',false);
                component.set('v.isTime',false);
                component.set('v.isTimePick',false);
            var result = JSON.parse(response1.getReturnValue());
            
            
            var hour = result.Hour;
            var minute = result.Minute;

            

            if(!result.Interval){
                component.set('v.isTime',true);
                component.set('v.isTimePick',true);

                if(result.Hour < 12){
                    component.set('v.selectedmeridiem','AM');
                }   
            
                else{
                    component.set('v.selectedmeridiem','PM');
                    if(result.Hour > 12){
                        result.Hour -= 12;
                    }    
                }
            }
            if(result.Hour < 10){
                hour = '0' + result.Hour;
            }
            if(result.Minute < 10){
                minute = '0' + result.Minute; 
            }
            
            if(result.Interval){
                component.set('v.isInterval',true);
                component.set('v.isIntervalPick',true);
                component.set('v.selectedHourInterval',hour);
                component.set('v.selectedMinuteInterval',minute);
            
                var obj = {"Hour":hour,"Minute":minute,"isTime":false};
                component.set('v.jobTimeDetails',obj);
            }
            else{
                if(hour == 0){
                    hour = '12';    
                }
                component.set('v.selectedHourTime',hour);
                component.set('v.selectedMinuteTime',minute);
                
                var obj = {"Hour":hour,"Minute":minute,"isTime":true,"Meridian":component.get('v.selectedmeridiem')};
                component.set('v.jobTimeDetails',obj);
            }
            
            component.set("v.toggleSpinner",false);
            
           }
        });
        $A.enqueueAction(action2);
        
        var action3 = component.get('c.getScheduleJobsInfo');
        action3.setParams({
        });
        action3.setCallback(this, function(response3){
            
        
            var parsedObj = JSON.parse(response3.getReturnValue());

            if(parsedObj.DataAvailable){
                component.set('v.batchJobsInfoOriginal',parsedObj);
                component.set('v.batchJobsInfo',JSON.parse(JSON.stringify(component.get('v.batchJobsInfoOriginal'))));
            }
        });
        $A.enqueueAction(action3);
        
        
    },
    
    getAPIToken : function(component, event, helper) {
        if(component.get("v.canCreateToken") == 'true')
        {
            

            var customerId = component.get('v.customerId');
            var creditsId = component.get('v.creditsId');
            var apiKey = component.get('v.apiKey');
            var serviceCredentials = component.get('v.serviceCredentials');
            var privateKey = component.get('v.privateKey');
            

            if(apiKey &&  creditsId &&  serviceCredentials && privateKey){


                
                var sampleVar = privateKey.toString().replace(/[\n\r]/g, '');
                

               
                var obj = {'customerId':component.get('v.customerId'),'creditsId':creditsId,'apiKey':apiKey,'serviceCredentials':serviceCredentials,'privateKey':privateKey.replace('\n','')};
                var action1 = component.get("c.getToken");
                component.set("v.toggleSpinner", true);
                
                action1.setParams({
                    "resMap": obj
                });
                action1.setCallback(this, function(response1){
                    if(response1.getState() == 'SUCCESS'){
                        component.set('v.showTabs',true);

                        component.set("v.toggleSpinner", false);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type": "success",
                            "title": "Success!",
                            "message": "Credentials Submitted Successfully."
                        });
                        toastEvent.fire();
                        component.set('v.tokenCheck',true);    
                        
                    }
                    else{
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type": "error",
                            "title": "Error!",
                            "message": response1.getReturnValue()
                        });
                        toastEvent.fire();    
                    }
                
                    

                });
                $A.enqueueAction(action1);
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error",
                    "title": "Error!",
                    "message": "Fill out all the fields."
                 });
                toastEvent.fire();
            }
        }
        else
        {
            
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "You can not authorize the app"
            });
            toastEvent.fire(); 
        }
    
   
},
    
    navigate : function(component, event, helper) {
        
       //window.open('https://modigie-customer-gateway-bqqdnyh5lq-uc.a.run.app/authenticate?callback='+ component.get('v.baseUrl')+'/modigie/ModigieConfigurationRedirectionApp.app','_self');
         window.open('https://modigie-customer-gateway-bqqdnyh5lq-uc.a.run.app/authenticate?callback='+ component.get('v.baseUrl')+'/modigie/TestConfigRedirectionApp.app','_self');
    },
    navigateModigie : function(component, event, helper) {
        var redirectURL = 'https://modigie.com';
        window.open(redirectURL);
        //window.location.href = redirectURL;
    },
    edit : function(component, event, helper) {
        
        component.set("v.tokenCheck", false);
    },
    
    closeModel : function(component, event, helper) {
        
        component.set("v.tokenGenerated",false);
        component.set("v.tokenCheck",true);
        component.set("v.uname",'');
        component.set("v.passwd",'');
      //  $A.get('e.force:refreshView').fire();
    },
    handleAction : function(component, event, helper) {
      
        component.set("v.isTimePick",!component.get("v.isTimePick"));
        component.set("v.isIntervalPick",!component.get("v.isIntervalPick"));
    },

    handleSubmit : function(component,event,helper){
        
        var hour;
        var minute;
        var type = 'Interval';
        
        if(component.get('v.isTimePick')){

            hour = parseInt(component.get('v.selectedHourTime'));
            minute = parseInt(component.get('v.selectedMinuteTime'));

            
            if(component.get('v.selectedmeridiem') == 'PM'){
                if(hour != 12){
                    hour = hour + 12;
                }
            }

            else if(component.get('v.selectedmeridiem') == 'AM'){
                if(hour == 12){
                    hour = 0;
                }
            }
        
           type = 'Time'; 
        }
        
        else{
        
            hour = parseInt(component.get('v.selectedHourInterval'));
            minute = parseInt(component.get('v.selectedMinuteInterval'));

            ('minute interval --->>>',minute);
            
            if(hour == 0 && minute ==0){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "Error",
                    "title": "Error!",
                    "message": "Invalid Interval"
                });
                toastEvent.fire();
                return;    
            }
        }
        component.set("v.toggleSpinner",true);
           
        var action1 = component.get("c.scheduleBatchClass");
            
            action1.setParams({
                hours : hour,
                minutes: minute,
                types:type
            });
            action1.setCallback(this, function(response1){ 
                component.set("v.toggleSpinner",false);
                
                var obj = {"GetLinkedIn":false,"GetMobileNumber":false,"GetPhoneInsights":false,"VerifyEmployer":false};

                component.set('v.batchJobsInfo',obj);
                component.set('v.batchJobsInfoOriginal',JSON.parse(JSON.stringify(component.get('v.batchJobsInfo'))));
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "Success",
                    "title": "Success!",
                    "message": "The Batch Schedule Class Time saved sucessfully."
                });
                toastEvent.fire();
                var a = component.get('c.doinit');
                $A.enqueueAction(a);
            });
            $A.enqueueAction(action1);
    },

    cancelAction : function(component,event,helper){
        var a = component.get('c.doinit');
        $A.enqueueAction(a);
    },
    abortScheduledJobs : function(component,event,helper){
        component.set('v.openAbortModal',false);
        var action1 = component.get("c.abortModigieJobs"); 
        component.set("v.toggleSpinner",true);
        var obj = component.get('v.batchJobsInfo');
        action1.setParams({
            "strObj": JSON.stringify(obj)
        });
        action1.setCallback(this, function(response1){
        component.set("v.toggleSpinner",false);
            
            if(response1.getReturnValue() == 'success'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "Success",
                    "title": "Success!",
                    "message": "Selected jobs aborted successfully."
                });
                toastEvent.fire(); 
                component.set('v.batchJobsInfoOriginal',JSON.parse(JSON.stringify(component.get('v.batchJobsInfo'))));
                var a = component.get('c.doinit');
                $A.enqueueAction(a);
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error", 
                    "title": "Error!",
                    "message": response1.getReturnValue()
                });
                toastEvent.fire(); 
            }
        });
        $A.enqueueAction(action1);
    },
    navigteToScheduleTab : function(component,event,helper){
        component.set('v.selectedTab','two');
    },

    shceduleForOneMinute : function(component,event,helper){
        component.set("v.toggleSpinner",true);

        var action1 = component.get("c.scheduleBatchClass");
            
            action1.setParams({
                hours : 0,
                minutes: 1,
                types:"Interval"
            });
            action1.setCallback(this, function(response1){ 
                component.set("v.toggleSpinner",false);

                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "Success",
                    "title": "Success!",
                    "message": "The Batch Schedule Class Time saved sucessfully."
                });
                toastEvent.fire();
            });
            $A.enqueueAction(action1);
    },
    openAbortModal : function(component,event,helper){
        component.set('v.openAbortModal',true);
    },
    closeAbortModal : function(component,event,helper){
        component.set('v.openAbortModal',false);
        var obj = component.get('v.batchJobsInfoOriginal');

        component.set('v.batchJobsInfo',JSON.parse(JSON.stringify(obj)));
    },
    handleCheckBoxChange : function(component,event,helper){
        var obj = component.get('v.batchJobsInfo');
    }*/
})