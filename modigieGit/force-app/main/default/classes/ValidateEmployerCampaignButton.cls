public with sharing class ValidateEmployerCampaignButton 
{
   	@AuraEnabled
    public static String CampaignCallout(Id recid)
    {
        Map<String, Integer> camMem = new Map<String, Integer>(); 
        try
        {
            Integer recordsToProcess;
            Integer haveTotalRecordsToProcess;
            Integer validatedRecords;
            Integer recordsRunning;
            Integer invalidatedRecords;
            Integer notFulfill;
            Integer userFilled;
            Integer newRecordsToProcess; 
            
            List<CampaignMember> totalMembersList = new List<CampaignMember>();
            List<CampaignMember> contactList = new List<CampaignMember>();
            List<CampaignMember> leadList = new List<CampaignMember>();
            
            
            Map<String, String> securityMap = new Map<String, String>();
            Map<String, String> securityCampaignMap = new Map<String, String>();
            
            List<modigie__Modigie_Service_Account__mdt> tokenList = ModigieApiUtils.getServiceAccountDetails();

            
            if(tokenList.size() > 0)
            {
                
                totalMembersList = [SELECT ContactId, LeadId FROM CampaignMember WHERE CampaignId =: recid AND (ContactId !=null OR LeadId != null) WITH SECURITY_ENFORCED];
                
                securityCampaignMap.put('CampaignId', 'CampaignMember');
                securityCampaignMap.put('ContactId', 'CampaignMember');
                securityCampaignMap.put('LeadId', 'CampaignMember');
                securityCampaignMap.put('FirstName', 'CampaignMember'); 
                securityCampaignMap.put('LastName', 'CampaignMember');
                securityMap.put('AccountId', 'Contact');
                securityMap.put('FirstName', 'Contact');
                securityMap.put('modigie__linkedin_url__c', 'Contact');
                securityMap.put('Name', 'Account');
                securityMap.put('FirstName', 'Lead');
                securityMap.put('Company', 'Lead');
                securityMap.put('modigie__linkedin_url__c', 'Lead');
                securityMap.put('modigie__Contact__c', 'modigie__Modigie__c');
                securityMap.put('modigie__Lead__c', 'modigie__Modigie__c');
                securityMap.put('modigie__Validation_Date_Verify_Employer__c', 'modigie__Modigie__c'); 
                securityMap.put('modigie__Validate_Employer_Status__c', 'modigie__Modigie__c'); 
                
                Boolean check = FieldLevelSecurityCheck.checkSecurity(securityMap);
                Boolean checkMember = FieldLevelSecurityCheck.checkSecurityForRead(securityCampaignMap);
                
                // User does not have the required object permissions.
                   
                    validatedRecords =  [SELECT count() FROM CampaignMember WHERE CampaignId =: recid AND ContactId !=null  AND ContactId  IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c    = 'Validated') WITH SECURITY_ENFORCED];
                   
                    invalidatedRecords = [SELECT count() FROM CampaignMember WHERE CampaignId = :recId AND ContactId != null AND ContactId IN (SELECT modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c  ='Not Available') WITH SECURITY_ENFORCED];
                   
                    recordsRunning = [SELECT count() FROM CampaignMember WHERE CampaignId = :recId AND ContactId != null AND ContactId IN (SELECT modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c  = 'In process') WITH SECURITY_ENFORCED];
                   
                    notFulfill = [SELECT count() FROM CampaignMember WHERE CampaignId = :recId AND ContactId != null AND ContactId IN (SELECT Id FROM Contact WHERE Account.Name = null OR (modigie__linkedin_url__c  = null AND FirstName = null)) AND ContactId NOT IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c = 'In process' OR modigie__Validate_Employer_Status__c != 'Validated' OR modigie__Validate_Employer_Status__c != 'Not Available') WITH SECURITY_ENFORCED];
                   
                    recordsToProcess = [SELECT count() FROM CampaignMember WHERE CampaignId = :recId AND ContactId != null AND ContactId IN (SELECT Id FROM Contact WHERE  Account.Name != null AND (modigie__linkedin_url__c  != null OR FirstName != null)) AND ContactId NOT IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c = 'In process') WITH SECURITY_ENFORCED];
                    
                    newRecordsToProcess = [SELECT count() FROM CampaignMember WHERE CampaignId = :recId AND ContactId != null AND ContactId IN (SELECT Id FROM Contact WHERE  Account.Name != null AND (modigie__linkedin_url__c  != null OR FirstName != null)) AND ContactId NOT IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c = 'In process' OR modigie__Validate_Employer_Status__c = 'Validated' OR modigie__Validate_Employer_Status__c = 'Not Available') WITH SECURITY_ENFORCED];
                    
                   
                    validatedRecords +=  [SELECT count() FROM CampaignMember WHERE CampaignId =: recid AND LeadId !=null  AND LeadId  IN (Select modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c  = 'Validated') WITH SECURITY_ENFORCED];
                    
                    invalidatedRecords += [SELECT count() FROM CampaignMember WHERE CampaignId = :recId AND LeadId != null AND LeadId IN (SELECT modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c ='Not Available') WITH SECURITY_ENFORCED];

                    recordsRunning += [SELECT count() FROM CampaignMember WHERE CampaignId = :recId AND LeadId != null AND LeadId IN (SELECT modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c = 'In process') WITH SECURITY_ENFORCED];
                   
                    notFulfill += [SELECT count() FROM CampaignMember WHERE CampaignId = :recId AND LeadId != null AND LeadId IN (SELECT Id FROM Lead WHERE Company = null OR (modigie__linkedin_url__c = null AND FirstName = null)) AND LeadId NOT IN (Select modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c = 'In process' OR modigie__Validate_Employer_Status__c = 'Validated' OR modigie__Validate_Employer_Status__c = 'Not Available') WITH SECURITY_ENFORCED]; 

                    recordsToProcess += [SELECT count() FROM CampaignMember WHERE CampaignId = :recId AND LeadId != null AND LeadId IN (SELECT Id FROM Lead WHERE company != null AND (modigie__linkedin_url__c != null OR FirstName != null)) AND LeadId NOT IN (Select modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c = 'In process') WITH SECURITY_ENFORCED];

                    newRecordsToProcess += [SELECT count() FROM CampaignMember WHERE CampaignId = :recId AND LeadId != null AND LeadId IN (SELECT Id FROM Lead WHERE company != null AND (modigie__linkedin_url__c != null OR FirstName != null)) AND LeadId NOT IN (Select modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c = 'In process' OR modigie__Validate_Employer_Status__c = 'Validated' OR modigie__Validate_Employer_Status__c = 'Not Available') WITH SECURITY_ENFORCED];
                    
                    
                    
                    //haveTotalRecordsToProcess = [SELECT count() FROM CampaignMember WHERE CampaignId = :recId AND ContactId != null AND ContactId IN (SELECT Id FROM Contact WHERE  Account.Name != null AND (modigie__linkedin_url__c  != null OR FirstName != null)) AND ContactId NOT IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c = 'In Process') WITH SECURITY_ENFORCED];
                   
                    //haveTotalRecordsToProcess += [SELECT count() FROM CampaignMember WHERE CampaignId = :recId AND LeadId != null AND LeadId IN (SELECT Id FROM Lead WHERE company != null AND (modigie__linkedin_url__c != null OR FirstName != null)) AND LeadId NOT IN (Select modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c = 'In Process') WITH SECURITY_ENFORCED];
                    
                    
                    
                    

                    if(recordsToProcess > 0){
                        camMem.put('TokenExist', 1);
                    }

                    // else if (haveTotalRecordsToProcess > 0)
                    // {
                    //     camMem.put('TokenExistAllRecords', 2);
                    // }
                    else{
                        camMem.put('TokenExist', -3);
                    }

                    
                    
                    camMem.put('totalSize', totalMembersList.size());
                    camMem.put('alreadyValidated', validatedRecords);
                    camMem.put('recordsRunning', recordsRunning);
                    camMem.put('recordsToProcess', recordsToProcess);
                    camMem.put('invalidatedRecords', invalidatedRecords);
                    camMem.put('notFulfill', notFulfill);
                    camMem.put('newRecordsToProcess',newRecordsToProcess);
                    return JSON.serialize(camMem);
                    
            }
            else{
                throw new ValidateEmployerCampaignButtonException('You are not an authorised user.');   
            }
            
        }
        catch(LimitException e)
        {
            throw new ValidateEmployerCampaignButtonException('You cannot process more than 50,000 records.');
        }
        catch(System.QueryException e){
            throw new ValidateEmployerCampaignButtonException('You do not have permission to query lead, contact or modigie fields.');
        }
        catch(Exception e)
        {
            throw new ValidateEmployerCampaignButtonException(e.getMessage());
        }
    }
    
    
/************************************************************************ 
*  @authors Tarun Gyanchandani
*  @date    6 Feb 2020
*  @name   campaignCalloutForNewMembers 
*  @description Method to Syncronization of new Campaign records.
*  @Parameters Campaign Id
***********************************************************************/     
    @AuraEnabled
    public static List<Id> campaignCalloutForNewMembers(Id recid)
    {
        try
        {
            
            List<CampaignMember> contactList = new List<CampaignMember>();
            List<CampaignMember> leadList = new List<CampaignMember>();
            Map<String, String> securityMap = new Map<String, String>();
            Map<String, String> securityCampaignMap = new Map<String, String>();
            
            securityCampaignMap.put('CampaignId', 'CampaignMember');
            securityCampaignMap.put('ContactId', 'CampaignMember');
            securityCampaignMap.put('LeadId', 'CampaignMember');
           
            securityMap.put('FirstName', 'Contact');
            securityMap.put('LastName', 'Contact');
            securityMap.put('Email', 'Contact');
            securityMap.put('MobilePhone', 'Contact');
            securityMap.put('modigie__linkedin_url__c', 'Contact');
            securityMap.put('Name', 'Account');
            securityMap.put('FirstName', 'Lead');
            securityMap.put('LastName', 'Lead');
            securityMap.put('Email', 'Lead');
            securityMap.put('Company', 'Lead');
            securityMap.put('MobilePhone', 'Lead');
            securityMap.put('modigie__linkedin_url__c', 'Lead');
            securityMap.put('modigie__Contact__c', 'modigie__Modigie__c');
            securityMap.put('modigie__Lead__c', 'modigie__Modigie__c'); 
            securityMap.put('modigie__Status__c', 'modigie__Modigie__c');
            securityMap.put('modigie__Validate_Employer_Status__c', 'modigie__Modigie__c');
            
            Boolean check = FieldLevelSecurityCheck.checkSecurity(securityMap);
            Boolean checkMember = FieldLevelSecurityCheck.checkSecurityForRead(securityCampaignMap);
            if(check && checkMember){
                contactList = [SELECT ContactId,FirstName,LastName FROM CampaignMember WHERE CampaignId = :recId AND ContactId != null AND ContactId IN (SELECT Id FROM Contact WHERE  Account.Name != null AND (modigie__linkedin_url__c  != null OR FirstName != null)) AND ContactId NOT IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c = 'In process' OR modigie__Validate_Employer_Status__c = 'Validated' OR modigie__Validate_Employer_Status__c = 'Not Available') WITH SECURITY_ENFORCED];
                leadList = [SELECT LeadId,FirstName,LastName FROM CampaignMember WHERE CampaignId = :recId AND LeadId != null AND LeadId IN (SELECT Id FROM Lead WHERE company != null AND (modigie__linkedin_url__c != null AND FirstName != null)) AND LeadId NOT IN (Select modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c = 'In process' OR modigie__Validate_Employer_Status__c = 'Validated' OR modigie__Validate_Employer_Status__c = 'Not Available') WITH SECURITY_ENFORCED];
                
                
                Set<Id> setOfContactIds = new Set<Id>();
                
                for(CampaignMember cm : contactList)
                {
                    setOfContactIds.add(cm.ContactId);
                }
                
                Set<ID> setOfLeadIds = new Set<ID>();
                for(CampaignMember cm : leadList)
                {
                    setOfLeadIds.add(cm.LeadId); 
                }
                
                List<Contact> conLst = [SELECT Id, Account.Name,modigie__Company_Email__c, Account.BillingStreet,Account.BillingPostalCode,Account.BillingCity,Account.BillingState,Account.BillingCountry,modigie__linkedin_url__c,FirstName, LastName, Email, modigie__Company_URL__c,MobilePhone,(SELECT id FROM modigie__Modigie__r) FROM Contact Where Id IN :setOfContactIds WITH SECURITY_ENFORCED];
                List<Lead> ldLst = [SELECT Id, FirstName, LastName, modigie__Company_Email__c,Email, Company, modigie__Company_URL__c, modigie__linkedin_url__c,MobilePhone,(SELECT id FROM modigie__Modigie__r) FROM Lead WHERE Id In :setOfLeadIds WITH SECURITY_ENFORCED];
                


                List<sObject> sobj1 = [SELECT FirstName,LastName,AccountId,modigie__Modigie_Verified_Number__c,MobilePhone,Email,modigie__linkedin_url__c FROM Contact WHERE Id IN (SELECT ContactId FROM CampaignMember WHERE CampaignId = :recid) AND (modigie__linkedin_url__c != null OR FirstName != null) AND Account.Name != null AND Id NOT IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c != 'Not started' AND modigie__Validate_Employer_Status__c != 'Unavailable') WITH SECURITY_ENFORCED];
                List<sObject> sobj2 = [SELECT FirstName,LastName,Company,modigie__Modigie_Verified_Number__c,MobilePhone,Email,modigie__linkedin_url__c FROM Lead WHERE Id IN (SELECT LeadId FROM CampaignMember WHERE CampaignId = :recid) AND (modigie__linkedin_url__c != null  OR FirstName != null )AND  Company != null AND Id NOT IN (Select modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c != 'Not started' AND modigie__Validate_Employer_Status__c != 'Unavailable') WITH SECURITY_ENFORCED];

                List<sObject> lstSobj = new List<sObject>();
                lstSobj.addAll(sobj1);
                lstSobj.addAll(sobj2);



                List<Id> lstBatchJobsIds = new List<Id>();

                String userId = UserInfo.getUserId();
                
                List<modigie__Process_Builder_Switch__c> lstPbs = [SELECT Id, modigie__Limit_User_for_Modigie_Ad_hoc__c FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED LIMIT 1];
                if(lstPbs.isEmpty()){
                    throw new ValidateEmployerCampaignButtonException('No settings found ! Please ask Modigie Admin to configure the user limits settings.');
                }
                else if(lstPbs[0].modigie__Limit_User_for_Modigie_Ad_hoc__c == null){
                    throw new ValidateEmployerCampaignButtonException('No settings found ! Please ask Modigie Admin to configure the user limits settings.');
                }
    
                if(lstPbs[0].modigie__Limit_User_for_Modigie_Ad_hoc__c){

                List<modigie__Daily_usage_modigie_callouts_by_users__c> modigieUsage = [SELECT modigie__User_Id__c, modigie__Number_of_modigie_callouts_in_a_day__c FROM modigie__Daily_usage_modigie_callouts_by_users__c WHERE modigie__User_Id__c = :userId WITH SECURITY_ENFORCED LIMIT 1];
                
                Integer dailyCallout = 0;
    
                if(modigieUsage.size() > 0){
                    dailyCallout = (Integer)modigieUsage[0].modigie__Number_of_modigie_callouts_in_a_day__c;
                }
    
                Map<Id,Integer> userToLimitsMap = LimitsMapClass.getProfileUserLimitsData();
    
                if(userToLimitsMap.containsKey(userId)){
                    if(userToLimitsMap.get(userId) < (dailyCallout + lstSobj.size())){
                        throw new ValidateEmployerCampaignButtonException('You do not have enough daily limit to call modigie services.');
                    }
                }
                else{
                    //throw new ValidateEmployerCampaignButtonException('You are not assigned limits for modigie services, please contact your system administrator.');
                }
            }
                
                if(lstSobj.size() > 0){
                    Integer b_size = 100;
                    try{
                        b_size = Integer.valueOf(System.Label.modigie.Batch_Size_Invocable);
                        if(b_size > 100 || b_size < 1){
                            b_size = 100;
                        }
                    }catch(Exception e){}
                    VerifyEmployerDataMaintainenceClass batchable = new VerifyEmployerDataMaintainenceClass(lstSobj,recid);
                    Id jobId = Database.executeBatch(batchable,b_size);
                    lstBatchJobsIds.add(jobId);
                }
                
                return lstBatchJobsIds;
            }
            else{
                throw new ServerErrorException('You do not have permission to query lead, contact, account and campaign member fields permission.');
            }
        }
        catch(ServerErrorException e){
            throw new ServerErrorException(e.getMessage());
        }
        catch(Exception e)
        {
            Map <String,Object> errorMap = new Map<String,Object>();
            errorMap.put('DisplayMessage',e.getMessage());
            throw new ValidateEmployerCampaignButtonException(JSON.serialize(errorMap));
        }
    }




    //new



    @AuraEnabled
    public static List<Id> campaignCalloutForAllMembers(Id recid)
    {
        try
        {
            
            List<CampaignMember> contactList = new List<CampaignMember>();
            List<CampaignMember> leadList = new List<CampaignMember>();
            Map<String, String> securityMap = new Map<String, String>();
            Map<String, String> securityCampaignMap = new Map<String, String>();
            
            securityCampaignMap.put('CampaignId', 'CampaignMember');
            securityCampaignMap.put('ContactId', 'CampaignMember');
            securityCampaignMap.put('LeadId', 'CampaignMember');
           
            securityMap.put('FirstName', 'Contact');
            securityMap.put('LastName', 'Contact');
            securityMap.put('Email', 'Contact');
            securityMap.put('MobilePhone', 'Contact');
            securityMap.put('modigie__linkedin_url__c', 'Contact');
            securityMap.put('Name', 'Account');
            securityMap.put('FirstName', 'Lead');
            securityMap.put('LastName', 'Lead');
            securityMap.put('Email', 'Lead');
            securityMap.put('Company', 'Lead');
            securityMap.put('MobilePhone', 'Lead');
            securityMap.put('modigie__linkedin_url__c', 'Lead');
            securityMap.put('modigie__Contact__c', 'modigie__Modigie__c');
            securityMap.put('modigie__Lead__c', 'modigie__Modigie__c'); 
            securityMap.put('modigie__Status__c', 'modigie__Modigie__c');
            securityMap.put('modigie__Validate_Employer_Status__c', 'modigie__Modigie__c');
            
            Boolean check = FieldLevelSecurityCheck.checkSecurity(securityMap);
            Boolean checkMember = FieldLevelSecurityCheck.checkSecurityForRead(securityCampaignMap);

            
            if(check && checkMember){
                contactList = [SELECT ContactId,FirstName,LastName FROM CampaignMember WHERE CampaignId = :recId AND ContactId != null AND ContactId IN (SELECT Id FROM Contact WHERE  Account.Name != null ) AND ContactId NOT IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c = 'In Process') WITH SECURITY_ENFORCED];
                leadList = [SELECT LeadId,FirstName,LastName FROM CampaignMember WHERE CampaignId = :recId AND LeadId != null AND LeadId IN (SELECT Id FROM Lead WHERE company != null ) AND LeadId NOT IN (Select modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c = 'In Process') WITH SECURITY_ENFORCED];
                
                
                Set<Id> setOfContactIds = new Set<Id>();
                
                for(CampaignMember cm : contactList)
                {
                    setOfContactIds.add(cm.ContactId);
                }
                
                Set<ID> setOfLeadIds = new Set<ID>();
                for(CampaignMember cm : leadList)
                {
                    setOfLeadIds.add(cm.LeadId); 
                }
                
                List<Contact> conLst = [SELECT Id, Account.Name,modigie__Company_Email__c, Account.BillingStreet,Account.BillingPostalCode,Account.BillingCity,Account.BillingState,Account.BillingCountry,modigie__linkedin_url__c,FirstName, LastName, Email, modigie__Company_URL__c,MobilePhone,(SELECT id FROM modigie__Modigie__r) FROM Contact Where Id IN :setOfContactIds WITH SECURITY_ENFORCED];
                List<Lead> ldLst = [SELECT Id, FirstName, LastName, modigie__Company_Email__c,Email, Company, modigie__Company_URL__c, modigie__linkedin_url__c,MobilePhone,(SELECT id FROM modigie__Modigie__r) FROM Lead WHERE Id In :setOfLeadIds WITH SECURITY_ENFORCED];
                


                List<sObject> sobj1 = [SELECT FirstName,LastName,AccountId,modigie__Modigie_Verified_Number__c,MobilePhone,Email,modigie__linkedin_url__c FROM Contact WHERE Id IN (SELECT ContactId FROM CampaignMember WHERE CampaignId = :recid) AND (modigie__linkedin_url__c != null OR FirstName != null) AND Account.Name != null AND Id NOT IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c = 'In process') WITH SECURITY_ENFORCED];
                List<sObject> sobj2 = [SELECT FirstName,LastName,Company,modigie__Modigie_Verified_Number__c,MobilePhone,Email,modigie__linkedin_url__c FROM Lead WHERE Id IN (SELECT LeadId FROM CampaignMember WHERE CampaignId = :recid) AND (modigie__linkedin_url__c != null  OR FirstName != null )AND  Company != null AND Id NOT IN (Select modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c = 'In process') WITH SECURITY_ENFORCED];

                List<sObject> lstSobj = new List<sObject>();
                lstSobj.addAll(sobj1);
                lstSobj.addAll(sobj2);



                List<Id> lstBatchJobsIds = new List<Id>();

                String userId = UserInfo.getUserId();

                List<modigie__Process_Builder_Switch__c> lstPbs = [SELECT Id, modigie__Limit_User_for_Modigie_Ad_hoc__c FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED LIMIT 1];
                if(lstPbs.isEmpty()){
                    throw new ValidateEmployerCampaignButtonException('No settings found ! Please ask Modigie Admin to configure the user limits settings.');
                }
                else if(lstPbs[0].modigie__Limit_User_for_Modigie_Ad_hoc__c == null){
                    throw new ValidateEmployerCampaignButtonException('No settings found ! Please ask Modigie Admin to configure the user limits settings.');
                }
    
                if(lstPbs[0].modigie__Limit_User_for_Modigie_Ad_hoc__c){
                List<modigie__Daily_usage_modigie_callouts_by_users__c> modigieUsage = [SELECT modigie__User_Id__c, modigie__Number_of_modigie_callouts_in_a_day__c FROM modigie__Daily_usage_modigie_callouts_by_users__c WHERE modigie__User_Id__c = :userId WITH SECURITY_ENFORCED LIMIT 1];
                
                Integer dailyCallout = 0;
    
                if(modigieUsage.size() > 0){
                    dailyCallout = (Integer)modigieUsage[0].modigie__Number_of_modigie_callouts_in_a_day__c;
                }
    
                Map<Id,Integer> userToLimitsMap = LimitsMapClass.getProfileUserLimitsData();
    
                if(userToLimitsMap.containsKey(userId)){
                    if(userToLimitsMap.get(userId) < (dailyCallout + lstSobj.size())){
                        throw new ValidateEmployerCampaignButtonException('You do not have enough daily limit to call modigie services.');
                    }
                }
                else{
                    //throw new ValidateEmployerCampaignButtonException('You are not assigned limits for modigie services, please contact your system administrator.');
                }
            }
                if(lstSobj.size() > 0){
                    Integer b_size = 100;
                    try{
                        b_size = Integer.valueOf(System.Label.modigie.Batch_Size_Invocable);
                        if(b_size > 100 || b_size < 1){
                            b_size = 100;
                        }
                    }catch(Exception e){}
                    VerifyEmployerDataMaintainenceClass batchable = new VerifyEmployerDataMaintainenceClass(lstSobj,recid);
                    Id jobId = Database.executeBatch(batchable,b_size);
                    lstBatchJobsIds.add(jobId);
                }
                
                return lstBatchJobsIds;
            }
            else{
                throw new ServerErrorException('You do not have permission to query lead, contact, account and campaign member fields permission.');
            }
        }
        catch(ServerErrorException e){
            throw new ServerErrorException(e.getMessage());
        }
        catch(Exception e)
        {
            Map <String,Object> errorMap = new Map<String,Object>();
            errorMap.put('DisplayMessage',e.getMessage());
            throw new ValidateEmployerCampaignButtonException(JSON.serialize(errorMap));
        }
    }




    //new ends
    
    private class ValidateEmployerCampaignButtonException extends Exception{} 
}