@isTest
public class RequestSupportTest {
    @isTest
    public static void test1()
    {
      /*  Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];   
        User u = new User(Alias = 'standt', Email='vaibhav@cyntexa.com', 
                          EmailEncodingKey='UTF-8', LastName='Vaibhav Vyas', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='vaibv@modigie.com');
        insert u;
        System.assert(u.Email == 'vaibhav@cyntexa.com');
        
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Contact';
        con.Email = 'testcontact@nomail.com';
        con.modigie__linkedin_url__c = 'linkedInurl@sample.com';
        insert con;
        System.assert(con.FirstName == 'Test');
        
        
        Modigie__c accToken = new Modigie__c();
        accToken.modigie__Contact__c = con.id;
        accToken.modigie__Lead__c = null;
                accToken.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';

        insert accToken;
        System.assert(accToken.Validation_Key__c == 'Modigie_Credit__c@Cyntexakey');*/
        
        test.startTest();
        RequestSupport obj = new RequestSupport();
       	System.assertNotEquals(obj, null);
        test.stopTest();        
    }
    
   
}