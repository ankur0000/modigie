global with sharing class PhoneInsightsDataMaintainenceClass implements Database.Batchable<sObject>, Database.AllowsCallouts{
     List<SObject> lstsObj = new List<SObject>();
    // List<modigie__Modigie_Credit__c> modiCredit = new List<modigie__Modigie_Credit__c>();
    // List<modigie__Modigie__c> modiList = new List<modigie__Modigie__c>(); 

    // @Depricated
     public PhoneInsightsDataMaintainenceClass(List <SObject> lstsObj) { 
    //     this.lstsObj = lstsObj;
     }

    
    public List<SObject> start(Database.BatchableContext bc)
    {
        return lstsObj;
    }


    
    public void execute(Database.BatchableContext bc, List<SObject> scope) 
    {
      /*  try
        {
            List<User> userobj = new List<User>();
            
                modiCredit = [SELECT Name, modigie__Purchased__c, modigie__Remaining__c, modigie__Validation_Key__c, modigie__Used__c, modigie__Date_Last_Synced__c FROM modigie__Modigie_Credit__c  WITH SECURITY_ENFORCED LIMIT 1];
            

                        
            Set<Id> setOfKeysIds = new Set<Id>();
            for(SObject sco : scope){
                setOfKeysIds.add((Id)sco.get('Id')); 
            }
            
            Map<Id,Contact> conMap = new Map<Id,Contact>([SELECT id,Account.Name FROM Contact WHERE Id in :setOfKeysIds WITH SECURITY_ENFORCED]);

            Map<ID, Lead> leadMap = new Map<ID, Lead>();
            
            Map<String,Object> outerMap = new Map<String,Object>();
           
            outerMap.put('creditsId', tokenList[0].modigie__Credits_Account_Id__c);
           
            List <Map<String,Object>> lstCon = new List<Map<String,Object>>();
                for(SObject sObj : scope)
                {
                    String sobjectType = sObj.getSObjectType().getDescribe().getName();
                    //leadMap.put(leadrec.id, leadrec);
                    
                    Map<String,Object> sinCon = new Map <String,Object>();
                    
                    if(sObj.get('FirstName') != null){
                        sinCon.put('firstName',sObj.get('FirstName'));      
                    }
                    
                    if(sObj.get('LastName') != null){
                        sinCon.put('lastName',sObj.get('LastName'));
                    }
                    
                    
                    if(sobjectType == 'Contact'){
                        if(sObj.get('AccountId') != null){
                            Contact con = conMap.get((Id)sObj.get('Id'));
                            //String accId = sObj.get('AccountId').toString();
                            //List<Account> acc = [SELECT Name FROM Account WHERE Id = :accId WITH SECURITY_ENFORCED LIMIT 1]; 
                            sinCon.put('company', con.Account.Name);
                        }
                    }
    
                    else if(sobjectType == 'Lead'){
                        if(sObj.get('Company') != null){
                            sinCon.put('company',sObj.get('Company'));
                        }
                    }
                    
                    

                    if(sObj.get('modigie__linkedin_url__c') != null){
                        sinCon.put('linkedInUrl',sObj.get('modigie__linkedin_url__c'));
                    }
               
                    List <String> lstMobileNumber = new List<String>();

                if( sobj.get('modigie__Modigie_Verified_Number__c') != null){
                    String mobileNumber = (String)sObj.get('modigie__Modigie_Verified_Number__c');
    
                    if(!mobileNumber.startsWith('+')){
                        if(mobileNumber.startsWith('1'))
                        {
                            mobileNumber = '+' + mobileNumber;
                        }
                        else{
                            mobileNumber = '+1' + mobileNumber;
                        }

                    }
                   
                    lstMobileNumber.add(mobileNumber);
                    //sinCon.put('mobilePhone',lstSobj[0].get('modigie__Modigie_Verified_Number__c'));
                }
               
                if(sObj.get('MobilePhone') != null){
                   
                    String mobileNumber = (String)sObj.get('MobilePhone');
    
                    if(!mobileNumber.startsWith('+')){
                        if(mobileNumber.startsWith('1'))
                        {
                            mobileNumber = '+' + mobileNumber;
                        }
                        else{
                            mobileNumber = '+1' + mobileNumber;
                        }

                    }
                   
                   
                    lstMobileNumber.add(mobileNumber);
                    //sinCon.put('mobilePhone',lstSobj[0].get('MobilePhone')); 
                }
                
                if(lstMobileNumber.size() > 0){
                    sinCon.put('mobilePhones',lstMobileNumber);
                }

                if(sObj.get('Email') != null){
                    
                    sinCon.put('companyEmail', sObj.get('Email'));
                }
                

                    Map<String,String> customParaMap = new Map<String,String>();

                    customParaMap.put('name', 'recordIdAndOrgId');
                    customParaMap.put('value', sObj.get('Id') + UserInfo.getOrganizationId());

                    List<Map<String,String>> lstMap = new List<Map<String,String>>();

                    lstMap.add(customParaMap);
                    sinCon.put('customParameters',lstMap);
 
                    
                    
                    lstCon.add(sinCon);
                }
                
                outerMap.put('contacts',lstCon);
            
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                request.setMethod('POST');
                String accessToken = 'Bearer ' + jwtapex.get_access_token(tokenList[0].modigie__Service_Account_Credentials__c,'https://modigie-engage-backend-bqqdnyh5lq-uc.a.run.app',tokenList[0].modigie__Private_Key__c);
                request.setHeader('Content-Type', ' application/json');
                request.setHeader('Authorization', accessToken);
                //request.setEndpoint('https://modigie-val-pjcfvhz2qq-uc.a.run.app/api/val/v1/phoneIntelJobs');
                request.setEndpoint('https://modigie-engage-gateway-bqqdnyh5lq-uc.a.run.app/api/v1/phoneIntelJobs?key=' + tokenList[0].modigie__API_Key__c);
                
            request.setTimeout(60000);
            
            request.setBody(JSON.serialize(outerMap));
            
            //request.setEndpoint('https://script.google.com/macros/s/AKfycbwDks3QIefh2jzEWIjoiR2--gE_CwownQ9IQwdo28bwVoPl2jom/exec?user_email='+tokenList[0].modigie__User_Email__c+'&user_token='+tokenList[0].modigie__Token__c+'&jobid='+jobid+'&fname='+conRec.FirstName+'&lname='+conRec.LastName+'&email='+conRec.Email+'&company='+companyname+'&linkedin_url='+conRec.modigie__linkedin_url__c+'&para_1=&para_2=&para_3=&type=validation&job_type=new');
            //request.setTimeout(120000);
            HttpResponse response = http.send(request);
            if(response.getStatusCode() == 202){
                String jsonResponse = response.getBody();
                Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(jsonResponse);
                
                String jobid = responseMap.get('id').toString();
                
                
                List<modigie__Modigie__c> lstmodigie = [SELECT Id,modigie__Contact__c,modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Contact__c IN :setOfKeysIds OR modigie__Lead__c IN :setOfKeysIds WITH SECURITY_ENFORCED];  
                
                Map<Id,Id> modigieData = new Map<Id,Id>();
    
                for(modigie__Modigie__c modi : lstmodigie){
                    if(modi.modigie__Contact__c != null){
                        modigieData.put(modi.modigie__Contact__c,modi.Id);
                    }
                    else if(modi.modigie__Lead__c != null){
                        modigieData.put(modi.modigie__Lead__c, modi.Id);
                    }
                }
                
                Map<String, String> securityMap = new Map<String, String>();
                securityMap.put('modigie__Validation_Date_Mobile__c', 'modigie__Modigie__c');
                securityMap.put('modigie__Get_Phone_Intelligence_Job_Id__c', 'modigie__Modigie__c');
                securityMap.put('modigie__Lead__c', 'modigie__Modigie__c');
                securityMap.put('modigie__Contact__c', 'modigie__Modigie__c');
                securityMap.put('modigie__Parent_Id__c', 'modigie__Modigie__c');
                securityMap.put('modigie__Get_Phone_Intelligence_Job_Status__c', 'modigie__Modigie__c');
                securityMap.put('modigie__Phone_Intelligence_Status__c', 'modigie__Modigie__c');
                securityMap.put('modigie__Validation_Key__c', 'modigie__Modigie__c');
                
                Boolean check = FieldLevelSecurityCheck.checkSecurity(securityMap);
                
                for(SObject sObj : scope){
                    String sobjectType = sObj.getSObjectType().getDescribe().getName();
                    
                    modigie__Modigie__c modiRec = new modigie__Modigie__c();
                    if(modigieData.get((ID)sObj.get('Id')) != null){
                        modiRec.Id = modigieData.get((ID)sObj.get('Id'));
                    }
                    
                    modirec.modigie__Validation_Date_Mobile__c = System.now();
                    modiRec.modigie__Get_Phone_Intelligence_Job_Id__c	 = jobid;
                    
    
                    if(sobjectType == 'Contact'){
                        modiRec.modigie__Contact__c = (ID)sObj.get('Id');
                    }
                    
                    else if(sobjectType == 'Lead'){
                        modiRec.modigie__Lead__c = (ID)sObj.get('Id');
                    }
                    
                    modiRec.modigie__Parent_Id__c = (String)sObj.get('Id');
                    
                    String statusGetModigie = responseMap.get('status').toString();
                    statusGetModigie = statusGetModigie.substring(0, 1).toUpperCase() + statusGetModigie.substring(1, statusGetModigie.length());
                    
                    modiRec.modigie__Get_Phone_Intelligence_Job_Status__c = statusGetModigie;
                    modiRec.modigie__Phone_Intelligence_Status__c = 'In process';
                    modiRec.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                    
                    modiList.add(modiRec);
                }
                    
                if(check){
                    upsert modiList;
                }
            }
            else{
                Map<String, String> errorLogSecurityMap = new Map<String, String>();
                errorLogSecurityMap.put('modigie__Description__c', 'modigie__Error_Log__c');
                errorLogSecurityMap.put('modigie__Error_Code__c', 'modigie__Error_Log__c');
                errorLogSecurityMap.put('modigie__Modigie_Service__c', 'modigie__Error_Log__c');
                errorLogSecurityMap.put('modigie__Validation_Key__c', 'modigie__Error_Log__c');
                Boolean check1 = FieldLevelSecurityCheck.checkSecurity(errorLogSecurityMap);
                
                modigie__Error_Log__c modigieErrorLog = new modigie__Error_Log__c();
                String jsonResponse = response.getBody();
                Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(jsonResponse);
                modigieErrorLog.modigie__Description__c = (String)responseMap.get('message');
                modigieErrorLog.modigie__Error_Code__c = response.getStatusCode();
                modigieErrorLog.modigie__Modigie_Service__c = 'Get Phone Insights';
                modigieErrorLog.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
                
                if(check1){
                    insert modigieErrorLog;
                }
            }

            
        }
        catch(Exception e)
        {
        }  
        */
    }

    
    public void finish(Database.BatchableContext bc){

    }
}