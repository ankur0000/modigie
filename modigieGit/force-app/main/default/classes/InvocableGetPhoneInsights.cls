global with sharing class InvocableGetPhoneInsights 
{
    global static boolean var = true;
    @InvocableMethod
    global static void getRecordId(List<String> lstIds)
    {
        try{
            if(FieldLevelSecurityCheck.canReadObject('Contact')&&
            FieldLevelSecurityCheck.canReadField('Contact', 'modigie__Modigie_Verified_Number__c')&&
            FieldLevelSecurityCheck.canReadField('Contact', 'modigie__Alternate_Mobile_Phone_Available__c')&&
            FieldLevelSecurityCheck.canReadField('Contact', 'modigie__Validation_Key__c')&&
            FieldLevelSecurityCheck.canUpdateField('Contact', 'modigie__Validation_Key__c')&&
            FieldLevelSecurityCheck.canReadObject('Lead')&&
            FieldLevelSecurityCheck.canReadField('Lead', 'modigie__Modigie_Verified_Number__c')&&
            FieldLevelSecurityCheck.canReadField('Lead', 'modigie__Alternate_Mobile_Phone_Available__c')&&
            FieldLevelSecurityCheck.canReadField('Lead', 'modigie__Validation_Key__c')&&
            FieldLevelSecurityCheck.canUpdateField('Lead', 'modigie__Validation_Key__c'))
            {
                if(System.isBatch()){
                    Datetime timeToSchedule = System.now().addMinutes(2);
                    ModigieServicesAsychronousSchedulable schedulable = new ModigieServicesAsychronousSchedulable(lstIds,'Get Phone Insights Contact/Lead');
                    System.schedule('Get Phone Insights Invocable Batch Class ' + System.now().addMinutes(2) + Math.round((Math.random() * (9000) + 1000)), timeToSchedule.second() + ' ' + timeToSchedule.minute() + ' ' + timeToSchedule.hour() + ' ' + timeToSchedule.day() + ' ' + timeToSchedule.month() + ' ? ' + timeToSchedule.year(), schedulable);
                }
                else{
                    List<modigie__Process_Builder_Switch__c> pbs = [SELECT modigie__Get_linkedin_url__c, modigie__Validate_Employer__c, modigie__Limits_No_Limits_Selection__c, modigie__Modigie_Phone_Insights_Invocable_Limit__c, modigie__Modigie_Phone_Insights_Invocable_Usage__c, modigie__Modigie_Phone_Insights_Invocable_Limit_A__c,modigie__No_Mobile_Information__c  FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED LIMIT 1];
                    
                    List<modigie__Modigie_Credit__c> modiCredit = new List<modigie__Modigie_Credit__c>();
                    
                    if(pbs.size() > 0){
                        if((pbs[0].modigie__Modigie_Phone_Insights_Invocable_Limit__c >= pbs[0].modigie__Modigie_Phone_Insights_Invocable_Usage__c + lstIds.size()) || pbs[0].modigie__Limits_No_Limits_Selection__c?.equalsIgnoreCase('No Limits') == true){
                            
                            List<modigie__Modigie_Credentials__c> tokenList = new List<modigie__Modigie_Credentials__c>();
                            tokenList = [SELECT Name, modigie__Credits_Account_Id__c,modigie__API_Key__c,modigie__Service_Account_Credentials__c,modigie__Private_Key__c FROM modigie__Modigie_Credentials__c  WITH SECURITY_ENFORCED LIMIT 1];
                            if(tokenList.size() > 0)
                            {            
                                String creditId = tokenList[0].modigie__Credits_Account_Id__c;
                                String privateKey = tokenList[0].modigie__Private_Key__c;
                                String APIkey = tokenList[0].modigie__API_Key__c;
                                String serviceAccountCred = tokenList[0].modigie__Service_Account_Credentials__c;
                                
                                modiCredit = [SELECT Name, modigie__Purchased__c, modigie__Remaining__c, modigie__Validation_Key__c, modigie__Used__c, modigie__Date_Last_Synced__c FROM modigie__Modigie_Credit__c WITH SECURITY_ENFORCED LIMIT 1];
                                
                                List<SObject> scope = new List<SObject>();
                                List<Contact> conLst = [SELECT Id, FirstName, LastName, Email, AccountId, modigie__linkedin_url__c,MobilePhone, Phone, OtherPhone FROM Contact WHERE Id IN :lstIds WITH SECURITY_ENFORCED];
                                List<Lead> ldLst = [SELECT Id, FirstName, LastName, Email, Company, modigie__linkedin_url__c,MobilePhone, Phone FROM Lead WHERE Id IN :lstIds WITH SECURITY_ENFORCED];
                                scope.addAll(conLst);
                                scope.addAll(ldLst);
                                
                                if(pbs[0].modigie__No_Mobile_Information__c || pbs[0].modigie__Get_linkedin_url__c || pbs[0].modigie__Validate_Employer__c){ 
                                    Datetime now = Datetime.now();
                                    System.debug('Initially now --> ' + now);
                                    now = now.addMinutes(2);
                                    //parse to cron expression
                                    String nextFireTime = now.second() + ' ' + now.minute() + ' ' + now.hour() + ' * * ?';
                                    InvocablePhoneInsightsSchedulableClass SC = new InvocablePhoneInsightsSchedulableClass(scope,0);
                                    System.schedule('Invocable Phone Insights Job ' + now.hour() + ': ' + now.minute() + ' : ' + now.second(), nextFireTime, SC);
                                }
                                
                                else{
                                    if(!scope.isEmpty()){
                                        Integer b_size = 100;
                                        try{
                                            b_size = Integer.valueOf(System.Label.modigie.Batch_Size_Invocable);
                                            if(b_size > 100 || b_size < 1){
                                                b_size = 100;
                                            }
                                        }catch(Exception e){}
                                        GetPhoneInsightsJobRequestBatchClass batchable = new GetPhoneInsightsJobRequestBatchClass(scope, 0);
                                        Database.executeBatch(batchable,b_size);    
                                    }
                                    
                                    //InvocableGetPhoneInsights.runCallout(lstIds,   creditId, privateKey, serviceAccountCred, APIkey);
                                }
                                
                            }
                        }
                        else{
                            //NotificationServiceClass.sendNotification('Modigie Phone Insights',pbs[0].modigie__Modigie_Phone_Insights_Invocable_Limit_A__c);
                            NotificationServiceClass.sendEmailLimitReached('Modigie Phone Insights', 'modigie__Modigie_Phone_Insights_Invocable_Limit__c', pbs[0].modigie__Modigie_Phone_Insights_Invocable_Limit__c, pbs[0].modigie__Modigie_Phone_Insights_Invocable_Usage__c, lstIds.size(), pbs[0].modigie__Modigie_Phone_Insights_Invocable_Limit_A__c);
                        }
                    }
                }
                
            } 
        }catch(Exception e){
            EmailServiceClass.sendErrorEmail('InvocableGetPhoneInsights', e);
        }
    }
    
}