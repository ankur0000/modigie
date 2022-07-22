global without sharing class GetModigieBatchClass implements 
Database.Batchable<sObject>, Database.Stateful,Database.AllowsCallouts {
    
    // instance member to retain state across transactions
    List<modigie__Modigie_Service_Account__mdt> modigieCredential = new List<modigie__Modigie_Service_Account__mdt>();
    global modigie__Modigie_Credentials__c tokenList = new modigie__Modigie_Credentials__c();
    
    Set<String> campaignForNotification = new Set<String>();
    Set<String> campaignOutForNotification = new Set<String>();
    Set<String> notificationReceiver = new Set<String>();
    
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        modigieCredential = ModigieApiUtils.getServiceAccountDetails();
        return Database.getQueryLocator('SELECT Id, modigie__Company_Name_Matches_Public_Records__c, modigie__Validate_Employer_Status__c, modigie__Parent_Id__c , modigie__Employment_Ends_Get_Modigie__c, modigie__Employment_Ends_Verify_Employer__c, modigie__Get_Mobile_Campaign_User__c, modigie__Campaign_Id_GetMobileNumber__c, modigie__Current_Title_Get_Modigie__c, modigie__Current_Country_Get_Modigie__c, modigie__Current_Employer_Get_Modigie__c, modigie__Status__c, modigie__Jobid__c, modigie__Company_Name_Matches_Records_Get_Modigie__c, modigie__Mobile__c,modigie__Mobile_2__c,modigie__Mobile_3__c, modigie__Get_Modigie_Job_Status__c,modigie__Get_Modigie_Id__c,modigie__Validation_Key__c,modigie__Validation_Date_Get_Mobile_Number__c,modigie__Contact__c,modigie__Lead__c,modigie__Line_Activity__c,modigie__Phone_Type__c,modigie__Phone_Name_Match__c,modigie__Best_Time_to_Call__c,modigie__Day_of_Week_Detail__c,modigie__Verified_Phone_Get_Phone_Insights__c,modigie__Validation_Date_Mobile__c,modigie__Phone_Intelligence_Status__c,modigie__Contact__r.modigie__linkedin_url__c	, modigie__Lead__r.modigie__linkedin_url__c FROM modigie__Modigie__c WHERE modigie__Status__c = \'In process\' WITH SECURITY_ENFORCED');
        
    }
    
    global void execute(Database.BatchableContext bc, List<modigie__Modigie__c> scope){  
        try{
            ModigieStaticReferenceHelper.isGetModigieBatchRunning = true;
            System.debug('Scope Size -->> ' + scope.size());
            Organization org = [SELECT Id, TimeZoneSidKey FROM Organization WITH SECURITY_ENFORCED LIMIT 1];
            
            Map<String, String> bestTimeAllMap = new Map<String, String>();
            bestTimeAllMap.put('1','12am - 2am');
            bestTimeAllMap.put('2','2am - 4am');
            bestTimeAllMap.put('3','4am - 6am');
            bestTimeAllMap.put('4','6am - 8am');
            bestTimeAllMap.put('5','8am - 10am');
            bestTimeAllMap.put('6','10am - 12pm');
            bestTimeAllMap.put('7','12pm - 2pm');
            bestTimeAllMap.put('8','2pm - 4pm');
            bestTimeAllMap.put('9','4pm - 6pm');
            bestTimeAllMap.put('10','6pm - 8pm');
            bestTimeAllMap.put('11','8pm - 10pm');
            bestTimeAllMap.put('12','10pm - 12am');
            
            // process each batch of records
            Set <String> setJobId = new Set<String>();
            Map<String,List<modigie__Modigie__c>> mapJobIdtoModigie = new Map<String,List<modigie__Modigie__c>>();
            
            for(modigie__Modigie__c modi : scope){
                setJobId.add(modi.modigie__Jobid__c); 
                
                if(mapJobIdtoModigie.containsKey(modi.modigie__Jobid__c)){
                    List <modigie__Modigie__c> temp = mapJobIdtoModigie.get(modi.modigie__Jobid__c);
                    temp.add(modi);
                }
                else{
                    List<modigie__Modigie__c> temp = new List<modigie__Modigie__c>();
                    temp.add(modi);
                    mapJobIdtoModigie.put(modi.modigie__Jobid__c,temp);
                }
                
            }
            
            List<modigie__Modigie_Callout_Info__mdt> calloutInfo = [SELECT Id, modigie__Endpoint_Url__c, modigie__targetAud__c, modigie__Content_Type__c FROM modigie__Modigie_Callout_Info__mdt WHERE MasterLabel = 'Mobile Phone Job Read' LIMIT 1];
            String targetAudience, endpoint, contentType;
            if(!calloutInfo.isEmpty()){
                endpoint = calloutInfo[0].modigie__Endpoint_Url__c;
                targetAudience = calloutInfo[0].modigie__targetAud__c;
                contentType = calloutInfo[0].modigie__Content_Type__c;
            }

            Map<String,Object> data = new Map<String,Object>();
            
            String accessToken = 'Bearer ' + jwtapex.get_access_token(modigieCredential[0].modigie__Email__c,targetAudience,modigieCredential[0].modigie__Private_Key__c);
            
            
            for(String jobId : setJobId){
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                request.setMethod('GET');   
                //String accessToken = 'Bearer ' + jwtapex.get_access_token(tokenList.modigie__Service_Account_Credentials__c,'https://modigie-engage-backend-kyaxv4ttua-uc.a.run.app',tokenList.modigie__Private_Key__c);
                request.setHeader('Content-Type', contentType); 
                request.setHeader('Authorization', accessToken);
                request.setHeader('x-api-key', modigieCredential[0].modigie__API_Key__c); 
                request.setEndpoint(endpoint + jobId); // Production Environment Endpoints
                //request.setEndpoint('https://modigie-engage-gateway-kyaxv4ttua-uc.a.run.app/api/v1/mobilePhoneJobs/' + jobId + '?key=' + tokenList.modigie__API_Key__c); // Staging Environment Endpoints
                request.setTimeout(120000);
                HttpResponse response = http.send(request);
                if(response.getStatusCode() == 200){
                    Map<String,Object> mMap = (Map<String,Object>)JSON.deserializeUntyped(response.getBody());
                    
                    //  Map<String,Object> hidden = (Map<String,Object>)mMap.get('_hidden_');
                    
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
                    EmailServiceClass.sendResponseError('GetModigieBatchClass', response.getStatusCode(), response.getBody());
                }
                
            }
            
            // List<SObject> lstSobj = new List<sObject>();
            List<Lead> lstLead = new List<Lead>();
            List<Contact> lstContact = new List<Contact>();

            Set<Id> lstSobjId = new Set<Id>();
            if(FieldLevelSecurityCheck.canReadObject('modigie__Error_Log__c')&&
               FieldLevelSecurityCheck.canUpdateObject('modigie__Error_Log__c')&&
               FieldLevelSecurityCheck.canReadObject('Contact')&&
               FieldLevelSecurityCheck.canUpdateObject('Contact')&&
               FieldLevelSecurityCheck.canReadObject('Lead')&&
               FieldLevelSecurityCheck.canUpdateObject('Lead')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Lead__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Lead__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Contact__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Contact__c')&&
               
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Mobile__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Mobile__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Status__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Status__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validation_Key__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Validation_Key__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Get_Modigie_Job_Status__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Get_Modigie_Job_Status__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validation_Date_Get_Mobile_Number__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Validation_Date_Get_Mobile_Number__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__LinkedIn_Url_Get_Mobile_Number__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__LinkedIn_Url_Get_Mobile_Number__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Campaign_Id_GetMobileNumber__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Campaign_Id_GetMobileNumber__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Line_Activity_Modigie_Validated_Number__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Line_Activity_Modigie_Validated_Number__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Get_Mobile_Campaign_User__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Get_Mobile_Campaign_User__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Phone_Type_Modigie_Validated_Number__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Phone_Type_Modigie_Validated_Number__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Name_Get_Mobile_Number__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Name_Get_Mobile_Number__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Accuracy_Match_Modigie_Validated_Number__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Accuracy_Match_Modigie_Validated_Number__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Best_Time_to_Call_Validated_Number__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Best_Time_to_Call_Validated_Number__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Day_of_Week_Detail_Modigie_Val_Number__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Day_of_Week_Detail_Modigie_Val_Number__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Mobile_2__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Mobile_2__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Line_Activity_Alternate1__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Line_Activity_Alternate1__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Phone_Type_Alternate_Number1__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Phone_Type_Alternate_Number1__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Accuracy_Match_Alternate_Number1__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Accuracy_Match_Alternate_Number1__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Best_Time_to_Call_Alternate_Number1__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Best_Time_to_Call_Alternate_Number1__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Day_of_Week_Detail_Alternate_Number1__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Day_of_Week_Detail_Alternate_Number1__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Mobile_3__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Mobile_3__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Line_Activity_Alternate2__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Line_Activity_Alternate2__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Phone_Type_Alternate_Number2__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Phone_Type_Alternate_Number2__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Accuracy_Match_Alternate_Number2__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Accuracy_Match_Alternate_Number2__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Best_Time_to_Call_Alternate_Number2__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Best_Time_to_Call_Alternate_Number2__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Day_of_Week_Detail_Alternate_Number2__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Day_of_Week_Detail_Alternate_Number2__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Current_Employer_Get_Modigie__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Company_Name_Matches_Public_Records__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Current_Employer__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Current_Employer__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Current__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Current__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Current_Title__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Current_Title__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validation_Date_Verify_Employer__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Validation_Date_Verify_Employer__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Name_Verify_Employer__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Name_Verify_Employer__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validate_Employer_Status__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Validate_Employer_Status__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validate_Employer_Job_Id__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Validate_Employer_Job_Id__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validate_Employer_Job_Status__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Validate_Employer_Job_Status__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__LinkedIn_Url_Verify_Employer__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__LinkedIn_Url_Verify_Employer__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Linkedin_URL__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Linkedin_URL__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validation_Date_Get_LinkedIn__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Validation_Date_Get_LinkedIn__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Name_Get_LinkedIn__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Name_Get_LinkedIn__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Get_LinkedIn_Job_Status__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Get_LinkedIn_Job_Status__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Linkedin_Status__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Linkedin_Status__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Linkedin_Job_Id__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Linkedin_Job_Id__c')&&
               
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Company_Name_Matches_Public_Records__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Current_Employer_Get_Modigie__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Current_Country_Get_Modigie__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Current_Country_Get_Modigie__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Current_Title_Get_Modigie__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Current_Title_Get_Modigie__c')&&
               FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Company_Name_Matches_Records_Get_Modigie__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Company_Name_Matches_Records_Get_Modigie__c')&&
               FieldLevelSecurityCheck.canReadField('Contact','modigie__Alternate_Mobile_Phone_Available__c')&&
               FieldLevelSecurityCheck.canUpdateField('Contact','modigie__Alternate_Mobile_Phone_Available__c')&&
               FieldLevelSecurityCheck.canReadField('Contact','modigie__Modigie_Verified_Number__c')&&
               FieldLevelSecurityCheck.canUpdateField('Contact','modigie__Modigie_Verified_Number__c')&&
               FieldLevelSecurityCheck.canReadField('Contact','modigie__Validation_Key__c')&&
               FieldLevelSecurityCheck.canReadField('Contact','modigie__linkedin_url__c')&&
               FieldLevelSecurityCheck.canReadField('Lead','modigie__linkedin_url__c')&&
               FieldLevelSecurityCheck.canUpdateField('Contact','modigie__linkedin_url__c')&&
               FieldLevelSecurityCheck.canUpdateField('Lead','modigie__linkedin_url__c')&&
               FieldLevelSecurityCheck.canUpdateField('Contact','modigie__Validation_Key__c')&&
               FieldLevelSecurityCheck.canReadField('Lead','modigie__Modigie_Verified_Number__c')&&
               FieldLevelSecurityCheck.canUpdateField('Lead','modigie__Modigie_Verified_Number__c')&&
               FieldLevelSecurityCheck.canReadField('Lead','modigie__Alternate_Mobile_Phone_Available__c')&&
               FieldLevelSecurityCheck.canUpdateField('Lead','modigie__Alternate_Mobile_Phone_Available__c')&&
               FieldLevelSecurityCheck.canReadField('Lead','modigie__Validation_Key__c')&&
               FieldLevelSecurityCheck.canUpdateField('Lead','modigie__Validation_Key__c'))
               //&&
               //FieldLevelSecurityCheck.canReadField('Lead','modigie__Modigie_Is_Active__c')&&
               //FieldLevelSecurityCheck.canUpdateField('Lead','modigie__Modigie_Is_Active__c')&&
               //FieldLevelSecurityCheck.canReadField('Contact','modigie__Modigie_Is_Active__c')&&
               //FieldLevelSecurityCheck.canUpdateField('Contact','modigie__Modigie_Is_Active__c'))
                
            {
                
                List<modigie__Modigie_Tab_Refresh__e> lstObjEvent = new List<modigie__Modigie_Tab_Refresh__e>();
                
                for(modigie__Modigie__c modi : scope){
                    
                    Map<String,Object> temp;
                    
                    // if(modi.modigie__Contact__c != null){
                    //     temp =  (Map<String,Object>)data.get(modi.modigie__Contact__c + UserInfo.getOrganizationId()); 
                    // }
                    // else if(modi.modigie__Lead__c != null){
                    //     temp =  (Map<String,Object>)data.get(modi.modigie__Lead__c + UserInfo.getOrganizationId());
                    // }
                    if(modi.modigie__Parent_Id__c != null){
                        temp = (Map<String,Object>)data.get(modi.modigie__Parent_Id__c + UserInfo.getOrganizationId());
                    }
                    if(temp != null){
                        if(temp.get('status')?.toString()?.equalsIgnoreCase('done') == true){ 
                            
                            lstObjEvent.add(new modigie__Modigie_Tab_Refresh__e(modigie__LeadOrContactRecordId__c = modi.modigie__Parent_Id__c));
                            
                            String alternateAvailable = '', alternateAvailable2 = '', modigieValNumber='',e164ValNum = '';
                            
                            if(temp.get('events') != null){
                                Boolean verifyEmployerDataAvailable = false;
                                List<Object> lstEvent = (List<Object>)temp.get('events');
                                for(Object objEvent : lstEvent){
                                    Map<String,Object> eventObj =  (Map<String,Object>)objEvent;
                                    if(eventObj.get('code') != null){
                                        String codeStr = eventObj.get('code').toString();
                                        
                                        switch on codeStr {
                                            when 'employer-verified' {		
                                                modi.modigie__Company_Name_Matches_Records_Get_Modigie__c = 'Yes';
                                                modi.modigie__Company_Name_Matches_Public_Records__c = 'Yes';
                                                verifyEmployerDataAvailable = true;
                                            }	
                                            when 'employer-changed' {		
                                                modi.modigie__Company_Name_Matches_Records_Get_Modigie__c = 'No';
                                                modi.modigie__Company_Name_Matches_Public_Records__c = 'No';
                                                verifyEmployerDataAvailable = true;
                                            }
                                        }    
                                    }
                                }
                                if(verifyEmployerDataAvailable){
                                    if(temp.get('company') != null){
                                        modi.modigie__Current_Employer_Get_Modigie__c = temp.get('company').toString();
                                        modi.modigie__Current_Employer__c = temp.get('company').toString();
                                    }
                                    if(temp.get('locations') != null){
                                        List<Object> countryNames =(List<Object>)temp.get('locations');
                                        if(!countryNames.isEmpty()){
                                            Map<String,Object> locationMap = (Map<String,Object>)countryNames[0];
                                            if(locationMap.get('formattedAddress') != null)
                                                modi.modigie__Current_Country_Get_Modigie__c = (String)locationMap.get('formattedAddress');
                                            modi.modigie__Current__c = (String)locationMap.get('formattedAddress');
                                        }
                                    }
                                    if(temp.get('jobTitle') != null){
                                        modi.modigie__Current_Title_Get_Modigie__c = temp.get('jobTitle').toString();
                                        modi.modigie__Current_Title__c = temp.get('jobTitle').toString();
                                    }
                                    modi.modigie__Validation_Date_Verify_Employer__c = System.now();
                                    modi.modigie__Name_Verify_Employer__c = (String)temp.get('name');
                                    modi.modigie__Validate_Employer_Status__c = 'Validated';
                                    List<String> lstName = ((String)temp.get('name')).split('/');
                                    modi.modigie__Validate_Employer_Job_Id__c = lstName[1];
                                    modi.modigie__Validate_Employer_Job_Status__c = (String)temp.get('status');
                                }
                                else{
                                    modi.modigie__Validate_Employer_Status__c = 'Not Available';
                                }
                            }
                            
                            
                            
                            if(temp.get('linkedInUrl') != null){
                                String trimmedUrl = (String)temp.get('linkedInUrl');
                                if(trimmedUrl.length() >= 255){
                                    trimmedUrl = trimmedUrl.split('\\?')[0];
                                    if(trimmedUrl.length() >= 255){
                                        trimmedUrl = trimmedUrl.subString(0,254);
                                    }
                                }
                                modi.modigie__LinkedIn_Url_Get_Mobile_Number__c = trimmedUrl;
                                modi.modigie__LinkedIn_Url_Verify_Employer__c = trimmedUrl;
                                modi.modigie__Linkedin_URL__c = trimmedUrl;
                                modi.modigie__Validation_Date_Get_LinkedIn__c = System.now();
                                modi.modigie__Name_Get_LinkedIn__c  = (String)temp.get('name');
                                modi.modigie__Get_LinkedIn_Job_Status__c = (String)temp.get('status');
                                modi.modigie__Linkedin_Status__c = 'Validated';
                                
                                List<String> lstName = ((String)temp.get('name')).split('/');
                                modi.modigie__Linkedin_Job_Id__c = lstName[1];
                            }
                            if(temp.get('employmentEnd') != null){
                                Map<String,Object> employmentEnd = (Map<String,Object>)temp.get('employmentEnd');
                                
                                if(employmentEnd.get('month') != null){
                                    Map<String,Object> month = (Map<String,Object>)employmentEnd.get('month');
                                    if(month.get('localeAbbrevFormat') != null){
                                        modi.modigie__Employment_Ends_Get_Modigie__c = modi.modigie__Employment_Ends_Verify_Employer__c = (String)month.get('localeAbbrevFormat');
                                    }
                                    
                                }
                            }
                            else{
                                modi.modigie__Employment_Ends_Get_Modigie__c = modi.modigie__Employment_Ends_Verify_Employer__c = null;    
                            }
                            
                            if(temp.get('verifiedPhones') != null){
                                List<Object> verifiedPhones = (List<Object>)temp.get('verifiedPhones');
                                Integer count = 0;
                                if(verifiedPhones.isEmpty()){
                                    modi.modigie__Status__c = 'Not Available';	    
                                }
                                else{
                                    
                                    for(Object obj : verifiedPhones){
                                        Map<String,Object> verifiedPhone = (Map<String,Object>)obj;
                                        System.debug('--------------------->'+verifiedPhone);
                                        Map<String,Object> phoneNumber = (Map<String,Object>)verifiedPhone.get('phoneNumber'); 
                                        String valNum = '', phoneInServiceVal='',phoneTypeVal='', phoneToNameLinkageVal='',bestTimeToCallVal='',dayOfWeekDetailVal='';
                                        if(phoneNumber != null){
                                            if(phoneNumber.get('natlFormat') != null && phoneNumber.get('e164Format') != null && phoneNumber.get('intlFormat') != null){
                                                if(phoneNumber.get('intlFormat').toString().startsWith('+1 ')){
                                                    valNum = phoneNumber.get('natlFormat').toString();
                                                }
                                                else{
                                                    valNum = phoneNumber.get('intlFormat').toString();
                                                }
                                            }
                                            Boolean isValidated = false;
                                            
                                            
                                            if(verifiedPhone.get('phoneInService') != null){
                                                
                                                Map<String,Object> phoneInService = (Map<String,Object>)verifiedPhone.get('phoneInService');
                                                if(phoneInService.get('code') != null && phoneInService.get('code') != ''){
                                                    isValidated = true;
                                                    phoneInServiceVal = phoneInService.get('text').toString();
                                                    // modi.modigie__Line_Activity_Modigie_Validated_Number__c = phoneInService.get('text').toString();
                                                }    
                                            }
                                            if(verifiedPhone.get('phoneType') != null){
                                                
                                                String tempPhoneType = (String)verifiedPhone.get('phoneType');
                                                tempPhoneType = tempPhoneType.substring(0, 1).toUpperCase() + tempPhoneType.substring(1, tempPhoneType.length());  
                                                phoneTypeVal = tempPhoneType;
                                                isValidated=true;
                                                
                                            }
                                            
                                            if(verifiedPhone.get('callWindows') != null){
                                                
                                                
                                                List<Object> callWindows = (List<Object>)verifiedPhone.get('callWindows');
                                                
                                                
                                                if(callWindows.size() > 0){
                                                    isValidated=true;
                                                    Map<String,Object> sinCallWindow = (Map<String,Object>)callWindows[0];
                                                    
                                                    String str = sinCallWindow.get('code').toString();
                                                    String result = '';
                                                    if(str?.equalsIgnoreCase('0') == true){
                                                        result = 'NA'; 
                                                    }   
                                                    
                                                    else{
                                                        Integer hour;
                                                        
                                                        if(str?.equalsIgnoreCase('1') == true){
                                                            hour = 0;
                                                        }
                                                        else{
                                                            hour = Integer.valueOf(str) * 2 -2;
                                                        }
                                                        
                                                        Date myDate = date.newinstance(0, 0, 0);
                                                        Time myTime = Time.newInstance(hour, 0, 0, 0);
                                                        DateTime dtt = DateTime.newInstanceGmt(myDate, myTime);
                                                        
                                                        
                                                        
                                                        String strConvertedDate = dtt.format('HH', org.TimeZoneSidKey);  
                                                        
                                                        
                                                        hour = Integer.valueOf(strConvertedDate);
                                                        
                                                        
                                                        if(hour == 0){
                                                            str = '1';
                                                        }
                                                        
                                                        else{
                                                            str = String.valueOf((hour / 2) + 1);
                                                        }
                                                        
                                                        
                                                        if(bestTimeAllMap.get(str) != null){
                                                            result = bestTimeAllMap.get(str);
                                                        }else{
                                                            result = 'NA';
                                                        }
                                                    }   
                                                    
                                                    bestTimeToCallVal = result;
                                                    //modi.modigie__Best_Time_to_Call_Validated_Number__c = result;
                                                    //callWindows.remove(0);
                                                    dayOfWeekDetailVal = '';
                                                    //modi.modigie__Day_of_Week_Detail_Modigie_Val_Number__c = '';
                                                    for(Object callWindow : callWindows){
                                                        sinCallWindow = (Map<String,Object>)callWindow;
                                                        dayOfWeekDetailVal += sinCallWindow.get('code').toString() + ';';
                                                        //modi.modigie__Day_of_Week_Detail_Modigie_Val_Number__c += sinCallWindow.get('code').toString() + ';';
                                                    }   
                                                }
                                            }
                                            
                                            
                                            
                                            if(count == 0){
                                                
                                                if(valNum != ''){
                                                    modi.modigie__Mobile__c = valNum;
                                                    modigieValNumber = valNum;
                                                    alternateAvailable = 'No'; 
                                                    alternateAvailable2 = 'No';
                                                    e164ValNum = phoneNumber.get('e164Format').toString();
                                                }
                                                
                                                if(phoneInServiceVal != ''){
                                                    modi.modigie__Line_Activity_Modigie_Validated_Number__c = phoneInServiceVal;
                                                }
                                                if(phoneTypeVal != ''){
                                                    modi.modigie__Phone_Type_Modigie_Validated_Number__c	 = phoneTypeVal;
                                                    
                                                }
                                                if(phoneToNameLinkageVal != ''){
                                                    modi.modigie__Accuracy_Match_Modigie_Validated_Number__c = phoneToNameLinkageVal;
                                                }
                                                
                                                if(bestTimeToCallVal != ''){
                                                    modi.modigie__Best_Time_to_Call_Validated_Number__c = bestTimeToCallVal;
                                                }
                                                if(dayOfWeekDetailVal != ''){
                                                    modi.modigie__Day_of_Week_Detail_Modigie_Val_Number__c = dayOfWeekDetailVal;  
                                                }
                                                
                                                
                                                if(isValidated){
                                                    modi.modigie__Status__c = 'Validated';
                                                    
                                                    //modi.modigie__Validation_Date_Modigie_Val_Phone_Number__c = System.now();
                                                    //modi.modigie__Verified_Phone_Get_Phone_Insights_ValNum__c = modi.modigie__Mobile__c;
                                                    //modi.modigie__Phone_Intelligence_Status_Modigie_Number__c = 'Validated';
                                                }
                                                
                                                //lstSobj.add(new Lead(id = modi.modigie__Lead__c,modigie__Modigie_Verified_Number__c=phoneNumber.get('intlNumber').toString()));
                                            }
                                            else if(count == 1){
                                                if(valNum != ''){
                                                    modi.modigie__Mobile_2__c = valNum;
                                                    //con.modigie__Alternate_Mobile_Phone_Available__c = 'Yes';
                                                    alternateAvailable = 'Yes';
                                                }
                                                
                                                if(phoneInServiceVal != ''){
                                                    modi.modigie__Line_Activity_Alternate1__c = phoneInServiceVal;
                                                }
                                                if(phoneTypeVal != ''){
                                                    modi.modigie__Phone_Type_Alternate_Number1__c	 = phoneTypeVal;
                                                    
                                                }
                                                if(phoneToNameLinkageVal != ''){
                                                    modi.modigie__Accuracy_Match_Alternate_Number1__c = phoneToNameLinkageVal;
                                                }
                                                
                                                if(bestTimeToCallVal != ''){
                                                    modi.modigie__Best_Time_to_Call_Alternate_Number1__c = bestTimeToCallVal;
                                                }
                                                if(dayOfWeekDetailVal != ''){
                                                    modi.modigie__Day_of_Week_Detail_Alternate_Number1__c = dayOfWeekDetailVal;  
                                                }
                                            }
                                            
                                            else if(count == 2){
                                                
                                                if(valNum != ''){
                                                    modi.modigie__Mobile_3__c = valNum;
                                                    alternateAvailable2 = 'Yes';
                                                }
                                                
                                                if(phoneInServiceVal != ''){
                                                    modi.modigie__Line_Activity_Alternate2__c = phoneInServiceVal;
                                                }
                                                if(phoneTypeVal != ''){
                                                    modi.modigie__Phone_Type_Alternate_Number2__c	 = phoneTypeVal;
                                                    
                                                }
                                                if(phoneToNameLinkageVal != ''){
                                                    modi.modigie__Accuracy_Match_Alternate_Number2__c = phoneToNameLinkageVal;
                                                }
                                                
                                                if(bestTimeToCallVal != ''){
                                                    modi.modigie__Best_Time_to_Call_Alternate_Number2__c = bestTimeToCallVal;
                                                }
                                                if(dayOfWeekDetailVal != ''){
                                                    modi.modigie__Day_of_Week_Detail_Alternate_Number2__c = dayOfWeekDetailVal;  
                                                }
                                            }
                                            
                                            count++;
                                        } 
                                    }    
                                }
                            }
                            else{
                                modi.modigie__Status__c = 'Not Available';
                            }
                            
                            
                            if(temp.get('verifiedBusinessEmails') != null){
                                List<Object> verifiedBusinessEmails = (List<Object>)temp.get('verifiedBusinessEmails');
                                Integer count = 0;
                                if(!verifiedBusinessEmails.IsEmpty()){
                                    for(Object obj:verifiedBusinessEmails){
                                        Map<String,Object> verifiedBusinessEmail = (Map<String,Object>)obj;
                                        if(verifiedBusinessEmail.get('address') != null){
                                            string BusinessMail = (string) verifiedBusinessEmail.get('address');
                                            if(count == 0){
                                                if(BusinessMail != ''){
                                                    modi.modigie__Business_Email_1__c = BusinessMail;
                                                }
                                            }else if(count == 1){
                                                if(BusinessMail != ''){
                                                 	modi.modigie__Business_Email_2__c = BusinessMail;   
                                                }
                                            }else if(count == 2){
                                                if(BusinessMail != ''){
                                                	modi.modigie__Business_Email_3__c = BusinessMail;    
                                                }
                                            }else if(count == 3){
                                                if(BusinessMail != ''){
                                                    modi.modigie__Business_Email_4__c = BusinessMail;
                                                }
                                            }
                                            count++;
                                        }
                                    }
                                }
                            }
                            
                            if(temp.get('verifiedPrivateEmails') != null){
                                List<Object> verifiedPrivateEmails = (List<Object>)temp.get('verifiedPrivateEmails');
                                Integer count = 0;
                                if(!verifiedPrivateEmails.IsEmpty()){
                                    for(Object obj:verifiedPrivateEmails){
                                        Map<String,Object> verifiedPrivateEmail = (Map<String,Object>)obj;
                                        if(verifiedPrivateEmail.get('address') != null){
                                            string PrivateEmail = (string) verifiedPrivateEmail.get('address');
                                            if(count == 0){
                                                if(PrivateEmail != ''){
                                                 	modi.modigie__Private_Email_1__c = PrivateEmail;   
                                                }
                                            }else if(count == 1){
                                                if(PrivateEmail != ''){
                                                 	modi.modigie__Private_Email_2__c = PrivateEmail;   
                                                }
                                            }
                                            count++;
                                        }
                                    }
                                }
                            }
                            
                            if(temp.get('linkedInUrl') != null || modigieValNumber != '' || alternateAvailable != ''){
                                if(modi.modigie__Contact__c != null && !lstSobjId.contains(modi.modigie__Contact__c)){
                                    Contact con = new Contact(id = modi.modigie__Contact__c, modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey');
                                    //con.modigie__Modigie_Is_Active__c = true;
                                    if(temp.get('linkedInUrl') != null){
                                        con.modigie__linkedin_url__c = temp.get('linkedInUrl').toString();
                                    }
                                    if(modigieValNumber != ''){
                                        con.modigie__Modigie_Verified_Number__c = modigieValNumber;
                                        con.modigie__Modigie_Mobile_Number_Salesloft__c = e164ValNum;
                                    }
                                    if(alternateAvailable != ''){
                                        con.modigie__Alternate_Mobile_Phone_Available__c = alternateAvailable;
                                        con.modigie__Alternate_Mobile_Number1__c = modi.modigie__Mobile_2__c;
                                        if(alternateAvailable2 != ''){
                                            con.modigie__Alternate_Mobile_Number2__c = modi.modigie__Mobile_3__c;
                                        }
                                    }
                                    if(modi.modigie__Company_Name_Matches_Public_Records__c == 'No'){
                                        con.modigie__Modigie_Employment_Changed__c = true;
                                    }
                                    // lstSobj.add(con);
                                    lstContact.add(con);
                                    lstSobjId.add(con.Id);
                                }
                                else if(modi.modigie__Lead__c != null && !lstSobjId.contains(modi.modigie__Lead__c)){
                                    Lead ld = new Lead(id = modi.modigie__Lead__c, modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey');
                                    //ld.modigie__Modigie_Is_Active__c = true;
                                    if(temp.get('linkedInUrl') != null){
                                        ld.modigie__linkedin_url__c = temp.get('linkedInUrl').toString();
                                    }
                                    if(modigieValNumber != ''){
                                        ld.modigie__Modigie_Verified_Number__c = modigieValNumber;
                                        ld.modigie__Modigie_Mobile_Phone_Number_Salesloft__c = e164ValNum;
                                    }
                                    //Could we update everything from here only so, there's no need to update from Modigie Trigger
                                    if(alternateAvailable != ''){
                                        ld.modigie__Alternate_Mobile_Phone_Available__c = alternateAvailable;
                                        ld.modigie__Alternate_Mobile_Number_1__c = modi.modigie__Mobile_2__c;
                                        if(alternateAvailable2 != ''){
                                            ld.modigie__Alternate_Mobile_Number_2__c = modi.modigie__Mobile_3__c;
                                        }
                                    }
                                    if(modi.modigie__Company_Name_Matches_Public_Records__c == 'No'){
                                        ld.modigie__Modigie_Employment_Changed__c = true;
                                    }
                                    // lstSobj.add(ld);
                                    lstLead.add(ld);
                                    lstSobjId.add(ld.Id);
                                }
                                
                            }
                        }    
                        
                        else if(temp.get('status')?.toString()?.equalsIgnoreCase('unavailable') == true){
                            modi.modigie__Status__c = 'Unavailable';
                        } 
                        
                        String status = temp.get('status')+'';
                        status = status.substring(0, 1).toUpperCase() + status.substring(1, status.length());
                        modi.modigie__Name_Get_Mobile_Number__c = (String)temp.get('name');
                        
                        if(!modi.modigie__Get_Modigie_Job_Status__c?.equalsIgnoreCase(status) == true){
                            modi.modigie__Get_Modigie_Job_Status__c = status;
                            modi.modigie__Validation_Date_Get_Mobile_Number__c = System.now();
                            
                        }
                        
                        //Fixing Repeating Jobs Here
                        if(temp.get('status')?.toString()?.equalsIgnoreCase('done') == true && modi.modigie__Status__c.equalsIgnoreCase('In process')==true){
                            modi.modigie__Status__c = 'Not available';
                        }
                        
                    }


                    
                    modi.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                    if(modi.modigie__Campaign_Id_GetMobileNumber__c != null)
                    {
                        
                        if(!campaignOutForNotification.contains(modi.modigie__Campaign_Id_GetMobileNumber__c))
                        {
                            if(modi.modigie__Get_Modigie_Job_Status__c?.equalsIgnoreCase('done') == true){
                                campaignForNotification.add(modi.modigie__Campaign_Id_GetMobileNumber__c);
                                notificationReceiver.add(modi.modigie__Get_Mobile_Campaign_User__c);
                            }
                            else if(modi.modigie__Get_Modigie_Job_Status__c != 'done' && campaignForNotification.contains(modi.modigie__Campaign_Id_GetMobileNumber__c)){
                                campaignForNotification.remove(modi.modigie__Campaign_Id_GetMobileNumber__c);
                                campaignOutForNotification.add(modi.modigie__Campaign_Id_GetMobileNumber__c);
                            }
                        }
                    }
                    
                }
                if(FieldLevelSecurityCheck.canReadObject('modigie__Error_Log__c')&&
                   FieldLevelSecurityCheck.canUpdateObject('modigie__Error_Log__c')&&
                   FieldLevelSecurityCheck.canReadObject('Contact')&&
                   FieldLevelSecurityCheck.canUpdateObject('Contact')&&
                   FieldLevelSecurityCheck.canReadObject('Lead')&&
                   FieldLevelSecurityCheck.canUpdateObject('Lead')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Lead__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Lead__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Contact__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Contact__c')&&
                   
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Mobile__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Mobile__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Status__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Status__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validation_Key__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Validation_Key__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Get_Modigie_Job_Status__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Get_Modigie_Job_Status__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validation_Date_Get_Mobile_Number__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Validation_Date_Get_Mobile_Number__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__LinkedIn_Url_Get_Mobile_Number__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__LinkedIn_Url_Get_Mobile_Number__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Campaign_Id_GetMobileNumber__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Campaign_Id_GetMobileNumber__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Line_Activity_Modigie_Validated_Number__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Line_Activity_Modigie_Validated_Number__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Get_Mobile_Campaign_User__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Get_Mobile_Campaign_User__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Phone_Type_Modigie_Validated_Number__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Phone_Type_Modigie_Validated_Number__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Name_Get_Mobile_Number__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Name_Get_Mobile_Number__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Accuracy_Match_Modigie_Validated_Number__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Accuracy_Match_Modigie_Validated_Number__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Best_Time_to_Call_Validated_Number__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Best_Time_to_Call_Validated_Number__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Day_of_Week_Detail_Modigie_Val_Number__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Day_of_Week_Detail_Modigie_Val_Number__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Mobile_2__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Mobile_2__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Line_Activity_Alternate1__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Line_Activity_Alternate1__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Phone_Type_Alternate_Number1__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Phone_Type_Alternate_Number1__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Accuracy_Match_Alternate_Number1__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Accuracy_Match_Alternate_Number1__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Best_Time_to_Call_Alternate_Number1__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Best_Time_to_Call_Alternate_Number1__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Day_of_Week_Detail_Alternate_Number1__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Day_of_Week_Detail_Alternate_Number1__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Mobile_3__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Mobile_3__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Line_Activity_Alternate2__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Line_Activity_Alternate2__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Phone_Type_Alternate_Number2__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Phone_Type_Alternate_Number2__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Accuracy_Match_Alternate_Number2__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Accuracy_Match_Alternate_Number2__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Best_Time_to_Call_Alternate_Number2__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Best_Time_to_Call_Alternate_Number2__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Day_of_Week_Detail_Alternate_Number2__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Day_of_Week_Detail_Alternate_Number2__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Current_Employer_Get_Modigie__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Company_Name_Matches_Public_Records__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Current_Employer__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Current_Employer__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Current__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Current__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Current_Title__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Current_Title__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validation_Date_Verify_Employer__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Validation_Date_Verify_Employer__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Name_Verify_Employer__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Name_Verify_Employer__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validate_Employer_Status__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Validate_Employer_Status__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validate_Employer_Job_Id__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Validate_Employer_Job_Id__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validate_Employer_Job_Status__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Validate_Employer_Job_Status__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__LinkedIn_Url_Verify_Employer__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__LinkedIn_Url_Verify_Employer__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Linkedin_URL__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Linkedin_URL__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validation_Date_Get_LinkedIn__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Validation_Date_Get_LinkedIn__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Name_Get_LinkedIn__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Name_Get_LinkedIn__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Get_LinkedIn_Job_Status__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Get_LinkedIn_Job_Status__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Linkedin_Status__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Linkedin_Status__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Linkedin_Job_Id__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Linkedin_Job_Id__c')&&
                   
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Company_Name_Matches_Public_Records__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Current_Employer_Get_Modigie__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Current_Country_Get_Modigie__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Current_Country_Get_Modigie__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Current_Title_Get_Modigie__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Current_Title_Get_Modigie__c')&&
                   FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Company_Name_Matches_Records_Get_Modigie__c')&&
                   FieldLevelSecurityCheck.canUpdateField('modigie__Modigie__c','modigie__Company_Name_Matches_Records_Get_Modigie__c')&&
                   FieldLevelSecurityCheck.canReadField('Contact','modigie__Alternate_Mobile_Phone_Available__c')&&
                   FieldLevelSecurityCheck.canUpdateField('Contact','modigie__Alternate_Mobile_Phone_Available__c')&&
                   FieldLevelSecurityCheck.canReadField('Contact','modigie__Modigie_Verified_Number__c')&&
                   FieldLevelSecurityCheck.canUpdateField('Contact','modigie__Modigie_Verified_Number__c')&&
                   FieldLevelSecurityCheck.canReadField('Contact','modigie__Validation_Key__c')&&
                   FieldLevelSecurityCheck.canReadField('Contact','modigie__linkedin_url__c')&&
                   FieldLevelSecurityCheck.canReadField('Lead','modigie__linkedin_url__c')&&
                   FieldLevelSecurityCheck.canUpdateField('Contact','modigie__linkedin_url__c')&&
                   FieldLevelSecurityCheck.canUpdateField('Lead','modigie__linkedin_url__c')&&
                   FieldLevelSecurityCheck.canUpdateField('Contact','modigie__Validation_Key__c')&&
                   FieldLevelSecurityCheck.canReadField('Lead','modigie__Modigie_Verified_Number__c')&&
                   FieldLevelSecurityCheck.canUpdateField('Lead','modigie__Modigie_Verified_Number__c')&&
                   FieldLevelSecurityCheck.canReadField('Lead','modigie__Alternate_Mobile_Phone_Available__c')&&
                   FieldLevelSecurityCheck.canUpdateField('Lead','modigie__Alternate_Mobile_Phone_Available__c')&&
                   FieldLevelSecurityCheck.canReadField('Lead','modigie__Validation_Key__c')&&
                   FieldLevelSecurityCheck.canUpdateField('Lead','modigie__Validation_Key__c'))
                    
                {
                    String jobType = 'Get Modigie';
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
                        /*
                        //to call Tom
                        List<Id> tomListIds = new List<Id>();
                        for(Database.SaveResult sR : saveResults){
                            if(sR.isSuccess()) {
                                tomListIds.add(sR.getId());
                            }
                        }
                        InvocableTomAutomationCall.getRecordId(tomListIds);
                        */
                    }
                    if(!lstLead.isEmpty()){
                        //Database.update(lstLead,false);
                        Database.SaveResult[] saveResults = database.update(lstLead, false);
                        ErrorLogClass.createErrorLog(lstLead, 'Id', saveResults, jobType, jobSource);
                        /*
                        //to call Tom
                        List<Id> tomListIds = new List<Id>();
                        for(Database.SaveResult sR : saveResults){
                            if(sR.isSuccess()) {
                                tomListIds.add(sR.getId());
                            }
                        }
                        InvocableTomAutomationCall.getRecordId(tomListIds);
                        */
                    }
                    System.debug('lstObjEvent --> ' + lstObjEvent);
                    if(!lstObjEvent.isEmpty()){
                        EventBus.publish(lstObjEvent);     
                    }
                }
                else{
                    throw new GetModigieBatchClassException('You do not have permission to query lead, contact or modigie fields.');
                }
            }
            
        }
        catch(Exception e){
            //call here Error Email
            EmailServiceClass.sendErrorEmail('GetModigieBatchClass Error', e);
            System.debug('GetModigieBatchClass -->' + e.getLineNumber());
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
                        mail.setSubject('Modigie : GetModigieBatchClass Error');
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
        
        
        // call some utility to send email
        
        if(campaignForNotification.size() > 0){
            String notificationTitle = 'Get Modigie Mobile Service Result Campaign';
            String notificationBody = 'Modigie Data for Get Modigie Mobile Service has been returned.';
            
            NotificationServiceClass.sendNotification(notificationTitle, notificationBody, notificationReceiver, campaignForNotification);
            
        }
    } 
    //fljsskhf
    @TestVisible
    private static String getInternationalNumber(String phoneNumber){
        if(!phoneNumber.startsWith('+')){
            if(phoneNumber.startsWith('1'))
            {
                phoneNumber = '+' + phoneNumber;
            }
            else{
                phoneNumber = '+1' + phoneNumber;
            }
            
        }
        
        phoneNumber = phoneNumber.substring(0, 2) + ' ' + phoneNumber.substring(2, phoneNumber.length());
        return phoneNumber;
    }   
    private class GetModigieBatchClassException extends Exception{}
}