global with sharing class OpportunityContactRoleClassInvocable { 
    global static boolean var = true;
    @InvocableMethod
    global static void getRecordId(List<String> lstIds){
        try{ 
            System.debug('In opp contact enrichment');
            if(FieldLevelSecurityCheck.canReadObject('Contact')&&
               FieldLevelSecurityCheck.canReadField('Contact', 'modigie__Modigie_Verified_Number__c')&&
               FieldLevelSecurityCheck.canReadField('Contact', 'modigie__Alternate_Mobile_Phone_Available__c')&&
               FieldLevelSecurityCheck.canReadField('Contact', 'modigie__Validation_Key__c')&&
               FieldLevelSecurityCheck.canUpdateField('Contact', 'modigie__Validation_Key__c'))
            {
                List<modigie__Modigie_Service_Account__mdt> lstCredential = ModigieApiUtils.getServiceAccountDetails();
                if(lstCredential.size() > 0){
                    
                    List<Contact> conLst = [SELECT Id, Account.Name,Email, Account.BillingStreet,Account.BillingPostalCode,Account.BillingCity,Account.BillingState,Account.BillingCountry,modigie__linkedin_url__c,FirstName, LastName, modigie__Company_URL__c,MobilePhone,modigie__Modigie_Verified_Number__c,(SELECT id FROM modigie__Modigie__r) FROM Contact WHERE Id IN (SELECT ContactId FROM OpportunityContactRole WHERE OpportunityId IN :lstIds) AND Id NOT IN (Select modigie__Contact__c FROM modigie__Modigie__c WHERE modigie__Status__c != 'Not started' AND modigie__Status__c != 'Unavailable') AND FirstName != null AND Email != null AND Account.Name != null];
                    if(conLst.size() > 0){
                        Integer b_size = 100;
                        try{
                            b_size = Integer.valueOf(System.Label.modigie.Batch_Size_Invocable);
                            if(b_size > 100 || b_size < 1){
                                b_size = 100;
                            }
                        }catch(Exception e){}
                        ContactBatchForGetModigieButton batchable = new ContactBatchForGetModigieButton(conLst,2);
                        Database.executeBatch(batchable,b_size);    
                    }
                }
            }
            
        }
        catch(ServerErrorException e){
            Map <String,Object> errorMap = (Map <String,Object>)JSON.deserializeUntyped(e.getMessage());
            errorMap.put('ModigieService','Get Modigie'); 
            System.debug(e.getMessage());
            
            EmailServiceClass.sendEmail(JSON.serialize(errorMap));
        }
        catch(Exception e){
            System.debug(e.getMessage());
        }  
    }
}