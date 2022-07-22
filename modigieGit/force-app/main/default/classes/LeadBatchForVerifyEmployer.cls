public with sharing class LeadBatchForVerifyEmployer implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful
{
//     List<modigie__Modigie__c> modiList = new List<modigie__Modigie__c>();
//     List<modigie__Modigie_Credit__c> modiCredit = new List<modigie__Modigie_Credit__c>();
//     List<modigie__Modigie_Credit__c> modiCreditToUpdate = new List<modigie__Modigie_Credit__c>();

//     modigie__Modigie_Credentials__c modigieCredential = new modigie__Modigie_Credentials__c();
//     String accessToken; 
//     List<Lead> leadList = new List<Lead>();
    
//     public LeadBatchForVerifyEmployer(List<Lead> lList)
//     {
//         try{
//             modigieCredential = [SELECT Id, modigie__Api_key__c, modigie__Credits_Account_Id__c, modigie__Private_key__c, modigie__Service_Account_Credentials__c FROM modigie__Modigie_Credentials__c WITH SECURITY_ENFORCED LIMIT 1];
//             accessToken = 'Bearer ' + jwtapex.get_access_token(modigieCredential.modigie__Service_Account_Credentials__c,'https://modigie-engage-backend-bqqdnyh5lq-uc.a.run.app',modigieCredential.modigie__Private_Key__c);
//         leadList = lList;
//         }
//         catch(Exception e){
             
//         }
        
//     }



    public List<Lead> start(Database.BatchableContext bc)
    {
        return null;
    }
    
    public void execute(Database.BatchableContext bc, List<Lead> scope) 
    {
        // try
        // {
        //     List<User> userobj = new List<User>();
            
        //         modiCredit = [SELECT Name, modigie__Purchased__c, modigie__Remaining__c, modigie__Validation_Key__c, modigie__Used__c, modigie__Date_Last_Synced__c FROM modigie__Modigie_Credit__c WITH SECURITY_ENFORCED LIMIT 1];
            
            
            
            

        //     Map<String,Object> outerMap = new Map<String,Object>();
            
        //     Integer requestId = Math.round((Math.random() * (9000) + 1000));
        //     outerMap.put('id', requestId);
        //     outerMap.put('creditsId', modigieCredential.modigie__Credits_Account_Id__c);
        //     //outerMap.put('creditsId', 'IB31VDkwiAnKpnK3HL4W');
            
        //     List <Map<String,Object>> lstCon = new List<Map<String,Object>>();

        //         for(Lead leadrec : scope)
        //         {
        //             //leadMap.put(leadrec.id, leadrec);
                    
        //             Map<String,Object> sinCon = new Map <String,Object>();
                    
        //             if(leadrec.FirstName != null){
        //                 sinCon.put('firstName',leadrec.FirstName);    
        //             }
                    
        //             if(leadrec.LastName != null){
        //                 sinCon.put('lastName',leadrec.LastName);
        //             }
                    
        //             if(leadrec.Company != null){
        //                 sinCon.put('company',leadrec.Company);
        //             }
                    
                    
        //             if(leadrec.MobilePhone != null){
        //                 sinCon.put('mobilePhone',leadrec.MobilePhone);
        //             }
                    
        //             if(leadrec.modigie__linkedin_url__c != null){
        //                 sinCon.put('linkedInUrl',leadrec.modigie__linkedin_url__c);    
        //             }
        //             Map<String,String> customParaMap = new Map<String,String>();

        //             customParaMap.put('name', 'recordIdAndOrgId');
        //             customParaMap.put('value', leadrec.Id + UserInfo.getOrganizationId());

        //             List<Map<String,String>> lstMap = new List<Map<String,String>>();

        //             lstMap.add(customParaMap);
        //             sinCon.put('customParameters',lstMap);
                    
        //            // sinCon.put('custom1',leadrec.Id);
        //            if(leadrec.email != null){ 
        //            sinCon.put('companyEmail', leadrec.Email);
        //            }
        //             lstCon.add(sinCon);
        //         }
                
        //         outerMap.put('contacts',lstCon);
                
            
            
        //         Http http = new Http();
        //         HttpRequest request = new HttpRequest();
        //         request.setMethod('POST');
        //         // request.setHeader('Content-Length', '4096');
        //         // request.setHeader('accept', 'application/json');
        //         request.setHeader('Content-Type', ' application/json');
        //         request.setHeader('Authorization', accessToken);
        //         request.setHeader('x-api-key', modigieCredential.modigie__API_Key__c);
        //         request.setEndpoint('https://modigie-engage-gateway-bqqdnyh5lq-uc.a.run.app/api/v1/verifyEmployerJobs'); //Production Environment Endpoints
        //         //request.setEndpoint('https://modigie-engage-gateway-kyaxv4ttua-uc.a.run.app/api/v1/verifyEmployerJobs?key=' + modigieCredential.modigie__API_Key__c); //Staging Environment Endpoints
                
            
        //     request.setBody(JSON.serialize(outerMap));
            
        //     request.setTimeout(120000);
        //     HttpResponse response = http.send(request);
        //     if(response.getStatusCode() == 202){
        //         String jsonResponse = response.getBody();
        //         Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(jsonResponse);
                
        //         String jobid = responseMap.get('id').toString();
                
        //         Map<String, String> securityMap = new Map<String, String>();
        //         securityMap.put('modigie__Validation_Date_Verify_Employer__c', 'modigie__Modigie__c');
        //         securityMap.put('modigie__Validate_Employer_Job_Id__c', 'modigie__Modigie__c');
        //         securityMap.put('modigie__Lead__c', 'modigie__Modigie__c');
        //         securityMap.put('modigie__Parent_Id__c', 'modigie__Modigie__c');
        //         securityMap.put('modigie__Validate_Employer_Job_Status__c', 'modigie__Modigie__c');
        //         securityMap.put('modigie__Validate_Employer_Status__c', 'modigie__Modigie__c');
        //         securityMap.put('modigie__Validation_Key__c', 'modigie__Modigie__c');
                
        //         Boolean check = FieldLevelSecurityCheck.checkSecurity(securityMap);
                
        //         for(Lead ld : scope){
        //             modigie__Modigie__c modiRec = new modigie__Modigie__c();
        //             if(ld.modigie__Modigie__r.size() > 0){
        //                 modiRec.Id = ld.modigie__Modigie__r[0].Id;
        //             }
                    
        //             modirec.modigie__Validation_Date_Verify_Employer__c = System.now();
        //             modiRec.modigie__Validate_Employer_Job_Id__c = jobid;
        //             modiRec.modigie__Lead__c = ld.id;
        //             modiRec.modigie__Parent_Id__c = ld.id;
                    
        //             String statusGetModigie = responseMap.get('status').toString();
        //             statusGetModigie = statusGetModigie.substring(0, 1).toUpperCase() + statusGetModigie.substring(1, statusGetModigie.length());
                    
        //             modiRec.modigie__Validate_Employer_Job_Status__c = statusGetModigie;
        //             modiRec.modigie__Validate_Employer_Status__c = 'In process';
        //             modiRec.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                    
        //             modiList.add(modiRec);
        //         }
        //         if(check){
        //             upsert modiList;
        //         }
                
        //     }
        //     else{
        //         Map<String, String> errorlogSecurityMap = new Map<String, String>();
        //         errorLogSecurityMap.put('modigie__Description__c', 'modigie__Error_Log__c');
        //         errorLogSecurityMap.put('modigie__Error_Code__c', 'modigie__Error_Log__c');
        //         errorLogSecurityMap.put('modigie__Modigie_Service__c', 'modigie__Error_Log__c');
        //         errorLogSecurityMap.put('modigie__Validation_Key__c', 'modigie__Error_Log__c');
                
        //         Boolean check = FieldLevelSecurityCheck.checkSecurity(errorlogSecurityMap);
        //         modigie__Error_Log__c errorLog = new modigie__Error_Log__c(modigie__Description__c = 'Invalid Input or Object.');
        //         if(check){
        //             insert errorLog;
        //         }
        //     }
        // }
        // catch(Exception e)
        // {
            
        // }  
    }
    
    public void finish(Database.BatchableContext bc)
    {
        // System.Queueable job = new CreditInfoQueableClass();
        // System.enqueueJob(job);
    }
}