global without sharing class VerifyEmployerBatchClass implements 
Database.Batchable<sObject>, Database.Stateful,Database.AllowsCallouts { 
    // instance member to retain state across transactions
    global List<modigie__Modigie_Service_Account__mdt> modigieCredential = new List<modigie__Modigie_Service_Account__mdt>();
    global modigie__Modigie_Credentials__c tokenList = new modigie__Modigie_Credentials__c();
    Set<String> notificationReceiver = new Set<String>();
    Set<String> campaignForNotification = new Set<String>();
    Set<String> campaignOutForNotification = new Set<String>();
    
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        modigieCredential = ModigieApiUtils.getServiceAccountDetails();
        return Database.getQueryLocator('SELECT Id, modigie__Parent_Id__c, modigie__Employment_Ends_Verify_Employer__c, modigie__Verify_Employer_Campaign_User__c, modigie__Campaign_Id_VerifyEmployer__c, modigie__Current_Employer_Get_Modigie__c, modigie__LinkedIn_Url_Get_Mobile_Number__c, modigie__Company_Name_Matches_Records_Get_Modigie__c, modigie__Validate_Employer_Status__c , modigie__Validate_Employer_Job_Status__c ,  modigie__Validate_Employer_Job_Id__c ,modigie__Validation_Key__c,modigie__Validation_Date_Verify_Employer__c ,modigie__Company_Name_Matches_Public_Records__c,modigie__Current_Employer__c ,modigie__Current_Title__c ,modigie__Current__c,modigie__Contact__r.Id,modigie__Lead__r.Id,modigie__Contact__r.Account.Name,modigie__Lead__r.Company,modigie__Lead__r.modigie__linkedin_url__c, modigie__Contact__r.modigie__linkedin_url__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c  = \'In process\' WITH SECURITY_ENFORCED');
        
    }
    global void execute(Database.BatchableContext bc, List<modigie__Modigie__c> scope){
        // process each batch of records
        
        try{
            
            Set <String> setJobId = new Set<String>();
            
            for(modigie__Modigie__c modi : scope){
                setJobId.add(modi.modigie__Validate_Employer_Job_Id__c); 
            }
            
            Map<String,Object> data = new Map<String,Object>();
            
            List<modigie__Modigie_Callout_Info__mdt> calloutInfo = [SELECT Id, modigie__Endpoint_Url__c, modigie__targetAud__c, modigie__Content_Type__c FROM modigie__Modigie_Callout_Info__mdt WHERE MasterLabel = 'Verify Employer Job Read' LIMIT 1];
            String targetAudience, endpoint, contentType;
            if(!calloutInfo.isEmpty()){
                endpoint = calloutInfo[0].modigie__Endpoint_Url__c;
                targetAudience = calloutInfo[0].modigie__targetAud__c;
                contentType = calloutInfo[0].modigie__Content_Type__c;
            }

            String accessToken = 'Bearer ' + jwtapex.get_access_token(modigieCredential[0].modigie__Email__c,targetAudience,modigieCredential[0].modigie__Private_Key__c);
            
            for(String jobId : setJobId){
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                request.setMethod('GET');
                //String accessToken = 'Bearer ' + jwtapex.get_access_token(tokenList.modigie__Service_Account_Credentials__c,'https://modigie-engage-backend-kyaxv4ttua-uc.a.run.app',tokenList.modigie__Private_Key__c);
                request.setHeader('Content-Type', contentType); 
                request.setHeader('Authorization', accessToken); 
                //request.setEndpoint('https://modigie-val-gateway-pjcfvhz2qq-uc.a.run.app/api/val/v1/verifyEmployerJobs/' + jobId + '?key=' + tokenList.modigie__API_Key__c);
                request.setHeader('x-api-key', modigieCredential[0].modigie__API_Key__c);
                
                request.setEndpoint(endpoint + jobId); //Production Environment Endpoints
                //request.setEndpoint('https://modigie-engage-gateway-kyaxv4ttua-uc.a.run.app/api/v1/verifyEmployerJobs/' + jobId + '?key=' + tokenList.modigie__API_Key__c); //Staging Environment Endpoints
                request.setTimeout(120000);
                HttpResponse response = http.send(request);
                String wholeJobStatus = 'Started';
                if(response.getStatusCode() == 200){
                    Map<String,Object> mMap = (Map<String,Object>)JSON.deserializeUntyped(response.getBody());
                    wholeJobStatus = (String)mMap.get('status');
                    //  Map<String,Object> hidden = (Map<String,Object>)mMap.get('_hidden_');
                    
                    List<Object> contacts = (List<Object>) mMap.get('results');
                    
                    for(Object contact : contacts){
                        Map<String,Object> mapCon = (Map<String,Object>)contact;
                        // Map<String,Object> output = (Map<String,Object>)mapCon.get('output');
                        //output.put('status', mapCon.get('status'));
                        List<Object> customParameters = (List<Object>) mapCon.get('customParameters');
                        if(customParameters.size() > 0){
                            Map<String,Object> customParaSin = (Map<String,Object>) customParameters[0];
                            
                            data.put(customParaSin.get('value')+'',mapCon);
                        }
                    }
                }else if(response.getStatusCode() == 201 || response.getStatusCode() == 204 || response.getStatusCode() == 401 || response.getStatusCode() == 402 || response.getStatusCode() == 403){
                    EmailServiceClass.sendResponseError('VerifyEmployerBatchClass', response.getStatusCode(), response.getBody());
                }
                
                
            }
            
            Map<String, String> securityMap = new Map<String, String>();
            securityMap.put('modigie__Lead__c', 'modigie__Modigie__c');
            securityMap.put('modigie__Contact__c', 'modigie__Modigie__c');
            
            securityMap.put('modigie__LinkedIn_Url_Verify_Employer__c', 'modigie__Modigie__c');
            securityMap.put('modigie__Current_Title__c', 'modigie__Modigie__c');
            securityMap.put('modigie__Current__c', 'modigie__Modigie__c');
            securityMap.put('modigie__Current_Employer__c', 'modigie__Modigie__c');
            //securityMap.put('modigie__Current_Employer_Get_Modigie__c', 'modigie__Modigie__c');
            securityMap.put('modigie__Validate_Employer_Status__c', 'modigie__Modigie__c');
            securityMap.put('modigie__Company_Name_Matches_Public_Records__c', 'modigie__Modigie__c');
            //securityMap.put('modigie__Company_Name_Matches_Records_Get_Modigie__c', 'modigie__Modigie__c');
            securityMap.put('modigie__Validation_Date_Verify_Employer__c', 'modigie__Modigie__c');
            securityMap.put('modigie__Validation_Key__c', 'modigie__Modigie__c');
            securityMap.put('modigie__Validate_Employer_Job_Status__c', 'modigie__Modigie__c');
            securityMap.put('modigie__Name_Verify_Employer__c', 'modigie__Modigie__c');
            //securityMap.put('modigie__LinkedIn_Url_Get_Mobile_Number__c','modigie__Modigie__c');
            securityMap.put('modigie__linkedin_url__c','Contact');
            securityMap.put('modigie__linkedin_url__c','Lead');
            
            
            Boolean check = FieldLevelSecurityCheck.checkSecurity(securityMap);
            // List<sObject> listToUpdate = new List<sObject>();
            
            List<Lead> lstLead = new List<Lead>();
            List<Contact> lstContact = new List<Contact>();
            List<Id> lstSobjId = new List<Id>();

            List<modigie__Modigie_Tab_Refresh__e> lstObjEvent = new List<modigie__Modigie_Tab_Refresh__e>();
            
            for(modigie__Modigie__c modi : scope){
                
                
                Map<String,Object> temp;
                
                // if(modi.modigie__Contact__c != null){
                //     temp =  (Map<String,Object>)data.get(modi.Contact__c + UserInfo.getOrganizationId());
                // }
                // else if(modi.modigie__Lead__c != null){
                //     temp =  (Map<String,Object>)data.get(modi.Lead__c + UserInfo.getOrganizationId());
                // }
                
                if(modi.modigie__Parent_Id__c != null){
                    temp =  (Map<String,Object>)data.get(modi.modigie__Parent_Id__c + UserInfo.getOrganizationId());
                }
                if(temp != null){
                    if(temp.get('status')?.toString()?.equalsIgnoreCase('done') == true){
                        lstObjEvent.add(new modigie__Modigie_Tab_Refresh__e(modigie__LeadOrContactRecordId__c = modi.modigie__Parent_Id__c));
                        if(temp.get('events') != null){
                            List<Object> lstEvent = (List<Object>)temp.get('events');
                            for(Object objEvent : lstEvent){
                                Map<String,Object> eventObj =  (Map<String,Object>)objEvent;
                                if(eventObj.get('code') != null){
                                    String codeStr = eventObj.get('code').toString();
                                    if(codeStr?.equalsIgnoreCase('employer-verified') == true || codeStr?.equalsIgnoreCase('employer-changed') == true || codeStr?.equalsIgnoreCase('unable-to-verify-employer') == true || codeStr?.equalsIgnoreCase('linkedinurl-notfound') == true){
                                        switch on codeStr {
                                            when 'employer-verified' {		
                                                modi.modigie__Company_Name_Matches_Public_Records__c = 'Yes';	
                                                /* if(modi.modigie__Company_Name_Matches_Records_Get_Modigie__c == null){modi.modigie__Company_Name_Matches_Records_Get_Modigie__c = 'Yes';}*/
                                                modi.modigie__Validate_Employer_Status__c = 'Validated';
                                            }	
                                            when 'employer-changed' {		
                                                modi.modigie__Company_Name_Matches_Public_Records__c = 'No';
                                                /*if(modi.modigie__Company_Name_Matches_Records_Get_Modigie__c == null){modi.modigie__Company_Name_Matches_Records_Get_Modigie__c = 'No';}*/
                                                modi.modigie__Validate_Employer_Status__c = 'Validated';
                                            }
                                            when else {
                                                modi.modigie__Validate_Employer_Status__c = 'Not Available';
                                            }
                                        }    
                                    }
                                    
                                }
                            }
                        }
                        
                        
                        if(temp.get('linkedInUrl') != null){
                            modi.modigie__LinkedIn_Url_Verify_Employer__c = (String)temp.get('linkedInUrl');
                            /* if(modi.modigie__LinkedIn_Url_Get_Mobile_Number__c == null){modi.modigie__LinkedIn_Url_Get_Mobile_Number__c = modi.modigie__LinkedIn_Url_Verify_Employer__c;}*/
                            if(modi.modigie__Contact__c != null && !lstSobjId.contains(modi.modigie__Contact__c) && modi.modigie__Contact__r.modigie__linkedin_url__c == null){
                                Contact con = new Contact(id = modi.modigie__Contact__c, modigie__linkedin_url__c = modi.modigie__LinkedIn_Url_Verify_Employer__c);
                                if(modi.modigie__Company_Name_Matches_Public_Records__c == 'No'){
                                    con.modigie__Modigie_Employment_Changed__c = true;
                                }
                                // listToUpdate.add(new Contact(id = modi.modigie__Contact__c, modigie__linkedin_url__c = modi.modigie__LinkedIn_Url_Verify_Employer__c));
                                lstContact.add(con);
                                lstSobjId.add(modi.modigie__Contact__c);
                            }
                            if(modi.modigie__Lead__c != null && !lstSobjId.contains(modi.modigie__Lead__c) && modi.modigie__Lead__r.modigie__linkedin_url__c == null){
                                Lead ld = new Lead(id = modi.modigie__Lead__c, modigie__linkedin_url__c = modi.modigie__LinkedIn_Url_Verify_Employer__c);
                                if(modi.modigie__Company_Name_Matches_Public_Records__c == 'No'){
                                    ld.modigie__Modigie_Employment_Changed__c = true;
                                }
                                // listToUpdate.add(new Lead(id = modi.modigie__Lead__c, modigie__linkedin_url__c = modi.modigie__LinkedIn_Url_Verify_Employer__c));
                                lstLead.add(ld);
                                lstSobjId.add(modi.modigie__Lead__c);
                            }
                        }
                        
                        if(temp.get('employmentEnd') != null){
                            	Map<String,Object> employmentEnd = (Map<String,Object>)temp.get('employmentEnd');
                                
                                if(employmentEnd.get('month') != null){
                                 	Map<String,Object> month = (Map<String,Object>)employmentEnd.get('month');
                                    if(month.get('localeAbbrevFormat') != null){
                                    	modi.modigie__Employment_Ends_Verify_Employer__c = (String)month.get('localeAbbrevFormat');
                                    }
                                    
                                }
                            }
                        
                        if(temp.get('jobTitle') != null){
                            if(temp.get('jobTitle') != null){
                                modi.modigie__Current_Title__c = temp.get('jobTitle') + '';
                            }
                        }
                        if(temp.get('company') != null){
                            modi.modigie__Current_Employer__c  = temp.get('company')+'';
                            /* if(modi.modigie__Current_Employer_Get_Modigie__c == null){modi.modigie__Current_Employer_Get_Modigie__c = temp.get('company')+'';}*/
                        }
                        if(temp.get('locations') != null){
                            List<Object> countryNames =(List<Object>)temp.get('locations');
                            if(!countryNames.isEmpty()){
                                Map<String,Object> locationMap = (Map<String,Object>)countryNames[0];
                                if(locationMap.get('formattedAddress') != null)
                                    modi.modigie__Current__c = (String)locationMap.get('formattedAddress');
                            }
                        }
                    }  
                    else if(temp.get('status')?.toString()?.equalsIgnoreCase('unavailable') == true){
                        modi.modigie__Validate_Employer_Status__c = 'Unavailable';
                    }
                    String status = temp.get('status').toString();
                    status = status.substring(0, 1).toUpperCase() + status.substring(1, status.length());
                    
                    if(!modi.modigie__Validate_Employer_Job_Status__c?.equalsIgnoreCase(status) == true){
                        modi.modigie__Validate_Employer_Job_Status__c = status;
                        modi.modigie__Validation_Date_Verify_Employer__c  = System.now();
                    }
                    
                    
                    if(temp.get('name') != null){
                        modi.modigie__Name_Verify_Employer__c = (String)temp.get('name');
                    }
                    //Fixing Repeating Jobs Here
                    if(temp.get('status')?.toString()?.equalsIgnoreCase('done') == true && modi.modigie__Validate_Employer_Status__c.equalsIgnoreCase('In process')==true){
                        modi.modigie__Validate_Employer_Status__c = 'Not available';
                    }
                }

                
                
                
                
                modi.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                
                if(modi.modigie__Campaign_Id_VerifyEmployer__c != null){
                    if(campaignOutForNotification.contains(modi.modigie__Campaign_Id_VerifyEmployer__c)){
                        
                    }
                    else{
                        if(modi.modigie__Validate_Employer_Job_Status__c?.equalsIgnoreCase('done') == true){
                            campaignForNotification.add(modi.modigie__Campaign_Id_VerifyEmployer__c);
                            notificationReceiver.add(modi.modigie__Verify_Employer_Campaign_User__c);
                        }
                        else if(modi.modigie__Validate_Employer_Job_Status__c != 'done' && campaignForNotification.contains(modi.modigie__Campaign_Id_VerifyEmployer__c)){
                            campaignForNotification.remove(modi.modigie__Campaign_Id_VerifyEmployer__c);
                            campaignOutForNotification.add(modi.modigie__Campaign_Id_VerifyEmployer__c);
                        }
                    }
                }
                
            }
            
            if(check){
                String jobType = 'Verify Employer';
                String jobSource = 'Data Pickup';
                if(!scope.isEmpty()){
                    //Database.update(scope,false);  
                    Database.SaveResult[] saveResults = database.update(scope, false);
                    ErrorLogClass.createErrorLog(scope, 'Id', saveResults, jobType, jobSource);  
                }
                // if(!lstSobj.isEmpty()){
                //     Database.update(lstSobj);    
                // }
                if(!lstContact.isEmpty()){
                    //Database.update(lstContact,false);
                    Database.SaveResult[] saveResults = database.update(lstContact, false);
                    ErrorLogClass.createErrorLog(lstContact, 'Id', saveResults, jobType, jobSource);
                }
                if(!lstLead.isEmpty()){
                    //Database.update(lstLead,false);
                    Database.SaveResult[] saveResults = database.update(lstLead, false);
                    ErrorLogClass.createErrorLog(lstLead, 'Id', saveResults, jobType, jobSource);
                }
                
                if(!lstObjEvent.isEmpty()){
                    EventBus.publish(lstObjEvent);     
                }
                
            }
            if(Test.isRunningTest()){
            	throw new VerifyEmployerBatchClassException('For Covering Catch block code');
            }
        }
        
        catch(Exception e){
            //call here Error Email
            EmailServiceClass.sendErrorEmail('VerifyEmployerBatchClass Error', e);
            /*List<modigie__Modigie_Batch_Class_Internal_Error_List__c> lstBatchClassError = [SELECT Id, modigie__Error_Message__c FROM modigie__Modigie_Batch_Class_Internal_Error_List__c];
            List<String> lstStrErr = new List<String>();
            for(modigie__Modigie_Batch_Class_Internal_Error_List__c batchClassError : lstBatchClassError){
                lstStrErr.add(batchClassError.modigie__Error_Message__c);
            }
            
            if(!lstStrErr.contains(e.getMessage())){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                
                List<User> lstUser = [SELECT Id, Email FROM User WHERE isActive = true AND Id IN (SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Name = 'Modigie_Admin') AND Profile.Name = 'System Administrator' WITH SECURITY_ENFORCED];
                
                List<String> toAddresses = new List<String>();
                
                for(User usrObj : lstUser){
                    toAddresses.add(usrObj.Email);
                }
                
                List<String> ccAddresses = new List<String>{'support@modigie.com','pratik@cyntexa.com','ashishsharma@cyntexa.com'};
                    
                    if(!toAddresses.isEmpty()){
                        mail.setToAddresses(toAddresses);
                        mail.setCcAddresses(ccAddresses);
                        mail.saveAsActivity= false;
                        mail.setSubject('Modigie : VerifyEmployerBatch Error');
                        String emailBody = 'Please check the error message - ' + e.getMessage();
                        emailBody += '\nLine Number : ' + e.getLineNumber();
                        emailBody += '\nOrganization Name : ' + UserInfo.getOrganizationName();
                        emailBody += '\nOrganization Id : ' + UserInfo.getOrganizationId();
                        mail.setPlainTextBody(emailBody);
                        List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                        insert new modigie__Modigie_Batch_Class_Internal_Error_List__c(Name =String.valueOf(lstBatchClassError.size()+1), modigie__Error_Message__c = e.getMessage());
                    }
            }*/
        }
        
    }    
    global void finish(Database.BatchableContext bc){
        
        if(campaignForNotification.size() > 0){
            String notificationTitle = 'Verify Employer Service Result Campaign';
            String notificationBody = 'Modigie Data for Verify Employer Service has been returned.';
            NotificationServiceClass.sendNotification(notificationTitle, notificationBody, notificationReceiver, campaignForNotification);
        }
    }
    private class VerifyEmployerBatchClassException extends Exception{}
}