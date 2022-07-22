@isTest
public class TriggerOnErrorLogTest {

    @isTest
    public static void test1(){
        Account acc = new Account(Name='Test Account');
        insert acc;
        system.assert(acc.Name == 'Test Account');
        
        Contact con= new Contact();
        con.LastName='test';
        con.AccountId = acc.Id;
        insert con;
        System.assert(con.LastName == 'test');
        
        modigie__Error_Log__c elc = new modigie__Error_Log__c();
        elc.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        elc.modigie__Contact__c = con.Id;
        elc.modigie__Description__c = 'Required Parameter Missing';
        Test.startTest();
        insert elc;
        system.assert(elc.modigie__Description__c == 'Required Parameter Missing');
        
        Test.stopTest();
        List<modigie__Error_Log__c> errList = [SELECT modigie__Validation_Key__c FROM modigie__Error_Log__c];
        System.assertEquals(NULL,errList.get(0).modigie__Validation_Key__c);

        try{
            delete elc;
           // System.assert(elc.modigie__Description__c == 'Request Timeout Error');
        }
        catch(Exception e){
        }
    }

    @isTest
    public static void test2(){
        Account acc = new Account(Name='Test Account');
        insert acc;
        system.assert(acc.Name=='Test Account');
        
        Contact con = new Contact();
        con.LastName = 'Test lname';
        con.AccountId = acc.Id;
        insert con;
        System.assert(con.LastName == 'Test lname');
        
        modigie__Error_Log__c elc = new modigie__Error_Log__c();
        elc.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        elc.modigie__Contact__c = con.Id;
        elc.modigie__Description__c = 'Required Parameter Missing';
        insert elc;
        system.assert(elc.modigie__Description__c == 'Required Parameter Missing');
        
        Test.startTest();
            elc.modigie__Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
            elc.modigie__Description__c = 'Request Timeout Error';
            update elc;
        	system.assert(elc.modigie__Description__c == 'Request Timeout Error');
        
        Test.stopTest();
        List<modigie__Error_Log__c> errList = [SELECT modigie__Validation_Key__c FROM modigie__Error_Log__c];
        System.assertEquals(NULL,errList.get(0).modigie__Validation_Key__c);
    }

}