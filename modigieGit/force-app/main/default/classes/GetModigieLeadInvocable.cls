global with sharing class GetModigieLeadInvocable {
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
                List<modigie__Modigie_Credentials__c> tokenList = new List<modigie__Modigie_Credentials__c>();
                tokenList = [SELECT Id  FROM modigie__Modigie_Credentials__c  WITH SECURITY_ENFORCED LIMIT 1];
                if(tokenList.size() > 0){
                    List<Lead> ldLst = [SELECT Id, FirstName, LastName, Email, Company, modigie__Company_URL__c, modigie__linkedin_url__c,MobilePhone,modigie__Modigie_Verified_Number__c,(SELECT id FROM modigie__Modigie__r) FROM Lead WHERE Id In :lstIds AND FirstName != null AND Company != null AND Email != null AND Id NOT IN (Select modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Status__c = 'In process' OR modigie__Status__c = 'Validated' OR modigie__Status__c = 'Not Available') WITH SECURITY_ENFORCED];
                    if(!ldLst.isEmpty()){
                        Integer b_size = 100;
                            try{
                                b_size = Integer.valueOf(System.Label.modigie.Batch_Size_Invocable);
                                if(b_size > 100 || b_size < 1){
                                    b_size = 100;
                                }
                            }catch(Exception e){}
                        LeadBatchForGetModigieButton batchable = new LeadBatchForGetModigieButton(ldLst, 2);
                        Database.executeBatch(batchable,b_size);    
                    }
                    
                }    
                
            }    
        }
        catch(Exception e){}
        
        
    }
}