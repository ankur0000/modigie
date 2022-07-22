@isTest
public class ModigieLightningCampaignTabTest {
    @testSetup static void setup(){
        Campaign camRec = new Campaign();
        camRec.Name = 'Test Campaign';
        insert camRec;
        System.assert(camRec.Name == 'Test Campaign');
        Account acc = new Account(Name='Test Account');
        insert acc;
        Contact con= new Contact();
        con.LastName='test';
        con.AccountId = acc.Id;
        insert con;
        System.assert(con.LastName == 'test');
        
        Lead l = new Lead();
        l.FirstName = 'Test';
        l.LastName = 'Lead';
        l.Company = 'Test Company';
        insert l;
        System.assert(l.Company == 'Test Company');
        
        List<CampaignMember> camMember = new List<CampaignMember>();
        camMember.add(new CampaignMember(CampaignId=camRec.Id, ContactId= con.Id, Status='Sent'));
        camMember.add(new CampaignMember(CampaignId=camRec.Id, LeadId= l.Id, Status='Sent'));
        insert camMember;
        System.assert(camMember.size() == 2);
    }
    
    @isTest
    public static void testMethod1(){
        Campaign camp = [SELECT Name FROM Campaign WHERE Name = 'Test Campaign' LIMIT 1];
        Contact con = [SELECT LastName FROM Contact WHERE LastName = 'test' LIMIT 1];
        
        Modigie__c modirec = new Modigie__c();
        modirec.Contact__c = con.id;
        modirec.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        modirec.Date_Last_Updated__c = Date.today();
        insert modirec;
        System.assert(modirec.Validation_Key__c == 'Modigie_Credit__c@Cyntexakey');
        
        Test.startTest();
            String result = ModigieLightningCampaignTabController.getCampaignMemberInformation(camp.Id);
            System.assertNotEquals(null, result);
        Test.stopTest();
        
    }   
    
    @isTest
    public static void testMethod2(){
        Campaign camp = [SELECT Name FROM Campaign WHERE Name = 'Test Campaign' LIMIT 1];
        Lead l = [SELECT LastName FROM Lead WHERE LastName = 'Lead' LIMIT 1];
        
        Modigie__c modirec1 = new Modigie__c();
        modirec1.Lead__c = l.id;
        modirec1.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        modirec1.Date_Last_Updated__c = Date.today();
        insert modirec1;
        System.assert(modirec1.Validation_Key__c == 'Modigie_Credit__c@Cyntexakey');
        
        Test.startTest();
            String result = ModigieLightningCampaignTabController.getCampaignMemberInformation(camp.Id);
            System.assertNotEquals(null, result);
        Test.stopTest();
        
    }

}