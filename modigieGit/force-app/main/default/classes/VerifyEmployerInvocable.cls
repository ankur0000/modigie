global with sharing class VerifyEmployerInvocable 
{
    global static boolean var = true;
    @InvocableMethod
    global static void getRecordId(List<String> lstIds) 
    {   
        try{
            if(FieldLevelSecurityCheck.canReadObject('Lead')&&
               FieldLevelSecurityCheck.canReadField('Lead', 'modigie__Modigie_Verified_Number__c')&&
               FieldLevelSecurityCheck.canReadField('Lead', 'modigie__Alternate_Mobile_Phone_Available__c')&&
               FieldLevelSecurityCheck.canReadField('Lead', 'modigie__Validation_Key__c')&&
               FieldLevelSecurityCheck.canUpdateField('Lead', 'modigie__Validation_Key__c'))
            {
                List<modigie__Modigie_Service_Account__mdt> tokenList = ModigieApiUtils.getServiceAccountDetails();
                // List<modigie__Modigie_Credentials__c> tokenList = new List<modigie__Modigie_Credentials__c>();
                // tokenList = [SELECT Name, modigie__Credits_Account_Id__c,modigie__API_Key__c,modigie__Service_Account_Credentials__c,modigie__Private_Key__c FROM modigie__Modigie_Credentials__c  WITH SECURITY_ENFORCED LIMIT 1];
                if(tokenList.size() > 0){
                    List<Contact> conLst = [SELECT Id, Account.Name,modigie__Company_Email__c, Account.BillingStreet,Account.BillingPostalCode,Account.BillingCity,Account.BillingState,Account.BillingCountry,modigie__linkedin_url__c,FirstName, LastName, Email, modigie__Modigie_Verified_Number__c, modigie__Company_URL__c,MobilePhone,(SELECT id FROM modigie__Modigie__r) FROM Contact Where Id IN :lstIds AND Account.Name != null AND (modigie__linkedin_url__c  != null OR FirstName != null) AND Id NOT IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c = 'In process' OR modigie__Validate_Employer_Status__c = 'Validated' OR modigie__Validate_Employer_Status__c = 'Not Available') WITH SECURITY_ENFORCED LIMIT 50000];
                    List<Lead> ldLst = [SELECT Id, FirstName, LastName, modigie__Company_Email__c,Email, Company, modigie__Company_URL__c, modigie__linkedin_url__c,MobilePhone, modigie__Modigie_Verified_Number__c, (SELECT id FROM modigie__Modigie__r) FROM Lead WHERE Id In :lstIds AND company != null AND (modigie__linkedin_url__c != null OR FirstName != null) AND Id NOT IN (Select modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Validate_Employer_Status__c = 'In process' OR modigie__Validate_Employer_Status__c = 'Validated' OR modigie__Validate_Employer_Status__c = 'Not Available') WITH SECURITY_ENFORCED LIMIT 50000];
                    List<sObject> lstSobj = new List<sObject>();
                    lstSobj.addAll(conLst);
                    lstSobj.addAll(ldLst);
                    if(!lstSobj.isEmpty()){
                        Integer b_size = 100;
                        try{
                            b_size = Integer.valueOf(System.Label.modigie.Batch_Size_Invocable);
                            if(b_size > 100 || b_size < 1){
                                b_size = 100;
                            }
                        }catch(Exception e){}
                    	VerifyEmployerDataMaintainenceClass batchable = new VerifyEmployerDataMaintainenceClass(lstSobj, 2);
                    	Database.executeBatch(batchable,b_size);    
                    }
                } 
            }
        }
        catch(Exception e){}
    } 
    
}