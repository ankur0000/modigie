/************************************************************************ 
*  @authors Tarun Gyanchandani
*  @date    21 May 2020
*  @name    GetLinkedinCampaignButton 
*  @description This class is used by "GetLinkedinCampaignButtonComponent" to make callout when user press Get Lnkedin Button.
***********************************************************************/
public with sharing class GetLinkedinCampaignButton 
{
    
/************************************************************************ 
*  @authors Tarun Gyanchandani
*  @date    21 May 2020
*  @name   CampaignCallout 
*  @description This method fetch Campaign members and credit limit from Modigie Credit to display counts of Leads & Contacts.
*  @Parameters Campaign Id
*  @return Returns remaining Credit Limit & count of Campaign members.
***********************************************************************/ 
    
   	@AuraEnabled
    public static String CampaignCallout(Id recid)
    {
        Map<String, Integer> camMem = new Map<String, Integer>(); 
        try
        {

            Map<String, String> securityForReadMap = new Map<String, String>();
            securityForReadMap.put('CampaignId', 'CampaignMember');
            securityForReadMap.put('ContactId', 'CampaignMember');
            securityForReadMap.put('LeadId', 'CampaignMember');
            securityForReadMap.put('modigie__Contact__c', 'modigie__Modigie__c');
            securityForReadMap.put('modigie__Lead__c', 'modigie__Modigie__c');
            securityForReadMap.put('modigie__Linkedin_Status__c', 'modigie__Modigie__c');
            securityForReadMap.put('FirstName', 'Contact');
            securityForReadMap.put('modigie__linkedin_url__c', 'Contact');
            securityForReadMap.put('Email', 'Contact');
            securityForReadMap.put('modigie__linkedin_url__c', 'Lead');
            securityForReadMap.put('FirstName', 'Lead');
            securityForReadMap.put('Company', 'Lead');
            securityForReadMap.put('Email', 'Lead');
            securityForReadMap.put('Name', 'Account');
            
            Boolean checkForRead = FieldLevelSecurityCheck.checkSecurityForRead(securityForReadMap);

            if(!checkForRead){
                throw new GetLinkedinCampaignButtonException('You do not have permission to query lead, contact, account and campaign member fields permission.');
            }

            List<modigie__Modigie_Service_Account__mdt> lstCredentials = ModigieApiUtils.getServiceAccountDetails();
            if(lstCredentials.size() > 0){
                Integer recordsToProcess;
                Integer validatedRecords;
                Integer recordsRunning;
                Integer invalidatedRecords;
                Integer notFulfill;
                Integer userFilled;
                Integer newRecordsToProcess;
                
                List<CampaignMember> totalMembersList = new List<CampaignMember>();
                List<CampaignMember> contactList = new List<CampaignMember>();
                List<CampaignMember> leadList = new List<CampaignMember>();
                totalMembersList = [SELECT ContactId, LeadId FROM CampaignMember WHERE CampaignId =: recid AND (ContactId !=null OR LeadId != null) WITH SECURITY_ENFORCED LIMIT 50000];
                
                validatedRecords =  [SELECT count() FROM CampaignMember WHERE CampaignId =: recid AND ContactId !=null  AND ContactId  IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Linkedin_Status__c  = 'Validated') WITH SECURITY_ENFORCED LIMIT 50000];
                
                invalidatedRecords = [SELECT count() FROM CampaignMember WHERE CampaignId = :recId AND ContactId != null AND ContactId IN (SELECT modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Linkedin_Status__c ='Not Available') WITH SECURITY_ENFORCED LIMIT 50000];
                
                recordsRunning = [SELECT count() FROM CampaignMember WHERE CampaignId = :recId AND ContactId != null AND ContactId IN (SELECT modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Linkedin_Status__c = 'In process')  WITH SECURITY_ENFORCED LIMIT 50000];
                
                notFulfill = [SELECT count() FROM CampaignMember WHERE CampaignId = :recId AND ContactId != null AND ContactId IN (SELECT Id FROM Contact WHERE FirstName = null OR Account.Name = null OR Email = null) AND ContactId NOT IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Linkedin_Status__c = 'In process' OR modigie__Linkedin_Status__c = 'Validated' OR modigie__Linkedin_Status__c = 'Not Available') WITH SECURITY_ENFORCED LIMIT 50000];
                
                recordsToProcess = [SELECT count() FROM CampaignMember WHERE CampaignId = :recId AND ContactId != null AND ContactId IN (SELECT Id FROM Contact WHERE FirstName != null AND Account.Name != null AND Email != null) AND ContactId NOT IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE  modigie__Linkedin_Status__c = 'In process') WITH SECURITY_ENFORCED LIMIT 50000];
                
                newRecordsToProcess = [SELECT count() FROM CampaignMember WHERE CampaignId = :recId AND ContactId != null AND ContactId IN (SELECT Id FROM Contact WHERE FirstName != null AND Account.Name != null AND Email != null AND modigie__linkedin_url__c = null) AND ContactId NOT IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE  modigie__Linkedin_Status__c = 'In process' OR modigie__Linkedin_Status__c = 'Validated' OR modigie__Linkedin_Status__c = 'Not Available') WITH SECURITY_ENFORCED LIMIT 50000];

                userFilled = [SELECT count() FROM CampaignMember WHERE CampaignId = :recId AND ContactId != null AND ContactId IN (SELECT Id FROM Contact WHERE modigie__linkedin_url__c != null) AND ContactId NOT IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Linkedin_Status__c = 'In process' OR modigie__Linkedin_Status__c = 'Validated' OR modigie__Linkedin_Status__c = 'Not Available') WITH SECURITY_ENFORCED LIMIT 50000];
                

                
                validatedRecords +=  [SELECT count() FROM CampaignMember WHERE CampaignId =: recid AND LeadId !=null  AND LeadId  IN (Select modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Linkedin_Status__c  = 'Validated') WITH SECURITY_ENFORCED LIMIT 50000];

                invalidatedRecords += [SELECT count() FROM CampaignMember WHERE CampaignId = :recId AND LeadId != null AND LeadId IN (SELECT modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Linkedin_Status__c ='Not Available') WITH SECURITY_ENFORCED LIMIT 50000];
                
                recordsRunning += [SELECT count() FROM CampaignMember WHERE CampaignId = :recId AND LeadId != null AND LeadId IN (SELECT modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Linkedin_Status__c = 'In process') WITH SECURITY_ENFORCED LIMIT 50000];

                notFulfill += [SELECT count() FROM CampaignMember WHERE CampaignId = :recId AND LeadId != null AND LeadId IN (SELECT Id FROM Lead WHERE FirstName = null OR Company = null OR Email = null) AND LeadId NOT IN (Select modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Linkedin_Status__c = 'In process' OR modigie__Linkedin_Status__c = 'Validated' OR modigie__Linkedin_Status__c = 'Not Available') WITH SECURITY_ENFORCED LIMIT 50000];

                recordsToProcess += [SELECT count() FROM CampaignMember WHERE CampaignId = :recId AND LeadId != null AND LeadId IN (SELECT Id FROM Lead WHERE FirstName != null AND company != null AND Email != null) AND LeadId NOT IN (Select modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Linkedin_Status__c = 'In process') WITH SECURITY_ENFORCED LIMIT 50000];
                
                newRecordsToProcess += [SELECT count() FROM CampaignMember WHERE CampaignId = :recId AND LeadId != null AND LeadId IN (SELECT Id FROM Lead WHERE FirstName != null AND company != null AND Email != null AND modigie__linkedin_url__c = null) AND LeadId NOT IN (Select modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Linkedin_Status__c = 'In process' OR modigie__Linkedin_Status__c = 'Validated' OR modigie__Linkedin_Status__c = 'Not Available') WITH SECURITY_ENFORCED LIMIT 50000];
                
                userFilled += [SELECT count() FROM CampaignMember WHERE CampaignId = :recId AND LeadId != null AND LeadId IN (SELECT Id FROM Lead WHERE modigie__linkedin_url__c != null) AND LeadId NOT IN (Select modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Linkedin_Status__c = 'Validated' OR modigie__Linkedin_Status__c = 'In process' OR modigie__Linkedin_Status__c = 'Not Available') WITH SECURITY_ENFORCED LIMIT 50000];
                
            
                
                if(recordsToProcess > 0){
                    camMem.put('TokenExist',1);
                }
                
                else{
                    camMem.put('TokenExist', -3);
                }
                camMem.put('totalSize', totalMembersList.size());
                camMem.put('alreadyValidated', validatedRecords);
                camMem.put('recordsRunning', recordsRunning);
                camMem.put('recordsToProcess', recordsToProcess);
                camMem.put('invalidatedRecords', invalidatedRecords);
                camMem.put('notFulfill', notFulfill);
                camMem.put('userFilled', userFilled);
                camMem.put('newRecordsToProcess',newRecordsToProcess);
                return JSON.serialize(camMem);
            }
            else{
                throw new GetLinkedinCampaignButtonException('You are not an authorized user.');
            }
        }
        catch(LimitException e)
        {
            throw new GetLinkedinCampaignButtonException('You cannot process more than 50,000 records.');
           
        }
        catch(System.QueryException e){
            throw new GetLinkedinCampaignButtonException('You do not have permission to query lead, contact, campaign member or modigie fields.');    
        }
        catch(Exception e)
        {
            throw new GetLinkedinCampaignButtonException(e.getMessage());
        }
            
    }
    
    
/************************************************************************ 
*  @authors Tarun Gyanchandani
*  @date    21 May 2020
*  @name   campaignCalloutForNewMembers 
*  @description Method to Syncronization of new Campaign records.
*  @Parameters Campaign Id
***********************************************************************/     
    @AuraEnabled
    public static List<Id> campaignCalloutForNewMembers(Id recid)
    {
        try
        {
            Map<String, String> securityMap = new Map<String, String>();
            Map<String, String> securityForRead = new Map<String, String>();
            List<CampaignMember> contactList = new List<CampaignMember>();
            List<CampaignMember> leadList = new List<CampaignMember>();
            
            securityForRead.put('CampaignId', 'CampaignMember');
            securityForRead.put('ContactId', 'CampaignMember');
            securityForRead.put('LeadId', 'CampaignMember');
            securityForRead.put('FirstName', 'Contact');
            securityForRead.put('LastName', 'Contact');
            securityForRead.put('Email', 'Contact');
            securityForRead.put('MobilePhone', 'Contact');
            securityForRead.put('Name', 'Account');
            securityForRead.put('FirstName', 'Lead');
            securityForRead.put('LastName', 'Lead');
            securityForRead.put('Email', 'Lead');
            securityForRead.put('Company', 'Lead');
            securityForRead.put('MobilePhone', 'Lead');
            
            
            securityMap.put('modigie__linkedin_url__c', 'Contact');
            securityMap.put('modigie__linkedin_url__c', 'Lead');
            securityMap.put('modigie__Contact__c', 'modigie__Modigie__c'); 
            securityMap.put('modigie__Lead__c', 'modigie__Modigie__c');
            securityMap.put('modigie__Linkedin_Status__c', 'modigie__Modigie__c');
            
            Boolean checkForRead = FieldLevelSecurityCheck.checkSecurityForRead(securityForRead);
            Boolean check = FieldLevelSecurityCheck.checkSecurity(securityMap);
            
            if(!checkForRead){
                throw new GetLinkedinCampaignButtonException('You do not have permission to query lead, contact, account and campaign member fields permission.');
            }

            if(!check){
                throw new GetLinkedinCampaignButtonException('You do not have permission to query lead, contact or modigie fields.');
            }
            
            contactList = [SELECT ContactId FROM CampaignMember WHERE CampaignId =: recid AND ContactId !=null AND ContactId IN (SELECT Id FROM Contact where FirstName != null AND Account.Name != null AND Email != null AND modigie__linkedin_url__c = null) AND ContactId NOT IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Linkedin_Status__c = 'In process' OR modigie__Linkedin_Status__c = 'Validated' OR modigie__Linkedin_Status__c = 'Not Available') WITH SECURITY_ENFORCED LIMIT 50000]; 
            leadList = [SELECT LeadId FROM CampaignMember WHERE CampaignId =: recid AND LeadId !=null AND LeadId IN (SELECT Id FROM Lead where FirstName != null AND Company != null AND Email != null AND modigie__linkedin_url__c = null) AND LeadId NOT IN (Select modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Linkedin_Status__c = 'In process' OR modigie__Linkedin_Status__c = 'Validated' OR modigie__Linkedin_Status__c = 'Not Available') WITH SECURITY_ENFORCED LIMIT 50000];
            
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
            
            List<Contact> conLst = [SELECT Id, Account.Name,Email,modigie__linkedin_url__c,FirstName, LastName, MobilePhone,(SELECT id FROM modigie__Modigie__r) FROM Contact Where Id IN :setOfContactIds WITH SECURITY_ENFORCED LIMIT 50000];
            List<Lead> ldLst = [SELECT Id, FirstName, LastName, Email,Company,  modigie__linkedin_url__c,MobilePhone,(SELECT id FROM modigie__Modigie__r) FROM Lead WHERE Id In :setOfLeadIds WITH SECURITY_ENFORCED LIMIT 50000];
            
            List<Id> lstBatchJobsIds = new List<Id>();

            String userId = UserInfo.getUserId();

            List<modigie__Process_Builder_Switch__c> lstPbs = [SELECT Id, modigie__Limit_User_for_Modigie_Ad_hoc__c FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED LIMIT 1];
            
            if(lstPbs.isEmpty()){
                throw new GetLinkedinCampaignButtonException('No settings found ! Please ask Modigie Admin to configure the user limits settings.');
            }
            else if(lstPbs[0].modigie__Limit_User_for_Modigie_Ad_hoc__c == null){
                throw new GetLinkedinCampaignButtonException('No settings found ! Please ask Modigie Admin to configure the user limits settings.');
            }

            if(lstPbs[0].modigie__Limit_User_for_Modigie_Ad_hoc__c){

            List<modigie__Daily_usage_modigie_callouts_by_users__c> modigieUsage = [SELECT modigie__User_Id__c, modigie__Number_of_modigie_callouts_in_a_day__c FROM modigie__Daily_usage_modigie_callouts_by_users__c WHERE modigie__User_Id__c = :userId WITH SECURITY_ENFORCED LIMIT 1];
            
            Integer dailyCallout = 0;

            if(modigieUsage.size() > 0){
                dailyCallout = (Integer)modigieUsage[0].modigie__Number_of_modigie_callouts_in_a_day__c;
            }

            Map<Id,Integer> userToLimitsMap = LimitsMapClass.getProfileUserLimitsData();

            if(userToLimitsMap.containsKey(userId)){
                if(userToLimitsMap.get(userId) < (dailyCallout + conLst.size() + ldLst.size())){
                    throw new GetLinkedinCampaignButtonException('You do not have enough daily limit to call modigie services.');
                }
            }
            else{
                //throw new GetLinkedinCampaignButtonException('You are not assigned limits for modigie services, please contact your system administrator.');
            }
        }
            List<modigie__Modigie_Service_Account__mdt> modigieCredential = ModigieApiUtils.getServiceAccountDetails();
            
            if(modigieCredential.size() > 0){
                List<modigie__Modigie_Callout_Info__mdt> calloutInfo = [SELECT Id, modigie__Endpoint_Url__c, modigie__targetAud__c, modigie__Content_Type__c FROM modigie__Modigie_Callout_Info__mdt WHERE MasterLabel = 'PhoneIntelligence Job Create' LIMIT 1];
                String targetAudience, endpoint, contentType;
                if(!calloutInfo.isEmpty()){
                    endpoint = calloutInfo[0].modigie__Endpoint_Url__c;
                    targetAudience = calloutInfo[0].modigie__targetAud__c;
                    contentType = calloutInfo[0].modigie__Content_Type__c;
                }

                String accessToken = 'Bearer ' + jwtapex.get_access_token(modigieCredential[0].modigie__Email__c,targetAudience,modigieCredential[0].modigie__Private_Key__c);
                //String accessToken = 'Bearer ' + jwtapex.get_access_token(modigieCredential[0].modigie__Service_Account_Credentials__c,'https://modigie-engage-backend-kyaxv4ttua-uc.a.run.app',modigieCredential[0].modigie__Private_Key__c);
                Integer b_size = 100;
                try{
                    b_size = Integer.valueOf(System.Label.modigie.Batch_Size_Invocable);
                    if(b_size > 100 || b_size < 1){
                        b_size = 100;
                    }
                }catch(Exception e){}
                if(conLst.size()>0)
                {
                    ContactBatchForGetLinkedinButton b1 = new ContactBatchForGetLinkedinButton(conLst,recid);
                    //Database.executeBatch(b1,100);
                    
                    Id jobId = Database.executeBatch(b1, b_size);
                    lstBatchJobsIds.add(jobId);
                }
                
                if(ldLst.size()>0)
                {
                    LeadBatchForGetLinkedInButton b2 = new LeadBatchForGetLinkedInButton(ldLst,recid); 
                    Id jobId = Database.executeBatch(b2, b_size);
                    lstBatchJobsIds.add(jobId);
                }
            }
            else{
                throw new GetLinkedinCampaignButtonException('You are not an authorized user.');
            }
            
            return lstBatchJobsIds;
            
            
        }
        catch(ServerErrorException e){
            Map <String,Object> errorMap = (Map <String,Object>)JSON.deserializeUntyped(e.getMessage());
            errorMap.put('ModigieService','Get LinkedIn'); 
            errorMap.put('SObjectId',recid);
            throw new ServerErrorException(JSON.serialize(errorMap));
        }
        catch(Exception e)
        {
            Map <String,Object> errorMap = new Map<String,Object>();
            errorMap.put('DisplayMessage', e.getMessage());
           	//return null;
             throw new GetLinkedinCampaignButtonException(JSON.serialize(errorMap));
        } 
        
    }



    /*new Method Dummy*/

    @AuraEnabled
    public static List<Id> campaignCalloutForAllMembers(Id recid)
    {
        try
        {
            Map<String, String> securityMap = new Map<String, String>();
            Map<String, String> securityForRead = new Map<String, String>();
            List<CampaignMember> contactList = new List<CampaignMember>();
            List<CampaignMember> leadList = new List<CampaignMember>();
            
            securityForRead.put('CampaignId', 'CampaignMember');
            securityForRead.put('ContactId', 'CampaignMember');
            securityForRead.put('LeadId', 'CampaignMember');
            securityForRead.put('FirstName', 'Contact');
            securityForRead.put('LastName', 'Contact');
            securityForRead.put('Email', 'Contact');
            securityForRead.put('MobilePhone', 'Contact');
            securityForRead.put('Name', 'Account');
            securityForRead.put('FirstName', 'Lead');
            securityForRead.put('LastName', 'Lead');
            securityForRead.put('Email', 'Lead');
            securityForRead.put('Company', 'Lead');
            securityForRead.put('MobilePhone', 'Lead');
            
            
            securityMap.put('modigie__linkedin_url__c', 'Contact');
            securityMap.put('modigie__linkedin_url__c', 'Lead');
            securityMap.put('modigie__Contact__c', 'modigie__Modigie__c'); 
            securityMap.put('modigie__Lead__c', 'modigie__Modigie__c');
            securityMap.put('modigie__Linkedin_Status__c', 'modigie__Modigie__c');
            
            Boolean checkForRead = FieldLevelSecurityCheck.checkSecurityForRead(securityForRead);
            Boolean check = FieldLevelSecurityCheck.checkSecurity(securityMap);
            
            if(!checkForRead){
                throw new GetLinkedinCampaignButtonException('You do not have permission to query lead, contact, account and campaign member fields permission.');
            }

            if(!check){
                throw new GetLinkedinCampaignButtonException('You do not have permission to query lead, contact or modigie fields.');
            }
            
            contactList = [SELECT ContactId FROM CampaignMember WHERE CampaignId =: recid AND ContactId !=null AND ContactId IN (SELECT Id FROM Contact where FirstName != null AND Account.Name != null AND Email != null) AND ContactId NOT IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Linkedin_Status__c = 'In Process') WITH SECURITY_ENFORCED LIMIT 50000]; 
            leadList = [SELECT LeadId FROM CampaignMember WHERE CampaignId =: recid AND LeadId !=null AND LeadId IN (SELECT Id FROM Lead where FirstName != null AND Company != null AND Email != null) AND LeadId NOT IN (Select modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Linkedin_Status__c = 'In Process' ) WITH SECURITY_ENFORCED LIMIT 50000];
            
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
            
            List<Contact> conLst = [SELECT Id, Account.Name,Email,modigie__linkedin_url__c,FirstName, LastName, MobilePhone,(SELECT id FROM modigie__Modigie__r) FROM Contact Where Id IN :setOfContactIds WITH SECURITY_ENFORCED LIMIT 50000];
            List<Lead> ldLst = [SELECT Id, FirstName, LastName, Email,Company,  modigie__linkedin_url__c,MobilePhone,(SELECT id FROM modigie__Modigie__r) FROM Lead WHERE Id In :setOfLeadIds WITH SECURITY_ENFORCED LIMIT 50000];
            
            List<Id> lstBatchJobsIds = new List<Id>();

            String userId = UserInfo.getUserId();

            List<modigie__Process_Builder_Switch__c> lstPbs = [SELECT Id, modigie__Limit_User_for_Modigie_Ad_hoc__c FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED LIMIT 1];
            
            if(lstPbs.isEmpty()){
                throw new GetLinkedinCampaignButtonException('No settings found ! Please ask Modigie Admin to configure the user limits settings.');
            }
            else if(lstPbs[0].modigie__Limit_User_for_Modigie_Ad_hoc__c == null){
                throw new GetLinkedinCampaignButtonException('No settings found ! Please ask Modigie Admin to configure the user limits settings.');
            }

            if(lstPbs[0].modigie__Limit_User_for_Modigie_Ad_hoc__c){
            List<modigie__Daily_usage_modigie_callouts_by_users__c> modigieUsage = [SELECT modigie__User_Id__c, modigie__Number_of_modigie_callouts_in_a_day__c FROM modigie__Daily_usage_modigie_callouts_by_users__c WHERE modigie__User_Id__c = :userId WITH SECURITY_ENFORCED LIMIT 1];
            
            Integer dailyCallout = 0;

            if(modigieUsage.size() > 0){
                dailyCallout = (Integer)modigieUsage[0].modigie__Number_of_modigie_callouts_in_a_day__c;
            }

            Map<Id,Integer> userToLimitsMap = LimitsMapClass.getProfileUserLimitsData();

            if(userToLimitsMap.containsKey(userId)){
                if(userToLimitsMap.get(userId) < (dailyCallout + conLst.size() + ldLst.size())){
                    throw new GetLinkedinCampaignButtonException('You do not have enough daily limit to call modigie services.');
                }
            }
            else{
                //throw new GetLinkedinCampaignButtonException('You are not assigned limits for modigie services, please contact your system administrator.');
            }

        }
            List<modigie__Modigie_Service_Account__mdt> modigieCredential = ModigieApiUtils.getServiceAccountDetails();
            
            if(modigieCredential.size() > 0){
                List<modigie__Modigie_Callout_Info__mdt> calloutInfo = [SELECT Id, modigie__Endpoint_Url__c, modigie__targetAud__c, modigie__Content_Type__c FROM modigie__Modigie_Callout_Info__mdt WHERE MasterLabel = 'PhoneIntelligence Job Create' LIMIT 1];
                String targetAudience, endpoint, contentType;
                if(!calloutInfo.isEmpty()){
                    endpoint = calloutInfo[0].modigie__Endpoint_Url__c;
                    targetAudience = calloutInfo[0].modigie__targetAud__c;
                    contentType = calloutInfo[0].modigie__Content_Type__c;
                }

                //String accessToken = 'Bearer ' + jwtapex.get_access_token(modigieCredential[0].modigie__Service_Account_Credentials__c,'https://modigie-engage-backend-bqqdnyh5lq-uc.a.run.app',modigieCredential[0].modigie__Private_Key__c);
                String accessToken = 'Bearer ' + jwtapex.get_access_token(modigieCredential[0].modigie__Email__c,targetAudience,modigieCredential[0].modigie__Private_Key__c);
                Integer b_size = 100;
                try{
                    b_size = Integer.valueOf(System.Label.modigie.Batch_Size_Invocable);
                    if(b_size > 100 || b_size < 1){
                        b_size = 100;
                    }
                }catch(Exception e){}
                if(conLst.size()>0)
                {
                    ContactBatchForGetLinkedinButton b1 = new ContactBatchForGetLinkedinButton(conLst,recid);
                    Id jobId = Database.executeBatch(b1,b_size);
                    lstBatchJobsIds.add(jobId);
                }
                
                if(ldLst.size()>0)
                {
                    LeadBatchForGetLinkedInButton b2 = new LeadBatchForGetLinkedInButton(ldLst,recid); 
                    Id jobId = Database.executeBatch(b2,b_size);
                    lstBatchJobsIds.add(jobId);
                }
            }
            else{
                throw new GetLinkedinCampaignButtonException('You are not an authorized user.');
            }
            
            return lstBatchJobsIds;
            
            
        }
        catch(ServerErrorException e){
            Map <String,Object> errorMap = (Map <String,Object>)JSON.deserializeUntyped(e.getMessage());
            errorMap.put('ModigieService','Get LinkedIn'); 
            errorMap.put('SObjectId',recid);
            throw new ServerErrorException(JSON.serialize(errorMap));
        }
        catch(Exception e)
        {
            Map <String,Object> errorMap = new Map<String,Object>();
            errorMap.put('DisplayMessage', e.getMessage());
            throw new GetLinkedinCampaignButtonException(JSON.serialize(errorMap));
        } 
        
    }


    /*new Method Dummy ends*/




    private class GetLinkedinCampaignButtonException extends Exception{}
}