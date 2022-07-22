@isTest
public class InvocableContactClassTest 
{
    @isTest
    public static void test()
    {
        List<String> conlist = new List<String>();
        
      	RuleSetFactoryTest.createToken();
        
        Modigie_Credit__c modicredit = new Modigie_Credit__c();
        modicredit.Purchased__c=20;
        modicredit.Used__c=20;
        modicredit.Validation_Key__c= 'Modigie_Credit__c@Cyntexakey';
        insert modicredit;
        System.assert(modicredit.modigie__Validation_Key__c == 'Modigie_Credit__c@Cyntexakey');
        Account acc = new Account(Name = 'Test Account');
        acc.BillingStreet = 'Test Street';
        acc.BillingCity = 'Test City';
        acc.BillingState = 'Test State';
        acc.BillingCountry = 'Test Country';
        acc.BillingPostalCode = '23564';
        insert acc;
        System.assert(acc.Name == 'Test Account');
        Contact con = new Contact(AccountId = acc.Id);
        con.FirstName = 'Test';
        con.LastName = 'Contact';
        //con.Email = 'testemail@nomail.com';
        con.MobilePhone = '8999736543';
        con.modigie__Company_URL__c = 'companyurl@test.com';
        con.modigie__Company_Email__c = 'companyemail@test.com';
        con.modigie__linkedin_url__c = 'linkedinurl@test.com';
        insert con;
        System.assert(con.LastName == 'Contact');
        
        conlist.add(con.Id);
        
        test.startTest();
        InvocableContactClass.getRecordId(conlist);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseToGetModigie());
        test.stopTest();
    }
    
    @isTest
    public static void test1()
    {
        List<String> conlist = new List<String>();
        
        
      	RuleSetFactoryTest.createToken();
        
        Modigie_Credit__c modicredit = new Modigie_Credit__c();
        modicredit.Purchased__c=20;
        modicredit.Used__c=20;
        modicredit.Validation_Key__c= 'Modigie_Credit__c@Cyntexakey';
        insert modicredit;
        System.assert(modicredit.modigie__Validation_Key__c == 'Modigie_Credit__c@Cyntexakey');
        Account acc = new Account(Name = 'Test Account');
        acc.BillingStreet = 'Test Street';
        acc.BillingCity = 'Test City';
        acc.BillingState = 'Test State';
        acc.BillingCountry = 'Test Country';
        acc.BillingPostalCode = '23564';
        insert acc;
        System.assert(acc.Name == 'Test Account');
        Contact con = new Contact(AccountId = acc.Id);
        con.FirstName = 'Test';
        con.LastName = 'Contact';
        //con.Email = 'testemail@nomail.com';
        con.MobilePhone = '8999736543';
        con.modigie__Company_URL__c = 'companyurl@test.com';
        con.modigie__Company_Email__c = 'companyemail@test.com';
        con.modigie__linkedin_url__c = 'linkedinurl@test.com';
        insert con;
        System.assert(con.LastName == 'Contact');
        
        conlist.add(con.id);
        
        test.startTest();
        InvocableContactClass.getRecordId(conlist);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseToGetModigie1());
        test.stopTest();
    }

}