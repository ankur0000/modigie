global with sharing class UnresponsiveLeadScheduleClass implements Schedulable,Database.AllowsCallouts{
    
    public static String sched = '0 00 00 * * ?';  //Every Day at Midnight
    global static String scheduleMe() {
        UnresponsiveLeadScheduleClass SC = new UnresponsiveLeadScheduleClass(); 
        return System.schedule('Unresposive Lead Schedule', sched, SC);
    }
    global void execute(SchedulableContext sc){
        
        try{
            List<modigie__Process_Builder_Switch__c> processSwitch = [SELECT modigie__Limits_No_Limits_Selection__c,
                                                                      modigie__Unresponsive_Lead_Toggle__c,
                                                                      modigie__Unresponsive_Lead_Invocable_Limits__c,
                                                                      modigie__Unresponsive_Lead_Invocable_Usage__c,
                                                                      modigie__Unresponsive_Lead_Invocable_Limits_A__c,
                                                                      modigie__Selected_Lead_Status__c, modigie__Unresponsive_Lead_Verify_Employer_Limit__c, modigie__Unresponsive_Lead_Verify_Employer_Usage__c, 
                                                                      modigie__Unresponsive_Lead_Get_Modigie__c, modigie__Unresponsive_Lead_Verify_Employer__c
                                                                      FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED LIMIT 1];
            if(processSwitch[0].modigie__Unresponsive_Lead_Get_Modigie__c){
                Integer availableLimit = (Integer)(processSwitch[0].modigie__Unresponsive_Lead_Invocable_Limits__c - processSwitch[0].modigie__Unresponsive_Lead_Invocable_Usage__c);
                List <String> lstSelectedStages = (List<String>)JSON.deserializeStrict(processSwitch[0].modigie__Selected_Lead_Status__c,List<String>.class);
                List<sObject> lstLead = [SELECT FirstName,LastName,Company,Email,modigie__linkedin_url__c FROM Lead WHERE Company != null AND FirstName != null AND LastName != null AND Email != null AND MobilePhone = null AND Status IN :lstSelectedStages AND LastModifiedDate < LAST_N_DAYS:10 WITH SECURITY_ENFORCED];
                if(processSwitch[0].modigie__Limits_No_Limits_Selection__c?.equalsIgnoreCase('No Limits') == true || availableLimit > lstLead.size()){
                    Integer b_size = 100;
                    try{
                        b_size = Integer.valueOf(System.Label.modigie.Batch_Size_Invocable);
                        if(b_size > 100 || b_size < 1){
                            b_size = 100;
                        }
                    }catch(Exception e){}
                    Database.executeBatch(new UnresponsiveLeadContactBatchClass(lstLead),b_size);
                }
            }

            else if(processSwitch[0].modigie__Unresponsive_Lead_Verify_Employer__c){
                Integer availableLimit = (Integer)(processSwitch[0].modigie__Unresponsive_Lead_Verify_Employer_Limit__c - processSwitch[0].modigie__Unresponsive_Lead_Verify_Employer_Usage__c);
                List <String> lstSelectedStages = (List<String>)JSON.deserializeStrict(processSwitch[0].modigie__Selected_Lead_Status__c,List<String>.class);
                List<sObject> lstLead = [SELECT FirstName,LastName,Company,Email,modigie__linkedin_url__c FROM Lead WHERE Company != null AND FirstName != null AND LastName != null AND Email != null AND Status IN :lstSelectedStages AND LastModifiedDate < LAST_N_DAYS:10 WITH SECURITY_ENFORCED];
                if(processSwitch[0].modigie__Limits_No_Limits_Selection__c?.equalsIgnoreCase('No Limits') == true || availableLimit > lstLead.size()){
                    //Database.executeBatch(new hVerifyEmployerDataMaintainenceClass(lstLead,1),100);
                }
            }
            
            
            
        }
        catch(System.QueryException e){
            throw new UnresponsiveLeadScheduleClassException('User does not have permission to query process builder switch custom settings.');
        }
        catch(Exception e){
            throw new UnresponsiveLeadScheduleClassException(e.getMessage());
        }
    }
    private class UnresponsiveLeadScheduleClassException extends Exception{}
}