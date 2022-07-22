public with sharing class LeadBatchForGetPhoneIntelligence implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
    // List<modigie__Modigie__c> modiList = new List<modigie__Modigie__c>();
    // List<modigie__Modigie_Credit__c> modiCredit = new List<modigie__Modigie_Credit__c>();
    // List<modigie__Modigie_Credit__c> modiCreditToUpdate = new List<modigie__Modigie_Credit__c>();

    // modigie__Modigie_Credentials__c modigieCredential = new modigie__Modigie_Credentials__c();
    // String accessToken;
    // List<Lead> leadList = new List<Lead>();

    // public LeadBatchForGetPhoneIntelligence(List<Lead> lList) {
    //     modigieCredential = [SELECT Id, modigie__Api_key__c, modigie__Credits_Account_Id__c, modigie__Private_key__c, modigie__Service_Account_Credentials__c FROM modigie__Modigie_Credentials__c LIMIT 1];
    //     accessToken = 'Bearer ' + jwtapex.get_access_token(modigieCredential.modigie__Service_Account_Credentials__c,'https://modigie-engage-backend-bqqdnyh5lq-uc.a.run.app',modigieCredential.modigie__Private_Key__c);
    //     leadList = lList;
    // }


    public List<Lead> start(Database.BatchableContext bc)
    {
        return null;
    }
    public void execute(Database.BatchableContext bc, List<Lead> scope) 
    {
        // try
        // {
        //     List<User> userobj = new List<User>();
            
        //         modiCredit = [SELECT Name, modigie__Purchased__c, modigie__Remaining__c, modigie__Validation_Key__c, modigie__Used__c, modigie__Date_Last_Synced__c FROM modigie__Modigie_Credit__c  WITH SECURITY_ENFORCED LIMIT 1];
            
            
            
        //     Map<ID, Lead> leadMap = new Map<ID, Lead>();
            
        //     Map<String,Object> outerMap = new Map<String,Object>();
            
        //     Integer requestId = Math.round((Math.random() * (9000) + 1000));
        //         outerMap.put('id', requestId);
        //         outerMap.put('creditsId', modigieCredential.modigie__Credits_Account_Id__c);
            
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
                    
                    
        //             if(leadrec.email != null){
        //                 sinCon.put('otherEmails',new List <String>{leadrec.email});    
        //             }
                    
                    

        //             List <String> lstMobileNumber = new List<String>();

        //         if( leadrec.modigie__Modigie_Verified_Number__c != null){
        //             String mobileNumber = (String)leadrec.modigie__Modigie_Verified_Number__c;
    
        //             if(!mobileNumber.startsWith('+')){
        //                 if(mobileNumber.startsWith('1'))
        //                 {
        //                     mobileNumber = '+' + mobileNumber;
        //                 }
        //                 else{
        //                     mobileNumber = '+1' + mobileNumber;
        //                 }

        //             }
                   
        //             lstMobileNumber.add(mobileNumber);
        //             //sinCon.put('mobilePhone',lstSobj[0].get('modigie__Modigie_Verified_Number__c'));
        //         }
               
        //         if(leadrec.MobilePhone != null){
                   
        //             String mobileNumber = (String)leadrec.MobilePhone;
    
        //             if(!mobileNumber.startsWith('+')){
        //                 if(mobileNumber.startsWith('1'))
        //                 {
        //                     mobileNumber = '+' + mobileNumber;
        //                 }
        //                 else{
        //                     mobileNumber = '+1' + mobileNumber;
        //                 }

        //             }
                   
                   
        //             lstMobileNumber.add(mobileNumber);
        //             //sinCon.put('mobilePhone',lstSobj[0].get('MobilePhone'));
        //         }
                
        //         if(lstMobileNumber.size() > 0){
        //             sinCon.put('mobilePhones',lstMobileNumber);
        //         }

        //             Map<String,String> customParaMap = new Map<String,String>();

        //             customParaMap.put('name', 'recordIdAndOrgId');
        //             customParaMap.put('value', leadrec.Id + UserInfo.getOrganizationId());

        //             List<Map<String,String>> lstMap = new List<Map<String,String>>();

        //             lstMap.add(customParaMap);
        //             sinCon.put('customParameters',lstMap);

        //             sinCon.put('companyEmail', leadrec.Email);
                    
        //             lstCon.add(sinCon);
        //         }
                
        //         outerMap.put('contacts',lstCon);
            
        //         Http http = new Http();
        //         HttpRequest request = new HttpRequest();
        //         request.setMethod('POST');
        //         // request.setHeader('Content-Length', '4096');
        //         //request.setHeader('accept', 'application/json');
        //         request.setHeader('Content-Type', ' application/json');
        //         request.setHeader('Authorization', accessToken);
        //         request.setHeader('x-api-key', modigieCredential.modigie__API_Key__c);
        //         request.setEndpoint('https://modigie-engage-gateway-bqqdnyh5lq-uc.a.run.app/api/v1/phoneIntelJobs');
                
        //         //request.setEndpoint('https://modigie-val-pjcfvhz2qq-uc.a.run.app/api/val/v1/phoneIntelJobs');
            
        //     request.setBody(JSON.serialize(outerMap));
            
        //     //request.setEndpoint('https://script.google.com/macros/s/AKfycbwDks3QIefh2jzEWIjoiR2--gE_CwownQ9IQwdo28bwVoPl2jom/exec?user_email='+tokenList[0].modigie__User_Email__c+'&user_token='+tokenList[0].modigie__Token__c+'&jobid='+jobid+'&fname='+conRec.FirstName+'&lname='+conRec.LastName+'&email='+conRec.Email+'&company='+companyname+'&linkedin_url='+conRec.modigie__linkedin_url__c+'&para_1=&para_2=&para_3=&type=validation&job_type=new');
        //     request.setTimeout(120000);
        //     HttpResponse response = http.send(request);
            
        //     String jsonResponse = response.getBody();
        //     Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(jsonResponse);
            
        //     String jobid = responseMap.get('id').toString();
        //     Map<String, String> securityMap = new Map<String, String>();
        //     securityMap.put('modigie__Validation_Date_Mobile__c', 'modigie__Modigie__c');
        //     securityMap.put('modigie__Get_Phone_Intelligence_Job_Id__c', 'modigie__Modigie__c');
        //     securityMap.put('modigie__Lead__c', 'modigie__Modigie__c');
        //     securityMap.put('modigie__Parent_Id__c', 'modigie__Modigie__c');
        //     securityMap.put('modigie__Get_Phone_Intelligence_Job_Status__c', 'modigie__Modigie__c');
        //     securityMap.put('modigie__Phone_Intelligence_Status__c', 'modigie__Modigie__c');
        //     securityMap.put('modigie__Validation_Key__c', 'modigie__Modigie__c');
            
        //     Boolean check = FieldLevelSecurityCheck.checkSecurity(securityMap);
            
        //         for(Lead ld : scope){
        //             modigie__Modigie__c modiRec = new modigie__Modigie__c();
        //             if(ld.modigie__Modigie__r.size() > 0){
        //                 modiRec.Id = ld.modigie__Modigie__r[0].Id;
        //             }
                    
        //             modirec.modigie__Validation_Date_Mobile__c = System.now();
        //             modiRec.modigie__Get_Phone_Intelligence_Job_Id__c	 = jobid;
        //             modiRec.modigie__Lead__c = ld.id;
        //             modiRec.modigie__Parent_Id__c = ld.id;
                    
        //             String statusGetModigie = responseMap.get('status').toString();
        //             statusGetModigie = statusGetModigie.substring(0, 1).toUpperCase() + statusGetModigie.substring(1, statusGetModigie.length());
                    
        //             modiRec.modigie__Get_Phone_Intelligence_Job_Status__c = statusGetModigie;
        //             modiRec.modigie__Phone_Intelligence_Status__c = 'In process';
        //             modiRec.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                    
        //             modiList.add(modiRec);
        //         }
                
        //     if(check){
        //         upsert modiList;
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