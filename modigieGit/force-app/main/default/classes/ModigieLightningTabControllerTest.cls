@isTest
public class ModigieLightningTabControllerTest {
    @testSetup static void setup(){
        Account acc = new Account(name = 'Test Account');
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
        
    }
    
    @isTest
    public static void testMethod1(){
        Contact con = [SELECT LastName FROM Contact WHERE LastName = 'test' LIMIT 1];
        
        Modigie__c modirec = new Modigie__c();
        modirec.Contact__c = con.id;
        modirec.modigie__Parent_Id__c = con.id;
        modirec.modigie__Phone_Intelligence_Status__c = 'Not started';
        modirec.modigie__Phone_Intelligence_Status_Phone__c = 'Not started';
        modirec.modigie__Phone_Intelligence_Status_Other_Phone__c = 'Not started';
        modirec.modigie__Phone_Intelligence_Status_Modigie_Number__c = 'Not started';
        modirec.modigie__Phone_Intelligence_Status_Alt_Number1__c = 'Not started';
        modirec.modigie__Phone_Intelligence_Status_Alt_Number2__c = 'Not started';
        modirec.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        modirec.Date_Last_Updated__c = Date.today();
        insert modirec;
        System.assert(modirec.Validation_Key__c == 'Modigie_Credit__c@Cyntexakey');
        
        Test.startTest();
        Object result = ModigieLightningTabController.getModigieInformationCustom(con.Id);
        System.assertNotEquals(null,result);
        Test.stopTest();
    }   
    
    @isTest
    public static void testMethod2(){
        Lead l = [SELECT LastName FROM Lead WHERE LastName = 'Lead' LIMIT 1];
        
        Modigie__c modirec = new Modigie__c();
        modirec.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        modirec.modigie__Lead__c = l.Id;
        modirec.modigie__Parent_Id__c = l.Id;
        modirec.modigie__Phone_Intelligence_Status__c = 'Not Available';
        modirec.modigie__Phone_Intelligence_Status_Phone__c = 'Not Available';
        modirec.modigie__Phone_Intelligence_Status_Other_Phone__c = 'Not Available';
        modirec.modigie__Phone_Intelligence_Status_Modigie_Number__c = 'Not Available';
        modirec.modigie__Phone_Intelligence_Status_Alt_Number1__c = 'Not Available';
        modirec.modigie__Phone_Intelligence_Status_Alt_Number2__c = 'Not Available';
        modirec.Date_Last_Updated__c = Date.today();
        insert modirec;
        System.assert(modirec.modigie__Validation_Key__c == 'Modigie_Credit__c@Cyntexakey');
        
        Test.startTest();
        Object result = ModigieLightningTabController.getModigieInformationCustom(l.Id);
        System.assertNotEquals(null,result);
        Test.stopTest();
        
    }
    
    @isTest
    public static void testMethod3(){
        Lead l = [SELECT LastName FROM Lead WHERE LastName = 'Lead' LIMIT 1];
        
        Modigie__c modirec = new Modigie__c();
        modirec.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        modirec.modigie__Lead__c = l.Id;
        modirec.modigie__Parent_Id__c = l.Id;
        modirec.modigie__Status__c= 'Validated';
        modirec.modigie__Mobile__c = '637673736744';
        modirec.modigie__Accuracy_Match_Modigie_Validated_Number__c='Test Match';
        modirec.modigie__Phone_Type_Modigie_Validated_Number__c = 'Mobile';
        modirec.modigie__Line_Activity_Modigie_Validated_Number__c = 'Test Line Type';
        modirec.modigie__Day_of_Week_Detail_Modigie_Val_Number__c = '5;6;3;5;6;4;4;';
        modirec.modigie__Mobile_2__c = '637673736744';
        modirec.modigie__Accuracy_Match_Alternate_Number1__c='Test Match';
        modirec.modigie__Phone_Type_Alternate_Number1__c = 'Mobile';
        modirec.modigie__Line_Activity_Alternate1__c = 'Test Line Type';
        modirec.modigie__Day_of_Week_Detail_Alternate_Number1__c = '5;6;3;5;6;4;4;';
        modirec.modigie__Phone_Intelligence_Status__c = 'Validated';
        modirec.modigie__Phone_Intelligence_Status_Phone__c = 'Validated';
        modirec.modigie__Phone_Intelligence_Status_Other_Phone__c = 'Validated';
        modirec.modigie__Phone_Intelligence_Status_Modigie_Number__c = 'Validated';
        modirec.modigie__Phone_Intelligence_Status_Alt_Number1__c = 'Validated';
        modirec.modigie__Phone_Intelligence_Status_Alt_Number2__c = 'Validated';
        modirec.Date_Last_Updated__c = Date.today();
        insert modirec;
        System.assert(modirec.modigie__Validation_Key__c == 'Modigie_Credit__c@Cyntexakey');
        
        Test.startTest();
        Object result = ModigieLightningTabController.getModigieInformationCustom(l.Id);
        System.assertNotEquals(null,result);
        Test.stopTest();
        
    }

    @isTest
    public static void testMethod4(){
        Lead l = [SELECT LastName FROM Lead WHERE LastName = 'Lead' LIMIT 1];
        
        Modigie__c modirec = new Modigie__c();
        modirec.Validation_Key__c = 'Modigie_Credit__c@Cyntexakey';
        modirec.modigie__Lead__c = l.Id;
        modirec.modigie__Parent_Id__c = l.Id;
        modirec.modigie__Phone_Intelligence_Status__c = 'In process';
        modirec.modigie__Phone_Intelligence_Status_Phone__c = 'In process';
        modirec.modigie__Phone_Intelligence_Status_Other_Phone__c = 'In process';
        modirec.modigie__Phone_Intelligence_Status_Modigie_Number__c = 'In process';
        modirec.modigie__Phone_Intelligence_Status_Alt_Number1__c = 'In process';
        modirec.modigie__Phone_Intelligence_Status_Alt_Number2__c = 'In process';
        modirec.Date_Last_Updated__c = Date.today();
        insert modirec;
        System.assert(modirec.modigie__Validation_Key__c == 'Modigie_Credit__c@Cyntexakey');
        
        Test.startTest();
        Object result = ModigieLightningTabController.getModigieInformationCustom(l.Id);
        System.assertNotEquals(null,result);
        Test.stopTest();
        
    }
}