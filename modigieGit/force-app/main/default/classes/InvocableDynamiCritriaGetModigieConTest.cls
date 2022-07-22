@isTest
public class InvocableDynamiCritriaGetModigieConTest {
    
    @testSetup 
    public static void setup() {
        Account acc = new Account();
        acc.name = 'Test Account';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'fname';
        con.LastName = 'lname';
        con.Email = 'contest@email.com';
        con.AccountId = acc.Id;
        insert con;
        
        modigie__Modigie_Automation_Criteria_Contact__c rec = new modigie__Modigie_Automation_Criteria_Contact__c();
        rec.Name = '0';
        rec.modigie__Field_Api_Name__c = 'lastname';
        //rec.modigie__Field_Data_Type__c = '';
        rec.modigie__Field_Value__c = 'lname';
        rec.modigie__Operator__c = 'equals';
        insert rec;
        
        modigie__Modigie_Automation_Criteria_Contact__c rec1 = new modigie__Modigie_Automation_Criteria_Contact__c();
        rec1.Name = '0';
        rec1.modigie__Field_Api_Name__c = 'photourl';
        //rec1.modigie__Field_Data_Type__c = '';
        rec1.modigie__Field_Value__c = 'true';
        rec1.modigie__Operator__c = 'null';
        insert rec1;
        
        modigie__Modigie_Automation_Criteria_Contact__c rec2 = new modigie__Modigie_Automation_Criteria_Contact__c();
        rec2.Name = '0';
        rec2.modigie__Field_Api_Name__c = 'salutation';
        //rec2.modigie__Field_Data_Type__c = '';
        rec2.modigie__Field_Value__c = 'Mr., Dr.';
        rec2.modigie__Operator__c = 'equals';
        insert rec2;
        
        modigie__Process_Builder_Switch__c mPBS = new modigie__Process_Builder_Switch__c();
        insert mPBS;
        
    }
    
    @isTest
    public static void test1(){
        
        Contact con = [SELECT Id, Firstname, Lastname, Email, AccountId, Account.Name FROM Contact LIMIT 1];
        List<Id> lstIds = new List<Id>();
        lstIds.add(con.Id);
        InvocableDynamiCritriaGetModigieContact.getRecordId(lstIds);
        System.assert(!lstIds.isEmpty());
    }

}