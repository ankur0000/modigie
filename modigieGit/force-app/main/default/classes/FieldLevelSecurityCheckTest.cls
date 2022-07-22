@isTest
public class FieldLevelSecurityCheckTest 
{
    @isTest
    public static void canReadObjectTest()
    {
        FieldLevelSecurityCheck a = new FieldLevelSecurityCheck();
        test.startTest();
            Boolean var1 = FieldLevelSecurityCheck.canReadObject('Account');
            System.assertEquals(true,var1);
        test.stopTest();
    }

    @isTest
    public static void canReadFieldTest()
    {
        FieldLevelSecurityCheck a = new FieldLevelSecurityCheck();
        test.startTest();
            Boolean var1 = FieldLevelSecurityCheck.canReadField('Account', 'Name');
            System.assertEquals(true,var1);
        test.stopTest();
    }

    @isTest
    public static void canCreateObjectTest()
    {
        FieldLevelSecurityCheck a = new FieldLevelSecurityCheck();
        test.startTest();
            Boolean var1 = FieldLevelSecurityCheck.canCreateObject('Account');
            System.assertEquals(true,var1);
        test.stopTest();
    }

    @isTest
    public static void canCreateFieldTest()
    {
        FieldLevelSecurityCheck a = new FieldLevelSecurityCheck();
        test.startTest();
            Boolean var1 = FieldLevelSecurityCheck.canCreateField('Account','Name');
            System.assertEquals(true,var1);
        test.stopTest();
    }

    @isTest
    public static void canUpdateObjectTest()
    {
        FieldLevelSecurityCheck a = new FieldLevelSecurityCheck();
        test.startTest();
            Boolean var1 = FieldLevelSecurityCheck.canUpdateObject('Account');
            System.assertEquals(true,var1);
        test.stopTest();
    }

    @isTest
    public static void canUpdateFieldTest()
    {
        FieldLevelSecurityCheck a = new FieldLevelSecurityCheck();
        test.startTest();
            Boolean var1 = FieldLevelSecurityCheck.canUpdateField('Account','Name');
            System.assertEquals(true,var1);
        test.stopTest();
    }

    @isTest
    public static void canDeleteObjectTest()
    {
        FieldLevelSecurityCheck a = new FieldLevelSecurityCheck();
        test.startTest();
            Boolean var1 = FieldLevelSecurityCheck.canDeleteObject('Account');
            System.assertEquals(true,var1);
        test.stopTest();
    }

    @isTest
    public static void checkSecurityTest()
    {
        Map<String, String> securityMap = new Map<String, String>();
        securityMap.put('modigie__Validation_Date_Get_LinkedIn__c', 'modigie__Modigie__c');
        securityMap.put('modigie__Linkedin_Job_Id__c', 'modigie__Modigie__c');
        securityMap.put('modigie__Contact__c', 'modigie__Modigie__c');
        securityMap.put('modigie__Parent_Id__c', 'modigie__Modigie__c');
        securityMap.put('modigie__Get_LinkedIn_Job_Status__c', 'modigie__Modigie__c');
        securityMap.put('modigie__Linkedin_Status__c', 'modigie__Modigie__c');
        securityMap.put('modigie__Validation_Key__c', 'modigie__Modigie__c');
        
        test.startTest();
        Boolean check = FieldLevelSecurityCheck.checkSecurity(securityMap);
            System.assertEquals(true,check);
        test.stopTest();
    }

    @isTest
    public static void checkSecurityForReadTest()
    {
        Map<String, String> securityMap = new Map<String, String>();
        
        securityMap.put('CampaignId', 'CampaignMember');
        securityMap.put('ContactId', 'CampaignMember');
        securityMap.put('LeadId', 'CampaignMember');
        securityMap.put('FirstName', 'CampaignMember');
        securityMap.put('LastName', 'CampaignMember');
        test.startTest();
        Boolean check = FieldLevelSecurityCheck.checkSecurityForRead(securityMap);
            System.assertEquals(true,check);
        test.stopTest();
    }
    
}