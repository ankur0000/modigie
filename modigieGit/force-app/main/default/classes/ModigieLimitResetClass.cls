global with sharing class ModigieLimitResetClass implements Schedulable{
    global void execute(SchedulableContext sc){

        List<modigie__Modigie_Rule_Sets__c> mrsList = [SELECT Id, modigie__Usage__c FROM modigie__Modigie_Rule_Sets__c WHERE modigie__Usage__c != 0];
        for(modigie__Modigie_Rule_Sets__c mrs: mrsList){
            mrs.modigie__Usage__c = 0;
            mrs.modigie__Email_Limit_Sent__c = false;
        }
        
        if(mrsList.size() > 0){
            if(FieldLevelSecurityCheck.canReadObject('modigie__Modigie_Rule_Sets__c')&&
            FieldLevelSecurityCheck.canUpdateObject('modigie__Modigie_Rule_Sets__c')&&
            FieldLevelSecurityCheck.canReadField('modigie__Modigie_Rule_Sets__c','modigie__Usage__c')&&
            FieldLevelSecurityCheck.canUpdateField('modigie__Modigie_Rule_Sets__c','modigie__Usage__c')&&
            FieldLevelSecurityCheck.canReadField('modigie__Modigie_Rule_Sets__c','modigie__Email_Limit_Sent__c')&&
            FieldLevelSecurityCheck.canUpdateField('modigie__Modigie_Rule_Sets__c','modigie__Email_Limit_Sent__c')){
                update mrsList;
            }
        }

        List<modigie__Daily_usage_modigie_callouts_by_users__c> modigieDailyUsage = [SELECT modigie__Number_of_modigie_callouts_in_a_day__c FROM modigie__Daily_usage_modigie_callouts_by_users__c WITH SECURITY_ENFORCED LIMIT 50000];
        
        for(modigie__Daily_usage_modigie_callouts_by_users__c modigieDailyUsagePerUser : modigieDailyUsage){
            modigieDailyUsagePerUser.modigie__Number_of_modigie_callouts_in_a_day__c = 0;
        }
        if(modigieDailyUsage.size() > 0){
            
            if(FieldLevelSecurityCheck.canReadObject('modigie__Daily_usage_modigie_callouts_by_users__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Daily_usage_modigie_callouts_by_users__c','modigie__Number_of_modigie_callouts_in_a_day__c')&&
               FieldLevelSecurityCheck.canReadObject('modigie__Daily_usage_modigie_callouts_by_users__c')&&
               FieldLevelSecurityCheck.canUpdateField('modigie__Daily_usage_modigie_callouts_by_users__c','modigie__Number_of_modigie_callouts_in_a_day__c')){
                   update modigieDailyUsage; 
               }
        }
        
        List<modigie__Process_Builder_Switch__c> lstPbs = [SELECT Id, modigie__Get_Modigie_Invocable_Usage__c, modigie__Dynamic_Criteria_Automation_Usage__c, modigie__Opportunity_Contact_Get_Modigie_Usage__c, modigie__Unresponsive_Lead_Get_Modigie_Usage__c, modigie__Unresponsive_Lead_Verify_Employer_Usage__c, modigie__Phone_Insights_Data_Maintenance_Usage__c, modigie__Validate_Employer_Data_Maintenance_Usage__c, modigie__Get_Modigie_Campaign_Invocable_Usage__c, modigie__Validate_employer_campaign_Usage__c, modigie__LinkedIn_Url_Campaign_Usage__c, modigie__Modigie_Phone_Insights_Invocable_Usage__c, modigie__Validate_Employer_Invocable_Usage__c, modigie__LinkedIn_Url_Invocable_Usage__c, modigie__Opp_Contact_Enrichment_Invocable_Usage__c FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED LIMIT 1];
        
        if(FieldLevelSecurityCheck.canReadObject('modigie__Process_Builder_Switch__c')&&
           FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c','modigie__Get_Modigie_Invocable_Usage__c')&&
           FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c','modigie__Unresponsive_Lead_Invocable_Usage__c')&&
           FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c','modigie__Phone_Insights_Data_Maintenance_Usage__c')&&
           FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c','modigie__Validate_Employer_Data_Maintenance_Usage__c')&&
           FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c','modigie__Get_Modigie_Campaign_Invocable_Usage__c')&&
           FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c','modigie__Validate_employer_campaign_Usage__c')&&
           FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c','modigie__LinkedIn_Url_Campaign_Usage__c')&&
           FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c','modigie__Modigie_Phone_Insights_Invocable_Usage__c')&&
           FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c','modigie__Validate_Employer_Invocable_Usage__c')&&
           FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c','modigie__LinkedIn_Url_Invocable_Usage__c')&&
           FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c','modigie__Opp_Contact_Enrichment_Invocable_Usage__c')&&
           FieldLevelSecurityCheck.canReadField('modigie__Process_Builder_Switch__c','modigie__Unresponsive_Lead_Verify_Employer_Usage__c')&&
           FieldLevelSecurityCheck.canUpdateObject('modigie__Process_Builder_Switch__c')&&
           FieldLevelSecurityCheck.canUpdateField('modigie__Process_Builder_Switch__c','modigie__Get_Modigie_Invocable_Usage__c')&&
           FieldLevelSecurityCheck.canUpdateField('modigie__Process_Builder_Switch__c','modigie__Unresponsive_Lead_Invocable_Usage__c')&&
           FieldLevelSecurityCheck.canUpdateField('modigie__Process_Builder_Switch__c','modigie__Phone_Insights_Data_Maintenance_Usage__c')&&
           FieldLevelSecurityCheck.canUpdateField('modigie__Process_Builder_Switch__c','modigie__Validate_Employer_Data_Maintenance_Usage__c')&&
           FieldLevelSecurityCheck.canUpdateField('modigie__Process_Builder_Switch__c','modigie__Get_Modigie_Campaign_Invocable_Usage__c')&&
           FieldLevelSecurityCheck.canUpdateField('modigie__Process_Builder_Switch__c','modigie__Validate_employer_campaign_Usage__c')&&
           FieldLevelSecurityCheck.canUpdateField('modigie__Process_Builder_Switch__c','modigie__LinkedIn_Url_Campaign_Usage__c')&&
           FieldLevelSecurityCheck.canUpdateField('modigie__Process_Builder_Switch__c','modigie__Modigie_Phone_Insights_Invocable_Usage__c')&&
           FieldLevelSecurityCheck.canUpdateField('modigie__Process_Builder_Switch__c','modigie__Validate_Employer_Invocable_Usage__c')&&
           FieldLevelSecurityCheck.canUpdateField('modigie__Process_Builder_Switch__c','modigie__LinkedIn_Url_Invocable_Usage__c')&&
           FieldLevelSecurityCheck.canUpdateField('modigie__Process_Builder_Switch__c','modigie__Opp_Contact_Enrichment_Invocable_Usage__c') && 
            FieldLevelSecurityCheck.canUpdateField('modigie__Process_Builder_Switch__c','modigie__Unresponsive_Lead_Verify_Employer_Usage__c')){
            
               if(lstPbs.size() > 0){
                   lstPbs[0].modigie__Get_Modigie_Invocable_Usage__c = 0;
                   lstPbs[0].modigie__Unresponsive_Lead_Invocable_Usage__c = 0;
                   lstPbs[0]. modigie__Phone_Insights_Data_Maintenance_Usage__c = 0;
                   lstPbs[0].modigie__Validate_Employer_Data_Maintenance_Usage__c = 0;
                   lstPbs[0].modigie__Get_Modigie_Campaign_Invocable_Usage__c = 0;
                   lstPbs[0].modigie__Validate_employer_campaign_Usage__c = 0;
                   lstPbs[0].modigie__LinkedIn_Url_Campaign_Usage__c = 0;
                   lstPbs[0].modigie__Modigie_Phone_Insights_Invocable_Usage__c = 0;
                   lstPbs[0].modigie__Validate_Employer_Invocable_Usage__c = 0;
                   lstPbs[0].modigie__LinkedIn_Url_Invocable_Usage__c = 0;
                   lstPbs[0].modigie__Opp_Contact_Enrichment_Invocable_Usage__c = 0;
                   lstPbs[0].modigie__Unresponsive_Lead_Verify_Employer_Usage__c = 0;
                   lstPbs[0].modigie__Unresponsive_Lead_Get_Modigie_Usage__c = 0;
                   lstPbs[0].modigie__Opportunity_Contact_Get_Modigie_Usage__c = 0;
                   lstPbs[0].modigie__Dynamic_Criteria_Automation_Usage__c = 0;
                   
                   update lstPbs;
               }
           }
    }
}