global with sharing class GetModigieContactInvocable {
    @InvocableMethod
    global static void getRecordId(List<String> lstIds){
        try{
            if(FieldLevelSecurityCheck.canReadObject('Contact')&&
               FieldLevelSecurityCheck.canReadField('Contact', 'modigie__Modigie_Verified_Number__c')&&
               FieldLevelSecurityCheck.canReadField('Contact', 'modigie__Alternate_Mobile_Phone_Available__c')&&
               FieldLevelSecurityCheck.canReadField('Contact', 'modigie__Validation_Key__c')&&
               FieldLevelSecurityCheck.canUpdateField('Contact', 'modigie__Validation_Key__c')){
                   List<modigie__Modigie_Credentials__c> tokenList = new List<modigie__Modigie_Credentials__c>();
                   tokenList = [SELECT Name, modigie__Credits_Account_Id__c,modigie__API_Key__c,modigie__Service_Account_Credentials__c,modigie__Private_Key__c FROM modigie__Modigie_Credentials__c  WITH SECURITY_ENFORCED LIMIT 1];
                   if(!tokenList.isEmpty()){
                       List<Contact> conLst = [SELECT Id, Account.Name,Email, Account.BillingStreet,Account.BillingPostalCode,Account.BillingCity,Account.BillingState,Account.BillingCountry,modigie__linkedin_url__c,FirstName, LastName, modigie__Company_URL__c,MobilePhone,modigie__Modigie_Verified_Number__c,(SELECT id, modigie__Mobile_2__c, modigie__Mobile_3__c FROM modigie__Modigie__r) FROM Contact Where Id IN :lstIds AND FirstName != null AND Account.Name != null AND Email != null AND Id NOT IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Status__c = 'In process' OR modigie__Status__c = 'Validated' OR modigie__Status__c = 'Not Available') WITH SECURITY_ENFORCED];
                       if(!conLst.isEmpty()){
                            Integer b_size = 100;
                            try{
                                b_size = Integer.valueOf(System.Label.modigie.Batch_Size_Invocable);
                                if(b_size > 100 || b_size < 1){
                                    b_size = 100;
                                }
                            }catch(Exception e){}
                           ContactBatchForGetModigieButton batchable = new ContactBatchForGetModigieButton(conLst,1);
                           Database.executeBatch(batchable,b_size);    
                       }
                   }        
               }    
        }
        catch(Exception e){}
        
    }
}