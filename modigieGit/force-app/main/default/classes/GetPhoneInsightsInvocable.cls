global with sharing class GetPhoneInsightsInvocable {
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
               FieldLevelSecurityCheck.canUpdateField('Lead', 'modigie__Validation_Key__c')){
            String recordId = lstIds[0]; 
            
            List<modigie__Modigie__c> modiList = new List<modigie__Modigie__c>();
           
            List<modigie__Process_Builder_Switch__c> pbs = [SELECT modigie__Get_linkedin_url__c, modigie__Validate_Employer__c, modigie__Limits_No_Limits_Selection__c, modigie__Modigie_Phone_Insights_Invocable_Limit__c, modigie__Modigie_Phone_Insights_Invocable_Usage__c, modigie__Modigie_Phone_Insights_Invocable_Limit_A__c,modigie__No_Mobile_Information__c  FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED LIMIT 1];

            List<modigie__Modigie_Credit__c> modiCredit = new List<modigie__Modigie_Credit__c>();
            
            if(pbs.size() > 0){
                    List<modigie__Modigie_Credentials__c> tokenList = new List<modigie__Modigie_Credentials__c>();
                    tokenList = [SELECT Name, modigie__Credits_Account_Id__c,modigie__API_Key__c,modigie__Service_Account_Credentials__c,modigie__Private_Key__c FROM modigie__Modigie_Credentials__c  WITH SECURITY_ENFORCED LIMIT 1];
                    if(tokenList.size() > 0){            
                         modiCredit = [SELECT Name, modigie__Purchased__c, modigie__Remaining__c, modigie__Validation_Key__c, modigie__Used__c, modigie__Date_Last_Synced__c FROM modigie__Modigie_Credit__c WITH SECURITY_ENFORCED LIMIT 1];

                         List<SObject> scope = new List<SObject>();
                            List<Contact> conLst = [SELECT Id, FirstName, LastName, Email, AccountId, modigie__linkedin_url__c,MobilePhone, Phone, OtherPhone FROM Contact WHERE Id IN :lstIds WITH SECURITY_ENFORCED];
                            List<Lead> ldLst = [SELECT Id, FirstName, LastName, Email, Company, modigie__linkedin_url__c,MobilePhone, Phone FROM Lead WHERE Id IN :lstIds WITH SECURITY_ENFORCED];
                            scope.addAll(conLst);
                            scope.addAll(ldLst);

                            if(!scope.isEmpty()){
                                if(pbs[0].modigie__No_Mobile_Information__c || pbs[0].modigie__Get_linkedin_url__c || pbs[0].modigie__Validate_Employer__c){ 

                                    String hour = String.valueOf(Datetime.now().hour());
                                    String min = String.valueOf(Datetime.now().minute() + 1); 
                                    
                                    String ss = String.valueOf(Datetime.now().second());
        
                                    //parse to cron expression
                                    String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';
        
                                    if(Integer.valueOf(min) > 59 || Test.isRunningTest()){
                                        min = String.valueOf((Integer.valueOf(min)-60));
                                        hour = String.valueOf((Integer.valueOf(hour) + 1));
                                    }
        
                                   if(Integer.valueOf(hour) > 23 || Test.isRunningTest()){
                                        hour = String.valueOf((Integer.valueOf(hour) - 24));
                                    }
                                    InvocablePhoneInsightsSchedulableClass SC = new InvocablePhoneInsightsSchedulableClass(scope,2);
                                    System.schedule('Invocable Phone Insights Job ' + hour + ': ' + min + ' : ' + ss, nextFireTime, SC);
                                }
                                
                                else{
                                    Integer b_size = 100;
                    try{
                        b_size = Integer.valueOf(System.Label.modigie.Batch_Size_Invocable);
                        if(b_size > 100 || b_size < 1){
                            b_size = 100;
                        }
                    }catch(Exception e){}
                                    GetPhoneInsightsJobRequestBatchClass batchable = new GetPhoneInsightsJobRequestBatchClass(scope, 2);
                                    Database.executeBatch(batchable,b_size);
                                    //InvocableGetPhoneInsights.runCallout(lstIds,   creditId, privateKey, serviceAccountCred, APIkey);
                                }
                            }
                        
                        
                    }
                
            }
        
    }   
        }
        catch(Exception e){}
             
    }
}