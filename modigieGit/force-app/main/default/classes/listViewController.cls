public with sharing class listViewController {

    @AuraEnabled
    public static String getSelectedRecordInformation(String idList){
        try{
            List<String> lstString = idList.split(',');
            Set<String> lstIds = new Set<String>(lstString);
            
            Map<String,Object> mMap = new Map<String,Object>();
            List<Map<String,Object>> lstMap = new List<Map<String,Object>>(); 
            
            Integer totalMembers = 0; //Assign size of Set lstIds
            totalMembers = lstIds.size();
            
            Map<String,Object> serviceCountMap = new Map<String,Object>();
            
            Map<String, String> securityMap = new Map<String, String>();
            securityMap.put('modigie__Contact__c', 'modigie__Modigie__c');
            securityMap.put('modigie__Lead__c', 'modigie__Modigie__c');
            securityMap.put('modigie__Linkedin_Status__c', 'modigie__Modigie__c');
            securityMap.put('modigie__Validate_Employer_Status__c', 'modigie__Modigie__c');
            securityMap.put('modigie__Phone_Intelligence_Status__c', 'modigie__Modigie__c');
            securityMap.put('modigie__Phone_Intelligence_Status_Phone__c', 'modigie__Modigie__c');
            securityMap.put('modigie__Phone_Intelligence_Status_Other_Phone__c', 'modigie__Modigie__c');
            securityMap.put('modigie__Status__c', 'modigie__Modigie__c');
            
            Boolean check = FieldLevelSecurityCheck.checkSecurity(securityMap);
            
            if(check){
                Integer runningJobs = [SELECT count() FROM modigie__Modigie__c WHERE (Contact__c IN :lstIds OR Lead__c IN :lstIds) AND modigie__Linkedin_Status__c = 'In process' WITH SECURITY_ENFORCED];
                Integer validated = [SELECT count() FROM modigie__Modigie__c WHERE (Contact__c IN :lstIds OR Lead__c IN :lstIds) AND modigie__Linkedin_Status__c = 'Validated' WITH SECURITY_ENFORCED];
                Integer invalidated = [SELECT count() FROM modigie__Modigie__c WHERE (Contact__c IN :lstIds OR Lead__c IN :lstIds) AND modigie__Linkedin_Status__c = 'Not Available' WITH SECURITY_ENFORCED];
                Integer remaining = totalMembers - runningJobs - validated - invalidated;
                
                serviceCountMap.put('Name','Get LinkedIn');
                serviceCountMap.put('Running',runningJobs);
                serviceCountMap.put('Validated',validated);
                serviceCountMap.put('Invalidated',invalidated);
                serviceCountMap.put('Remaining',remaining);
                serviceCountMap.put('TotalMembers',totalMembers);
                // mMap.put('GetLinkedIn',serviceCountMap);
                lstMap.add(serviceCountMap);
                
                serviceCountMap = new Map<String,Object>();
                
                runningJobs = [SELECT count() FROM modigie__Modigie__c WHERE (Contact__c IN :lstIds OR Lead__c IN :lstIds) AND modigie__Validate_Employer_Status__c = 'In process' WITH SECURITY_ENFORCED];
                validated = [SELECT count() FROM modigie__Modigie__c WHERE (Contact__c IN :lstIds OR Lead__c IN :lstIds) AND modigie__Validate_Employer_Status__c = 'Validated' WITH SECURITY_ENFORCED];
                invalidated = [SELECT count() FROM modigie__Modigie__c WHERE (Contact__c IN :lstIds OR Lead__c IN :lstIds) AND modigie__Validate_Employer_Status__c = 'Not Available' WITH SECURITY_ENFORCED]; 
                remaining = totalMembers - runningJobs - validated - invalidated;
                
                serviceCountMap.put('Name','Verify Employer');
                serviceCountMap.put('Running',runningJobs);
                serviceCountMap.put('Validated',validated);
                serviceCountMap.put('Remaining',remaining);
                serviceCountMap.put('Invalidated',invalidated);
                
                // mMap.put('VerifyEmployer',serviceCountMap);
                lstMap.add(serviceCountMap);
                
                serviceCountMap = new Map<String,Object>();
                serviceCountMap.put('Name','Get Phone Insights');
                serviceCountMap.put('isGetPhoneInsights',true);
                
                
                runningJobs = [SELECT count() FROM modigie__Modigie__c WHERE (Contact__c IN :lstIds OR Lead__c IN :lstIds) AND modigie__Phone_Intelligence_Status__c  = 'In process' WITH SECURITY_ENFORCED];
                validated = [SELECT count() FROM modigie__Modigie__c WHERE (Contact__c IN :lstIds OR Lead__c IN :lstIds) AND modigie__Phone_Intelligence_Status__c = 'Validated' WITH SECURITY_ENFORCED];
                invalidated = [SELECT count() FROM modigie__Modigie__c WHERE (Contact__c IN :lstIds OR Lead__c IN :lstIds) AND modigie__Phone_Intelligence_Status__c = 'Not Available' WITH SECURITY_ENFORCED];
                remaining = totalMembers - runningJobs - validated - invalidated;
                
                List<Map<String,Object>> nestedLst = new List<Map<String,Object>>();
                
                Map<String,Object> phoneInsightsCountMap = new Map<String,Object>();
                
                
                phoneInsightsCountMap.put('Name','Mobile');
                phoneInsightsCountMap.put('Running',runningJobs);
                phoneInsightsCountMap.put('Validated',validated);
                phoneInsightsCountMap.put('Remaining',remaining);
                phoneInsightsCountMap.put('Invalidated',invalidated);
                
                //mMap.put('GetPhoneIntelligenceMobile',serviceCountMap);
                
                nestedLst.add(phoneInsightsCountMap);
                
                phoneInsightsCountMap = new Map<String,Object>();
                
                runningJobs = [SELECT count() FROM modigie__Modigie__c WHERE (Contact__c IN :lstIds OR Lead__c IN :lstIds) AND modigie__Phone_Intelligence_Status_Phone__c  = 'In process' WITH SECURITY_ENFORCED];
                validated = [SELECT count() FROM modigie__Modigie__c WHERE (Contact__c IN :lstIds OR Lead__c IN :lstIds) AND modigie__Phone_Intelligence_Status_Phone__c = 'Validated' WITH SECURITY_ENFORCED];
                invalidated = [SELECT count() FROM modigie__Modigie__c WHERE (Contact__c IN :lstIds OR Lead__c IN :lstIds) AND modigie__Phone_Intelligence_Status_Phone__c = 'Not Available' WITH SECURITY_ENFORCED];
                remaining = totalMembers - runningJobs - validated - invalidated;
                
                phoneInsightsCountMap.put('Name','Phone');
                phoneInsightsCountMap.put('Running',runningJobs);
                phoneInsightsCountMap.put('Validated',validated);
                phoneInsightsCountMap.put('Remaining',remaining);
                phoneInsightsCountMap.put('Invalidated',invalidated);
                
                //mMap.put('GetPhoneIntelligenceMobile',serviceCountMap);
                
                nestedLst.add(phoneInsightsCountMap);
                
                phoneInsightsCountMap = new Map<String,Object>();
                
                runningJobs = [SELECT count() FROM modigie__Modigie__c WHERE (Contact__c IN :lstIds OR Lead__c IN :lstIds) AND modigie__Phone_Intelligence_Status_Other_Phone__c  = 'In process' WITH SECURITY_ENFORCED];
                validated = [SELECT count() FROM modigie__Modigie__c WHERE (Contact__c IN :lstIds OR Lead__c IN :lstIds) AND modigie__Phone_Intelligence_Status_Other_Phone__c = 'Validated' WITH SECURITY_ENFORCED];
                invalidated = [SELECT count() FROM modigie__Modigie__c WHERE (Contact__c IN :lstIds OR Lead__c IN :lstIds) AND modigie__Phone_Intelligence_Status_Other_Phone__c = 'Not Available' WITH SECURITY_ENFORCED];
                Integer totalContacts = [SELECT count() FROM modigie__Modigie__c WHERE Contact__c IN :lstIds WITH SECURITY_ENFORCED];
                remaining = totalContacts - runningJobs - validated - invalidated;
                
                phoneInsightsCountMap.put('Name','Other Phone');
                phoneInsightsCountMap.put('Running',runningJobs);
                phoneInsightsCountMap.put('Validated',validated);
                phoneInsightsCountMap.put('Remaining',remaining);
                phoneInsightsCountMap.put('Invalidated',invalidated);
                
                
                nestedLst.add(phoneInsightsCountMap);
                
                serviceCountMap.put('GetPhoneInsightsData', nestedLst);
                
                lstMap.add(serviceCountMap);
                serviceCountMap = new Map<String,Object>();
                
                runningJobs = [SELECT count() FROM modigie__Modigie__c WHERE (Contact__c IN :lstIds OR Lead__c IN :lstIds) AND modigie__Status__c = 'In process' WITH SECURITY_ENFORCED];
                validated = [SELECT count() FROM modigie__Modigie__c WHERE (Contact__c IN :lstIds OR Lead__c IN :lstIds) AND modigie__Status__c = 'Validated' WITH SECURITY_ENFORCED];
                invalidated = [SELECT count() FROM modigie__Modigie__c WHERE (Contact__c IN :lstIds OR Lead__c IN :lstIds) AND modigie__Status__c = 'Not Available' WITH SECURITY_ENFORCED];
                remaining = totalMembers - runningJobs - validated - invalidated;
                
                serviceCountMap.put('Name','Get Modigie');
                serviceCountMap.put('Running',runningJobs);
                serviceCountMap.put('Validated',validated);
                serviceCountMap.put('Invalidated',invalidated);
                serviceCountMap.put('Remaining',remaining);
                
                
                mMap.put('GetModigie',serviceCountMap);
                lstMap.add(serviceCountMap);
                
                
                
            }
            
            else{
                throw new listViewControllerException('You Do Not Have Permissions to edit Modigie Object');   
            }
            
            return JSON.serialize(lstMap);
            
        }
        catch(Exception e){
            throw new listViewControllerException(e.getMessage());
            
        }
    }

    @AuraEnabled
    public static List<sObject> getSelectedRecords(String idList, String objectname){
        List<PermissionSetAssignment> lstUser = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId =:UserInfo.getUserId() AND PermissionSet.NamespacePrefix = 'modigie' AND PermissionSet.Name in ('Modigie_Admin', 'Modigie_User', 'Modigie_Automation_User')];
        if(lstUser.size() == 0 && !Test.isRunningTest()){
            throw new listViewControllerException('You are not an authorized user.');
        }

        List<String> lstString = idList.split(',');
        Set<String> sstring = new Set<String>(lstString);
        
        if(objectname?.equalsIgnoreCase('Lead') == true)
        {
            
            List<Lead> leadList = [SELECT Id, Firstname, Lastname, Email, Company, MobilePhone, Title, modigie__linkedin_url__c FROM Lead WHERE Id In :sstring WITH SECURITY_ENFORCED];
            return leadList;
        }
        else {
            
            List<Contact> conList = [SELECT Id, Firstname, Lastname, Email, MobilePhone, Account.Name, Title, modigie__linkedin_url__c FROM Contact WHERE Id In :sstring WITH SECURITY_ENFORCED];
            return conList;
        }
    }

    @AuraEnabled
    public static String getMembersData(String idList, String objectName, String buttonPressed)
    {
        Map<String, Integer> camMem = new Map<String, Integer>(); 
        try
        {
            Integer recordsToProcess;
            Integer validatedRecords;
            Integer recordsRunning;
            Integer invalidatedRecords;
            Integer notFulfill;
            Integer userFilled; 

            List<String> recId = idList.split(',');
            
            Integer totalMembersList  = 0;
            List<CampaignMember> contactList = new List<CampaignMember>();
            List<CampaignMember> leadList = new List<CampaignMember>();
            
            
            Map<String, String> securityMap = new Map<String, String>();
            Map<String, String> securityCampaignMap = new Map<String, String>();
            
            // List<modigie__Modigie_Credentials__c> tokenList = new List<modigie__Modigie_Credentials__c>();
            // tokenList = [SELECT Name, modigie__Credits_Account_Id__c,modigie__API_Key__c,modigie__Service_Account_Credentials__c,modigie__Private_Key__c FROM modigie__Modigie_Credentials__c  WITH SECURITY_ENFORCED LIMIT 1];

            List<modigie__Modigie_Service_Account__mdt> serviceAccountDetails = ModigieApiUtils.getServiceAccountDetails();
            if(!serviceAccountDetails.isEmpty())
            {
                
                totalMembersList = recId.size();

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
                  if(buttonPressed?.equalsIgnoreCase('VerifyEmployer') == true){
                    if(objectName?.equalsIgnoreCase('Contact') == true){
                        validatedRecords =  [SELECT count() FROM Contact WHERE Id IN :recid AND Id  IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c    = 'Validated') WITH SECURITY_ENFORCED];
                        invalidatedRecords = [SELECT count() FROM Contact WHERE Id IN :recId AND  Id IN (SELECT modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c  ='Not Available') WITH SECURITY_ENFORCED];
                        recordsRunning = [SELECT count() FROM Contact WHERE Id IN :recId AND Id IN (SELECT modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c  = 'In process') WITH SECURITY_ENFORCED];
                        notFulfill = [SELECT count() FROM Contact WHERE Id IN :recId AND (Account.Name = null OR (modigie__linkedin_url__c  = null AND FirstName = null)) AND Id NOT IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c != 'Not started' AND modigie__Validate_Employer_Status__c != 'Unavailable') WITH SECURITY_ENFORCED];
                        recordsToProcess = [SELECT count() FROM Contact WHERE Id IN :recId AND (Account.Name != null AND (modigie__linkedin_url__c  != null OR FirstName != null)) AND Id NOT IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c != 'Not started' AND modigie__Validate_Employer_Status__c != 'Unavailable') WITH SECURITY_ENFORCED];
                    }
                    
                    else if(objectName?.equalsIgnoreCase('Lead') == true){
                        recordsToProcess = [SELECT count() FROM Lead WHERE Id IN :recId AND (company != null AND (modigie__linkedin_url__c != null OR FirstName != null)) AND Id NOT IN (Select modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c != 'Not started' AND modigie__Validate_Employer_Status__c != 'Unavailable') WITH SECURITY_ENFORCED];
                        recordsRunning = [SELECT count() FROM Lead WHERE Id IN :recId AND  Id IN (SELECT modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c = 'In process') WITH SECURITY_ENFORCED];
                        validatedRecords =  [SELECT count() FROM Lead WHERE Id IN : recid AND Id  IN (Select modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c  = 'Validated') WITH SECURITY_ENFORCED];
                        invalidatedRecords = [SELECT count() FROM Lead WHERE Id IN :recId AND Id IN (SELECT modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c ='Not Available') WITH SECURITY_ENFORCED];
                        notFulfill = [SELECT count() FROM Lead WHERE Id IN :recId AND  (Company = null OR (modigie__linkedin_url__c = null AND FirstName = null)) AND Id NOT IN (Select modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c != 'Not started' AND modigie__Validate_Employer_Status__c != 'Unavailable') WITH SECURITY_ENFORCED]; 
                    }
                  }
                  else if(buttonPressed?.equalsIgnoreCase('GetLinkedIn') == true){
                    if(objectName?.equalsIgnoreCase('Contact') == true){
                        validatedRecords =  [SELECT count() FROM Contact WHERE Id IN :recid AND Id  IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Linkedin_Status__c    = 'Validated') WITH SECURITY_ENFORCED];
                        invalidatedRecords = [SELECT count() FROM Contact WHERE Id IN :recId AND  Id IN (SELECT modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Linkedin_Status__c  ='Not Available') WITH SECURITY_ENFORCED];
                        recordsRunning = [SELECT count() FROM Contact WHERE Id IN :recId AND Id IN (SELECT modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Linkedin_Status__c  = 'In process') WITH SECURITY_ENFORCED];
                        notFulfill = [SELECT count() FROM Contact WHERE Id IN :recId AND (FirstName = null OR Account.Name  = null OR Email = null) AND Id NOT IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Linkedin_Status__c != 'Not started' AND modigie__Linkedin_Status__c != 'Unavailable') WITH SECURITY_ENFORCED];
                        recordsToProcess = [SELECT count() FROM Contact WHERE Id IN :recId AND (Account.Name != null AND (modigie__linkedin_url__c  = null AND FirstName != null AND Account.Name != null AND Email != null)) AND Id NOT IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Linkedin_Status__c != 'Not started' AND modigie__Linkedin_Status__c != 'Unavailable') WITH SECURITY_ENFORCED];
                        userFilled = [SELECT count() FROM Contact WHERE Id IN :recId AND (modigie__linkedin_url__c != null) AND Id NOT IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Linkedin_Status__c != 'Not started' AND modigie__Linkedin_Status__c != 'Unavailable') WITH SECURITY_ENFORCED];
                    }
                    
                    else if(objectName?.equalsIgnoreCase('Lead') == true){
                        validatedRecords =  [SELECT count() FROM Lead WHERE Id IN :recid AND Id  IN (Select modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Linkedin_Status__c    = 'Validated') WITH SECURITY_ENFORCED];
                        invalidatedRecords = [SELECT count() FROM Lead WHERE Id IN :recId AND  Id IN (SELECT modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Linkedin_Status__c  ='Not Available') WITH SECURITY_ENFORCED];
                        recordsRunning = [SELECT    count() FROM Lead WHERE Id IN :recId AND Id IN (SELECT modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Linkedin_Status__c  = 'In process') WITH SECURITY_ENFORCED];
                        notFulfill = [SELECT count() FROM Lead WHERE Id IN :recId AND (FirstName = null OR Company  = null OR Email = null) AND Id NOT IN (Select modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Linkedin_Status__c != 'Not started' AND modigie__Linkedin_Status__c != 'Unavailable') WITH SECURITY_ENFORCED];
                        recordsToProcess = [SELECT count() FROM Lead WHERE Id IN :recId AND (Company != null AND (modigie__linkedin_url__c  = null AND FirstName != null AND Company != null AND Email != null)) AND Id NOT IN (Select modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Linkedin_Status__c != 'Not started' AND modigie__Linkedin_Status__c != 'Unavailable') WITH SECURITY_ENFORCED];
                        userFilled = [SELECT count() FROM Lead WHERE Id IN :recId AND (modigie__linkedin_url__c != null) AND Id NOT IN (Select modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Linkedin_Status__c != 'Not started' AND modigie__Linkedin_Status__c != 'Unavailable') WITH SECURITY_ENFORCED];
                    }    
                  }
                
                  else if(buttonPressed?.equalsIgnoreCase('GetMobileNumber') == true || buttonPressed?.equalsIgnoreCase('GetModigie') == true){
                        if(objectName?.equalsIgnoreCase('Contact') == true){
                            validatedRecords =  [SELECT count() FROM Contact WHERE Id IN :recid AND Id  IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Status__c    = 'Validated') WITH SECURITY_ENFORCED];
                            invalidatedRecords = [SELECT count() FROM Contact WHERE Id IN :recId AND  Id IN (SELECT modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Status__c  ='Not Available') WITH SECURITY_ENFORCED];
                            recordsRunning = [SELECT count() FROM Contact WHERE Id IN :recId AND Id IN (SELECT modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Status__c  = 'In process') WITH SECURITY_ENFORCED];
                            notFulfill = [SELECT count() FROM Contact WHERE Id IN :recId AND (Account.Name = null OR FirstName = null OR Email = null) AND Id NOT IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Status__c != 'Not started' AND modigie__Status__c != 'Unavailable') WITH SECURITY_ENFORCED];
                            recordsToProcess = [SELECT count() FROM Contact WHERE Id IN :recId AND (Account.Name != null AND Email  != null AND FirstName != null) AND Id NOT IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Status__c != 'Not started' AND modigie__Status__c != 'Unavailable') WITH SECURITY_ENFORCED];
                        
                        
                          /*  validatedRecords =  [SELECT count() FROM CampaignMember WHERE CampaignId =: recid AND ContactId !=null  AND ContactId  IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Status__c   = 'Validated') WITH SECURITY_ENFORCED];
                            invalidatedRecords = [SELECT count() FROM CampaignMember WHERE CampaignId = :recId AND ContactId != null AND ContactId IN (SELECT modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Status__c ='Not Available') WITH SECURITY_ENFORCED];
                            recordsRunning = [SELECT count() FROM CampaignMember WHERE CampaignId = :recId AND ContactId != null AND ContactId IN (SELECT modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Status__c = 'In process') WITH SECURITY_ENFORCED];
                            notFulfill = [SELECT count() FROM CampaignMember WHERE CampaignId = :recId AND ContactId != null AND ContactId IN (SELECT Id FROM Contact WHERE FirstName = null OR Account.Name = null OR Email = null) AND ContactId NOT IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Status__c != 'Not started' AND modigie__Status__c != 'Network error, please try again') WITH SECURITY_ENFORCED];
                            recordsToProcess = [SELECT count() FROM CampaignMember WHERE CampaignId = :recId AND ContactId != null AND ContactId IN (SELECT Id FROM Contact WHERE  FirstName != null AND Account.Name != null AND Email != null) AND ContactId NOT IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Status__c != 'Not started' AND modigie__Status__c != 'Network error, please try again') WITH SECURITY_ENFORCED];*/
                        }
                        
                        else if(objectName?.equalsIgnoreCase('Lead') == true){
                            
                           
                            validatedRecords =  [SELECT count() FROM Lead WHERE Id IN :recid AND Id  IN (Select modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Status__c    = 'Validated') WITH SECURITY_ENFORCED];
                            invalidatedRecords = [SELECT count() FROM Lead WHERE Id IN :recId AND  Id IN (SELECT modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Status__c  ='Not Available') WITH SECURITY_ENFORCED];
                            recordsRunning = [SELECT count() FROM Lead WHERE Id IN :recId AND Id IN (SELECT modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Status__c  = 'In process') WITH SECURITY_ENFORCED];
                            notFulfill = [SELECT count() FROM Lead WHERE Id IN :recId AND (Company = null OR FirstName = null OR Email = null) AND Id NOT IN (Select modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Status__c != 'Not started' AND modigie__Status__c != 'Unavailable') WITH SECURITY_ENFORCED];
                            recordsToProcess = [SELECT count() FROM Lead WHERE Id IN :recId AND (Company != null AND Email  != null AND FirstName != null) AND Id NOT IN (Select modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Status__c != 'Not started' AND modigie__Status__c != 'Unavailable') WITH SECURITY_ENFORCED];
                        }
                    }
                
                    
                    

                    if(recordsToProcess > 0){
                        camMem.put('TokenExist', 1);
                    }
                    else{
                        camMem.put('TokenExist', -3);
                    }
                    
                    camMem.put('totalSize', totalMembersList);
                    camMem.put('alreadyValidated', validatedRecords);
                    camMem.put('recordsRunning', recordsRunning);
                    camMem.put('recordsToProcess', recordsToProcess);
                    camMem.put('invalidatedRecords', invalidatedRecords);
                    camMem.put('notFulfill', notFulfill);
                    camMem.put('userFilled', userFilled);

                    return JSON.serialize(camMem);
                    
            }
            else{
                throw new listViewControllerException('You are not an authorised user.');   
            }
            
        }
        catch(LimitException e)
        {
            throw new listViewControllerException('You cannot process more than 50,000 records.');
        }
        catch(System.QueryException e){
            throw new listViewControllerException('You do not have permission to query lead, contact or modigie fields.');
        }
        catch(Exception e)
        {
            throw new listViewControllerException(e.getMessage());
        }
    }


   

    @AuraEnabled
    public static List<Id> requestPhoneIntelJobs(List<sObject> selectedrecords,String objectname,String inputNumbers){
        try{
            
        
            Map<String, String> securityMap = new Map<String, String>();
            Map<String, String> securityCampaignMemberMap = new Map<String, String>();
            
    
                securityCampaignMemberMap.put('CampaignId', 'CampaignMember');
                securityCampaignMemberMap.put('ContactId', 'CampaignMember');
                securityCampaignMemberMap.put('LeadId', 'CampaignMember');
                
                securityMap.put('AccountId', 'Contact');
                securityMap.put('FirstName', 'Contact');
                securityMap.put('LastName', 'Contact');
                securityMap.put('Email', 'Contact');
                securityMap.put('MobilePhone', 'Contact');
                securityMap.put('modigie__linkedin_url__c', 'Contact');
                securityMap.put('Phone', 'Contact');
                securityMap.put('OtherPhone', 'Contact');
                securityMap.put('Name', 'Account');
                securityMap.put('FirstName', 'Lead');
                securityMap.put('LastName', 'Lead');
                securityMap.put('Email', 'Lead');
                securityMap.put('Company', 'Lead');
                securityMap.put('MobilePhone', 'Lead');
                securityMap.put('modigie__linkedin_url__c', 'Lead');
                securityMap.put('modigie__Contact__c', 'modigie__Modigie__c');
                securityMap.put('modigie__Lead__c', 'modigie__Modigie__c');
                securityMap.put('modigie__Linkedin_Status__c', 'modigie__Modigie__c');
    
                Boolean checkMember = FieldLevelSecurityCheck.checkSecurityForRead(securityCampaignMemberMap);
                Boolean check = FieldLevelSecurityCheck.checkSecurity(securityMap);
                if(check){
                    Map<String,Object> mapInputNumbers = (Map<String,Object>)JSON.deserializeUntyped(inputNumbers);
            
                    Map<String,Object> result = new Map<String,Object>{'isContact'=>false,'Mobile' => true, 'Phone' => true, 'OtherPhone' => true, 'ModigieValNumber' => true,'Alternate1' => true,'Alternate2'=>true,'MobileNumber'=>'','PhoneNumber'=>'','OtherNumber'=>'','ModigieNumber'=>'','AlternateNumber1'=>'','AlternateNumber2'=>''};
            
                    List<sObject> lstSobj = new List<sObject>();
                    String queryForCon = 'SELECT Id, FirstName, LastName, Email, AccountId, modigie__linkedin_url__c,MobilePhone, Phone, OtherPhone FROM Contact WHERE Id IN : selectedrecords AND (';
                    String queryForLead = 'SELECT Id, FirstName, LastName, Email, Company, modigie__linkedin_url__c,MobilePhone, Phone FROM Lead WHERE Id IN : selectedrecords AND (';
            
                    if(objectname?.equalsIgnoreCase('Lead') == true)
                    {
                        if(mapInputNumbers.get('selectedFieldsLead').toString().containsIgnoreCase('Mobile')){
                            queryForLead += ' MobilePhone != null OR';
                        }

                        if(mapInputNumbers.get('selectedFieldsLead').toString().containsIgnoreCase('Phone')){
                            queryForLead += ' Phone != null OR';
                        }

                        if(queryForLead.lastIndexOf('OR') != -1){
                            queryForLead = queryForLead.substring(0,queryForLead.lastIndexOf('OR'));
                            queryForLead += ') WITH SECURITY_ENFORCED';
                            List<SObject> ldLst = Database.query(queryForLead);
                            lstSobj.addAll(ldLst);
                        }
                    }
                    else if(objectname?.equalsIgnoreCase('Contact') == true)
                    {
                        if(mapInputNumbers.get('selectedFieldsContact').toString().containsIgnoreCase('Mobile')){
                            queryForCon += ' MobilePhone != null OR';
                        }
                            
                        if(mapInputNumbers.get('selectedFieldsContact').toString().containsIgnoreCase('Phone')){
                            queryForCon += ' Phone != null OR';
                        }
                
                        if(mapInputNumbers.get('selectedFieldsContact').toString().containsIgnoreCase('Other')){
                            queryForCon += ' OtherPhone != null OR';
                        }

                        if(queryForCon.lastIndexOf('OR') != -1){
                            queryForCon = queryForCon.substring(0,queryForCon.lastIndexOf('OR'));
                            queryForCon += ') WITH SECURITY_ENFORCED';
                            List<sObject> conLst = Database.query(queryForCon);
                            lstSobj.addAll(conLst);
                        }
                    }
                    
                    List<modigie__Modigie__c> lstModigie = [SELECT id,modigie__Contact__c,modigie__Lead__c,modigie__Mobile_2__c,modigie__Mobile_3__c FROM modigie__Modigie__c WHERE modigie__Lead__c IN :lstSobj OR modigie__Contact__c IN :lstSobj WITH SECURITY_ENFORCED];
            
                    Map<String,modigie__Modigie__c> mapModigie = new Map<String,modigie__Modigie__c>();
            
                    for(modigie__Modigie__c modigie : lstModigie){
                        if(modigie.modigie__Contact__c != null){
                            mapModigie.put(modigie.modigie__Contact__c,modigie);
                        }
                        else if(modigie.modigie__Lead__c != null){
                            mapModigie.put(modigie.modigie__Lead__c,modigie);
                        }        
                    }
            
            
                    List<Id> lstBatchJobsIds = new List<Id>();
    
                       
                    if(lstSobj.size() > 0){
                        ListViewGetPhoneInsightsBatchClass b1 = new ListViewGetPhoneInsightsBatchClass(lstSobj,inputNumbers);
                        Integer b_size = 100;
                        try{
                            b_size = Integer.valueOf(System.Label.modigie.Batch_Size_Invocable);
                            if(b_size > 100 || b_size < 1){
                                b_size = 100;
                            }
                        }catch(Exception e){}
                        Id jobId =Database.executeBatch(b1,b_size); 
                
                        lstBatchJobsIds.add(jobId);
                    }
            
                    return lstBatchJobsIds;
                } 
                else {
                    throw new listViewControllerException('User does not have the required object edit permissions.');
                }
            }
            catch(ServerErrorException e){
                throw new ServerErrorException(e.getMessage());
            }
            catch(Exception e)
            {
                Map <String,Object> errorMap = new Map<String,Object>();
                errorMap.put('DisplayMessage', e.getLineNumber());
                throw new listViewControllerException(JSON.serialize(errorMap));
            } 
    }  


    @AuraEnabled
    public static List<Id> requestLinkedInUrls(List<sObject> selectedrecords,String objectname)
    {
        try
        {
            Map<String, String> securityMap = new Map<String, String>();
            Map<String, String> securityCampaignMemberMap = new Map<String, String>();
            List<Contact> contactList = new List<Contact>();
            List<Lead> leadList = new List<Lead>();
            
            securityCampaignMemberMap.put('CampaignId', 'CampaignMember');
            securityCampaignMemberMap.put('ContactId', 'CampaignMember');
            securityCampaignMemberMap.put('LeadId', 'CampaignMember');
            
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
            securityMap.put('modigie__Linkedin_Status__c', 'modigie__Modigie__c');
            
           // Boolean checkMember = FieldLevelSecurityCheck.checkSecurityForRead(securityCampaignMemberMap);
            Boolean check = FieldLevelSecurityCheck.checkSecurity(securityMap);
            
            if(check){
           
                if(objectname?.equalsIgnoreCase('Contact') == true)
                {
                contactList = [SELECT id,modigie__linkedin_url__c,Account.Name,Email,FirstName FROM Contact WHERE (id  IN : selectedrecords AND modigie__linkedin_url__c = NULL AND FirstName != null AND Account.Name != null AND Email != null) AND Id NOT IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Linkedin_Status__c != 'Not started' AND modigie__Linkedin_Status__c != 'Unavailable') WITH SECURITY_ENFORCED];                 
                }
                else if(objectname?.equalsIgnoreCase('Lead') == true)
                {
                leadList = [SELECT id,FirstName,Company,Email,modigie__linkedin_url__c FROM Lead WHERE (Id IN : selectedrecords AND modigie__linkedin_url__c = null AND FirstName != null AND Company != null AND Email != null) AND Id NOT IN (Select modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Linkedin_Status__c != 'Not started' AND modigie__Linkedin_Status__c != 'Unavailable') WITH SECURITY_ENFORCED];
                }

                
                Set<Id> setOfContactIds = new Set<Id>();
                
                for(Contact cm : contactList)
                {
                    setOfContactIds.add(cm.Id);
                }
                
                Set<ID> setOfLeadIds = new Set<ID>();
                List<Lead> ldLst = new List<Lead>();
                List<Contact> conLst = new List<Contact>();

                for(Lead cm : leadList)
                {
                    setOfLeadIds.add(cm.Id);
                }
                if(objectname?.equalsIgnoreCase('Contact') == true)
                {
                conLst = [SELECT Id, Account.Name,Email,Account.BillingStreet,Account.BillingPostalCode,Account.BillingCity,Account.BillingState,Account.BillingCountry,modigie__linkedin_url__c,FirstName, LastName, modigie__Company_URL__c,MobilePhone,(SELECT id FROM modigie__Modigie__r) FROM Contact Where Id IN :setOfContactIds WITH SECURITY_ENFORCED];
                }

                if(objectname?.equalsIgnoreCase('Lead') == true)
                {
                ldLst = [SELECT Id, FirstName, LastName, Email,Company, modigie__Company_URL__c, modigie__linkedin_url__c,MobilePhone,(SELECT id FROM modigie__Modigie__r) FROM Lead WHERE Id In :setOfLeadIds WITH SECURITY_ENFORCED];
                }

                List<Id> lstBatchJobsIds = new List<Id>();

                                
                List<modigie__Modigie_Service_Account__mdt> serviceAccountDetails = ModigieApiUtils.getServiceAccountDetails();

                if(!serviceAccountDetails.isEmpty()){
                    List<modigie__Modigie_Callout_Info__mdt> calloutInfo = [SELECT Id, modigie__Endpoint_Url__c, modigie__targetAud__c, modigie__Content_Type__c FROM modigie__Modigie_Callout_Info__mdt WHERE MasterLabel = 'PhoneIntelligence Job Create' LIMIT 1];
                    String targetAudience, endpoint, contentType;
                    if(!calloutInfo.isEmpty()){
                        endpoint = calloutInfo[0].modigie__Endpoint_Url__c;
                        targetAudience = calloutInfo[0].modigie__targetAud__c;
                        contentType = calloutInfo[0].modigie__Content_Type__c;
                    }

                    String accessToken = 'Bearer ' + jwtapex.get_access_token(serviceAccountDetails[0].modigie__Email__c,targetAudience,serviceAccountDetails[0].modigie__Private_Key__c);
                    //String accessToken = 'Bearer ' + jwtapex.get_access_token(modigieCredential[0].modigie__Service_Account_Credentials__c,'https://modigie-engage-gateway-kyaxv4ttua-uc.a.run.app',modigieCredential[0].modigie__Private_Key__c);
                    Integer b_size = 100;
                    try{
                        b_size = Integer.valueOf(System.Label.modigie.Batch_Size_Invocable);
                        if(b_size > 100 || b_size < 1){
                            b_size = 100;
                        }
                    }catch(Exception e){}
                    //String accessToken;
                    if(objectname?.equalsIgnoreCase('Contact') == true){
                        ListViewGetLinkedInBatchClass b1 = new ListViewGetLinkedInBatchClass(conLst,accessToken,'Contact');
                        Id jobId = Database.executeBatch(b1,b_size);
                        lstBatchJobsIds.add(jobId);
                    }
                    
                    if(objectname?.equalsIgnoreCase('Lead') == true){
                        ListViewGetLinkedInBatchClass b2 = new ListViewGetLinkedInBatchClass(ldLst,accessToken,'Lead'); 
                        Id jobId = Database.executeBatch(b2,b_size);
                        lstBatchJobsIds.add(jobId);
                    }
                }
                else{
                    throw new listViewControllerException('You are not an authorized user.');
                }
               
                return lstBatchJobsIds;
            }
            else{
                throw new listViewControllerException('User does not have the required object edit permissions.');
            }
            
        }
        catch(ServerErrorException e){
            Map <String,Object> errorMap = (Map <String,Object>)JSON.deserializeUntyped(e.getMessage());
            errorMap.put('ModigieService','Get LinkedIn'); 
           // errorMap.put('SObjectId',recid);
            throw new ServerErrorException(JSON.serialize(errorMap));
        }
        catch(Exception e)
        {
            Map <String,Object> errorMap = new Map<String,Object>();
            errorMap.put('DisplayMessage', e.getMessage());
            throw new listViewControllerException(JSON.serialize(errorMap));
        } 
        
    }


    @AuraEnabled
    public static List<Id> requestgetmodigie(List<sObject> selectedrecords,String objectname)
    {
        try
        {
            Map<String, String> securityMap = new Map<String, String>();
            Map<String, String> securityCamapaignMemberMap = new Map<String, String>();
            List<Contact> contactList = new List<Contact>();
            List<Lead> leadList = new List<Lead>();
            
            securityCamapaignMemberMap.put('CampaignId', 'CampaignMember');
            securityCamapaignMemberMap.put('ContactId', 'CampaignMember');
            securityCamapaignMemberMap.put('LeadId', 'CampaignMember');
            
            securityMap.put('AccountId', 'Contact');
            securityMap.put('FirstName', 'Contact');
            securityMap.put('LastName', 'Contact');
            securityMap.put('Email', 'Contact');
            securityMap.put('MobilePhone', 'Contact');
            securityMap.put('modigie__linkedin_url__c', 'Contact');
            securityMap.put('modigie__Modigie_Verified_Number__c', 'Contact');
            securityMap.put('Name', 'Account');
            securityMap.put('FirstName', 'Lead');
            securityMap.put('LastName', 'Lead');
            securityMap.put('Email', 'Lead');
            securityMap.put('Company', 'Lead');
            securityMap.put('MobilePhone', 'Lead');
            securityMap.put('modigie__Modigie_Verified_Number__c', 'Lead');
            securityMap.put('modigie__linkedin_url__c', 'Lead');
            securityMap.put('modigie__Contact__c', 'modigie__Modigie__c');
            securityMap.put('modigie__Lead__c', 'modigie__Modigie__c');
            securityMap.put('modigie__Status__c', 'modigie__Modigie__c');
            
            Boolean check = FieldLevelSecurityCheck.checkSecurity(securityMap);
            Boolean checkMember = FieldLevelSecurityCheck.checkSecurityForRead(securityCamapaignMemberMap);
            
            if(check){

                contactList = [SELECT Id,FirstName,Account.Name,Email FROM Contact WHERE (Id IN : selectedrecords AND FirstName != null AND Account.Name != null AND Email != null) AND Id NOT IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Status__c = 'In process' OR modigie__Status__c = 'Validated' OR modigie__Status__c = 'Not Available') WITH SECURITY_ENFORCED]; 
                //contactList = [SELECT ContactId FROM CampaignMember WHERE CampaignId = :recid AND ContactId !=null AND ContactId NOT IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Get_Modigie_Job_Status__c != NULL)];
                        
                //leadList = [SELECT LeadId, FirstName, LastName FROM CampaignMember WHERE CampaignId =: recid AND LeadId !=null AND LeadId IN (SELECT Id FROM Lead where modigie__Modigie_Verified_Number__c = null) AND LeadId NOT IN (Select modigie__Lead__c FROM modigie__Modigie__c)];
                leadList = [SELECT Id,FirstName,Company,Email FROM Lead WHERE (Id IN : selectedrecords AND FirstName != null AND Company != null AND Email != null) AND Id NOT IN (Select modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Status__c = 'In process' OR modigie__Status__c = 'Validated' OR modigie__Status__c = 'Not Available') WITH SECURITY_ENFORCED];
                //leadList =    [SELECT LeadId FROM CampaignMember WHERE CampaignId =: recid AND LeadId !=null AND LeadId NOT IN (Select modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Get_Modigie_Job_Status__c != NULL)];
            
            
                Set<Id> setOfContactIds = new Set<Id>();
            
                for(Contact con : contactList)
                {
                    setOfContactIds.add(con.Id);
                }
            
                Set<ID> setOfLeadIds = new Set<ID>();
                
                for(Lead l : leadList)
                {
                    setOfLeadIds.add(l.Id);
                }



            
                List<Contact> conLst = [SELECT Id, Account.Name,Email, Account.BillingStreet,Account.BillingPostalCode,Account.BillingCity,Account.BillingState,Account.BillingCountry,modigie__linkedin_url__c,FirstName, LastName, modigie__Company_URL__c,MobilePhone,modigie__Modigie_Verified_Number__c,(SELECT id FROM modigie__Modigie__r) FROM Contact Where Id IN :setOfContactIds WITH SECURITY_ENFORCED];
                List<Lead> ldLst = [SELECT Id, FirstName, LastName, Email, Company, modigie__Company_URL__c, modigie__linkedin_url__c,MobilePhone,modigie__Modigie_Verified_Number__c,(SELECT id FROM modigie__Modigie__r) FROM Lead WHERE Id In :setOfLeadIds WITH SECURITY_ENFORCED];
                
                List<Id> lstBatchJobsIds = new List<Id>();

                // List <modigie__Modigie_Credentials__c> modigieCredential = [SELECT Id, modigie__Api_key__c, modigie__Credits_Account_Id__c, modigie__Private_key__c, modigie__Service_Account_Credentials__c FROM modigie__Modigie_Credentials__c WITH SECURITY_ENFORCED LIMIT 1];
               
                List<modigie__Modigie_Service_Account__mdt> serviceAccountDetails = ModigieApiUtils.getServiceAccountDetails();
                List<modigie__Modigie_Callout_Info__mdt> calloutInfo = [SELECT Id, modigie__Endpoint_Url__c, modigie__targetAud__c, modigie__Content_Type__c FROM modigie__Modigie_Callout_Info__mdt WHERE MasterLabel = 'PhoneIntelligence Job Create' LIMIT 1];
                String targetAudience, endpoint, contentType;
                if(!calloutInfo.isEmpty()){
                    endpoint = calloutInfo[0].modigie__Endpoint_Url__c;
                    targetAudience = calloutInfo[0].modigie__targetAud__c;
                    contentType = calloutInfo[0].modigie__Content_Type__c;
                }

                String accessToken = 'Bearer ' + jwtapex.get_access_token(serviceAccountDetails[0].modigie__Email__c,targetAudience,serviceAccountDetails[0].modigie__Private_Key__c);
                //String accessToken = 'Bearer ' + jwtapex.get_access_token(modigieCredential[0].modigie__Service_Account_Credentials__c,'https://modigie-engage-gateway-kyaxv4ttua-uc.a.run.app',modigieCredential[0].modigie__Private_Key__c);
                
                if(!serviceAccountDetails.isEmpty()){
                    Integer b_size = 100;
                    try{
                        b_size = Integer.valueOf(System.Label.modigie.Batch_Size_Invocable);
                        if(b_size > 100 || b_size < 1){
                            b_size = 100;
                        }
                    }catch(Exception e){}
                    if(conLst.size()>0)
                    {
                        ListViewGetModigieBatchClass b1 = new ListViewGetModigieBatchClass(conLst,accessToken,'Contact');
                        
                        Id jobId = Database.executeBatch(b1,b_size);
                        lstBatchJobsIds.add(jobId);
                    }
                    
                    if(ldLst.size()>0)
                    {
                        ListViewGetModigieBatchClass b2 = new ListViewGetModigieBatchClass(ldLst,accessToken,'Lead');
                        Id jobId = Database.executeBatch(b2,b_size);
                        lstBatchJobsIds.add(jobId);
                    }
                }
                
                else{
                    throw new listViewControllerException('You are not an authorized user.');
                }
            
                return lstBatchJobsIds;
            }
            else{
                throw new listViewControllerException('User does not have the required object edit permissions.');
            }
            
        }
        catch(ServerErrorException e){
            Map <String,Object> errorMap = (Map <String,Object>)JSON.deserializeUntyped(e.getMessage());
            errorMap.put('ModigieService','Get Modigie'); 
        //    errorMap.put('SObjectId',recid);
            throw new ServerErrorException(JSON.serialize(errorMap));
        }
        catch(System.QueryException e){
            Map <String,Object> errorMap = new Map<String,Object>();
            errorMap.put('DisplayMessage', 'You do not have permission to query lead, contact or modigie fields.');
            throw new listViewControllerException(JSON.serialize(errorMap)); 
            //throw new listViewControllerException(e.getMessage()+'-----'+e.getLineNumber());
        }
        catch(Exception e)
        {
            Map <String,Object> errorMap = new Map<String,Object>();
            errorMap.put('DisplayMessage', e.getMessage());
            throw new listViewControllerException(JSON.serialize(errorMap)); 
        } 
    }


    @AuraEnabled
    public static List<Id> requestverifyemployer(List<sObject> selectedrecords,String objectname)
    {
        try
        {
            
            List<Contact> contactList = new List<Contact>();
            List<Lead> leadList = new List<Lead>();
            Map<String, String> securityMap = new Map<String, String>();
            
           
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
           
            
            if(check){
                contactList = [SELECT Id,FirstName,LastName FROM Contact WHERE (Id IN : selectedrecords AND Account.Name != null ) AND Id NOT IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c != 'Not started' AND modigie__Validate_Employer_Status__c != 'Unavailable') WITH SECURITY_ENFORCED];
                leadList = [SELECT Id,FirstName,LastName FROM Lead WHERE (Id IN : selectedrecords AND company != null ) AND Id NOT IN (Select modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c != 'Not started' AND modigie__Validate_Employer_Status__c != 'Unavailable') WITH SECURITY_ENFORCED];
                
                Set<Id> setOfContactIds = new Set<Id>();
                
                for(Contact con : contactList)
                {
                    setOfContactIds.add(con.Id);
                }
                
                Set<ID> setOfLeadIds = new Set<ID>();
                for(Lead l : leadList)
                {
                    setOfLeadIds.add(l.Id); 
                }
               
                List<sObject> sobj1 = [SELECT FirstName,LastName,AccountId,modigie__Modigie_Verified_Number__c,MobilePhone,Email,modigie__linkedin_url__c FROM Contact WHERE Id IN : setOfContactIds AND (modigie__linkedin_url__c != null OR FirstName != null) AND Account.Name != null AND Id NOT IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c != 'Not started' AND modigie__Validate_Employer_Status__c != 'Unavailable') WITH SECURITY_ENFORCED];
                List<sObject> sobj2 = [SELECT FirstName,LastName,Company,modigie__Modigie_Verified_Number__c,MobilePhone,Email,modigie__linkedin_url__c FROM Lead WHERE Id IN : setOfLeadIds AND (modigie__linkedin_url__c != null  OR FirstName != null ) AND  Company != null AND Id NOT IN (Select modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c != 'Not started' AND modigie__Validate_Employer_Status__c != 'Unavailable') WITH SECURITY_ENFORCED];

                List<sObject> lstSobj = new List<sObject>();
                lstSobj.addAll(sobj1);
                lstSobj.addAll(sobj2);

                List<Id> lstBatchJobsIds = new List<Id>();

                if(lstSobj.size() > 0){
                    Integer b_size = 100;
                    try{
                        b_size = Integer.valueOf(System.Label.modigie.Batch_Size_Invocable);
                        if(b_size > 100 || b_size < 1){
                            b_size = 100;
                        }
                    }catch(Exception e){}
                    ListViewVerifyEmployerBatchClass batchable = new ListViewVerifyEmployerBatchClass(lstSobj);
                    Id jobId = Database.executeBatch(batchable,b_size);
                    lstBatchJobsIds.add(jobId);
                }
                
                return lstBatchJobsIds;
            }
            else{
                throw new ServerErrorException('You do not have permission to query lead, contact or modigie fields.');
            }
        }
        catch(ServerErrorException e){
            throw new ServerErrorException(e.getMessage());
        }
        catch(Exception e)
        {
            Map <String,Object> errorMap = new Map<String,Object>();
            errorMap.put('DisplayMessage',e.getMessage());
            throw new listViewControllerException(JSON.serialize(errorMap));
        }
    }


    private class listViewControllerException extends Exception{}
}