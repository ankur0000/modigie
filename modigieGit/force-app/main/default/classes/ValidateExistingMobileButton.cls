public with sharing class ValidateExistingMobileButton {
    
    //@Depricated
    // public static string checkValidateRecord(ID recid)
    // {
    //     try
    //     {
    //         String result;
            
    //         List<modigie__Modigie__c> modiList = new List<modigie__Modigie__c>();
    //         List<modigie__Modigie_Credit__c> modiCredit = new List<modigie__Modigie_Credit__c>();
            
            
            
           
            
    //             if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie_Credit__c') &&
    //                FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','Name') &&
    //                FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','modigie__Used__c') &&
    //                FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','modigie__Purchased__c') &&
    //                FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','modigie__Remaining__c') &&
    //                FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','modigie__Validation_Key__c')&&
    //                FieldLevelSecurityCheck.canReadField('modigie__Modigie_Credit__c','modigie__Date_Last_Synced__c'))
    //             {
    //                 modiCredit = [SELECT Name, modigie__Purchased__c, modigie__Remaining__c, modigie__Validation_Key__c, modigie__Used__c, modigie__Date_Last_Synced__c FROM modigie__Modigie_Credit__c LIMIT 1];
    //             }
    //             else
    //             {
    //                 throw new GetModigieException('User does not have needed permissions for Modigie Credit object and/or fields.');
    //             }
                
                
    //                 String sobjectType = recid.getSObjectType().getDescribe().getName();
    //                 if(sobjectType == 'Contact')
    //                 {
    //                     if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie__c') &&
    //                        FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','Name') &&
    //                        FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validation_Date_Mobile__c') &&
    //                        FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Contact__c'))
    //                     {
    //                         modiList = [SELECT Name, modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Contact__c =: recid LIMIT 1];
                            
    //                         Contact con = [SELECT FirstName,LastName,Phone,MobilePhone,modigie__Modigie_Verified_Number__c FROM Contact WHERE id = :recId];
    //                         if(modiList.size() == 1)
    //                         {
                                
    //                         }
    //                         else if(modiList.size() == 0)
    //                         {
    //                             result = 'Available';
    //                         	if(con.MobilePhone == null || con.MobilePhone == ''){
    //                                 result = 'Mobile Number is not Provided by the User.';    
    //                             }
    //                         }
    //                     }
    //                     else
    //                     {
    //                         throw new GetModigieException('User does not have needed permissions for Modigie object and/or fields.');
    //                     }
    //                 }
    //                 else if(sobjectType == 'Lead')
    //                 {
    //                     if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie__c') &&
    //                        FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','Name') &&
    //                        FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Validation_Date_Mobile__c') &&
    //                        FieldLevelSecurityCheck.canReadField('modigie__Modigie__c','modigie__Lead__c'))
    //                     {
    //                         modiList = [SELECT Name, modigie__Lead__c FROM modigie__Modigie__c WHERE modigie__Lead__c =: recid LIMIT 1];
                            
    //                         Lead ld = [SELECT FirstName,LastName,Phone,MobilePhone,modigie__Modigie_Verified_Number__c FROM Lead WHERE id = :recId];
                            
    //                         if(modiList.size() == 1)
    //                         {
                                
    //                         }
    //                         else if(modiList.size() == 0)
    //                         {
    //                             result = 'Available';
    //                         	if(ld.MobilePhone == null || ld.MobilePhone == ''){
    //                                 result = 'Mobile Number is not Provided by the User.';    
    //                             }
    //                         }
    //                     }
    //                     else
    //                     {
    //                         throw new GetModigieException('User does not have needed permissions for Modigie object and/or fields.');
    //                     }
    //                 }
            
            
    //         return result;
    //     }
    //     catch(Exception e)
    //     {
    //         return e.getMessage(); 
    //     }
    // }
    
    
    // @Depricated
    // public static string makeGetCallout(ID recid){
    //     List<modigie__Modigie__c> lstModigie = [SELECT id,modigie__Parent_Id__c,modigie__Validation_Key__c FROM modigie__Modigie__c WHERE modigie__Parent_Id__c = :recid LIMIT 1];
    //     if(lstModigie.size() > 0){
            
             
            
    //         lstModigie[0].modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
    //     }

    //     else{
            
    //         String sObjectType = recid.getSObjectType().getDescribe().getName();
    //         modigie__Modigie__c modi = new modigie__Modigie__c(modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey',modigie__Parent_Id__c = recid);
    //         if(sObjectType == 'Contact'){
    //             modi.modigie__Contact__c = recid;
    //         }
    //         else if(sObjectType == 'Lead'){
    //             modi.modigie__Lead__c = recid;
    //         }
    //         lstModigie.add(modi);
    //     }

    //     upsert lstModigie;        
    //     return 'success';
    // }

    // public class GetModigieException extends Exception{}
}