@isTest
public class UserLimitsCompControllerTest 
{
    @testSetup
	public static void setup()
    {
        modigie__Profile_and_user_modigie_limits__c mpu = new modigie__Profile_and_user_modigie_limits__c();
        mpu.Name = UserInfo.getUserId();
        mpu.modigie__User_or_Profile_Name__c = 'Test Name';
        mpu.modigie__User_Or_Profile__c = 'System Administrator';
        mpu.modigie__Limit_of_modigie_callouts__c = 500; 
        insert mpu; 
        
        modigie__Process_Builder_Switch__c pbs = new modigie__Process_Builder_Switch__c();
        pbs.modigie__Limit_User_for_Modigie_Ad_hoc__c = true;
        insert pbs;
    }
    
    
    @isTest
    public static void test1()
    {
        List<map <string, object>> lst = new List<map <string, object>>();
        
        map <string, object> dataMap = new Map<string, object>();
        dataMap.put('SelectedOptionId', 'value');
        dataMap.put('SelectedOptionId', userinfo.getProfileId());
        dataMap.put('SelectedOptionValue', 'system administrator');
        dataMap.put('searchObject', 'profile');
        dataMap.put('numberOfLimits', 50);
        
        string demo = 'demo';
        string profile = 'profile';
        
        lst.add(dataMap);
        test.startTest();
        UserLimitsCompController.fetchUserProfileData(demo, profile, lst);
        test.stopTest();
        
        
    }
    
    
    @isTest
    public static void test2()
    {
        List<map <string, object>> lst = new List<map <string, object>>();
        
        map <string, object> dataMap = new Map<string, object>();
        dataMap.put('SelectedOptionId', 'value');
        dataMap.put('SelectedOptionId', userinfo.getProfileId());
        dataMap.put('SelectedOptionValue', 'system administrator');
        dataMap.put('searchObject', 'profile');
        dataMap.put('numberOfLimits', 50);
        
        lst.add(dataMap);
        test.startTest();
        UserLimitsCompController.storeUserProfileLimits(lst);
        test.stopTest();
        
        
    }
    
    @isTest
    public static void test3()
    {
        test.startTest();
        UserLimitsCompController.getUserProfileLimitsData();
        test.stopTest();
    }
    
    @isTest
    public static void test4()
    {
        test.startTest();
        UserLimitsCompController.getAdhocLimitData();
        test.stopTest();
    }
    
    @isTest
    public static void test5()
    {
        modigie__Process_Builder_Switch__c pbs = [SELECT Id, modigie__Limit_User_for_Modigie_Ad_hoc__c FROM modigie__Process_Builder_Switch__c WITH SECURITY_ENFORCED LIMIT 1];
    	test.startTest();
        UserLimitsCompController.setAdHocLimitData(pbs.modigie__Limit_User_for_Modigie_Ad_hoc__c);
        test.stopTest();
    }
}