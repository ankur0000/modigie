global with sharing class InvocableVerifyEmployer 
{
    global static boolean var = true;
    @InvocableMethod
    global static void getRecordId(List<String> lstIds) {
        try{
            if(FieldLevelSecurityCheck.canReadObject('Lead')&&
               FieldLevelSecurityCheck.canReadField('Lead', 'modigie__Modigie_Verified_Number__c')&&
               FieldLevelSecurityCheck.canReadField('Lead', 'modigie__Alternate_Mobile_Phone_Available__c')&&
               FieldLevelSecurityCheck.canReadField('Lead', 'modigie__Validation_Key__c')&&
               FieldLevelSecurityCheck.canUpdateField('Lead', 'modigie__Validation_Key__c'))
            {
                if(System.isBatch()){
                    Datetime timeToSchedule = System.now().addMinutes(2);
                    ModigieServicesAsychronousSchedulable schedulable = new ModigieServicesAsychronousSchedulable(lstIds,'Verify Employer Contact/Lead');
                    System.schedule('Verify Employer Invocable Batch Class ' + System.now().addMinutes(2) + Math.round((Math.random() * (9000) + 1000)), timeToSchedule.second() + ' ' + timeToSchedule.minute() + ' ' + timeToSchedule.hour() + ' ' + timeToSchedule.day() + ' ' + timeToSchedule.month() + ' ? ' + timeToSchedule.year(), schedulable);
                }
                else{
                    List<modigie__Process_Builder_Switch__c> pbs = [SELECT modigie__Limits_No_Limits_Selection__c, modigie__Validate_Employer_Invocable_Limit__c, modigie__Validate_Employer_Invocable_Usage__c, modigie__Validate_Employer_Invocable_Limit_A__c FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED LIMIT 1];
                    
                    if(pbs.size() > 0){
                        if(pbs[0].modigie__Limits_No_Limits_Selection__c?.equalsIgnoreCase('No Limits') == true  || (pbs[0].modigie__Validate_Employer_Invocable_Limit__c >= pbs[0].modigie__Validate_Employer_Invocable_Usage__c + lstIds.size())){
                            List<modigie__Modigie_Credentials__c> tokenList = new List<modigie__Modigie_Credentials__c>();
                            tokenList = [SELECT Name, modigie__Credits_Account_Id__c,modigie__API_Key__c,modigie__Service_Account_Credentials__c,modigie__Private_Key__c FROM modigie__Modigie_Credentials__c  WITH SECURITY_ENFORCED LIMIT 1];
                            if(tokenList.size() > 0){
                                List<Contact> conLst = [SELECT Id, Account.Name,modigie__Company_Email__c, Account.BillingStreet,Account.BillingPostalCode,Account.BillingCity,Account.BillingState,Account.BillingCountry,modigie__linkedin_url__c,FirstName, LastName, Email, modigie__Modigie_Verified_Number__c, modigie__Company_URL__c,MobilePhone,(SELECT id FROM modigie__Modigie__r) FROM Contact Where Id IN :lstIds WITH SECURITY_ENFORCED];
                                List<Lead> ldLst = [SELECT Id, FirstName, LastName, modigie__Company_Email__c,Email, Company, modigie__Company_URL__c, modigie__linkedin_url__c,MobilePhone, modigie__Modigie_Verified_Number__c, (SELECT id FROM modigie__Modigie__r) FROM Lead WHERE Id In :lstIds WITH SECURITY_ENFORCED];
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
                                    VerifyEmployerDataMaintainenceClass batchable = new VerifyEmployerDataMaintainenceClass(lstSobj, 0);
                                    Database.executeBatch(batchable,b_size);    
                                }
                                
                            } 
                        }
                        else{
                            //NotificationServiceClass.sendNotification('Verify Employer',pbs[0].modigie__Validate_Employer_Invocable_Limit_A__c);
                            NotificationServiceClass.sendEmailLimitReached('Verify Employer', 'modigie__Validate_Employer_Invocable_Limit__c', pbs[0].modigie__Validate_Employer_Invocable_Limit__c, pbs[0].modigie__Validate_Employer_Invocable_Usage__c, lstIds.size(), pbs[0].modigie__Validate_Employer_Invocable_Limit_A__c);
                        }
                    }
                    
                }
            }
        }
        catch(Exception e){
            EmailServiceClass.sendErrorEmail('InvocableUnresponsiveLeadVerifyEmployer', e);
        }
    } 
    
}