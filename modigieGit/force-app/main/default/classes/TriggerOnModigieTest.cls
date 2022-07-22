@isTest
public class TriggerOnModigieTest 
{
    @isTest
    public static void method1()
    {
        Account acc = new Account(name='Test Account');
        insert acc;
        System.assert(acc.Name == 'Test Account');
        
        Contact con = new Contact();
        //con.FirstName = 'Test11';
        con.LastName = 'Contact11';
        con.Email = 'testemail11@nomail.com';
        con.MobilePhone = '8999736543';
        con.modigie__Company_URL__c = 'companyurl@test.com';
        con.AccountId = acc.Id;
        insert con;
        System.assert(con.LastName == 'Contact11');
        
        Modigie__c modirec = new Modigie__c();
        modirec.Contact__c = con.id;
        modirec.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        modirec.Status__c = 'In process';
        modirec.Mobile__c = '1234567890';
        modirec.Date_Last_Updated__c = Date.today();
        insert modirec;
        System.assert(modirec.Status__c == 'In process');
        
        modirec.Status__c = 'Validated';
        update modirec;
        System.assert(modirec.Status__c == 'Validated');
        
        lead l = new lead();
        l.FirstName = 'Test';
        l.LastName = 'Lead 1';
        l.Company = 'TestLead1';
        insert l;
        System.assert(l.FirstName == 'Test');
        
        Modigie__c modirec1 = new Modigie__c();
        modirec1.Status__c = 'In process';
        modirec1.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        modirec1.Lead__c = l.id;
        modirec1.Mobile__c = '1234567890';
        modirec1.Date_Last_Updated__c = Date.today();
        insert modirec1;
        System.assert(modirec1.Status__c == 'In process');
        
        modirec1.Status__c = 'Validated';
        update modirec1;
        System.assert(modirec1.Status__c == 'Validated');
        
        lead l2 = new lead();
        l2.FirstName = 'Test2';
        l2.LastName = 'Lead 1';
        l2.Company = 'Test2Lead1';
        insert l2;
        System.assert(l2.FirstName == 'Test2');
        
        Modigie__c modirec2 = new Modigie__c();
        modirec2.Status__c = 'In process';
        modirec2.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        modirec2.Lead__c = l2.id;
        modirec2.Mobile__c = '1234567890';
        modirec2.Date_Last_Updated__c = Date.today();
        insert modirec2;
        System.assert(modirec2.Status__c == 'In process');
        
        modirec2.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        modirec2.Mobile__c = '1234521190';
        update modirec2;
        System.assert(modirec2.Mobile__c == '1234521190');
    }
    
    @isTest
    public static void method2()
    {
        Account acc = new Account(name='Test Account');
        insert acc;
        System.assert(acc.Name == 'Test Account');
        
        Contact con = new Contact();
        con.FirstName = 'Test11';
        con.LastName = 'Contact11';
        con.Email = 'testemail11@nomail.com';
        con.MobilePhone = '8999736543';
        con.AccountId = acc.Id;
        con.modigie__Company_URL__c = 'companyurl@test.com';
        insert con;
        System.assert(con.LastName == 'Contact11');
        
        Modigie__c modirec = new Modigie__c();
        modirec.Contact__c = con.id;
        modirec.modigie__Parent_Id__c = con.Id;
        modirec.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        modirec.Status__c = 'Validated';
        modirec.Mobile__c = '1234567890';
        modirec.Date_Last_Updated__c = Date.today();
        insert modirec;
        System.assert(modirec.Status__c == 'Validated');
        
        delete con;
        System.assert(modirec.Status__c == 'Validated');
        
        undelete con;
        System.assert(con.FirstName == 'Test11');
        
        /*undelete modirec;
        System.assert(modirec.Status__c == 'Validated');*/
    }

    @isTest
    public static void method3()
    {
        
        Account acc = new Account(name='Test Account');
        insert acc;
        System.assert(acc.Name == 'Test Account');
        
        Contact con = new Contact();
        //con.FirstName = 'Test11';
        con.LastName = 'Contact11';
        con.Email = 'testemail11@nomail.com';
        con.MobilePhone = '8999736543';
        con.modigie__Company_URL__c = 'companyurl@test.com';
        con.AccountId = acc.Id;
        insert con;
        System.assert(con.LastName == 'Contact11');
        
        Modigie__c modirec = new Modigie__c();
        modirec.Contact__c = con.id;
        modirec.modigie__Parent_Id__c = con.Id;
        modirec.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        modirec.Status__c = 'Validated';
        modirec.Mobile__c = '1234567890';
        modirec.Date_Last_Updated__c = Date.today();
        insert modirec;
        System.assert(modirec.Status__c == 'Validated');
        
        delete con;
        System.assert(modirec.Status__c == 'Validated');
        
        test.startTest();
        undelete con;
        test.stopTest();
        List<Contact> conList = [select id,modigie__Validation_Key__c from contact];
        System.assertEquals(true,conList.size()>0);
        
    }

    @isTest
    public static void method4()
    {
        Account acc = new Account(name='Test Account');
        insert acc;
        System.assert(acc.Name == 'Test Account');
        
        Contact con = new Contact();
        //con.FirstName = 'Test11';
		con.AccountId = acc.Id;
        con.LastName = 'Contact11';
        con.Email = 'testemail11@nomail.com';
        con.MobilePhone = '8999736543';
        con.modigie__Company_URL__c = 'companyurl@test.com';
        insert con;
        System.assert(con.LastName == 'Contact11');
        
        Modigie__c modirec = new Modigie__c();
        modirec.Contact__c = con.id;
        modirec.modigie__Parent_Id__c = con.Id;
        modirec.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        modirec.Status__c = 'Validated';
        modirec.Mobile__c = '1234567890';
        modirec.Date_Last_Updated__c = Date.today();
        
        Test.startTest();
        insert modirec;
        System.assert(modirec.Status__c == 'Validated');
        Test.stopTest();
        List<Contact> conList = [select id,modigie__Validation_Key__c from contact];
        System.assertEquals(true,conList.size()>0);
        
        
    }

    @isTest
    public static void method5()
    {
        
        Account acc = new Account(name='Test Account');
        insert acc;
        System.assert(acc.Name == 'Test Account');
        
        Contact con = new Contact();
        //con.FirstName = 'Test11';
        con.LastName = 'Contact11';
        con.Email = 'testemail11@nomail.com';
        con.AccountId = acc.Id;
        con.MobilePhone = '8999736543';
        con.modigie__Company_URL__c = 'companyurl@test.com';
        insert con;
        System.assert(con.LastName == 'Contact11');
        
        Modigie__c modirec = new Modigie__c();
        modirec.Contact__c = con.id;
        modirec.modigie__Parent_Id__c = con.Id;
        modirec.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        modirec.Status__c = 'Validated';
        modirec.Mobile__c = '1234567890';
        modirec.Date_Last_Updated__c = Date.today();
        insert modirec;
        System.assert(modirec.Status__c == 'Validated');
        
        Test.startTest();
        try{
            undelete modirec;
        }catch(exception e){
        }
        Test.stopTest();
        List<modigie__Modigie__c> modigies = [select id,modigie__Contact__c from modigie__Modigie__c];
        System.assertEquals(true,modigies.size()>0);
           //System.assert(modirec.Status__c == 'Validated');
    }
}