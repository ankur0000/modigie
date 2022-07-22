global with sharing class invocableUnresponsiveLeadVerifyEmployer 
{
    @invocableMethod
    global static void UnresponsiveLeadVerifyEmployer(List<id> lstIds)
    {
        try{
            System.debug('lead id ulvf :::: ' +lstIds);
            
            if(FieldLevelSecurityCheck.canReadObject('Contact')&&
            FieldLevelSecurityCheck.canReadField('Contact', 'modigie__Modigie_Verified_Number__c')&&
            FieldLevelSecurityCheck.canReadField('Contact', 'modigie__Alternate_Mobile_Phone_Available__c')&&
            FieldLevelSecurityCheck.canReadField('Contact', 'modigie__Validation_Key__c')&&
            FieldLevelSecurityCheck.canUpdateField('Contact', 'modigie__Validation_Key__c')){
                
                if(System.isBatch()){
                    Datetime timeToSchedule = System.now().addMinutes(2);
                    ModigieServicesAsychronousSchedulable schedulable = new ModigieServicesAsychronousSchedulable(lstIds,'Unresponsive Lead Verify Employer');
                    System.schedule('Unresponsive Lead VerifyEmployer Batch Class ' + System.now().addMinutes(2) + Math.round((Math.random() * (9000) + 1000)), timeToSchedule.second() + ' ' + timeToSchedule.minute() + ' ' + timeToSchedule.hour() + ' ' + timeToSchedule.day() + ' ' + timeToSchedule.month() + ' ? ' + timeToSchedule.year(), schedulable);
                }
                else{
                List<modigie__Process_Builder_Switch__c> pbs = [SELECT Id, modigie__Selected_Lead_Status__c, modigie__Unresponsive_Lead_Verify_Employer_A__c, modigie__Unresponsive_Lead_Verify_Employer_Limit__c, modigie__Unresponsive_Lead_Verify_Employer_Usage__c,modigie__Limits_No_Limits_Selection__c FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED  LIMIT 1];
                if(pbs.size() > 0){
                    if((pbs[0].modigie__Unresponsive_Lead_Verify_Employer_Limit__c >= pbs[0].modigie__Unresponsive_Lead_Verify_Employer_Usage__c + lstIds.size()) || pbs[0].modigie__Limits_No_Limits_Selection__c?.equalsIgnoreCase('No Limits') == true){
                        List <String> statusList = (List<String>)JSON.deserializeStrict(pbs[0].modigie__Selected_Lead_Status__c,List<String>.class);
                        
                        System.debug('status list is :::: ' +statusList);
                        
                        // List<Object> statusList = (List<Object>)JSON.deserializeUntyped(lstPbs[0].modigie__Selected_Lead_Status__c);
                        List <lead> leadList = [select Id, FirstName, LastName, Email, Company, status, modigie__Company_URL__c, modigie__linkedin_url__c,MobilePhone,modigie__Modigie_Verified_Number__c from lead where status IN :statusList AND Id IN :lstIds];
                        System.debug('leads are :::: ' +leadList);
                        if(!leadList.isEmpty()){
                                Integer b_size = 100;
                                try{
                                    b_size = Integer.valueOf(System.Label.modigie.Batch_Size_Invocable);
                                    if(b_size > 100 || b_size < 1){
                                        b_size = 100;
                                    }
                                }catch(Exception e){}
                                VerifyEmployerDataMaintainenceClass batchable = new VerifyEmployerDataMaintainenceClass(leadList, 1);
                                Database.executeBatch(batchable,b_size);    
                        }
                        }else{
                            //notification and email
                            //NotificationServiceClass.sendNotification('Unresponsive Lead Verify Employer',pbs[0].modigie__Unresponsive_Lead_Verify_Employer_A__c);
                            NotificationServiceClass.sendEmailLimitReached('Unresponsive Lead Verify Employer', 'modigie__Unresponsive_Lead_Verify_Employer_Limit__c', pbs[0].modigie__Unresponsive_Lead_Verify_Employer_Limit__c, pbs[0].modigie__Unresponsive_Lead_Verify_Employer_Usage__c, lstIds.size(), pbs[0].modigie__Unresponsive_Lead_Verify_Employer_A__c);
                        }
                }
                }
            }
        }catch(Exception e){
            EmailServiceClass.sendErrorEmail('InvocableUnresponsiveLeadVerifyEmployer', e);
        }
    } 
}