global with sharing class PhoneInsightsSchedulableClass implements Schedulable, Database.AllowsCallouts{
    global void execute(SchedulableContext sc)
    {
        
        List<modigie__Process_Builder_Switch__c> processSwitch = [SELECT modigie__Phone_Insights_Data_Maintenance__c,
                                                                  modigie__Phone_Insights_Data_Maintenance_Limits__c, modigie__Phone_Insights_Data_Maintenance_Usage__c, modigie__Limits_No_Limits_Selection__c, modigie__Get_Phone_Insights_Phone_Number_Selected__c, modigie__Phone_Insights_Data_Maintenance_Limits_A__c FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED LIMIT 1];

        if(processSwitch[0].modigie__Phone_Insights_Data_Maintenance__c)
        {
            List<sObject> sobj1 = [SELECT FirstName,LastName,AccountId,modigie__Modigie_Verified_Number__c,
                                   MobilePhone, Phone, OtherPhone, Email,modigie__linkedin_url__c FROM Contact WITH SECURITY_ENFORCED];
       
            List<sObject> sobj2 = [SELECT FirstName,LastName,Company,modigie__Modigie_Verified_Number__c,
                                   MobilePhone, Phone, Email,modigie__linkedin_url__c FROM Lead WITH SECURITY_ENFORCED];

            List<sObject> lstSobj = new List<sObject>();
            if(!sobj1.isEmpty())
            {
                lstSobj.addAll(sobj1);
            }
            
            if(!sobj2.isEmpty())
            {
                lstSobj.addAll(sobj2);
            }
            
            List<SObject> finalList = new List<SObject>();

            if(processSwitch[0].modigie__Limits_No_Limits_Selection__c?.equalsIgnoreCase('Limits') == true)
            {
                Integer availableLimit = (Integer)(processSwitch[0].modigie__Phone_Insights_Data_Maintenance_Limits__c - processSwitch[0].modigie__Phone_Insights_Data_Maintenance_Usage__c);
                if(availableLimit > 0)
                {
                    if(availableLimit >= lstSobj.size()){
                        finalList = lstSobj;
                    }
                    else{
                        for(Integer i = 0; i < availableLimit; i++){
                            finalList.add(lstSobj[i]);
                        }
                    }
                }
                else{
                    //Limit Functionality
                    //NotificationServiceClass.sendNotification('Modigie Phone Insights (Data Maintenance)', processSwitch[0].modigie__Phone_Insights_Data_Maintenance_Limits_A__c);
                    NotificationServiceClass.sendEmailLimitReached('Modigie Phone Insights (Data Maintenance)', 'modigie__Phone_Insights_Data_Maintenance_Limits__c', processSwitch[0].modigie__Phone_Insights_Data_Maintenance_Limits__c, processSwitch[0].modigie__Phone_Insights_Data_Maintenance_Usage__c, 0, processSwitch[0].modigie__Phone_Insights_Data_Maintenance_Limits_A__c);
                }
            }
            else{
                finalList = lstSobj;
            }

            if(!finalList.isEmpty() && !Test.isRunningTest())
            {
                Integer b_size = 100;
                try{
                    b_size = Integer.valueOf(System.Label.modigie.Batch_Size_Invocable);
                    if(b_size > 100 || b_size < 1){
                        b_size = 100;
                    }
                }catch(Exception e){}
                GetPhoneInsightsJobRequestBatchClass b1 = new GetPhoneInsightsJobRequestBatchClass(finalList,processSwitch[0].modigie__Get_Phone_Insights_Phone_Number_Selected__c); 
                Database.executeBatch(b1,b_size);
            }
        }
    }
}