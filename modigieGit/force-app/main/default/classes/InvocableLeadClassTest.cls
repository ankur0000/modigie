@isTest
public class InvocableLeadClassTest
{
    @isTest
    public static void test()
    {
        List<String> leadlist = new List<String>();
        
       
      	RuleSetFactoryTest.createToken();
        
        Modigie_Credit__c modicredit = new Modigie_Credit__c();
        modicredit.Purchased__c=20;
        modicredit.Used__c=20;
        modicredit.Validation_Key__c= 'Modigie_Credit__c@Cyntexakey';
        insert modicredit;
        System.assert(modicredit.modigie__Validation_Key__c == 'Modigie_Credit__c@Cyntexakey');
        
        Lead lea = new Lead();
        lea.FirstName = 'Test';
        lea.LastName = 'Contact';
        lea.Email = 'testcontact@gmail.com';
        lea.Company = 'test Company';
        insert lea;
        System.assert(lea.Company == 'test Company');
        
        leadlist.add(lea.Id);
        
        test.startTest();
        InvocableLeadClass.getRecordId(leadlist);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseToGetModigie());
        test.stopTest();
    }
    
    @isTest
    public static void test1()
    {
        List<String> leadlist = new List<String>();
        
      	RuleSetFactoryTest.createToken();
        
        Modigie_Credit__c modicredit = new Modigie_Credit__c();
        modicredit.Purchased__c=20;
        modicredit.Used__c=20;
        modicredit.Validation_Key__c= 'Modigie_Credit__c@Cyntexakey';
        insert modicredit;
        System.assert(modicredit.modigie__Validation_Key__c == 'Modigie_Credit__c@Cyntexakey');
        
        Lead lea = new Lead();
        lea.FirstName = 'Test';
        lea.LastName = 'Contact';
        lea.Email = 'testcontact@gmail.com';
        lea.Company = 'test Company';
        insert lea;
        System.assert(lea.Company == 'test Company');
        
        leadlist.add(lea.Id);
        
        test.startTest();
        InvocableLeadClass.getRecordId(leadlist);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseToGetModigie1());
        test.stopTest();
    }


}