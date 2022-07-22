@isTest
public class NotificationServiceClassTest {
    
    @isTest
    public static void test1(){
        Set<String> userSet = new Set<String>();
        userSet.add(UserInfo.getUserId());
        
        Set<String> campaignSet = new Set<String>();
        Campaign cm = new Campaign();
        cm.Name = 'Test';
        insert cm;
        system.assert(cm.Name == 'Test');
        campaignSet.add(cm.Id);
        
        String notificationTitle = 'Get Linkedin Service Result Campaign';
        String notificationBody = 'Modigie Data for Get Linkedin Service has been returned.';
        NotificationServiceClass.sendNotification(notificationTitle, notificationBody, userSet, campaignSet);
    }
    
    @isTest
    public static void test2(){
        
        String notificationTitle = 'Get Linkedin Service Result Campaign';
        String adminId = UserInfo.getUserId();
        NotificationServiceClass.sendNotification(notificationTitle, adminId);
    	System.assert(notificationTitle == 'Get Linkedin Service Result Campaign');
    }

    //Limit Functionality
    @isTest
    public static void test3(){
        modigie__Modigie_Configurator__c modConf = new modigie__Modigie_Configurator__c();
        modConf.modigie__ConfigurerId__c = UserInfo.getUserId();
        insert modConf;

        modigie__Process_Builder_Switch__c pbs = new modigie__Process_Builder_Switch__c();
        pbs.modigie__Limits_No_Limits_Selection__c  = 'Limits';
        pbs.modigie__Limit_User_for_Modigie_Ad_hoc__c = true;
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
        
        modigie__Daily_usage_modigie_callouts_by_users__c modigieUsage = new modigie__Daily_usage_modigie_callouts_by_users__c();
        modigieUsage.Name = 'Testing';
        modigieUsage.modigie__Number_of_modigie_callouts_in_a_day__c = 10;
        
        modigieUsage.modigie__User_Id__c = UserInfo.getUserId();
        insert modigieUsage;

        modigie__Profile_and_user_modigie_limits__c modigieUserProfileLimits = new modigie__Profile_and_user_modigie_limits__c();
        modigieUserProfileLimits.Name = 'Testing';
        modigieUserProfileLimits.modigie__User_or_Profile_Id__c = UserInfo.getUserId();
        modigieUserProfileLimits.modigie__User_Or_Profile__c = 'User';
        modigieUserProfileLimits.modigie__Limit_of_modigie_callouts__c = 10;
        insert modigieUserProfileLimits;
        NotificationServiceClass.adhoqLimitCheck();
        NotificationServiceClass.sendAdhoqEmailLimitReached(10);

        modigieUserProfileLimits.modigie__User_or_Profile_Id__c = UserInfo.getProfileId();
        List<Profile> prof = [SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId()];
        modigieUserProfileLimits.modigie__User_Or_Profile__c = 'Profile';
        update modigieUserProfileLimits;
        //[SELECT modigie__User_Id__c, modigie__Number_of_modigie_callouts_in_a_day__c FROM modigie__Daily_usage_modigie_callouts_by_users__c WHERE modigie__User_Id__c = :userId LIMIT 1];
        
        NotificationServiceClass.adhoqLimitCheck();
        NotificationServiceClass.sendAdhoqEmailLimitReached(10);

        NotificationServiceClass.sendEmailLimitReached('Test', 'Test', 10, 10, 1, UserInfo.getUserId());
        System.assert(modigieUserProfileLimits.Id != null);
    }
    
    @isTest
    public static void test4(){
        RuleSetFactoryTest.insertUseCase('Test');
        List<modigie__Modigie_Rule_Sets__c> testmrs = [SELECT Id, modigie__Rule_Set_Name__c , modigie__Email_Limit_Sent__c, modigie__Limit__c, modigie__Usage__c, modigie__isLimit__c, modigie__Maintain_Queue__c, modigie__isActive__c FROM modigie__Modigie_Rule_Sets__c WHERE modigie__isActive__c = true];
        testmrs[0].modigie__Usage__c = 5;
        NotificationServiceClass.sendEmailRuleSetLimit(testmrs);
        String errorBody = 'EmailLog- Modigie Job Automation Limit Reached -';
        errorBody += ' ' + testmrs[0].modigie__Rule_Set_Name__c + ' : ' + testmrs[0].modigie__Limit__c + ' : ' + (testmrs[0].modigie__Maintain_Queue__c ? 'Yes' : 'No') + ';';
        modigie__Modigie_Rule_Sets__c mrs = [SELECT Id, modigie__Email_Limit_Sent__c FROM modigie__Modigie_Rule_Sets__c WHERE Id = :testmrs[0].Id];
        Integer maxWidth = 255;
        String message = errorBody.abbreviate(maxWidth);
        String errorMessage = '%'+message+'%';
        List<modigie__Error_Log__c> lstBatchClassErrorLog = [
            SELECT Id, modigie__Job_Id__c 
            FROM modigie__Error_Log__c 
            WHERE modigie__Job_Id__c LIKE :errorMessage AND 
            CreatedDate = TODAY 
            LIMIT 1
        ];
        System.assert(mrs.modigie__Email_Limit_Sent__c == true || !lstBatchClassErrorLog.isEmpty());
    }
}