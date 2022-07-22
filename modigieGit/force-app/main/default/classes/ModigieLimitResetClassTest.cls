@istest
public class ModigieLimitResetClassTest {
    
    @isTest
    public static void test1(){
        modigie__Process_Builder_Switch__c pbs = new modigie__Process_Builder_Switch__c();
        pbs.modigie__Limits_No_Limits_Selection__c  = 'Limits';
        pbs.modigie__Get_Modigie_Invocable_Usage__c = 0;
        pbs.modigie__Unresponsive_Lead_Invocable_Usage__c = 0;
        pbs.modigie__Phone_Insights_Data_Maintenance_Usage__c = 0;
        pbs.modigie__Validate_Employer_Data_Maintenance_Usage__c = 0;
        pbs.modigie__Get_Modigie_Campaign_Invocable_Usage__c = 0;
        pbs.modigie__Validate_employer_campaign_Usage__c = 0;
        pbs.modigie__LinkedIn_Url_Campaign_Usage__c = 0;
        pbs.modigie__Modigie_Phone_Insights_Invocable_Usage__c = 0;
        pbs.modigie__Validate_Employer_Invocable_Usage__c = 0;
        pbs.modigie__LinkedIn_Url_Invocable_Usage__c = 0;
        pbs.modigie__Opp_Contact_Enrichment_Invocable_Usage__c  = 0;
        pbs.modigie__Get_Modigie_Invocable_Limit__c = 10;
        pbs.modigie__Modigie_Phone_Insights_Invocable_Limit__c = 10;
        pbs.modigie__Validate_Employer_Invocable_Limit__c = 10;
        pbs.modigie__LinkedIn_Url_Invocable_Limits__c = 10;
        pbs.modigie__Opp_Contact_Enrichment_Invocable_Limit__c = 10;
        pbs.modigie__Unresponsive_Lead_Invocable_Limits__c = 10;
        pbs.modigie__Phone_Insights_Data_Maintenance_Limits__c = 10;
        pbs.modigie__Validate_Employer_Data_Maintenance_Lmt__c = 10;
        pbs.modigie__Get_Modigie_Campaign_Invocable_Limits__c = 10;
        pbs.modigie__Validate_employer_campaign_Limits__c = 10;
        pbs.modigie__Linkedin_Url_Campaign_Limits__c = 10;
        insert pbs;
        System.assert(pbs.modigie__Linkedin_Url_Campaign_Limits__c == 10);
        
        modigie__Daily_usage_modigie_callouts_by_users__c dailycall = new modigie__Daily_usage_modigie_callouts_by_users__c();
        dailycall.Name = 'Daily calls';
        dailycall.modigie__Number_of_modigie_callouts_in_a_day__c = 20;
        dailycall.modigie__User_Id__c = UserInfo.getUserId();
        insert dailycall;
        System.assert(dailycall.modigie__Number_of_modigie_callouts_in_a_day__c == 20);
        
        //Test.setMock(HttpCalloutMock.class, new JwtapexMock());
        Test.startTest();
        String sched = '0 00 00 * * ?';  //Every Day at Midnight
        ModigieLimitResetClass SC = new ModigieLimitResetClass(); 
        System.schedule('Schedule', sched, SC);
        Test.stopTest();
    }
    
}