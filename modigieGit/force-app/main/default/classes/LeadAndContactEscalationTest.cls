@isTest
public class LeadAndContactEscalationTest {
  
    @isTest
    public static void Method1(){
      
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='vaibhav@cyntexa.com', 
                          EmailEncodingKey='UTF-8', LastName='Vaibhav Vyas', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='vaibv@modigie.com');
        insert u;
       
      
        
        Integer len = 11;
        String str = string.valueof(Math.abs(Crypto.getRandomLong()));
        String jobid = str.substring(0, len);
        
        Modigie__c modirec = new Modigie__c();
        modirec.Jobid__c = jobid;
        modirec.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        modirec.Status__c = 'In process';
        modirec.Mobile__c = '1234567890';
        modirec.Date_Last_Updated__c = Date.today();
        insert modirec;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseForEscalation());
        test.stopTest();
    }
    
    @isTest
    public static void Method2(){
      
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='vaibhav@cyntexa.com', 
                          EmailEncodingKey='UTF-8', LastName='Vaibhav Vyas', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='vaibv@modigie.com');
        insert u;
       
        
        
        Integer len = 11;
        String str = string.valueof(Math.abs(Crypto.getRandomLong()));
        String jobid = str.substring(0, len);

        Modigie__c modirec = new Modigie__c();
        modirec.Jobid__c = jobid;
        modirec.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        modirec.Status__c = 'Validated';
        modirec.Mobile__c = '1234567890';
        modirec.Date_Last_Updated__c = Date.today();
        insert modirec;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseForEscalation());
        test.stopTest();
    }
}