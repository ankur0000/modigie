global without sharing class GetLinkedInBatchClass implements 
Database.Batchable<sObject>, Database.Stateful,Database.AllowsCallouts {
    
    // instance member to retain state across transactions
    global modigie__Modigie_Credentials__c tokenList = new modigie__Modigie_Credentials__c();
    global List<modigie__Modigie_Service_Account__mdt> modigieCredential = new List<modigie__Modigie_Service_Account__mdt>();

    Set<String> notificationReceiver = new Set<String>();
    Set<String> campaignForNotification = new Set<String>();
    Set<String> campaignOutForNotification = new Set<String>();
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        modigieCredential = ModigieApiUtils.getServiceAccountDetails();
        return Database.getQueryLocator('SELECT Id, modigie__Parent_Id__c, modigie__Get_Linkedin_Campaign_User__c, modigie__Campaign_Id_GetLinkedin__c, modigie__LinkedIn_Url_Get_Mobile_Number__c, modigie__Linkedin_Status__c, modigie__Linkedin_Job_Id__c,  modigie__Get_LinkedIn_Job_Status__c,modigie__Validation_Key__c,modigie__Validation_Date_Get_LinkedIn__c,modigie__Linkedin_URL__c,modigie__Contact__r.Id,modigie__Lead__r.Id,modigie__Lead__r.modigie__linkedin_url__c,modigie__Contact__r.modigie__linkedin_url__c FROM modigie__Modigie__c WHERE modigie__Linkedin_Status__c  = \'In process\'  WITH SECURITY_ENFORCED');
    }
    global void execute(Database.BatchableContext bc, List<modigie__Modigie__c> scope){
        
        try{ 
            // process each batch of records
            Set <String> setJobId = new Set<String>();
            
            for(modigie__Modigie__c modi : scope){
                setJobId.add(modi.modigie__Linkedin_Job_Id__c); 
            }
            
            Map<String,Object> data = new Map<String,Object>();
             
            List<modigie__Modigie_Callout_Info__mdt> calloutInfo = [SELECT Id, modigie__Endpoint_Url__c, modigie__targetAud__c, modigie__Content_Type__c FROM modigie__Modigie_Callout_Info__mdt WHERE MasterLabel = 'LinkedIn Job Read' LIMIT 1];
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
                request.setHeader('x-api-key', modigieCredential[0].modigie__API_Key__c); 
                request.setEndpoint(endpoint + jobId);// Production Environment Endpoints
                //request.setEndpoint('https://modigie-engage-gateway-kyaxv4ttua-uc.a.run.app/api/v1/linkedInUrlJobs/' + jobId + '?key=' + tokenList.modigie__API_Key__c); // Staging Environment Endpoints
                request.setTimeout(120000);
                
                HttpResponse response = http.send(request);
                
                if(response.getStatusCode() == 200){

                
                    Map<String,Object> mMap = (Map<String,Object>)JSON.deserializeUntyped(response.getBody());
                    
                    // Map<String,Object> hidden = (Map<String,Object>)mMap.get('_hidden_');
                        
                        List<Object> contacts = (List<Object>) mMap.get('results');
                        
                        for(Object contact : contacts){
                            Map<String,Object> mapCon = (Map<String,Object>)contact;
                            
                            List<Object> customParameters = (List<Object>) mapCon.get('customParameters');

                            if(customParameters.size() > 0){
                                for(Object obj : customParameters){
                                    Map<String,Object> customParaSin = (Map<String,Object>) obj;
                                    if(customParaSin.get('name')?.toString()?.equalsIgnoreCase('recordIdAndOrgId') == true)
                                        data.put(customParaSin.get('value')+'',mapCon);
                                }
                                
                            }
                        }
                    
                }else if(response.getStatusCode() == 201 || response.getStatusCode() == 204 || response.getStatusCode() == 401 || response.getStatusCode() == 402 || response.getStatusCode() == 403){
                    EmailServiceClass.sendResponseError('GetLinkedInBatchClass', response.getStatusCode(), response.getBody());
                }
                
            }
            
            // List<SObject> lstSobj = new List<sObject>();
            List<Contact> lstContact = new List<Contact>();
            List<Lead> lstLead = new List<Lead>();
            Set<Id> lstSobjId = new Set<Id>();
            Map<String, String> securityMap = new Map<String, String>();
            
            securityMap.put('modigie__Validation_Key__c', 'modigie__Modigie__c');
            securityMap.put('modigie__Linkedin_Status__c', 'modigie__Modigie__c');
            securityMap.put('modigie__Get_LinkedIn_Job_Status__c', 'modigie__Modigie__c');
            securityMap.put('modigie__Validation_Date_Get_LinkedIn__c', 'modigie__Modigie__c');
            securityMap.put('modigie__Name_Get_LinkedIn__c', 'modigie__Modigie__c');
            securityMap.put('modigie__Linkedin_URL__c', 'modigie__Modigie__c');
            securityMap.put('modigie__linkedin_url__c', 'Contact');
            securityMap.put('modigie__linkedin_url__c', 'Lead');
            securityMap.put('modigie__LinkedIn_Url_Get_Mobile_Number__c', 'modigie__Modigie__c');
            
            Boolean check = FieldLevelSecurityCheck.checkSecurity(securityMap);
            
            List<modigie__Modigie_Tab_Refresh__e> lstObjEvent = new List<modigie__Modigie_Tab_Refresh__e>();
            
            for(modigie__Modigie__c modi : scope){
                Map<String,Object> temp;
                // if(modi.modigie__Contact__c != null){
                //      temp =  (Map<String,Object>)data.get(modi.Contact__c + UserInfo.getOrganizationId());
                // }
                
                // else if(modi.modigie__Lead__c != null){
                //    temp =  (Map<String,Object>)data.get(modi.modigie__Lead__c + UserInfo.getOrganizationId());
                // }
                if(modi.modigie__Parent_Id__c != null){
                    temp =  (Map<String,Object>)data.get(modi.modigie__Parent_Id__c + UserInfo.getOrganizationId());
                }
                if(temp != null){
                    if(temp.get('status') != null){
                        
                        if(temp.get('status')?.toString()?.equalsIgnoreCase('done') == true){
                            
                            lstObjEvent.add(new modigie__Modigie_Tab_Refresh__e(modigie__LeadOrContactRecordId__c = modi.modigie__Parent_Id__c));
                            
                            if(temp.get('linkedInUrl') != null){
                                String trimmedUrl = (String)temp.get('linkedInUrl');
                                if(trimmedUrl.length() >= 255){
                                    trimmedUrl = trimmedUrl.split('\\?')[0];
                                    if(trimmedUrl.length() >= 255){
                                        trimmedUrl = trimmedUrl.subString(0,254);
                                    }
                                }
                                modi.modigie__Linkedin_URL__c = trimmedUrl+'';
                                if(modi.modigie__LinkedIn_Url_Get_Mobile_Number__c == null){
                                    modi.modigie__LinkedIn_Url_Get_Mobile_Number__c = trimmedUrl+'';
                                }
                                modi.modigie__Linkedin_Status__c = 'Validated';
                                
                                if(modi.modigie__Contact__c != null && !lstSobjId.contains(modi.modigie__Contact__c)){
                                    // lstSobj.add(new Contact(id = modi.modigie__Contact__c,modigie__linkedin_url__c=String.valueOf(temp.get('linkedInUrl'))));
                                    lstContact.add(new Contact(id = modi.modigie__Contact__c,modigie__linkedin_url__c=String.valueOf(temp.get('linkedInUrl'))));
                                	lstSobjId.add(modi.modigie__Contact__c);
                                }
                                else if(modi.modigie__Lead__c != null && !lstSobjId.contains(modi.modigie__Lead__c)){
                                    // lstSobj.add(new Lead(id = modi.modigie__Lead__c,modigie__linkedin_url__c=String.valueOf(temp.get('linkedInUrl'))));
                                    lstLead.add(new Lead(id = modi.modigie__Lead__c,modigie__linkedin_url__c=String.valueOf(temp.get('linkedInUrl'))));
                                    lstSobjId.add(modi.modigie__Lead__c);
                                }
                            }
                            else{
                                modi.modigie__Linkedin_Status__c = 'Not available';
                            }
                        }
                        else if(temp.get('status')?.toString()?.equalsIgnoreCase('unavailable') == true){
                            modi.modigie__Linkedin_Status__c = 'Unavailable';
                        }  
                        
                        String status = temp.get('status').toString();
                        status = status.substring(0, 1).toUpperCase() + status.substring(1, status.length());
                        
                        if(!modi.modigie__Get_LinkedIn_Job_Status__c?.equalsIgnoreCase(status) == true){
                            modi.modigie__Get_LinkedIn_Job_Status__c = status;
                            modi.modigie__Validation_Date_Get_LinkedIn__c = System.now();
                        }
                        
                        // modi.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                    }
                    if(temp.get('name') != null){
                        modi.modigie__Name_Get_LinkedIn__c = (String)temp.get('name');
                    }
                    
                    if(modi.modigie__Campaign_Id_GetLinkedin__c != null){
                        if(campaignOutForNotification.contains(modi.modigie__Campaign_Id_GetLinkedin__c)){
                            
                        }
                        else{
                            if(modi.modigie__Get_LinkedIn_Job_Status__c?.equalsIgnoreCase('done') == true){
                                campaignForNotification.add(modi.modigie__Campaign_Id_GetLinkedin__c);
                            }
                            else if(modi.modigie__Get_LinkedIn_Job_Status__c != 'done' && campaignForNotification.contains(modi.modigie__Campaign_Id_GetLinkedin__c)){
                                campaignForNotification.remove(modi.modigie__Campaign_Id_GetLinkedin__c);
                                campaignOutForNotification.add(modi.modigie__Campaign_Id_GetLinkedin__c);
                            }
                        }
                    }
                }
                if(modi.modigie__Campaign_Id_GetLinkedin__c != null){
                    if(campaignOutForNotification.contains(modi.modigie__Campaign_Id_GetLinkedin__c)){
                        
                    }
                    else{
                        if(modi.modigie__Get_LinkedIn_Job_Status__c?.equalsIgnoreCase('done') == true){
                            campaignForNotification.add(modi.modigie__Campaign_Id_GetLinkedin__c);
                            notificationReceiver.add(modi.modigie__Get_Linkedin_Campaign_User__c);
                        }
                        else if(modi.modigie__Get_LinkedIn_Job_Status__c != 'done' && campaignForNotification.contains(modi.modigie__Campaign_Id_GetLinkedin__c)){
                            campaignForNotification.remove(modi.modigie__Campaign_Id_GetLinkedin__c);
                            campaignOutForNotification.add(modi.modigie__Campaign_Id_GetLinkedin__c);
                        }
                    }
                }
                
                modi.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
            }
            
            if(check){
                if(!scope.isEmpty()){
                	Database.update(scope);    
                }
                // if(!lstSobj.isEmpty()){
                // 	Database.update (lstSobj);    
                // }
                if(!lstContact.isEmpty()){
                    Database.update(lstContact);
                }

                if(!lstLead.isEmpty()){
                    Database.update(lstLead);
                }

                if(!lstObjEvent.isEmpty()){
					EventBus.publish(lstObjEvent);     
				}
            }
            
        }
        
        catch(Exception e){
            //call here Error Email
            EmailServiceClass.sendErrorEmail('GetLinkedInBatchClass Error', e);
            System.debug('GetModigieBatchClass -->' + e.getLineNumber());
            /* List<modigie__Modigie_Batch_Class_Internal_Error_List__c> lstBatchClassError = [SELECT Id, modigie__Error_Message__c FROM modigie__Modigie_Batch_Class_Internal_Error_List__c];
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
                
                List<String> ccAddresses = new List<String>{'support@modigie.com'};
               
                if(!toAddresses.isEmpty()){
                    mail.setToAddresses(toAddresses);
                    mail.setCcAddresses(ccAddresses);
                    mail.saveAsActivity= false;
                    mail.setSubject('Modigie : GetLinkedInBatchClass Error');
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
       
        //add here
        if(campaignForNotification.size() > 0){
            String notificationTitle = 'Get LinkedIn Service Result Campaign';
            String notificationBody = 'Modigie Data for Get LinkedIn Service has been returned.';
            NotificationServiceClass.sendNotification(notificationTitle, notificationBody, notificationReceiver, campaignForNotification);
        }
    }    
    private class GetLinkedInBatchClassException extends Exception{}
}