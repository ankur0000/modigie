global with sharing class UnresponsiveLeadBatchClass implements Database.Batchable<sObject>, Database.Stateful,Database.AllowsCallouts {
    
    // List<modigie__Modigie__c> modiList = new List<modigie__Modigie__c>();
    // List<modigie__Modigie_Credit__c> modiCredit = new List<modigie__Modigie_Credit__c>();
    // List<modigie__Modigie_Credit__c> modiCreditToUpdate = new List<modigie__Modigie_Credit__c>();
    
    // modigie__Modigie_Credentials__c modigieCredential = new modigie__Modigie_Credentials__c();
    // String accessToken;
    
    // List<Lead> leadList = new List<Lead>();
    
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        // modigie__Process_Builder_Switch__c pbs = [SELECT Id, modigie__Selected_Lead_Status__c FROM modigie__Process_Builder_Switch__c];
        // List<String> strList = (List<String>)JSON.deserializeStrict(pbs.modigie__Selected_Lead_Status__c, List<String>.class);
         return Database.getQueryLocator('SELECT Id, FirstName, LastName, Email, Company, MobilePhone, modigie__Modigie_Verified_Number__c, modigie__linkedin_url__c, LastModifiedDate FROM Lead WHERE LastModifiedDate < LAST_N_DAYS:9  WITH SECURITY_ENFORCED');
        
    }
    
    global void execute(Database.BatchableContext bc, List<Lead> scope){
        
        // List<User> userobj = new List<User>();
        
        // modiCredit = [SELECT Name, modigie__Purchased__c, modigie__Remaining__c, modigie__Validation_Key__c, modigie__Used__c, modigie__Date_Last_Synced__c FROM modigie__Modigie_Credit__c WITH SECURITY_ENFORCED LIMIT 1];
        
        
        // modigieCredential = [SELECT Id, modigie__Api_key__c, modigie__Credits_Account_Id__c, modigie__Private_key__c, modigie__Service_Account_Credentials__c FROM modigie__Modigie_Credentials__c WITH SECURITY_ENFORCED LIMIT 1];
        // accessToken = 'Bearer ' + jwtapex.get_access_token(modigieCredential.modigie__Service_Account_Credentials__c,'https://modigie-engage-backend-bqqdnyh5lq-uc.a.run.app',modigieCredential.modigie__Private_Key__c);
        
        // Map<String,Object> outerMap = new Map<String,Object>();
        
        // Integer requestId = Math.round((Math.random() * (9000) + 1000));
        // outerMap.put('id', requestId);
        // outerMap.put('creditsId', modigieCredential.modigie__Credits_Account_Id__c);
        
        // List <Map<String,Object>> lstCon = new List<Map<String,Object>>();
        
        // for(Lead leadrec : scope)
        // {
        //     Map<String,Object> sinCon = new Map <String,Object>();
            
        //     if(leadrec.FirstName != null){
        //         sinCon.put('firstName',leadrec.FirstName);    
        //     }
            
        //     if(leadrec.LastName != null){
        //         sinCon.put('lastName',leadrec.LastName);
        //     }
            
        //     if(leadrec.Company != null){
        //         sinCon.put('company',leadrec.Company);
        //     }
            
            
        //     List <String> lstMobileNumber = new List<String>();
            
        //     if( leadrec.modigie__Modigie_Verified_Number__c != null){
        //         String mobileNumber = (String)leadrec.modigie__Modigie_Verified_Number__c;
                
        //         if(!mobileNumber.startsWith('+')){
        //             if(mobileNumber.startsWith('1'))
        //             {
        //                 mobileNumber = '+' + mobileNumber;
        //             }
        //             else{
        //                 mobileNumber = '+1' + mobileNumber;
        //             }
                    
        //         }
                
        //         lstMobileNumber.add(mobileNumber);
        //     }
            
        //     if(leadrec.MobilePhone != null){
                
        //         String mobileNumber = (String)leadrec.MobilePhone;
                
        //         if(!mobileNumber.startsWith('+')){
        //             if(mobileNumber.startsWith('1'))
        //             {
        //                 mobileNumber = '+' + mobileNumber;
        //             }
        //             else{
        //                 mobileNumber = '+1' + mobileNumber;
        //             }
                    
        //         }
                
                
        //         lstMobileNumber.add(mobileNumber);
        //     }
            
        //     if(lstMobileNumber.size() > 0){
        //         sinCon.put('mobilePhones',lstMobileNumber);
        //     }
            
            
        //     if(leadrec.modigie__linkedin_url__c != null){
        //         sinCon.put('linkedInUrl',leadrec.modigie__linkedin_url__c);    
        //     }
            
            
        //     Map<String,String> customParaMap = new Map<String,String>();
            
        //     customParaMap.put('name', 'recordIdAndOrgId');
        //     customParaMap.put('value', leadrec.Id +  UserInfo.getOrganizationId());
            
        //     List<Map<String,String>> lstMap = new List<Map<String,String>>();
            
        //     lstMap.add(customParaMap);
        //     sinCon.put('customParameters',lstMap);
            
        //     if(leadrec.Email != null){
        //         sinCon.put('companyEmail', leadrec.Email);
        //     }
        //     lstCon.add(sinCon);
        // }
        
        // outerMap.put('contacts',lstCon);
        
        // Http http = new Http();
        // HttpRequest request = new HttpRequest();
        // request.setMethod('POST');
        // // request.setHeader('Content-Length', '4096');
        // // request.setHeader('accept', 'application/json');
        // request.setHeader('Content-Type', ' application/json');
        // request.setHeader('Authorization', accessToken);
        // request.setHeader('x-api-key', modigieCredential.modigie__API_Key__c);
        // request.setEndpoint('https://modigie-engage-gateway-bqqdnyh5lq-uc.a.run.app/api/v1/mobilePhoneJobs'); //Production Environment Endpoints
        // //request.setEndpoint('https://modigie-engage-gateway-kyaxv4ttua-uc.a.run.app/api/v1/mobilePhoneJobs?key=' + modigieCredential.modigie__API_Key__c); //Staging Environment Endpoints
        
        // request.setBody(JSON.serialize(outerMap));
        
        // request.setTimeout(120000);
        // HttpResponse response = http.send(request);
        // if(response.getStatusCode() == 202){
        //     String jsonResponse = response.getBody();
        //     Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(jsonResponse);
            
        //     String jobid = responseMap.get('id').toString();
            
        //     Map<String, String> securityMap = new Map<String, String>();
        //     securityMap.put('modigie__Jobid__c', 'modigie__Modigie__c');
        //     securityMap.put('modigie__Validation_Key__c', 'modigie__Modigie__c');
        //     securityMap.put('modigie__Status__c', 'modigie__Modigie__c');
        //     securityMap.put('modigie__Lead__c', 'modigie__Modigie__c');
        //     securityMap.put('modigie__Parent_Id__c', 'modigie__Modigie__c');
        //     securityMap.put('modigie__Validation_Date_Get_Mobile_Number__c', 'modigie__Modigie__c');
        //     securityMap.put('modigie__Get_Modigie_Job_Status__c', 'modigie__Modigie__c');
            
        //     Boolean check = FieldLevelSecurityCheck.checkSecurity(securityMap);
            
        //     for(Lead ld : scope){
        //         modigie__Modigie__c modiRec = new modigie__Modigie__c();
        //         if(ld.modigie__Modigie__r.size() > 0){
        //             modiRec.Id = ld.modigie__Modigie__r[0].Id;
        //         }
                
        //         modirec.modigie__Validation_Date_Get_Mobile_Number__c = System.now();
        //         modiRec.modigie__Jobid__c = jobid;
        //         modiRec.modigie__Lead__c = ld.id;
        //         modiRec.modigie__Parent_Id__c = ld.id;
                
        //         String statusGetModigie = responseMap.get('status').toString();
        //         statusGetModigie = statusGetModigie.substring(0, 1).toUpperCase() + statusGetModigie.substring(1, statusGetModigie.length());
                
        //         modiRec.modigie__Get_Modigie_Job_Status__c = statusGetModigie;
        //         modiRec.modigie__Status__c = 'In process';
        //         modiRec.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                
        //         modiList.add(modiRec);
        //     }
            
        //     if(check){
        //         upsert modiList;
        //     }
            
        // }
        // else{
        //     Map<String, String> errorLogSecurityMap = new Map<String, String>();
        //     errorLogSecurityMap.put('modigie__Description__c', 'modigie__Error_Log__c');
        //     errorLogSecurityMap.put('modigie__Error_Code__c', 'modigie__Error_Log__c');
        //     errorLogSecurityMap.put('modigie__Modigie_Service__c', 'modigie__Error_Log__c');
        //     errorLogSecurityMap.put('modigie__Validation_Key__c', 'modigie__Error_Log__c');
        //     Boolean check1 = FieldLevelSecurityCheck.checkSecurity(errorLogSecurityMap);
            
        //     modigie__Error_Log__c modigieErrorLog = new modigie__Error_Log__c();
        //     String jsonResponse = response.getBody();
        //     Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(jsonResponse);
        //     modigieErrorLog.modigie__Description__c = (String)responseMap.get('message');
        //     modigieErrorLog.modigie__Error_Code__c = response.getStatusCode();
        //     modigieErrorLog.modigie__Modigie_Service__c = 'Get Mobile Number';
        //     modigieErrorLog.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
            
        //     if(check1){
        //         insert modigieErrorLog;
        //     }
        // }
        
    }
    
    global void finish(Database.BatchableContext bc){
        // AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
        //                     JobItemsProcessed,
        //                     TotalJobItems, CreatedBy.Email
        //                     FROM AsyncApexJob
        //                     WHERE Id = :bc.getJobId() WITH SECURITY_ENFORCED];
        
    }    
}